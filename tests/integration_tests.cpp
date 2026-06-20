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

TEST_CASE("word expressions support bitwise and shift operators",
          "[integration][assembly]") {
  const std::string asm_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_word_bitwise_expr.asm";
  const std::string output_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_word_bitwise_expr.nes";

  {
    std::ofstream output(asm_path);
    REQUIRE(output.is_open());
    output << ".inesprg 1\n";
    output << ".ineschr 0\n";
    output << ".inesmap 0\n";
    output << ".inesmir 1\n\n";
    output << ".bank 0\n";
    output << ".org $8000\n\n";
    output << ".dw ($f0f0 | $000f), ($f0f0 & $0ff0), ($1234 >> 4)\n";
    output << "LDA $1234 | $0003 & $12ff\n";
  }

  const ProcessResult result = run_yana(
      {"-o", ".yana_test_word_bitwise_expr.nes", ".yana_test_word_bitwise_expr.asm"});
  REQUIRE(result.exit_code == 0);

  const std::string rom = read_file(output_path);
  REQUIRE(rom.size() >= 16 + 9);
  const std::vector<unsigned char> actual(rom.begin() + 16, rom.begin() + 16 + 9);
  const std::vector<unsigned char> expected = {
      0xff, 0xf0,        // .dw ($f0f0 | $000f)
      0xf0, 0x00,        // .dw ($f0f0 & $0ff0)
      0x23, 0x01,        // .dw ($1234 >> 4)
      0xad, 0x37, 0x12,  // LDA (($1234 | $0003) & $12ff)
  };

  REQUIRE(actual == expected);

  std::remove(asm_path.c_str());
  std::remove(output_path.c_str());
}

TEST_CASE("invalid addressing mode is rejected", "[integration][negative]") {
  expect_assembler_failure({"-o", ".yana_test_addr_mode.nes", "negative/invalid_addr_mode.asm"});
}

TEST_CASE("immediate value out of range is rejected", "[integration][negative]") {
  expect_assembler_failure({"-o", ".yana_test_immediate.nes", "negative/invalid_immediate.asm"});
}

TEST_CASE("byte expressions support add/subtract and reject out of range",
          "[integration][assembly][negative]") {
  const std::string asm_path = std::string(YANA_DATA_DIR) + "/.yana_test_byte_expr.asm";
  const std::string output_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_byte_expr.nes";

  {
    std::ofstream output(asm_path);
    REQUIRE(output.is_open());
    output << ".inesprg 1\n";
    output << ".ineschr 0\n";
    output << ".inesmap 0\n";
    output << ".inesmir 1\n\n";
    output << ".bank 0\n";
    output << ".org $8000\n\n";
    output << ".db ($10 + 1), ($20 - 1)\n";
    output << "LDA #$10 + 1\n";
    output << "LDA #$ff - 1\n";
    output << "LDA ($20 + 2), Y\n";
    output << "LDA ($20 + 3, X)\n";
  }

  const ProcessResult result =
      run_yana({"-o", ".yana_test_byte_expr.nes", ".yana_test_byte_expr.asm"});
  REQUIRE(result.exit_code == 0);

  const std::string rom = read_file(output_path);
  REQUIRE(rom.size() >= 16 + 10);
  const std::vector<unsigned char> actual(rom.begin() + 16, rom.begin() + 16 + 10);
  const std::vector<unsigned char> expected = {
      0x11, 0x1f,  // .db ($10 + 1), ($20 - 1)
      0xa9, 0x11,  // LDA #($10 + 1)
      0xa9, 0xfe,  // LDA #($ff - 1)
      0xb1, 0x22,  // LDA ($20 + 2), Y
      0xa1, 0x23,  // LDA ($20 + 3, X)
  };
  REQUIRE(actual == expected);

  std::remove(asm_path.c_str());
  std::remove(output_path.c_str());
}

TEST_CASE("byte expressions support bitwise and shift operators",
          "[integration][assembly]") {
  const std::string asm_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_byte_bitwise_expr.asm";
  const std::string output_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_byte_bitwise_expr.nes";

  {
    std::ofstream output(asm_path);
    REQUIRE(output.is_open());
    output << ".inesprg 1\n";
    output << ".ineschr 0\n";
    output << ".inesmap 0\n";
    output << ".inesmir 1\n\n";
    output << ".bank 0\n";
    output << ".org $8000\n\n";
    output << ".db ($f0 | $0f), ($f3 & $0f), ($80 >> 3)\n";
    output << "LDA #$f0 | $01\n";
    output << "LDA #$f3 & $0f\n";
    output << "LDA #$80 >> 2\n";
    output << "LDA ($f0 & $0f), Y\n";
    output << "LDA ($80 >> 2, X)\n";
  }

  const ProcessResult result = run_yana(
      {"-o", ".yana_test_byte_bitwise_expr.nes", ".yana_test_byte_bitwise_expr.asm"});
  REQUIRE(result.exit_code == 0);

  const std::string rom = read_file(output_path);
  REQUIRE(rom.size() >= 16 + 13);
  const std::vector<unsigned char> actual(rom.begin() + 16, rom.begin() + 16 + 13);
  const std::vector<unsigned char> expected = {
      0xff, 0x03, 0x10,  // .db ($f0 | $0f), ($f3 & $0f), ($80 >> 3)
      0xa9, 0xf1,        // LDA #($f0 | $01)
      0xa9, 0x03,        // LDA #($f3 & $0f)
      0xa9, 0x20,        // LDA #($80 >> 2)
      0xb1, 0x00,        // LDA ($f0 & $0f), Y
      0xa1, 0x20,        // LDA ($80 >> 2, X)
  };
  REQUIRE(actual == expected);

  std::remove(asm_path.c_str());
  std::remove(output_path.c_str());
}

