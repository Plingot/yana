#ifndef INES_HEADER_H
#define INES_HEADER_H

#include "bank.h"

using namespace std;

#define HORZ_MIRROR 0x0
#define VERT_MIRROR 0x1
#define FOUR_SCREEN 0x8

class InesHeader : public Bank {
public:
  InesHeader()
    : Bank(0),
    _current(data.begin()),
    flags6(0x0),
    flags7(0x0),
    flags9(0x0),
    flags10(0x0) {

    // Add the 4 byte costant
    addByte(0x4e);
    addByte(0x45);
    addByte(0x53);
    addByte(0x1a);

    // Advance to end
    advance(0xff);
  };
  ~InesHeader() {};

  void setPRGRomSize(unsigned char size) {
    data.at(4) = size;
  };

  unsigned char prgRomSize() {
    return data.at(4);
  };

  void setCHRRomSize(unsigned char size) {
    data.at(5) = size;
  };

  unsigned char chrRomSize() {
    return data.at(5);
  };

  void setMapper(unsigned char mapper) {
    unsigned char upper = mapper >> 4;
    unsigned char lower = mapper & 0xf;
    flags6 = flags6 | (lower << 4);
    flags7 = flags7 | (upper << 4);
    updateFlags6();
    updateFlags7();
  };

  unsigned char mapper() {
    unsigned char lower = (flags6 >> 4);
    unsigned char upper = (flags7 >> 4);
    return (upper << 4) + lower;
  };

  void setMirroring(unsigned char type) {
    // Make sure we only set mirroring bits
    type = type & 0x9;
    flags6 = flags6 | type;
    updateFlags6();
  };

  string mirroring() {
    unsigned char mirrorValue = flags6 & 0x9;
    string ret;
    switch (mirrorValue) {
      case HORZ_MIRROR:
        ret = "HORZ";
        break;

      case VERT_MIRROR:
        ret = "VERT";
        break;

      case FOUR_SCREEN:
        ret = "4SCR";
        break;

      default:
        ret = "UNKNOWN";
        break;
    }
    return ret;
  };

  void setPRGRamSize(unsigned char size) {
    data.at(8) = size;
  };

  void setSRAM(bool sram) {
    if (sram) {
      flags6 = flags6 | 0x2;
    } else if ((flags6 & 0x2) == 0x2) {
      flags6 = flags6 ^ 0x2;
    }
    updateFlags6();
  };

  bool sram() {
    return ((flags6 & 0x2) > 0);
  };

  void setTrainer(bool trainer) {
    if (trainer) {
      flags6 = flags6 | 0x4;
    } else if ((flags6 & 0x4) == 0x4) {
      flags6 = flags6 ^ 0x4;
    }
    updateFlags6();
  };

  bool trainer() {
    return ((flags6 & 0x4) > 0);
  };

  void setMirroringNESASM(unsigned char value) {
    /*
    0 = H (Horizontal Mirroring ONLY)
    1 = V (Vertical Mirroring ONLY)
    2 = H + Bat. (Horiztonal Mirroring + Battery ON)
    3 = V + Bat. (Vertical Mirroring + Battery ON)
    4 = H + Train. (Horizontal Mirroring + Trainer ON)
    5 = V + Train. (Vertical Mirroring + Trainer ON)
    6 = H + Bat. + Train. (Horizontal Mirroring + Battery and Trainer ON)
    7 = V + Bat. + Train. (Vertical Mirroring + Battery and Trainer ON)
    8 = H + 4scr. (Horizontal Mirroring + 4 Screen VRAM ON)
    9 = V + 4scr. (Vertical Mirroring + 4 Screen VRAM ON)
    A = H + Bat. + 4scr. (Horizontal Mirroring + Battery and 4 Screen VRAM ON)
    B = V + Bat. + 4scr. (Vertical Mirroring + Battery and 4 Screen VRAM ON)
    C = H + 4scr. + Train. (Horizontal Mirroring + 4 Screen VRAM and Trainer ON)
    D = V + 4scr. + Train. (Vertical Mirroring + 4 Screen VRAM and Trainer ON)
    E = H + Bat. + 4scr. + Train. (Horizontal Mirroring + Battery, 4 Screen VRAM,
    and Trainer ON)
    F = V + Bat. + 4scr. + Train. (Vertical Mirroring + Battery, 4 Screen VRAM,
    and Trainer ON)
     */

    // Make sure we only care about lower nybble
    value = value & 0xf;

    // Mirroring mode
    if ((value & 0x8) > 0) {
      setMirroring(FOUR_SCREEN);
    } else if ((value & 0x1) > 0){
      setMirroring(VERT_MIRROR);
    } else {
      setMirroring(HORZ_MIRROR);
    }

    // SRAM
    setSRAM(((value & 0x2) > 0));

    // Trainer
    setTrainer(((value & 0x4) > 0));
  };

  virtual unsigned char operator[](unsigned short i) const {
    return data.at(i);
  };
  virtual unsigned char &operator[](unsigned short i) {
    return data.at(i);
  };

protected:
  virtual void advance(short step) {
    _current += step;
    if (_current > data.end()) {
      _current = data.end();
    } else if (_current < data.begin()) {
      _current = data.begin();
    }
  };
  virtual unsigned char *begin() {
    return data.begin();
  };
  virtual unsigned char *current() {
    return _current;
  };
  virtual unsigned char *last() {
    return data.end();
  };

private:
  void updateFlags6() {
    data.at(6) = flags6;
  };

  void updateFlags7() {
    data.at(7) = flags7;
  };

  void updateFlags9() {
    data.at(9) = flags9;
  };

  void updateFlags10() {
    data.at(10) = flags10;
  };

  typedef array<unsigned char, 16> InesArray;
  InesArray data;
  InesArray::iterator _current;

  unsigned char flags6;
  unsigned char flags7;
  unsigned char flags9;
  unsigned char flags10;
};

#endif
