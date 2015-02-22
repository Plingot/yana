#ifndef SYMBOL_H
#define SYMBOL_H

#include <iostream>
#include <map>
#include <vector>

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

struct forward_symbol {
  const char *name;
  unsigned char bankNo;
  unsigned short address;
  int lineNum;
};

class SymbolTable {

public:
  void add(string name, unsigned short address);
  void addForward(string name, unsigned char bankNo, unsigned short address, int lineNum);
  vector<forward_symbol>::iterator forward_symbols_begin();
  vector<forward_symbol>::iterator forward_symbols_end();
  symbol find(string name);

private:
  map<string, symbol, less_string> symbol_map;
  vector<forward_symbol> forward_symbols;

};

#endif
