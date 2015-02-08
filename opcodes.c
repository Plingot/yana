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
  return opcode_bbb_set_addr_mode(base, addr_mode);;
}

unsigned char opcode_CC10_set_addr_mode(unsigned char base, unsigned char addr_mode) {
  /*
  000 #immediate
  001 zero page
  011 absolute
  101 zero page,X
  111 absolute,X
   */
  unsigned char cc10_addr_mode = 0;
  switch (addr_mode) {
    case mode_ZERO:
      cc10_addr_mode = 0x1;
      break;

    case mode_ABS:
      cc10_addr_mode = 0x3;
      break;

    case mode_IMM:
    default:
      break;
  }
  return opcode_bbb_set_addr_mode(base, cc10_addr_mode);
}

unsigned char opcode_CC00_set_addr_mode(unsigned char base, unsigned char addr_mode) {
  switch (addr_mode) {
    case mode_IMM:
      base = opcode_CC10_set_addr_mode(base, addr_mode);
      break;

    default:
      break;
  }
  return base;
}
