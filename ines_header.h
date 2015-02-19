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

  void setCHRRomSize(unsigned char size) {
    data.at(5) = size;
  };

  void setMapper(unsigned char mapper) {
    unsigned char upper = mapper >> 4;
    unsigned char lower = mapper & 0xf;
    flags6 = flags6 | (lower << 4);
    flags7 = flags7 | (upper << 4);
    updateFlags6();
    updateFlags7();
  };

  void setMirroring(unsigned char type) {
    // Make sure we only set mirroring bits
    type = type | 0x9;
    flags6 = flags6 | type;
    updateFlags6();
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

  void setTrainer(bool trainer) {
    if (trainer) {
      flags6 = flags6 | 0x4;
    } else if ((flags6 & 0x4) == 0x4) {
      flags6 = flags6 ^ 0x4;
    }
    updateFlags6();
  };

  virtual unsigned char operator[](unsigned short i) const {
    return data.at(i);
  };
  virtual unsigned char &operator[](unsigned short i) {
    return data.at(i);
  };

protected:
  virtual void advance(unsigned short step) {
    _current += step;
    if (_current > data.end()) {
      _current = data.end();
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
