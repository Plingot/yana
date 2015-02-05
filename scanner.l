%option noyywrap
%{
#include <iostream>
#include "parser.h"
using namespace std;
#define YY_DECL extern "C" int yylex()
int line_num = 1;
%}
%%
[ \t]                  ;
lda                    { return INSTR_LDA; }
ldx                    { return INSTR_LDX; }
ldy                    { return INSTR_LDY; }
\$[a-fA-F0-9]{2}       { /*Byte hex value */ yylval.byte = strtol(yytext + 1, 0, 16); return T_BYTE; } ;
\$[a-fA-F0-9]{4}       { /*Word hex value */ yylval.word = strtol(yytext + 1, 0, 16); return T_WORD; } ;
\n                     { ++line_num; return ENDL; }
.                      { return UNKNOWN; }
%%