TEST_CASE("byte expression out of range is rejected", "[integration][negative]") {
  const std::string asm_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_byte_expr_range.asm";

  {
    std::ofstream output(asm_path);
    REQUIRE(output.is_open());
    output << ".inesprg 1\n";
    output << ".ineschr 0\n";
    output << ".inesmap 0\n";
    output << ".inesmir 1\n\n";
    output << ".bank 0\n";
    output << ".org $8000\n\n";
    output << "LDA #$ff + 1\n";
  }

  const ProcessResult result = run_yana(
      {"-o", ".yana_test_byte_expr_range.nes", ".yana_test_byte_expr_range.asm"});
  REQUIRE(result.exit_code != 0);

  std::remove(asm_path.c_str());
  std::remove((std::string(YANA_DATA_DIR) + "/.yana_test_byte_expr_range.nes").c_str());
}

TEST_CASE("immediate parenthesized expressions are supported",
          "[integration][assembly]") {
  const std::string asm_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_immediate_expr.asm";
  const std::string output_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_immediate_expr.nes";

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
    output << "LDA #($10 + 1)\n";
    output << "LDA #(LOW(base) + 1)\n";
  }

  const ProcessResult result = run_yana(
      {"-o", ".yana_test_immediate_expr.nes", ".yana_test_immediate_expr.asm"});
  REQUIRE(result.exit_code == 0);

  const std::string rom = read_file(output_path);
  REQUIRE(rom.size() >= 16 + 4);
  const std::vector<unsigned char> actual(rom.begin() + 16, rom.begin() + 16 + 4);
  const std::vector<unsigned char> expected = {
      0xa9, 0x11,  // LDA #($10 + 1)
      0xa9, 0x35,  // LDA #(LOW($1234) + 1)
  };
  REQUIRE(actual == expected);

  std::remove(asm_path.c_str());
  std::remove(output_path.c_str());
}

TEST_CASE("jmp absolute and indirect encode distinct opcodes",
          "[integration][assembly]") {
  const std::string asm_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_jmp_modes.asm";
  const std::string output_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_jmp_modes.nes";

  {
    std::ofstream output(asm_path);
    REQUIRE(output.is_open());
    output << ".inesprg 1\n";
    output << ".ineschr 0\n";
    output << ".inesmap 0\n";
    output << ".inesmir 1\n\n";
    output << ".bank 0\n";
    output << ".org $8000\n\n";
    output << "JMP $8000\n";
    output << "JMP ($FFFC)\n";
  }

  const ProcessResult result =
      run_yana({"-o", ".yana_test_jmp_modes.nes", ".yana_test_jmp_modes.asm"});
  REQUIRE(result.exit_code == 0);

  const std::string rom = read_file(output_path);
  REQUIRE(rom.size() >= 16 + 6);
  const std::vector<unsigned char> actual(rom.begin() + 16, rom.begin() + 16 + 6);
  const std::vector<unsigned char> expected = {
      0x4c, 0x00, 0x80,  // JMP $8000
      0x6c, 0xfc, 0xff,  // JMP ($FFFC)
  };
  REQUIRE(actual == expected);

  std::remove(asm_path.c_str());
  std::remove(output_path.c_str());
}

TEST_CASE("forward symbols work inside word/byte data expressions",
          "[integration][assembly]") {
  const std::string asm_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_forward_expr_data.asm";
  const std::string output_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_forward_expr_data.nes";

  {
    std::ofstream output(asm_path);
    REQUIRE(output.is_open());
    output << ".inesprg 1\n";
    output << ".ineschr 0\n";
    output << ".inesmap 0\n";
    output << ".inesmir 1\n\n";
    output << ".bank 0\n";
    output << ".org $0000\n\n";
    output << ".dw ForwardLabel + 1\n";
    output << ".db ForwardLabel, ForwardLabel + 2\n";
    output << "ForwardLabel:\n";
    output << ".db $aa\n";
  }

  const ProcessResult result = run_yana(
      {"-o", ".yana_test_forward_expr_data.nes", ".yana_test_forward_expr_data.asm"});
  REQUIRE(result.exit_code == 0);

  const std::string rom = read_file(output_path);
  REQUIRE(rom.size() >= 16 + 5);
  const std::vector<unsigned char> actual(rom.begin() + 16, rom.begin() + 16 + 5);
  const std::vector<unsigned char> expected = {
      0x05, 0x00,  // .dw ForwardLabel + 1
      0x04,        // .db ForwardLabel
      0x06,        // .db ForwardLabel + 2
      0xaa,        // ForwardLabel
  };
  REQUIRE(actual == expected);

  std::remove(asm_path.c_str());
  std::remove(output_path.c_str());
}

