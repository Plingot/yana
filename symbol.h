#ifndef SYMBOL_H
#define SYMBOL_H

#include <iostream>
#include <map>

using namespace std;

struct less_string {
  bool operator()(string s1, string s2) const {
    return s1.compare(s2) < 0;
  }
};

struct symbol {
  unsigned short address;
};

class SymbolTable {

public:
  void add(string name, symbol s);
  symbol *find(string name);

private:
  map<string, symbol, less_string> symbol_map;

};

#endif
