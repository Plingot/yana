#ifndef BANK_H
#define BANK_H

#include <array>
#include <fstream>
#include <map>
#include <memory>
#include <string>
#include "symbol.h"

enum bank_type{PRG, PRG16, CHR};

class Bank {
public:
  Bank(unsigned short i) : _bankOffset(i) {};
  ~Bank() {};

  void alignOffset(unsigned short alignment);
  void addByte(unsigned char byte);
  void addWord(unsigned short word);
  void addBinary(const char *fileName);
  void printData();

  unsigned short bankOffset() { return _bankOffset; };
  unsigned short currentOffset() {
    return bankOffset() + (current() - begin());
  };
  void advanceOffset(unsigned short offset);
  virtual void advance(short step) = 0;

  virtual void write(std::fstream &file) = 0;

protected:
  virtual unsigned char *begin() = 0;
  virtual unsigned char *current() = 0;
  virtual unsigned char *last() = 0;
  virtual void fill(unsigned char value) = 0;

private:
  unsigned short _bankOffset;

  void alignBankOffset();
};

class Bank8 : public Bank {
public:
  Bank8(unsigned short i) : Bank(i), _current(data.begin()) {
    fill(0xff);
  };
  ~Bank8() {};

  virtual void advance(short step);

protected:
  virtual unsigned char *begin() {
    return data.begin();
  };
  virtual unsigned char *current() {
    return _current;
  };
  virtual unsigned char *last() {
    return data.end();
  };
  virtual void fill(unsigned char value) {
    data.fill(value);
  };

  virtual void write(std::fstream &file);

private:
  typedef std::array<unsigned char, 8192> Array8k;
  Array8k data;
  Array8k::iterator _current;
};

class Bank16 : public Bank {
public:
  Bank16(unsigned short i) : Bank(i), _current(data.begin()) {
    fill(0xff);
  };
  ~Bank16() {};

  virtual void advance(short step);

protected:
  virtual unsigned char *begin() {
    return data.begin();
  };
  virtual unsigned char *current() {
    return _current;
  };
  virtual unsigned char *last() {
    return data.end();
  };
  virtual void fill(unsigned char value) {
    data.fill(value);
  };

  virtual void write(std::fstream &file);

private:
  typedef std::array<unsigned char, 16384> Array16k;
  Array16k data;
  Array16k::iterator _current;
};


class BankFactory {
public:
  std::unique_ptr<Bank> createBank(bank_type type, unsigned short offset) {
    Bank *bank;

    switch (type) {
      case PRG16:
        bank = new Bank16(offset);
        bank->alignOffset(0x4000);
        break;

      case CHR:
      case PRG:
      default:
        bank = new Bank8(offset);
        bank->alignOffset(0x2000);
        break;
    }

    std::unique_ptr<Bank> result(bank);
    return result;
  }
};

class BankTable {
public:
  void add(unsigned int number, std::unique_ptr<Bank> bank);
  Bank *find(unsigned int number);
  void write(std::fstream &file);
  bool updateForwardSymbols(SymbolTable &symbolTable);

private:
  std::map<unsigned int, std::unique_ptr<Bank> > bank_map;
};

#endif
