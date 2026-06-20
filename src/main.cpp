#include <cstdio>
#include <getopt.h>
#include <iostream>
#include <stdexcept>
#include <string>

#include "ines_header.h"
#include "bank.h"

BankTable bankTable;
InesHeader inesHeader;

extern "C" FILE *yyin;

int yyparse();
void clear_token_pool();

void printUsage() {
  std::cout << "usage: yana [-o|--output=<outfile>] <infile>" << std::endl;
  std::cout << std::endl;
  std::cout << "  If -o is omitted, output is written to <infile>.nes" << std::endl;
  exit(1);
}

std::string defaultOutputPath(const char *inFile) {
  std::string outFile = inFile;
  std::string::size_type dot = outFile.rfind('.');
  if (dot != std::string::npos) {
    outFile.erase(dot);
  }
  outFile += ".nes";
  return outFile;
}

void readArguments(int argc, char *argv[], const char **inFile, std::string *outFile) {
  int c;
  *inFile = nullptr;
  outFile->clear();

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

  if (!*inFile) {
    printUsage();
  }

  if (outFile->empty()) {
    *outFile = defaultOutputPath(*inFile);
  }
}

void parseAsm(const char *inFile) {
  FILE *asmFile = fopen(inFile, "r");
  if (!asmFile) {
    std::cerr << "error: Unable to open " << inFile << " file!" << std::endl;
    exit(1);
  }

  yyin = asmFile;
  clear_token_pool();

  if (yyparse() != 0) {
    std::cerr << "error: Failed to parse " << inFile << std::endl;
    fclose(asmFile);
    exit(1);
  }

  fclose(asmFile);
}

void writeBinary(const std::string &outFile) {
  std::fstream binary(outFile, std::ios::out | std::ios::binary);
  if (!binary) {
    std::cerr << "error: Unable to open output file " << outFile << std::endl;
    exit(1);
  }

  inesHeader.write(binary);
  if (inesHeader.trainer()) {
    inesHeader.writeTrainer(binary);
  }
  bankTable.write(binary);

  if (!binary) {
    std::cerr << "error: Failed to write output file " << outFile << std::endl;
    exit(1);
  }
}

int main(int argc, char *argv[]) {
  const char *inFile = nullptr;
  std::string outFile;

  try {
    readArguments(argc, argv, &inFile, &outFile);
    parseAsm(inFile);
    writeBinary(outFile);
  } catch (const std::exception &e) {
    std::cerr << "error: " << e.what() << std::endl;
    return 1;
  }

  return 0;
}
