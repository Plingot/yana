#include "symbol.h"

using namespace std;

void SymbolTable::add(string name, unsigned short address) {
  symbol s;
  s.name = name.c_str();
  s.address = address;

  symbol_map[name] = s;
}

symbol *SymbolTable::find(string name) {
  map<string, symbol, less_string>::iterator it;
  it = symbol_map.find(name);
  if (it == symbol_map.end()) {
    return NULL;
  }
  return &it->second;
}
