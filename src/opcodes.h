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
0000  (zero page,X)  - Indirect X
0001  zero page      - Zero page
0010  #immediate     - Immediate
0011  absolute       - Absolute
0100  (zero page),Y  - Indirect Y
0101  zero page,X    - Zero page X
0110  absolute,Y     - Absolute Y
0111  absolute,X     - Absolute X
1000  accumulator    - Accumulator - only CC10
 */

#define mode_IND_X  0x00
#define mode_ZERO   0x01
#define mode_IMM    0x02
#define mode_ABS    0x03
#define mode_IND_Y  0x04
#define mode_ZERO_X 0x05
#define mode_ABS_Y  0x06
#define mode_ABS_X  0x07
#define mode_ACC    0x08

unsigned char opcode_set_addr_mode(unsigned char group, unsigned char base, unsigned char addr_mode);
unsigned char opcode_CC01_set_addr_mode(unsigned char base, unsigned char addr_mode);
unsigned char opcode_CC10_set_addr_mode(unsigned char base, unsigned char addr_mode);
unsigned char opcode_CC00_set_addr_mode(unsigned char base, unsigned char addr_mode);

char branch_relative(unsigned short from, unsigned short to);

#endif
