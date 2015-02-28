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

void BankTable::write(fstream &file) {
  map<unsigned int, unique_ptr<Bank> >::iterator it;
  for (it = bank_map.begin(); it != bank_map.end(); it++) {
    it->second->write(file);
  }
}

bool BankTable::updateForwardSymbols(SymbolTable &symbolTable) {
  vector<forward_symbol>::iterator it;
  for (it = symbolTable.forward_symbols_begin(); it != symbolTable.forward_symbols_end(); ++it) {
    forward_symbol forward = *it;
    symbol sym = symbolTable.find(forward.name);
    if (sym.name) {
      Bank *bank = find(forward.bankNo);
      if (bank) {
        bank->advanceOffset(forward.address);

        switch(forward.type) {
          case WORD:
            bank->addWord(sym.address);
            break;

          case BYTE_HIGH:
            bank->addByte(sym.address >> 8);
            break;

          case BYTE_LOW:
            bank->addByte(sym.address | 0xff);
            break;

          default:
            cerr << "error: Unhandled forward symbol type! [" << forward.type << "]" << endl;
            cerr << "Referenced [" << forward.name << "] at line (" << forward.lineNum << ")." << endl;
            return false;
            break;
        }

      } else {
        cerr << "error: Bank not found [" << (int)forward.bankNo << "]!" << endl;
        cerr << "Referenced [" << forward.name << "] at line (" << forward.lineNum << ")." << endl;
        return false;
      }
    } else {
      cerr << "error: Symbol not found [" << forward.name << "]!" << endl;
      cerr << "Referenced [" << forward.name << "] at line (" << forward.lineNum << ")." << endl;
      return false;
    }
  }
  return true;
}
