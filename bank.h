#ifndef BANK_H
#define BANK_H

#include <array>
#include <map>

using namespace std;

enum bank_type{PRG, CHR};

class Bank {
public:
  Bank(unsigned short i) : _bankOffset(i) {};
  ~Bank() {};

  void addByte(unsigned char byte);
  void addWord(unsigned short word);
  void addBinary(const char *fileName);
  void printData();

  virtual unsigned char operator[](unsigned short i) const = 0;
  virtual unsigned char &operator[](unsigned short i) = 0;

  unsigned short bankOffset() { return _bankOffset; };
  unsigned short currentOffset() {
    return bankOffset() + (current() - begin());
  };
  void advanceOffset(unsigned short offset) {
    cout << "Current offset: $" << hex << currentOffset() << endl;
    short relative = offset - currentOffset();
    advance(relative);
    cout << "Advanced " << relative << " steps, to: $" << hex << offset << endl;
  };

protected:
  virtual void advance(short step) = 0;
  virtual unsigned char *begin() = 0;
  virtual unsigned char *current() = 0;
  virtual unsigned char *last() = 0;

private:
  unsigned short _bankOffset;
};

class Bank8 : public Bank {
public:
  Bank8(unsigned short i) : Bank(i), _current(data.begin()) {};
  ~Bank8() {};

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
  typedef array<unsigned char, 8192> Array8k;
  Array8k data;
  Array8k::iterator _current;
};

class Bank16 : public Bank {
public:
  Bank16(unsigned short i) : Bank(i), _current(data.begin()) {};
  ~Bank16() {};

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
  typedef array<unsigned char, 16384> Array16k;
  Array16k data;
  Array16k::iterator _current;
};


class BankFactory {
public:
  unique_ptr<Bank> createBank(bank_type type, unsigned short offset) {
    Bank *bank;

    switch (type) {
      case CHR:
        bank = new Bank8(offset);
        break;

      case PRG:
      default:
        bank = new Bank16(offset);
        break;
    }

    unique_ptr<Bank> result(bank);
    return result;
  }
};

struct less_num {

};

class BankTable {
public:
  void add(unsigned int number, unique_ptr<Bank> bank);
  Bank *find(unsigned int number);

private:
  map<unsigned int, unique_ptr<Bank> > bank_map;
};

#endif
