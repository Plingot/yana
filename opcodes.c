#include "opcodes.h"

unsigned char opcode_set_addr_mode(unsigned char group, unsigned char base, unsigned char addr_mode) {
  switch (group) {
    case opcode_CC01:
      base = opcode_CC01_set_addr_mode(base, addr_mode);
      break;
    case opcode_CC10:
      base = opcode_CC10_set_addr_mode(base, addr_mode);
      break;
    case opcode_CC00:
      base = opcode_CC00_set_addr_mode(base, addr_mode);
      break;
    case opcode_BRANCH:
    case opcode_IS:
    case opcode_REM:
    default:
      break;
  }
  return base;
}

unsigned char opcode_bbb_set_addr_mode(unsigned char base, unsigned char addr_mode) {
  return base | (addr_mode << 2);
}

unsigned char opcode_CC01_set_addr_mode(unsigned char base, unsigned char addr_mode) {
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
  return opcode_bbb_set_addr_mode(base, addr_mode);;
}

unsigned char opcode_CC10_set_addr_mode(unsigned char base, unsigned char addr_mode) {
  /*
  000 #immediate
  001 zero page
  010 accumulator   - 65C02 only. not NES
  011 absolute
  101 zero page,X
  111 absolute,X
   */
  unsigned char cc10_addr_mode = 0;
  switch (addr_mode) {
    case mode_IMM:
      break;

    case mode_ZERO:
      cc10_addr_mode = 0x1;
      break;

    case mode_ABS:
      cc10_addr_mode = 0x3;
      break;

    case mode_ZERO_X:
      cc10_addr_mode = 0x5;
      break;

    case mode_ABS_X:
      cc10_addr_mode = 0x7;
      break;

    case mode_IND_X:
    case mode_IND_Y:
    case mode_ABS_Y:
    default:
      // throw exception
      break;
  }
  return opcode_bbb_set_addr_mode(base, cc10_addr_mode);
}

unsigned char opcode_CC00_set_addr_mode(unsigned char base, unsigned char addr_mode) {
  // Check if it's jmp
  if (base == 0x40) {
    if (addr_mode == mode_ABS) {
      base = 0x60;
    }
  }

  // Apart from jmp, it's same as CC10 addresses
  return obcode_CC10_set_addr_mode(base, addr_mode);
}
