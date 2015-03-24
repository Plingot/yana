%{
#include <iostream>
#include "opcodes.h"
#include "symbol.h"
#include "parser.h"

using namespace std;

#define YY_DECL extern "C" int yylex()

int line_num = 1;
SymbolTable localSymbols;

extern void yyerror(const char *s);

inline unsigned char aaabbbcc_base(unsigned char type, unsigned char base) {
  return (base << 5) | type;
}

inline unsigned char branch_base(unsigned char base) {
  // xxy10000
  return (base << 5) | 0x10;
}

inline void opCC01(unsigned char base) {
  yylval.opcode.type = opcode_CC01;
  yylval.opcode.base = aaabbbcc_base(1, base);
  yylval.opcode.lineNum = line_num;
}

inline void opCC10(unsigned char base) {
  yylval.opcode.type = opcode_CC10;
  yylval.opcode.base = aaabbbcc_base(2, base);
  yylval.opcode.lineNum = line_num;
}

inline void opCC00(unsigned char base) {
  yylval.opcode.type = opcode_CC00;
  yylval.opcode.base = aaabbbcc_base(0, base);
  yylval.opcode.lineNum = line_num;
}

inline void opBRA(unsigned char base) {
  yylval.opcode.type = opcode_BRANCH;
  yylval.opcode.base = branch_base(base);
  yylval.opcode.lineNum = line_num;
}

inline void opIS(unsigned char base) {
  yylval.opcode.type = opcode_IS;
  yylval.opcode.base = base;
  yylval.opcode.lineNum = line_num;
}

inline void opREM(unsigned char base) {
  yylval.opcode.type = opcode_REM;
  yylval.opcode.base = base;
  yylval.opcode.lineNum = line_num;
}

%}

%option case-insensitive noyywrap batch
%x COMMENT
%x DEBUG_IGNORE

NAME [a-zA-Z_][a-zA-Z0-9_]*

%%
<COMMENT>\n            { ++line_num; BEGIN(INITIAL); }
<COMMENT>.             ;
\;                     { BEGIN(COMMENT); }
[ \t]                  ;

,                      { return T_COMMA; }
[\(\[]                 { return T_OPEN_PAREN; }
[\)\]]                 { return T_CLOSE_PAREN; }
=                      { return T_EQU; }
equ                    { return T_EQU; }
&                      { return T_BITWISE_AND; }
>>                     { return T_BITWISE_SHR; }
\+                     { return T_ADD; }
-                      { return T_SUB; }

  /* ines header */
\.inesprg              { return T_INES_PRG; }
\.ineschr              { return T_INES_CHR; }
\.inesmir              { return T_INES_MIR; }
\.inesmap              { return T_INES_MAP; }

  /* bank handling */
\.bank                 { return T_BANK; }
\.org                  { return T_ORG; }

  /* data bytes/words */
\.dw                   { return T_DATA_WORD; }
\.db                   { return T_DATA_BYTE; }

  /* file includes */
\.incbin               { return T_FILE_BINARY; }

  /* internal RS counter */
\.rsset                { return T_RS_SET; }
\.rs                   { return T_RS; }

  /* aaabbbcc opcodes - cc = 01 */
ORA                    { opCC01(0); return T_INSTR_CC01; } /* 000 ORA */
AND                    { opCC01(1); return T_INSTR_CC01; } /* 001 AND */
EOR                    { opCC01(2); return T_INSTR_CC01; } /* 010 EOR */
ADC                    { opCC01(3); return T_INSTR_CC01; } /* 011 ADC */
STA                    { opCC01(4); return T_INSTR_CC01; } /* 100 STA */
LDA                    { opCC01(5); return T_INSTR_CC01; } /* 101 LDA */
CMP                    { opCC01(6); return T_INSTR_CC01; } /* 110 CMP */
SBC                    { opCC01(7); return T_INSTR_CC01; } /* 111 SBC */


  /* aaabbbcc opcodes - cc = 10 */
