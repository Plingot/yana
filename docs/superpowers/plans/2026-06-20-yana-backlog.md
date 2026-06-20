# YANA Backlog Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Close prioritized open issues (#72, #29, expression epic #80→#81→#90→#82→#78→#79) with one PR per issue (expression epic split across multiple PRs), proper `Fixes #NN` commit links, and CI validation.

**Architecture:** Keep changes minimal and NESASM-compatible. Use existing CMake/CTest/Catch2 integration tests. Gate or remove assembler debug logging without changing ROM output. Extend scanner/parser for expressions incrementally with reference comparisons where possible.

**Tech Stack:** C++17, Bison/Flex, CMake, Catch2, CTest, GitHub Actions

## Global Constraints

- Do not change ROM output for existing integration fixtures unless fixing a proven bug
- Link every PR/commit to its GitHub issue (`Fixes #NN` or `Closes #NN`)
- One PR per issue (expression epic may use a PR chain)
- All PRs must pass CI matrix (clang++/g++)
- Preserve clear error messages on `stderr`; normal successful assembly must be quiet on `stdout`
- Run `ctest --test-dir build --output-on-failure` before opening each PR

---

### Task 0: GitHub Actions CI (#91)

**Files:**
- Create: `.github/workflows/ci.yml`
- Modify: `README.md`
- Delete: `.travis.yml`

**Status:** PR #92 opened

---

### Task 1: Cleanup debugging output (#72)

**Files:**
- Modify: `src/parser.y` — remove/gate `cout` debug helpers (`logoptype`, `loginstr`, `logsymbol`, etc.)
- Modify: `src/bank.cpp` — remove/gate `printData()` and `advanceOffset()` chatter
- Modify: `src/parser.y` — route `yyerror` to `cerr` and return non-zero instead of `exit(-1)` if needed for tests
- Test: existing Catch2 integration suite (must still pass)

**Interfaces:**
- Produces: quiet successful assembly on stdout

- [ ] **Step 1:** Remove or guard all non-error `cout` logging in parser/bank paths
- [ ] **Step 2:** Ensure errors still print to `stderr`
- [ ] **Step 3:** Run `cmake --build build && ctest --test-dir build --output-on-failure`
- [ ] **Step 4:** Commit `Fixes #72` and open PR

---

### Task 2: Invalid opcode/value validation (#29)

**Files:**
- Modify: `src/opcodes.c`, `src/parser.y`
- Create: `src/negative/invalid_addr_mode.asm` (or similar)
- Modify: `tests/integration_tests.cpp`

**Interfaces:**
- Consumes: quiet assembler from Task 1
- Produces: deterministic failure for invalid opcode/operand combos

- [ ] **Step 1:** Add negative fixture(s) for invalid addressing/operand combinations
- [ ] **Step 2:** Replace silent/broken encoding paths with explicit errors
- [ ] **Step 3:** Add Catch2 negative tests
- [ ] **Step 4:** Run full CTest suite
- [ ] **Step 5:** Commit `Fixes #29` and open PR

---

### Task 3: Word expressions (#80)

**Files:**
- Modify: `src/scanner.l` — add expression tokens/operators
- Modify: `src/parser.y` — add `expr` grammar for word-sized values
- Modify: `tests/integration_tests.cpp` — add fixture comparing NESASM output if available

- [ ] **Step 1:** Implement scanner tokens for literals, symbols, `+`, `-`, parentheses
- [ ] **Step 2:** Add word expression grammar and evaluation
- [ ] **Step 3:** Wire into `word` / `word_imm` rules
- [ ] **Step 4:** Add tests + run CTest
- [ ] **Step 5:** Commit `Fixes #80` and open PR

---

### Task 4: Byte expressions (#81)

**Files:**
- Modify: `src/parser.y` — byte-sized expression grammar
- Modify: `tests/integration_tests.cpp`

- [ ] **Step 1:** Reuse expression infrastructure with 8-bit truncation/validation
- [ ] **Step 2:** Wire into `byte`, `byte_imm`, `zp_byte`
- [ ] **Step 3:** Tests + CTest
- [ ] **Step 4:** Commit `Fixes #81` and open PR

---

### Task 5: Immediate expressions (#90)

**Files:**
- Modify: `src/scanner.l`, `src/parser.y`
- Modify: `tests/integration_tests.cpp`

- [ ] **Step 1:** Support `#(...)` / `#expr` forms used by NESASM
- [ ] **Step 2:** Tests for immediate expression operands
- [ ] **Step 3:** Commit `Fixes #90` and open PR

---

### Task 6: Forward symbol expressions (#82)

**Files:**
- Modify: `src/symbol.cpp`, `src/symbol.h`, `src/parser.y`, `src/bank.cpp`
- Modify: `tests/integration_tests.cpp`

- [ ] **Step 1:** Track forward references inside expressions for second pass
- [ ] **Step 2:** Patch emitted bytes/words after symbol resolution
- [ ] **Step 3:** Tests with forward refs in `.dw`/operands
- [ ] **Step 4:** Commit `Fixes #82` and open PR

---

### Task 7: Remaining operators (#78)

**Files:**
- Modify: `src/scanner.l`, `src/parser.y`

- [ ] **Step 1:** Add `|`, `&`, `>>` (and other missing NESASM operators)
- [ ] **Step 2:** Tests per operator
- [ ] **Step 3:** Commit `Fixes #78` and open PR

---

### Task 8: Comparison operators (#79)

**Files:**
- Modify: `src/scanner.l`, `src/parser.y`

- [ ] **Step 1:** Add comparison operators with NESASM semantics
- [ ] **Step 2:** Tests
- [ ] **Step 3:** Commit `Fixes #79` and open PR
