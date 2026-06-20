#include <iostream>
#include <sstream>
#include <fstream>
#include <vector>
#include <iterator>
#include <map>
#include <stdexcept>
#include "bank.h"
#include "opcodes.h"

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
  if (current() >= last()) {
    throw runtime_error("Bank overflow while writing byte");
  }
  *current() = byte;
  advance(1);
}

void Bank::addWord(unsigned short word) {
  addByte(word & 0xff);
  addByte(word >> 8);
}

void Bank::addBinary(const char *fileName) {
  ifstream file(fileName, ios::binary);
  if (!file) {
    throw runtime_error(string("Unable to open binary include: ") + fileName);
  }

  noskipws(file);
  istream_iterator<unsigned char> its(file), end;

  for (; its != end; its++) {
    addByte(*its);
  }
}

void Bank::printData() {
}

void Bank::advanceOffset(unsigned short offset) {
  short relative = offset - currentOffset();
  unsigned char *new_current = current() + relative;
  if (new_current < begin() || new_current > last()) {
    throw runtime_error("Bank position out of bounds while advancing offset");
  }
  advance(relative);
}

void Bank8::advance(short step) {
  unsigned char *new_current = _current + step;
  if (new_current > data.end() || new_current < data.begin()) {
    throw runtime_error("Bank position out of bounds");
  }
  _current = new_current;
}

void Bank8::write(fstream &file) {
  file.write((const char *)data.begin(), data.end() - data.begin());
  if (!file) {
    throw runtime_error("Failed to write bank data");
  }
}

void Bank16::advance(short step) {
  unsigned char *new_current = _current + step;
  if (new_current > data.end() || new_current < data.begin()) {
    throw runtime_error("Bank position out of bounds");
  }
  _current = new_current;
}

void Bank16::write(fstream &file) {
  file.write((const char *)data.begin(), data.end() - data.begin());
  if (!file) {
    throw runtime_error("Failed to write bank data");
  }
}

void BankTable::add(unsigned int number, unique_ptr<Bank> bank) {
  bank_map[number] = move(bank);
}

Bank *BankTable::find(unsigned int number) {
  map<unsigned int, unique_ptr<Bank> >::iterator it;
  it = bank_map.find(number);
  if (it == bank_map.end()) {
    return nullptr;
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
            bank->addByte(sym.address & 0xff);
            break;

          case BYTE_REL: {
            char relative;
            if (!branch_relative(forward.address - 1, sym.address, &relative)) {
              cerr << "error: Branch target out of range!" << endl;
              cerr << "Referenced [" << forward.name << "] at line (" << forward.lineNum << ")." << endl;
              return false;
            }
            bank->addByte(relative);
            break;
          }

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
