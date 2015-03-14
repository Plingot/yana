#include <cstdio>
#include <getopt.h>

#include "ines_header.h"
#include "bank.h"

BankTable bankTable;
InesHeader inesHeader;
string asmPath;

extern "C" int yyparse();
extern "C" FILE *yyin;

using namespace std;

string getDirname(const char *fileName) {
  string str = string(fileName);
  size_t found;
  found = str.find_last_of("/\\");
  return str.substr(0, found);
}

void printUsage() {
  cout << "usage: yana [-o|--output[=<outfile>]] <infile>" << endl << endl;
  exit(1);
}

void readArguments(int argc, char *argv[], char **inFile, char **outFile) {
  int c;
  *inFile = NULL;
  *outFile = NULL;

  while (1) {
    static struct option long_options[] = {
      {"output", required_argument, 0, 'o'},
      {0, 0, 0, 0}
    };

    int option_index = 0;

    c = getopt_long (argc, argv, "o:",
                     long_options, &option_index);

    if (c == -1) {
      break;
    }

    switch (c) {
    case 'o':
      *outFile = optarg;
      break;

    default:
      printUsage();
    }
  }

  if (optind < argc) {
    *inFile = argv[optind];
  }

  if (!*inFile || !*outFile) {
    printUsage();
  }
}

void parseAsm(const char *inFile) {
  FILE *asmFile = fopen(inFile, "r");
  if (!asmFile) {
    cerr << "error: Unable to open " << inFile << " file!" << endl;
    exit(1);
  }

  yyin = asmFile;

  do {
    yyparse();
  } while (!feof(yyin));
}

void writeBinary(const char *outFile) {
  fstream binary = fstream(outFile, ios::out | ios::binary);
  inesHeader.write(binary);
  bankTable.write(binary);
  binary.close();
}

int main(int argc, char *argv[]) {
  char *inFile = NULL;
  char *outFile = NULL;
  readArguments(argc, argv, &inFile, &outFile);
  asmPath = getDirname(inFile);
  parseAsm(inFile);
  writeBinary(outFile);
}
