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
void logoptype(const char *type, unsigned char base);
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

%token UNKNOWN

%token <byte> T_BYTE
%token <word> T_WORD
%token <opcode> T_INSTR_CC01
%token <opcode> T_INSTR_CC10
%token <opcode> T_INSTR_CC00
%token <opcode> T_INSTR_BRA
%token <opcode> T_INSTR_IS
%token <opcode> T_INSTR_REM

%%
instructions:
  instructions instruction
  | instruction
  ;

instruction:
  T_INSTR T_BYTE { loginstr($2); }
  | T_INSTR T_WORD { loginstr($2); }
  | T_INSTR { loginstr("no value instr."); }
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

%%

int main() {
  const char *fileName = "metroid.asm";

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

void logoptype(const char *type, unsigned char base) {
  cout << "[" << type << ":\t" << hex(base) << "]\t";
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
