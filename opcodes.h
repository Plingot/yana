#ifndef OPCODES_H
#define OPCODES_H

// Opcode groups
#define opcode_CC01     0x01
#define opcode_CC10     0x02
#define opcode_CC00     0x03
#define opcode_BRANCH   0x04
#define opcode_IS       0x05
#define opcode_REM      0x06

// Address modes
/*
000 (zero page,X)
001 zero page
010 #immediate
011 absolute
100 (zero page),Y
101 zero page,X
110 absolute,Y
111 absolute,X
 */

#define mode_IMM 0x02

unsigned char opcode_set_addr_mode(unsigned char group, unsigned char base, unsigned char addr_mode);
unsigned char opcode_CC01_set_addr_mode(unsigned char base, unsigned char addr_mode);
unsigned char opcode_CC10_set_addr_mode(unsigned char base, unsigned char addr_mode);
unsigned char opcode_CC00_set_addr_mode(unsigned char base, unsigned char addr_mode);

#endif
