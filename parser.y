%{
#include <cstdio>
#include <iostream>
using namespace std;

#include "parser.h"  // to get the token types that we return

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
extern int line_num;

void yyerror(const char *s);
%}

%union {
  int ival;
}

// define the constant-string tokens:
%token INSTR_LDA INSTR_LDX INSTR_LDY
%token ENDL UNKNOWN

// define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the union:
%token <ival> INT

%%
instructions:
  instructions instruction
  | instruction
  ;

instruction:
  INSTR_LDA INT ENDLS { cout << "Load Accumulator with Memory: " << $2 << endl; }
  | INSTR_LDX INT ENDLS { cout << "Load Index X with Memory: " << $2 << endl; }
  | INSTR_LDY INT ENDLS { cout << "Load Index Y with Memory: " << $2 << endl; }
  | UNKNOWN ENDLS { yyerror("Unknown instruction"); }
  ;

ENDLS:
  ENDLS ENDL
  | ENDL
  ;

%%

int main() {
  // open a file handle to a particular file:
  FILE *myfile = fopen("test.yana", "r");
  // make sure it's valid:
  if (!myfile) {
    cout << "I can't open test.yana file!" << endl;
    return -1;
  }
  // set flex to read from it instead of defaulting to STDIN:
  yyin = myfile;

  // parse through the input until there is no more:
  do {
    yyparse();
  } while (!feof(yyin));
}

void yyerror(const char *s) {
  cout << "Error on line (" << line_num << "): " << s << endl;
  cout << "\nAborting!\n" << endl;
  exit(-1);
}
