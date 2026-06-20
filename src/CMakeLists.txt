find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

set(YANA_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(YANA_GEN_DIR ${CMAKE_CURRENT_BINARY_DIR})

BISON_TARGET(yana_parser
  ${YANA_SRC_DIR}/parser.y
  ${YANA_GEN_DIR}/parser.c
  DEFINES_FILE ${YANA_GEN_DIR}/parser.h
)

FLEX_TARGET(yana_scanner
  ${YANA_SRC_DIR}/scanner.l
  ${YANA_GEN_DIR}/scanner.cpp
)

ADD_FLEX_BISON_DEPENDENCY(yana_scanner yana_parser)

add_executable(yana
  main.cpp
  opcodes.c
  symbol.cpp
  bank.cpp
  ${YANA_GEN_DIR}/parser.c
  ${YANA_GEN_DIR}/scanner.cpp
)

target_include_directories(yana PRIVATE
  ${YANA_SRC_DIR}
  ${YANA_GEN_DIR}
)

set_source_files_properties(
  opcodes.c
  ${YANA_GEN_DIR}/parser.c
  PROPERTIES LANGUAGE CXX
)
