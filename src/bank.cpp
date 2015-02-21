#include <iostream>
#include <sstream>
#include <fstream>
#include <vector>
#include <iterator>
#include <map>
#include "bank.h"

using namespace std;

void Bank::alignOffset(unsigned short alignment) {
  unsigned short alignOffset = 0x0;
  unsigned short alignDiff = bankOffset() - alignOffset;
  while (alignDiff >= alignment) {
    alignOffset += alignment;
    alignDiff = bankOffset() - alignOffset;
  }

  _bankOffset = alignOffset;
  if (alignDiff > 0) {
    advanceOffset(_bankOffset + alignDiff);
  }
}

void Bank::addByte(unsigned char byte) {
  *current() = byte;
  advance(1);
}

void Bank::addWord(unsigned short word) {
  addByte(word & 0xff);
  addByte(word >> 8);
}

void Bank::addBinary(const char *fileName) {
  ifstream file(fileName, ios::binary);
  istream_iterator<unsigned char> its(file), end;

  for (; its != end; its++) {
    addByte(*its);
  }

  file.close();
}

#define BYTES_PER_LINE 24

void Bank::printData() {
  int lineCount = BYTES_PER_LINE;
  cout << endl << "-- Printing data --" << endl;
  for (unsigned char *it = begin(); it != current(); ++it) {
    cout << "$" << hex << (unsigned int) *it << "  ";
    if (--lineCount <= 0) {
      cout << endl;
      lineCount = BYTES_PER_LINE;
    }
  }
  cout << endl << "-- End of data --" << endl << endl;
}

void BankTable::add(unsigned int number, unique_ptr<Bank> bank) {
  bank_map[number] = move(bank);
}

Bank *BankTable::find(unsigned int number) {
  map<unsigned int, unique_ptr<Bank> >::iterator it;
  it = bank_map.find(number);
  if (it == bank_map.end()) {
    return NULL;
  }
  return it->second.get();
}
