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

enum symbol_type{WORD, BYTE_HIGH, BYTE_LOW, BYTE_REL};

struct symbol {
  const char *name;
  unsigned short address;
  bool isByte;
};

struct forward_symbol {
  const char *name;
  unsigned char bankNo;
  unsigned short address;
  int lineNum;
  symbol_type type;
};

class SymbolTable {

public:
  void add(string name, unsigned short address);
  void addLocal(unsigned char ref, unsigned short address);
  void addByte(string name, unsigned short address);
  void addForward(string name, unsigned char bankNo, unsigned short address, int lineNum);
  void addForwardHigh(string name, unsigned char bankNo, unsigned short address, int lineNum);
  void addForwardLow(string name, unsigned char bankNo, unsigned short address, int lineNum);
  void addForwardRel(string name, unsigned char bankNo, unsigned short address, int lineNum);
  void addLocalForwardRel(unsigned char ref, unsigned char bankNo, unsigned short address, int lineNum);
  vector<forward_symbol>::iterator forward_symbols_begin();
  vector<forward_symbol>::iterator forward_symbols_end();
  symbol find(string name);
  symbol findLocal(unsigned char ref);
  bool setForwardRel(int lineNum);

private:
  void addForward(string name, unsigned char bankNo, unsigned short address, int lineNum, symbol_type type);

  map<string, symbol, less_string> symbol_map;
  vector<forward_symbol> forward_symbols;

};

#endif
