%{
#include <cstdio>
#include <iostream>
#include <sstream>
using namespace std;

#include "parser.h"  // to get the token types that we return
#include "opcodes.h"

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
extern int line_num;

std::string hex(unsigned int c);
std::string dec(unsigned int c);
void logoptype(const char *type, unsigned char base);
void logaddrmode(const char *mode);
void loginstr(unsigned int c);
void loginstr(const char *s);
void yyerror(const char *s);

%}

%union {
  unsigned char byte;
  unsigned short word;

  struct opcode {
    unsigned char type;
    unsigned char base;
  } opcode;
}

%token T_INES_PRG T_INES_CHR T_INES_MIR T_INES_MAP
%token T_BANK T_ORG
%token T_DATA_WORD T_DATA_BYTE
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

%type <byte> T_IMMEDIATE
%type <opcode> T_INSTR

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
  bank_header instructions
  ;

bank_header:
  bank_no org
  | org bank_no
  ;

bank_no:
  T_BANK T_BYTE { cout << "Starting bank " << dec($2) << endl; }
  ;

org:
  T_ORG T_WORD { cout << "Bank start: " << hex($2) << endl; }
  ;

instructions:
  instructions instruction
  | instruction
  ;

instruction:
  T_INSTR T_IMMEDIATE {
    $1.base = opcode_set_addr_mode($1.type, $1.base, mode_IMM);
    logoptype("IMM", $1.base);
    loginstr($2);
  }
  | T_INSTR T_BYTE { loginstr($2); }
  | T_INSTR T_WORD { loginstr($2); }
  | T_INSTR { loginstr("no value instr."); }
  | T_DATA
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

T_IMMEDIATE:
  T_BYTE_IMM
  | T_WORD_IMM
  ;

T_DATA:
  T_DATA_WORD { cout << "word data: " << endl; } T_WORDS
  | T_DATA_BYTE { cout << "byte data: " << endl; } T_BYTES
  ;

T_WORDS:
  T_WORDS T_WORD { cout << hex($2) << endl; }
  | T_WORDS T_BYTE { cout << hex($2) << endl; }
  | T_WORD { cout << hex($1) << endl; }
  | T_BYTE { cout << hex($1) << endl; }

T_BYTES:
  T_BYTES T_BYTE { cout << hex($2) << endl; }
  | T_BYTE { cout << hex($1) << endl; }
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

std::string hex(unsigned int c) {
    std::ostringstream stm;
    stm << '$' << std::hex << c;
    return stm.str();
}

std::string dec(unsigned int c) {
    std::ostringstream stm;
    stm << std::dec << c;
    return stm.str();
}

void logoptype(const char *type, unsigned char base) {
  cout << "[" << type << ":\t" << hex(base) << "]\t";
}

void logaddrmode(const char *mode) {
  cout << "[AM: " << mode << "]\t";
}

void loginstr(unsigned int c) {
  cout << "(" << line_num << ")\t" << "Instr: " << hex(c) << endl;
}

void loginstr(const char *s) {
  cout << "(" << line_num << ")\t" << "Instr: " << s << endl;
}

void yyerror(const char *s) {
  cout << "Error on line (" << line_num << "): " << s << endl;
  cout << "\nAborting!\n" << endl;
  exit(-1);
}
