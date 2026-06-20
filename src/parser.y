%{
#include <cstdio>
#include <iostream>

using namespace std;

#include "symbol.h"
#include "ines_header.h"
#include "parser.h"  // to get the token types that we return
#include "opcodes.h"
#include "bank.h"

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" FILE *yyin;
extern int line_num;
extern SymbolTable localSymbols;

void logoptype(const char *type, unsigned char base);
void logaddrmode(const char *mode);
void loginstr(unsigned int c);
void loginstr(const char *s);
void logsymbol(symbol s);
void logforwardsymbol(const char *s);
void yyerror(const char *s);

extern BankTable bankTable;
extern InesHeader inesHeader;

BankFactory bankFactory;
typedef unique_ptr<Bank> BankPtr;
BankPtr currentBank;
unsigned char currentBankNo;
unsigned short internalRS;

%}

%union {
  unsigned char byte;
  unsigned short word;

  struct opcode {
    unsigned char type;
    unsigned char base;
    int lineNum;
  } opcode;

  const char *c_str;
  struct symbol sym;
}

%token T_COMMA T_OPEN_PAREN T_CLOSE_PAREN
%token T_INES_PRG T_INES_CHR T_INES_MIR T_INES_MAP
%token T_BANK T_ORG
%token T_DATA_WORD T_DATA_BYTE
%token T_X_REGISTER T_Y_REGISTER T_ACCUMULATOR
%token T_RS_SET T_RS T_EQU
%token T_FILE_BINARY
%token T_HIGH T_HIGH_IMM T_LOW T_LOW_IMM
%token UNKNOWN

%token <byte> T_BYTE_IMM
%token <byte> T_BYTE
%token <word> T_WORD_IMM
%token <word> T_WORD
%token <opcode> T_INSTR_CC01
%token <opcode> T_INSTR_CC10
%token <opcode> T_INSTR_CC00
%token <opcode> T_INSTR_BRA
%token <opcode> T_INSTR_IS
%token <opcode> T_INSTR_REM
%token <c_str> T_LABEL
%token <sym> T_SYMBOL T_SYMBOL_BYTE T_SYMBOL_IMM T_SYMBOL_BYTE_IMM
%token <c_str> T_FORWARD_SYMBOL T_FORWARD_SYMBOL_IMM
%token <c_str> T_STRING_LITERAL

%type <word> word
%type <word> word_imm
%type <byte> byte
%type <byte> byte_imm
%type <byte> zp_byte
%type <opcode> T_INSTR
%type <word> org
%type <byte> bank_header
%type <byte> bank_no

%%
program:
  ines_header banks {
    if (!bankTable.updateForwardSymbols(localSymbols)) {
      yyerror("Failed to update forward symbols.");
      YYABORT;
    }
  }
  ;

ines_header:
  ines_entries
  ;

ines_entries:
  ines_entries ines_entry
  | ines_entry
  ;

ines_entry:
  T_INES_PRG byte {
    inesHeader.setPRGRomSize($2);
  }
  | T_INES_CHR byte {
    inesHeader.setCHRRomSize($2);
  }
  | T_INES_MIR byte {
    inesHeader.setMirroringNESASM($2);
  }
  | T_INES_MAP byte {
    inesHeader.setMapper($2);
  }
  ;

banks:
  banks bank
  | banks variables
  | bank
  | variables
  ;

bank:
  bank_header instructions {
    bankTable.add($1, move(currentBank));
  }
  ;

bank_header:
  bank_no org {
    // TODO: Check that we're not trying to create more banks than specified

    bank_type type = PRG;
    if ($1 >= inesHeader.prgRomSize()) {
      type = CHR;
    }

    currentBankNo = $1;
    currentBank = bankFactory.createBank(type, $2);
    $$ = currentBankNo;
  }
  | org bank_no {
    // TODO: Check that we're not trying to create more banks than specified

    bank_type type = PRG;
    if ($2 >= inesHeader.prgRomSize()) {
      type = CHR;
    }

    currentBankNo = $2;
    currentBank = bankFactory.createBank(type, $1);
    $$ = currentBankNo;
  }
  ;

bank_no:
  T_BANK byte {
    $$ = $2;
  }
  ;

org:
  T_ORG word { $$ = $2; }
  ;

instructions:
  instructions instruction
  | instruction
  ;

