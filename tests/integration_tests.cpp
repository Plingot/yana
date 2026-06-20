#include <catch2/catch_test_macros.hpp>

#include "yana_test_config.h"

#include <cstdlib>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>

#if defined(_WIN32)
#include <io.h>
#define WEXITSTATUS(status) (status)
#else
#include <sys/wait.h>
#endif

namespace {

std::string shell_quote(const std::string &value) {
  std::string quoted = "'";
  for (char ch : value) {
    if (ch == '\'') {
      quoted += "'\\''";
    } else {
      quoted += ch;
    }
  }
  quoted += "'";
  return quoted;
}

std::string read_file(const std::string &path, bool required = true) {
  std::ifstream input(path, std::ios::binary);
  if (!input.is_open()) {
    if (required) {
      FAIL("Unable to open file: " << path);
    }
    return {};
  }
  std::ostringstream buffer;
  buffer << input.rdbuf();
  return buffer.str();
}

struct ProcessResult {
  int exit_code = -1;
  std::string stderr_text;
};

ProcessResult run_yana(const std::vector<std::string> &args) {
  const std::string stderr_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_stderr.txt";

  std::ostringstream command;
  command << "cd " << shell_quote(YANA_DATA_DIR) << " && ";
  command << shell_quote(YANA_BIN);
  for (const auto &arg : args) {
    command << ' ' << shell_quote(arg);
  }
  command << " >/dev/null 2> " << shell_quote(stderr_path);

  ProcessResult result;
  const int status = std::system(command.str().c_str());
  if (status == -1) {
    return result;
  }

  result.exit_code = WEXITSTATUS(status);
  result.stderr_text = read_file(stderr_path, false);
  std::remove(stderr_path.c_str());
  return result;
}

void compare_assembly(const std::string &asm_file) {
  const std::string base = asm_file.substr(0, asm_file.find('.'));
  const std::string output = ".yana_test_" + base + ".nes";
  const std::string reference = std::string(YANA_DATA_DIR) + '/' + base + "_nesasm.nes";

  const ProcessResult result = run_yana({"-o", output, asm_file});
  REQUIRE(result.exit_code == 0);

  const std::string actual = read_file(std::string(YANA_DATA_DIR) + '/' + output);
  const std::string expected = read_file(reference);
  std::remove((std::string(YANA_DATA_DIR) + '/' + output).c_str());

  REQUIRE(actual == expected);
}

void expect_assembler_failure(const std::vector<std::string> &args) {
  const ProcessResult result = run_yana(args);
  REQUIRE(result.exit_code != 0);
}

}  // namespace

TEST_CASE("simple.asm matches NESASM3 reference", "[integration][assembly]") {
  compare_assembly("simple.asm");
}

TEST_CASE("sprites.asm matches NESASM3 reference", "[integration][assembly]") {
  compare_assembly("sprites.asm");
}

TEST_CASE("sprites2.asm matches NESASM3 reference", "[integration][assembly]") {
  compare_assembly("sprites2.asm");
}

TEST_CASE("background3.asm matches NESASM3 reference", "[integration][assembly]") {
  compare_assembly("background3.asm");
}

TEST_CASE("pong2.asm matches NESASM3 reference", "[integration][assembly]") {
  compare_assembly("pong2.asm");
}

TEST_CASE("controller.asm matches NESASM3 reference", "[integration][assembly]") {
  compare_assembly("controller.asm");
}

TEST_CASE("scrolling5.asm matches NESASM3 reference", "[integration][assembly]") {
  compare_assembly("scrolling5.asm");
}

TEST_CASE("missing input file is rejected", "[integration][negative]") {
  expect_assembler_failure({"nonexistent/input.asm"});
}

TEST_CASE("unresolved symbol is rejected", "[integration][negative]") {
  expect_assembler_failure({"-o", ".yana_test_unresolved.nes", "negative/unresolved.asm"});
}

TEST_CASE("branch out of range is rejected", "[integration][negative]") {
  expect_assembler_failure({"-o", ".yana_test_branch.nes", "negative/branch_range.asm"});
}

TEST_CASE("missing incbin file is rejected", "[integration][negative]") {
  expect_assembler_failure({"-o", ".yana_test_incbin.nes", "negative/missing_incbin.asm"});
}

TEST_CASE("word expressions support add/subtract with parentheses",
          "[integration][assembly]") {
  const std::string asm_path = std::string(YANA_DATA_DIR) + "/.yana_test_word_expr.asm";
  const std::string output_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_word_expr.nes";

  {
    std::ofstream output(asm_path);
    REQUIRE(output.is_open());
    output << ".inesprg 1\n";
    output << ".ineschr 0\n";
    output << ".inesmap 0\n";
    output << ".inesmir 1\n\n";
    output << ".bank 0\n";
    output << ".org $8000\n\n";
    output << "base = $1234\n";
    output << ".dw $100 + 1, base + 1, ($100 + 2) - 1\n";
    output << "LDA base + ($10 - 1)\n";
  }

  const ProcessResult result =
      run_yana({"-o", ".yana_test_word_expr.nes", ".yana_test_word_expr.asm"});
  REQUIRE(result.exit_code == 0);

  const std::string rom = read_file(output_path);
  REQUIRE(rom.size() >= 16 + 9);
  const std::vector<unsigned char> actual(rom.begin() + 16, rom.begin() + 16 + 9);
  const std::vector<unsigned char> expected = {
      0x01, 0x01,        // .dw $100 + 1
      0x35, 0x12,        // .dw base + 1
      0x01, 0x01,        // .dw ($100 + 2) - 1
      0xAD, 0x43, 0x12,  // LDA base + ($10 - 1)
  };

  REQUIRE(actual == expected);

  std::remove(asm_path.c_str());
  std::remove(output_path.c_str());
}
