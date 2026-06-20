#include "symbol.h"

void SymbolTable::add(std::string name, unsigned short address) {
  symbol s;
  s.name = nullptr;
  s.address = address;
  s.isByte = false;

  symbol_map[name] = s;
}

void SymbolTable::addByte(std::string name, unsigned short address) {
  symbol s;
  s.name = nullptr;
  s.address = address & 0xff;
  s.isByte = true;

  symbol_map[name] = s;
};

void SymbolTable::addForward(std::string name, unsigned char bankNo, unsigned short address, int lineNum, symbol_type type, short exprOffset) {
  forward_symbol s;
  s.name = name;
  s.bankNo = bankNo;
  s.address = address;
  s.lineNum = lineNum;
  s.type = type;
  s.exprOffset = exprOffset;

  forward_symbols.push_back(s);
}

void SymbolTable::addForward(std::string name, unsigned char bankNo, unsigned short address, int lineNum) {
  addForward(name, bankNo, address, lineNum, WORD);
}

void SymbolTable::addForwardExprWord(std::string name, unsigned char bankNo, unsigned short address, int lineNum, short exprOffset) {
  addForward(name, bankNo, address, lineNum, WORD_EXPR, exprOffset);
}

void SymbolTable::addForwardExprByte(std::string name, unsigned char bankNo, unsigned short address, int lineNum, short exprOffset) {
  addForward(name, bankNo, address, lineNum, BYTE_EXPR, exprOffset);
}

void SymbolTable::addForwardHigh(std::string name, unsigned char bankNo, unsigned short address, int lineNum) {
  addForward(name, bankNo, address, lineNum, BYTE_HIGH);
}

void SymbolTable::addForwardLow(std::string name, unsigned char bankNo, unsigned short address, int lineNum) {
  addForward(name, bankNo, address, lineNum, BYTE_LOW);
}

void SymbolTable::addForwardRel(std::string name, unsigned char bankNo, unsigned short address, int lineNum) {
  addForward(name, bankNo, address, lineNum, BYTE_REL);
}

std::vector<forward_symbol>::iterator SymbolTable::forward_symbols_begin() {
  return forward_symbols.begin();
}

std::vector<forward_symbol>::iterator SymbolTable::forward_symbols_end() {
  return forward_symbols.end();
}

symbol SymbolTable::find(std::string name) {
  std::map<std::string, symbol, less_string>::iterator it;
  it = symbol_map.find(name);
  if (it == symbol_map.end()) {
    return symbol{nullptr, 0, false};
  }

  symbol s = it->second;
  s.name = it->first.c_str();
  return s;
}

bool SymbolTable::setForwardRel(int lineNum) {
  std::vector<forward_symbol>::iterator it;
  for (it = forward_symbols.begin(); it != forward_symbols.end(); ++it) {
    if (it->lineNum == lineNum) {
      it->type = BYTE_REL;
      return true;
    }
  }
  return false;
}