ASL                    { opCC10(0); return T_INSTR_CC10; } /* 000 ASL */
ROL                    { opCC10(1); return T_INSTR_CC10; } /* 001 ROL */
LSR                    { opCC10(2); return T_INSTR_CC10; } /* 010 LSR */
ROR                    { opCC10(3); return T_INSTR_CC10; } /* 011 ROR */
STX                    { opCC10(4); return T_INSTR_CC10; } /* 100 STX */
LDX                    { opCC10(5); return T_INSTR_CC10; } /* 101 LDX */
DEC                    { opCC10(6); return T_INSTR_CC10; } /* 110 DEC */
INC                    { opCC10(7); return T_INSTR_CC10; } /* 111 INC */


  /* aaabbbcc opcodes - cc = 00 */
BIT                    { opCC00(1); return T_INSTR_CC00; } /* 001 BIT */
JMP                    { opCC00(2); return T_INSTR_CC00; } /* 010 JMP */
  /* 011 JMP (abs) */
STY                    { opCC00(4); return T_INSTR_CC00; } /* 100 STY */
LDY                    { opCC00(5); return T_INSTR_CC00; } /* 101 LDY */
CPY                    { opCC00(6); return T_INSTR_CC00; } /* 110 CPY */
CPX                    { opCC00(7); return T_INSTR_CC00; } /* 111 CPX */


  /* conditional branch instructions - xxy10000 */
  /*
    xx  flag
    00  negative
    01  overflow
    10  carry
    11  zero
   */
BPL                    { opBRA(0); return T_INSTR_BRA; }
BMI                    { opBRA(1); return T_INSTR_BRA; }
BVC                    { opBRA(2); return T_INSTR_BRA; }
BVS                    { opBRA(3); return T_INSTR_BRA; }
BCC                    { opBRA(4); return T_INSTR_BRA; }
BCS                    { opBRA(5); return T_INSTR_BRA; }
BNE                    { opBRA(6); return T_INSTR_BRA; }
BEQ                    { opBRA(7); return T_INSTR_BRA; }


  /* interrupt and subroutine instructions */
BRK                    { opIS(0x00); return T_INSTR_IS; }
JSR                    { opIS(0x20); return T_INSTR_IS; }
RTI                    { opIS(0x40); return T_INSTR_IS; }
RTS                    { opIS(0x60); return T_INSTR_IS; }

  /* remaining single-byte instructions */
PHP                    { opREM(0x08); return T_INSTR_REM; }
PLP                    { opREM(0x28); return T_INSTR_REM; }
PHA                    { opREM(0x48); return T_INSTR_REM; }
PLA                    { opREM(0x68); return T_INSTR_REM; }
DEY                    { opREM(0x88); return T_INSTR_REM; }
TAY                    { opREM(0xa8); return T_INSTR_REM; }
INY                    { opREM(0xc8); return T_INSTR_REM; }
INX                    { opREM(0xe8); return T_INSTR_REM; }
CLC                    { opREM(0x18); return T_INSTR_REM; }
SEC                    { opREM(0x38); return T_INSTR_REM; }
CLI                    { opREM(0x58); return T_INSTR_REM; }
SEI                    { opREM(0x78); return T_INSTR_REM; }
TYA                    { opREM(0x98); return T_INSTR_REM; }
CLV                    { opREM(0xb8); return T_INSTR_REM; }
CLD                    { opREM(0xd8); return T_INSTR_REM; }
SED                    { opREM(0xf8); return T_INSTR_REM; }
TXA                    { opREM(0x8a); return T_INSTR_REM; }
TXS                    { opREM(0x9a); return T_INSTR_REM; }
TAX                    { opREM(0xaa); return T_INSTR_REM; }
TSX                    { opREM(0xba); return T_INSTR_REM; }
DEX                    { opREM(0xca); return T_INSTR_REM; }
NOP                    { opREM(0xea); return T_INSTR_REM; }

