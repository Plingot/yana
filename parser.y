%{
#include <cstdio>
#include <iostream>
#include <sstream>

using namespace std;

#include "symbol.h"
#include "parser.h"  // to get the token types that we return
#include "opcodes.h"
#include "bank.h"

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
extern int line_num;
extern SymbolTable localSymbols;

string hex(unsigned int c);
string dec(unsigned int c);
void logoptype(const char *type, unsigned char base);
void logaddrmode(const char *mode);
void loginstr(unsigned int c);
void loginstr(const char *s);
void logsymbol(symbol s);
void yyerror(const char *s);

BankFactory bankFactory;
typedef unique_ptr<Bank> BankPtr;
BankPtr currentBank;

%}

%union {
  unsigned char byte;
  unsigned short word;

  struct opcode {
    unsigned char type;
    unsigned char base;
  } opcode;

  const char *c_str;
  struct symbol sym;
}

%token T_INES_PRG T_INES_CHR T_INES_MIR T_INES_MAP
%token T_BANK T_ORG
%token T_DATA_WORD T_DATA_BYTE
%token T_FILE_BINARY
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
%token <sym> T_SYMBOL
%token <c_str> T_STRING_LITERAL

%type <opcode> T_INSTR
%type <word> org

%%
program:
  ines_header banks
  ;

ines_header:
  ines_entries
  ;

ines_entries:
  ines_entries ines_entry
  | ines_entry
  ;

ines_entry:
  T_INES_PRG T_BYTE { cout << dec($2) << " program banks." << endl; }
  | T_INES_CHR T_BYTE { cout << dec($2) << " chr banks." << endl; }
  | T_INES_MIR T_BYTE { cout << dec($2) << " mirroring mode." << endl; }
  | T_INES_MAP T_BYTE { cout << dec($2) << " mapper." << endl; }
  ;

banks:
  banks bank
  | bank
  ;

bank:
  bank_header instructions { currentBank->printData(); }
  ;

bank_header:
  bank_no org { currentBank = bankFactory.createBank(PRG, $2); }
  | org bank_no { currentBank = bankFactory.createBank(PRG, $1); }
  ;

bank_no:
  T_BANK T_BYTE { cout << "Starting bank " << dec($2) << endl; }
  ;

org:
  T_ORG T_WORD {
    cout << "Bank start: " << hex($2) << endl;
    $$ = $2;
  }
  ;

instructions:
  instructions instruction
  | instruction
  ;

instruction:
  T_LABEL {
    unsigned short labelOffset = currentBank->currentOffset();
    cout << "Found label [" << $1 << "] ref: " << hex(labelOffset) << endl;
    localSymbols.add($1, labelOffset);
  }
  | T_INSTR T_BYTE_IMM {
    $1.base = opcode_set_addr_mode($1.type, $1.base, mode_IMM);

    currentBank->addByte($1.base);
    currentBank->addByte($2);

    logoptype("IMM", $1.base);
    loginstr($2);
  }
  | T_INSTR T_WORD_IMM {
    $1.base = opcode_set_addr_mode($1.type, $1.base, mode_IMM);

    currentBank->addByte($1.base);
    currentBank->addWord($2);

    logoptype("IMM", $1.base);
    loginstr($2);
  }
  | T_INSTR T_BYTE {
    currentBank->addByte($1.base);
    currentBank->addByte($2);

    loginstr($2);
  }
  | T_INSTR T_WORD {
    currentBank->addByte($1.base);
    currentBank->addWord($2);

    loginstr($2);
  }
  | T_INSTR T_SYMBOL {
    logsymbol($2);

    currentBank->addByte($1.base);
    currentBank->addWord($2.address);
  }
  | T_INSTR { loginstr("no value instr."); }
  | T_DATA
  | T_FILE
  | UNKNOWN { yyerror("Unknown instruction"); }
  ;

T_INSTR:
  T_INSTR_CC01   { logoptype("CC01",   $1.base); }
  | T_INSTR_CC10 { logoptype("CC10",   $1.base); }
  | T_INSTR_CC00 { logoptype("CC00",   $1.base); }
  | T_INSTR_BRA  { logoptype("BRANCH", $1.base); }
  | T_INSTR_IS   { logoptype("IS",     $1.base); }
  | T_INSTR_REM  { logoptype("REM",    $1.base); }
  ;

T_DATA:
  T_DATA_WORD { cout << "word data: " << endl; } T_WORDS
  | T_DATA_WORD T_SYMBOL {
    currentBank->addWord($2.address);

    cout << "word data: " << endl;
    logsymbol($2);
  }
  | T_DATA_BYTE { cout << "byte data: " << endl; } T_BYTES
  ;

T_WORDS:
  T_WORDS T_WORD {
    currentBank->addWord($2);

    cout << hex($2) << endl;
  }
  | T_WORDS T_BYTE {
    currentBank->addWord($2);

    cout << hex($2) << endl;
  }
  | T_WORD {
    currentBank->addWord($1);

    cout << hex($1) << endl;
  }
  | T_BYTE {
    currentBank->addWord($1);

    cout << hex($1) << endl;
  }

T_BYTES:
  T_BYTES T_BYTE {
    currentBank->addByte($2);

    cout << hex($2) << endl;
  }
  | T_BYTE {
    currentBank->addByte($1);

    cout << hex($1) << endl;
  }
  ;

T_FILE:
  T_FILE_BINARY T_STRING_LITERAL {
    currentBank->addBinary($2);

    cout << "Adding binary: " << $2 << endl;
  }
  ;

%%

int main() {
  const char *fileName = "test.asm";

  // open a file handle to a particular file:
  FILE *myfile = fopen(fileName, "r");
  // make sure it's valid:
  if (!myfile) {
    cout << "I can't open " << fileName << " file!" << endl;
    return -1;
  }
  // set flex to read from it instead of defaulting to STDIN:
  yyin = myfile;

  // parse through the input until there is no more:
  do {
    yyparse();
  } while (!feof(yyin));
}

string hex(unsigned int c) {
  ostringstream stm;
  stm << '$' << hex << c;
  return stm.str();
}

string dec(unsigned int c) {
  ostringstream stm;
  stm << dec << c;
  return stm.str();
}

void logoptype(const char *type, unsigned char base) {
  cout << "[" << type << ":\t" << hex(base) << "]\t";
}

void logaddrmode(const char *mode) {
  cout << "[AM: " << mode << "]\t";
}

void logline() {
  cout << "(" << line_num << ")\t";
}

void loginstr(unsigned int c) {
  logline();
  cout << "Instr: " << hex(c) << endl;
}

void loginstr(const char *s) {
  logline();
  cout << "Instr: " << s << endl;
}

void logsymbol(symbol s) {
  logline();
  cout << "Symbol [" << s.name << "] = " << hex(s.address) << endl;
}

void yyerror(const char *s) {
  cout << "Error on line (" << line_num << "): " << s << endl;
  cout << "\nAborting!\n" << endl;
  exit(-1);
}
