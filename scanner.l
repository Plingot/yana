%option noyywrap
%{
#include <iostream>
#include "parser.h"
using namespace std;
#define YY_DECL extern "C" int yylex()
int line_num = 1;
%}
%%
[ \t]          ;
LDA            { return INSTR_LDA; }
LDX            { return INSTR_LDX; }
LDY            { return INSTR_LDY; }
[0-9]+         { yylval.ival = atoi(yytext); return INT; }
\n             { ++line_num; return ENDL; }
.              { return UNKNOWN; }
%%
