#include "symbol.h"

using namespace std;

void SymbolTable::add(string name, unsigned short address) {
  symbol s;
  s.name = strdup(name.c_str());
  s.address = address;

  symbol_map[name] = s;
}

void SymbolTable::addForward(string name, unsigned char bankNo, unsigned short address, int lineNum, symbol_type type) {
  forward_symbol s;
  s.name = strdup(name.c_str());
  s.bankNo = bankNo;
  s.address = address;
  s.lineNum = lineNum;
  s.type = type;

  forward_symbols.push_back(s);
}

void SymbolTable::addForward(string name, unsigned char bankNo, unsigned short address, int lineNum) {
  addForward(name, bankNo, address, lineNum, WORD);
}

void SymbolTable::addForwardByte(string name, unsigned char bankNo, unsigned short address, int lineNum) {
  addForward(name, bankNo, address, lineNum, BYTE);
}

void SymbolTable::addForwardHigh(string name, unsigned char bankNo, unsigned short address, int lineNum) {
  addForward(name, bankNo, address, lineNum, BYTE_HIGH);
}

void SymbolTable::addForwardLow(string name, unsigned char bankNo, unsigned short address, int lineNum) {
  addForward(name, bankNo, address, lineNum, BYTE_LOW);
}

void SymbolTable::addForwardRel(string name, unsigned char bankNo, unsigned short address, int lineNum) {
  addForward(name, bankNo, address, lineNum, BYTE_REL);
}

vector<forward_symbol>::iterator SymbolTable::forward_symbols_begin() {
  return forward_symbols.begin();
}

vector<forward_symbol>::iterator SymbolTable::forward_symbols_end() {
  return forward_symbols.end();
}

symbol SymbolTable::find(string name) {
  map<string, symbol, less_string>::iterator it;
  it = symbol_map.find(name);
  if (it == symbol_map.end()) {
    return symbol{};
  }
  return it->second;
}

bool SymbolTable::setForwardRel(int lineNum) {
  vector<forward_symbol>::iterator it;
  for (it = forward_symbols.begin(); it != forward_symbols.end(); ++it) {
    if (it->lineNum == lineNum) {
      it->type = BYTE_REL;
      return true;
    }
  }
  return false;
}