TEST_CASE("comparison operators evaluate to 0 or 1 in expressions",
          "[integration][assembly]") {
  const std::string asm_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_compare_expr.asm";
  const std::string output_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_compare_expr.nes";

  {
    std::ofstream output(asm_path);
    REQUIRE(output.is_open());
    output << ".inesprg 1\n";
    output << ".ineschr 0\n";
    output << ".inesmap 0\n";
    output << ".inesmir 1\n\n";
    output << ".bank 0\n";
    output << ".org $0000\n\n";
    output << ".db $05 = $05\n";
    output << ".db $05 <> $04\n";
    output << ".db $03 < $04\n";
    output << ".db $05 >= $05\n";
  }

  const ProcessResult result = run_yana(
      {"-o", ".yana_test_compare_expr.nes", ".yana_test_compare_expr.asm"});
  REQUIRE(result.exit_code == 0);

  const std::string rom = read_file(output_path);
  REQUIRE(rom.size() >= 16 + 4);
  const std::vector<unsigned char> actual(rom.begin() + 16, rom.begin() + 16 + 4);
  const std::vector<unsigned char> expected = {0x01, 0x01, 0x01, 0x01};
  REQUIRE(actual == expected);

  std::remove(asm_path.c_str());
  std::remove(output_path.c_str());
}

TEST_CASE("inesflags7 directive sets iNES header byte 7", "[integration][assembly]") {
  const std::string asm_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_ines_flags7.asm";
  const std::string output_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_ines_flags7.nes";

  {
    std::ofstream output(asm_path);
    REQUIRE(output.is_open());
    output << ".inesprg 1\n";
    output << ".ineschr 0\n";
    output << ".inesmap 0\n";
    output << ".inesmir 1\n";
    output << ".inesflags7 $AB\n\n";
    output << ".bank 0\n";
    output << ".org $8000\n";
    output << "NOP\n";
  }

  const ProcessResult result = run_yana(
      {"-o", ".yana_test_ines_flags7.nes", ".yana_test_ines_flags7.asm"});
  REQUIRE(result.exit_code == 0);

  const std::string rom = read_file(output_path);
  REQUIRE(rom.size() >= 17);
  REQUIRE(static_cast<unsigned char>(rom[7]) == 0xAB);

  std::remove(asm_path.c_str());
  std::remove(output_path.c_str());
}

TEST_CASE("inesflags9 and inesflags10 directives set NES 2.0 header bytes",
          "[integration][assembly]") {
  const std::string asm_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_ines_flags9_10.asm";
  const std::string output_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_ines_flags9_10.nes";

  {
    std::ofstream output(asm_path);
    REQUIRE(output.is_open());
    output << ".inesprg 1\n";
    output << ".ineschr 0\n";
    output << ".inesmap 0\n";
    output << ".inesmir 1\n";
    output << ".inesflags9 $12\n";
    output << ".inesflags10 $34\n\n";
    output << ".bank 0\n";
    output << ".org $8000\n";
    output << "NOP\n";
  }

  const ProcessResult result = run_yana(
      {"-o", ".yana_test_ines_flags9_10.nes", ".yana_test_ines_flags9_10.asm"});
  REQUIRE(result.exit_code == 0);

  const std::string rom = read_file(output_path);
  REQUIRE(rom.size() >= 17);
  REQUIRE(static_cast<unsigned char>(rom[9]) == 0x12);
  REQUIRE(static_cast<unsigned char>(rom[10]) == 0x34);

  std::remove(asm_path.c_str());
  std::remove(output_path.c_str());
}

TEST_CASE("inestrainer directive writes 512-byte trainer section after header",
          "[integration][assembly]") {
  const std::string asm_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_trainer.asm";
  const std::string output_path =
      std::string(YANA_DATA_DIR) + "/.yana_test_trainer.nes";

  {
    std::ofstream output(asm_path);
    REQUIRE(output.is_open());
    output << ".inesprg 1\n";
    output << ".ineschr 0\n";
    output << ".inesmap 0\n";
    output << ".inesmir 1\n";
    output << ".inestrainer \"HELLO\"\n\n";
    output << ".bank 0\n";
    output << ".org $8000\n";
    output << "NOP\n";
  }

  const ProcessResult result =
      run_yana({"-o", ".yana_test_trainer.nes", ".yana_test_trainer.asm"});
  REQUIRE(result.exit_code == 0);

  const std::string rom = read_file(output_path);
  REQUIRE(rom.size() >= 16 + 512 + 1);
  REQUIRE((static_cast<unsigned char>(rom[6]) & 0x04) != 0);
  REQUIRE(rom.substr(16, 5) == "HELLO");
  REQUIRE(static_cast<unsigned char>(rom[16 + 512]) == 0xEA);  // NOP opcode

  std::remove(asm_path.c_str());
  std::remove(output_path.c_str());
}