instruction:
  T_LABEL {
    unsigned short labelOffset = currentBank->currentOffset();
    localSymbols.add($1, labelOffset);
  }
  | T_INSTR byte_imm {
    $1.base = opcode_set_addr_mode($1.type, $1.base, mode_IMM);

    currentBank->addByte($1.base);
    currentBank->addByte($2);

    logoptype("IMM", $1.base);
    loginstr($2);
  }
  | T_INSTR word_imm {
    $1.base = opcode_set_addr_mode($1.type, $1.base, mode_IMM);

    currentBank->addByte($1.base);
    currentBank->addWord($2);

    logoptype("IMM", $1.base);
    loginstr($2);
  }
  | T_INSTR byte {
    if ($1.type == opcode_BRANCH) {
      currentBank->addByte($1.base);
      currentBank->addByte($2);

      logoptype("REL", $1.base);
      loginstr($2);
    } else {
      $1.base = opcode_set_addr_mode($1.type, $1.base, mode_ZERO);
      currentBank->addByte($1.base);
      currentBank->addByte($2);

      logoptype("ZERO", $1.base);
      loginstr($2);
    }
  }
  | T_INSTR word {
    if ($1.type == opcode_BRANCH) {
      unsigned short from = currentBank->currentOffset();
      char relative = 0xff;

      // Forward branches are patched in the second pass.
      if (!localSymbols.setForwardRel($1.lineNum)) {
        if (!branch_relative(from, $2, &relative)) {
          yyerror("Branch target out of range");
          YYABORT;
        }
      }

      currentBank->addByte($1.base);
      currentBank->addByte(relative);

      logoptype("REL", $1.base);
      loginstr(from);
      loginstr($2);
      loginstr(relative);
    } else {
      $1.base = opcode_set_addr_mode($1.type, $1.base, mode_ABS);

      currentBank->addByte($1.base);
      currentBank->addWord($2);

      logoptype("ABS", $1.base);
      loginstr($2);
    }
  }
  | T_INSTR byte T_COMMA T_X_REGISTER {
    $1.base = opcode_set_addr_mode($1.type, $1.base, mode_ZERO_X);

    currentBank->addByte($1.base);
    currentBank->addByte($2);

    logoptype("ZERO_X", $1.base);
    loginstr($2);
  }
  | T_INSTR word T_COMMA T_X_REGISTER {
    $1.base = opcode_set_addr_mode($1.type, $1.base, mode_ABS_X);

    currentBank->addByte($1.base);
    currentBank->addWord($2);

    logoptype("ABS_X", $1.base);
    loginstr($2);
  }
  | T_INSTR word T_COMMA T_Y_REGISTER {
    $1.base = opcode_set_addr_mode($1.type, $1.base, mode_ABS_Y);

    currentBank->addByte($1.base);
    currentBank->addWord($2);

    logoptype("ABS_Y", $1.base);
    loginstr($2);
  }
  | T_INSTR T_OPEN_PAREN zp_byte T_CLOSE_PAREN T_COMMA T_Y_REGISTER {
    $1.base = opcode_set_addr_mode($1.type, $1.base, mode_IND_Y);

    currentBank->addByte($1.base);
    currentBank->addByte($3);

    logoptype("IND_Y", $1.base);
    loginstr($3);
  }
  | T_INSTR T_OPEN_PAREN zp_byte T_COMMA T_X_REGISTER T_CLOSE_PAREN {
    $1.base = opcode_set_addr_mode($1.type, $1.base, mode_IND_X);

    currentBank->addByte($1.base);
    currentBank->addByte($3);

    logoptype("IND_X", $1.base);
    loginstr($3);
  }
  | T_INSTR T_ACCUMULATOR {
    $1.base = opcode_set_addr_mode($1.type, $1.base, mode_ACC);

    currentBank->addByte($1.base);

    logoptype("ACC", $1.base);
  }
  | T_INSTR {
    currentBank->addByte($1.base);

    logoptype("NO VALUE", $1.base);
  }
  | T_DATA
  | T_FILE
  | org {
    currentBank->advanceOffset($1);
  }
  | variables
  | UNKNOWN { yyerror("Unknown instruction"); YYABORT; }
  ;

T_INSTR:
  T_INSTR_CC01   { logoptype("CC01",   $1.base); }
  | T_INSTR_CC10 { logoptype("CC10",   $1.base); }
  | T_INSTR_CC00 { logoptype("CC00",   $1.base); }
  | T_INSTR_BRA  { logoptype("BRANCH", $1.base); }
  | T_INSTR_IS   { logoptype("IS",     $1.base); }
  | T_INSTR_REM  { logoptype("REM",    $1.base); }
  ;

variables:
  variables T_VARIABLE
  | T_VARIABLE
  ;

T_VARIABLE:
  T_RS_SET word {
    internalRS = $2;
  }
  | T_RS_SET byte {
    internalRS = $2;
  }
  | T_RS_SET T_SYMBOL {
    internalRS = $2.address;
  }
  | T_FORWARD_SYMBOL T_RS byte {
    unsigned short labelOffset = internalRS;
    internalRS += $3;
    localSymbols.add($1, labelOffset);
  }
  | equ_variable
  ;

equ_variable:
  T_FORWARD_SYMBOL T_EQU word {
    localSymbols.add($1, $3);
  }
  | T_FORWARD_SYMBOL T_EQU byte {
    localSymbols.addByte($1, $3);
  }
  ;

T_DATA:
  T_DATA_WORD T_WORDS
  | T_DATA_BYTE T_BYTES
  ;

T_WORDS:
  T_WORDS word {
    currentBank->addWord($2);
  }
  | T_WORDS T_COMMA word {
    currentBank->addWord($3);
  }
  | T_WORDS byte {
    currentBank->addWord($2);
  }
  | T_WORDS T_COMMA byte {
    currentBank->addWord($3);
  }
  | word {
    currentBank->addWord($1);
  }
  | byte {
    currentBank->addWord($1);
  }
  ;

