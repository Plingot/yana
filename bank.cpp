#include <iostream>
#include <sstream>
#include "bank.h"

using namespace std;

void Bank::addByte(unsigned char byte) {
  *current() = byte;
  advance(1);
}

void Bank::addWord(unsigned short word) {
  addByte(word & 0xff);
  addByte(word >> 8);
}

#define BYTES_PER_LINE 20

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
