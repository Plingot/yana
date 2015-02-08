#include "opcodes.h"

unsigned char opcode_set_addr_mode(unsigned char group, unsigned char base, unsigned char addr_mode) {
  switch (group) {
    case opcode_CC01:
      base = opcode_CC01_set_addr_mode(base, addr_mode);
      break;
    case opcode_CC10:
      break;
    case opcode_CC00:
      break;
    case opcode_BRANCH:
      break;
    case opcode_IS:
      break;
    case opcode_REM:
      break;
    default:
      break;
  }
  return base;
}

unsigned char opcode_CC01_set_addr_mode(unsigned char base, unsigned char addr_mode) {
  switch (addr_mode) {
    case mode_IMM:
      base |= (addr_mode << 2);
      break;

    default:
      break;
  }
  return base;
}

unsigned char opcode_CC10_set_addr_mode(unsigned char base, unsigned char addr_mode) {
  switch (addr_mode) {
    case mode_IMM:
    default:
      break;
  }
  return base;
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
