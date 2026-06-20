#include "opcodes.h"

int opcode_set_addr_mode(unsigned char group, unsigned char base, unsigned char addr_mode,
                         unsigned char *out) {
  unsigned char encoded = base;

  switch (group) {
    case opcode_CC01:
      if (!opcode_CC01_set_addr_mode(base, addr_mode, &encoded)) {
        return 0;
      }
      break;
    case opcode_CC10:
      if (!opcode_CC10_set_addr_mode(base, addr_mode, &encoded)) {
        return 0;
      }
      break;
    case opcode_CC00:
      if (!opcode_CC00_set_addr_mode(base, addr_mode, &encoded)) {
        return 0;
      }
      break;
    case opcode_BRANCH:
    case opcode_IS:
    case opcode_REM:
    default:
      encoded = base;
      break;
  }

  *out = encoded;
  return 1;
}

unsigned char opcode_bbb_set_addr_mode(unsigned char base, unsigned char addr_mode) {
  addr_mode = addr_mode & 0x7;
  return base | (addr_mode << 2);
}

int opcode_CC01_set_addr_mode(unsigned char base, unsigned char addr_mode, unsigned char *out) {
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
  if (addr_mode == mode_ACC) {
    return 0;
  }

  *out = opcode_bbb_set_addr_mode(base, addr_mode);
  return 1;
}

int opcode_CC10_set_addr_mode(unsigned char base, unsigned char addr_mode, unsigned char *out) {
  /*
  000 #immediate
  001 zero page
  010 accumulator
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

    case mode_ACC:
      cc10_addr_mode = 0x2;
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
      return 0;
  }

  *out = opcode_bbb_set_addr_mode(base, cc10_addr_mode);
  return 1;
}

static int cc00_addr_mode_valid(unsigned char base, unsigned char addr_mode) {
  unsigned char aaa = (base >> 5) & 0x7;

  switch (aaa) {
    case 1: /* BIT */
      return addr_mode == mode_ZERO || addr_mode == mode_ABS;

    case 2: /* JMP */
      return addr_mode == mode_ABS;

    case 4: /* STY */
      return addr_mode == mode_ZERO || addr_mode == mode_ABS ||
             addr_mode == mode_ZERO_X || addr_mode == mode_ABS_X;

    case 5: /* LDY */
      return addr_mode == mode_IMM || addr_mode == mode_ZERO ||
             addr_mode == mode_ZERO_X || addr_mode == mode_ABS ||
             addr_mode == mode_ABS_X;

    case 6: /* CPY */
    case 7: /* CPX */
      return addr_mode == mode_IMM || addr_mode == mode_ABS;

    default:
      return 0;
  }
}

int opcode_CC00_set_addr_mode(unsigned char base, unsigned char addr_mode, unsigned char *out) {
  if (!cc00_addr_mode_valid(base, addr_mode)) {
    return 0;
  }

  return opcode_CC10_set_addr_mode(base, addr_mode, out);
}

int branch_relative(unsigned short from, unsigned short to, char *out) {
  // We're assuming that from is sent pre change of offset
  short distance = (to - 1) - (from + 1);
  if (distance < -128 || distance > 127) {
    return 0;
  }
  *out = (char)distance;
  return 1;
}
