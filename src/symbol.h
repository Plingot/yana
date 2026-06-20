#ifndef SYMBOL_H
#define SYMBOL_H

#include <iostream>
#include <map>
#include <string>
#include <vector>

struct less_string {
  bool operator()(const std::string &s1, const std::string &s2) const {
    return s1.compare(s2) < 0;
  }
};

enum symbol_type{WORD, BYTE_HIGH, BYTE_LOW, BYTE_REL, WORD_EXPR, BYTE_EXPR};

struct symbol {
  const char *name;
  unsigned short address;
  bool isByte;
};

struct forward_symbol {
  std::string name;
  unsigned char bankNo;
  unsigned short address;
  int lineNum;
  symbol_type type;
  short exprOffset;
};

class SymbolTable {

public:
  void add(std::string name, unsigned short address);
  void addByte(std::string name, unsigned short address);
  void addForward(std::string name, unsigned char bankNo, unsigned short address, int lineNum);
  void addForwardExprWord(std::string name, unsigned char bankNo, unsigned short address, int lineNum, short exprOffset);
  void addForwardExprByte(std::string name, unsigned char bankNo, unsigned short address, int lineNum, short exprOffset);
  void addForwardHigh(std::string name, unsigned char bankNo, unsigned short address, int lineNum);
  void addForwardLow(std::string name, unsigned char bankNo, unsigned short address, int lineNum);
  void addForwardRel(std::string name, unsigned char bankNo, unsigned short address, int lineNum);
  std::vector<forward_symbol>::iterator forward_symbols_begin();
  std::vector<forward_symbol>::iterator forward_symbols_end();
  symbol find(std::string name);
  bool setForwardRel(int lineNum);

private:
  void addForward(std::string name, unsigned char bankNo, unsigned short address, int lineNum, symbol_type type, short exprOffset = 0);

  std::map<std::string, symbol, less_string> symbol_map;
  std::vector<forward_symbol> forward_symbols;

};

#endif