X                      { return T_X_REGISTER; }
Y                      { return T_Y_REGISTER; }
A                      { return T_ACCUMULATOR; }

#\$[a-fA-F0-9]{2}      { /*Byte hex value - immediate */ yylval.byte = strtol(yytext + 2, 0, 16); return T_BYTE_IMM; } ;
\$[a-fA-F0-9]{2}       { /*Byte hex value */ yylval.byte = strtol(yytext + 1, 0, 16); return T_BYTE; } ;
#\$[a-fA-F0-9]{3,4}    { /*Word hex value - immediate */ yylval.word = strtol(yytext + 2, 0, 16); return T_WORD_IMM; } ;
\$[a-fA-F0-9]{3,4}     { /*Word hex value */ yylval.word = strtol(yytext + 1, 0, 16); return T_WORD; } ;
#%[01]{8}              { /*Byte immediate binary value */ yylval.byte = strtol(yytext + 2, 0, 2); return T_BYTE_IMM; } ;
%[01]{8}               { /*Byte binary value */ yylval.byte = strtol(yytext + 1, 0, 2); return T_BYTE; } ;
[0-9]{1,3}             {
  /* Decimal value */
  unsigned short val = strtol(yytext, 0, 10);
  if (val <= 0xFF) {
    yylval.byte = (unsigned char)(val & 0xFF);
    return T_BYTE;
  }
  yylval.word = val;
  return T_WORD;
};
#[0-9]{1,3}            {
  /* Decimal immediate */
  unsigned short val = strtol(yytext + 1, 0, 10);
  if (val <= 0xFF) {
    yylval.byte = (unsigned char)(val & 0xFF);
    return T_BYTE_IMM;
  }
  yylval.word = val;
  return T_WORD_IMM;
};
HIGH                   { return T_HIGH; }
LOW                    { return T_LOW; }
#HIGH                  { return T_HIGH_IMM; }
#LOW                   { return T_LOW_IMM; }
\"[^"]*\"              { //" <- syntax highlighting fix
  /* String literal */

  // Copy everything but the quotes
  yylval.c_str = strndup(yytext + 1, strlen(yytext) - 2);
  return T_STRING_LITERAL;
};
{NAME}:                {
  /* Named label definition */

  // Copy everything but the colon
  yylval.c_str = strndup(yytext, strlen(yytext) - 1);
  return T_LABEL;
};

{NAME}                 {
  /* Name reference */
  symbol sym = localSymbols.find(yytext);
  if (!sym.name) {
    // Undefined symbol
    yylval.c_str = strdup(yytext);
    return T_FORWARD_SYMBOL;
  }
  yylval.sym = sym;

  if (sym.isByte) {
    return T_SYMBOL_BYTE;
  } else {
    return T_SYMBOL;
  }
};

#{NAME}                {
  /* Name reference - immediate */
  symbol sym = localSymbols.find(yytext + 1);
  if (!sym.name) {
    // Undefined symbol
    yylval.c_str = strdup(yytext + 1);
    return T_FORWARD_SYMBOL_IMM;
  }
  yylval.sym = sym;

  if (sym.isByte) {
    return T_SYMBOL_BYTE_IMM;
  } else {
    return T_SYMBOL_IMM;
  }
};

^\.[0-9]+               {
  /* Branch label */
  unsigned short val = strtol(yytext + 1, 0, 10);
  yylval.byte = (unsigned char)(val & 0xFF);
  return T_BRANCH_LABEL;
}

\.[0-9]+               {
  /* Branch label ref */
  unsigned char ref = (strtol(yytext + 1, 0, 10) & 0xFF);

  symbol sym = localSymbols.findLocal(ref);
  if (!sym.name) {
    // Undefined local branch - throw error
    // yyerror("Found undefined local branch label.");
  }
  yylval.sym = sym;

  if (sym.isByte) {
    return T_SYMBOL_BYTE;
  } else {
    return T_SYMBOL;
  }
}

\n                     { ++line_num; }
%%
