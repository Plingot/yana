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
  const char *name;
  unsigned short address;
};

class SymbolTable {

public:
  void add(string name, unsigned short address);
  symbol find(string name);

private:
  map<string, symbol, less_string> symbol_map;

};

#endif