T_BYTES:
  T_BYTES byte {
    currentBank->addByte($2);
  }
  | T_BYTES T_COMMA byte {
    currentBank->addByte($3);
  }
  | byte {
    currentBank->addByte($1);
  }
  ;

T_FILE:
  T_FILE_BINARY T_STRING_LITERAL {
    currentBank->addBinary($2);
  }
  ;

byte:
  T_BYTE
  | T_SYMBOL_BYTE {
    logsymbol($1);
    $$ = $1.address;
  }
  | T_HIGH T_OPEN_PAREN T_SYMBOL T_CLOSE_PAREN {
    $$ = ($3.address >> 8);
  }
  | T_LOW T_OPEN_PAREN T_SYMBOL T_CLOSE_PAREN {
    $$ = ($3.address & 0xff);
  }
  | T_HIGH T_OPEN_PAREN T_FORWARD_SYMBOL T_CLOSE_PAREN {
    // If forward_symbol is caught here, it will always have an instruction before it
    // That's why we add 1 to the currentOffset.
    localSymbols.addForwardHigh($3, currentBankNo, currentBank->currentOffset() + 1, line_num);
    logforwardsymbol($3);
    $$ = 0xff;
  }
  | T_LOW T_OPEN_PAREN T_FORWARD_SYMBOL T_CLOSE_PAREN {
    // If forward_symbol is caught here, it will always have an instruction before it
    // That's why we add 1 to the currentOffset.
    localSymbols.addForwardLow($3, currentBankNo, currentBank->currentOffset() + 1, line_num);
    logforwardsymbol($3);
    $$ = 0xff;
  }
  ;

zp_byte:
  byte
  | T_SYMBOL {
    logsymbol($1);
    if ($1.address > 0xff) {
      yyerror("Indirect addressing requires a zero page operand");
      YYABORT;
    }
    $$ = $1.address & 0xff;
  }
  | T_FORWARD_SYMBOL {
    localSymbols.addForwardLow($1, currentBankNo, currentBank->currentOffset() + 1, line_num);
    logforwardsymbol($1);
    $$ = 0xff;
  }
  ;

byte_imm:
  T_BYTE_IMM
  | T_SYMBOL_BYTE_IMM {
    logsymbol($1);
    $$ = $1.address;
  }
  | T_HIGH_IMM T_OPEN_PAREN T_SYMBOL T_CLOSE_PAREN {
    $$ = ($3.address >> 8);
  }
  | T_LOW_IMM T_OPEN_PAREN T_SYMBOL T_CLOSE_PAREN {
    $$ = ($3.address & 0xff);
  }
  | T_HIGH_IMM T_OPEN_PAREN T_FORWARD_SYMBOL T_CLOSE_PAREN {
    // If forward_symbol is caught here, it will always have an instruction before it
    // That's why we add 1 to the currentOffset.
    localSymbols.addForwardHigh($3, currentBankNo, currentBank->currentOffset() + 1, line_num);
    logforwardsymbol($3);
    $$ = 0xff;
  }
  | T_LOW_IMM T_OPEN_PAREN T_FORWARD_SYMBOL T_CLOSE_PAREN {
    // If forward_symbol is caught here, it will always have an instruction before it
    // That's why we add 1 to the currentOffset.
    localSymbols.addForwardLow($3, currentBankNo, currentBank->currentOffset() + 1, line_num);
    logforwardsymbol($3);
    $$ = 0xff;
  }
  ;

word:
  T_WORD
  | T_FORWARD_SYMBOL {
    // If forward_symbol is caught here, it will always have an instruction before it
    // That's why we add 1 to the currentOffset.
    localSymbols.addForward($1, currentBankNo, currentBank->currentOffset() + 1, line_num);
    logforwardsymbol($1);
    $$ = 0xffff;
  }
  | T_SYMBOL {
    logsymbol($1);
    $$ = $1.address;
  }
  ;

word_imm:
  T_WORD_IMM
  | T_FORWARD_SYMBOL_IMM {
    // If forward_symbol is caught here, it will always have an instruction before it
    // That's why we add 1 to the currentOffset.
    localSymbols.addForward($1, currentBankNo, currentBank->currentOffset() + 1, line_num);
    logforwardsymbol($1);
    $$ = 0xffff;
  }
  | T_SYMBOL_IMM {
    logsymbol($1);
    $$ = $1.address;
  }
  ;

%%

void logoptype(const char *type, unsigned char base) {
  (void)type;
  (void)base;
}

void logaddrmode(const char *mode) {
  (void)mode;
}

void loginstr(unsigned int c) {
  (void)c;
}

void loginstr(const char *s) {
  (void)s;
}

void logsymbol(symbol s) {
  (void)s;
}

void logforwardsymbol(const char *s) {
  (void)s;
}

void yyerror(const char *s) {
  cerr << "Error on line (" << dec << line_num << "): " << s << endl;
}
