#include "symbol.h"

using namespace std;

const char *localRef(unsigned char ref) {
  char name[100];
  sprintf(name, "local_%d", ref);
  return strdup(name);
}

void SymbolTable::add(string name, unsigned short address) {
  symbol s;
  s.name = strdup(name.c_str());
  s.address = address;
  s.isByte = false;

  symbol_map[name] = s;
}

void SymbolTable::addLocal(unsigned char ref, unsigned short address) {
  add(localRef(ref), address);
}

void SymbolTable::addByte(string name, unsigned short address) {
  symbol s;
  s.name = strdup(name.c_str());
  s.address = address & 0xff;
  s.isByte = true;

  symbol_map[name] = s;
};

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

void SymbolTable::addForwardHigh(string name, unsigned char bankNo, unsigned short address, int lineNum) {
  addForward(name, bankNo, address, lineNum, BYTE_HIGH);
}

void SymbolTable::addForwardLow(string name, unsigned char bankNo, unsigned short address, int lineNum) {
  addForward(name, bankNo, address, lineNum, BYTE_LOW);
}

void SymbolTable::addForwardRel(string name, unsigned char bankNo, unsigned short address, int lineNum) {
  addForward(name, bankNo, address, lineNum, BYTE_REL);
}

void SymbolTable::addLocalForwardRel(unsigned char ref, unsigned char bankNo, unsigned short address, int lineNum) {
  addForward(localRef(ref), bankNo, address, lineNum, BYTE_REL);
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

symbol SymbolTable::findLocal(unsigned char ref) {
  return find(localRef(ref));
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
