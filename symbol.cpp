#include "symbol.h"

using namespace std;

void SymbolTable::add(string name, symbol s) {
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
