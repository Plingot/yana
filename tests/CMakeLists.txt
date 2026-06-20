include(FetchContent)

FetchContent_Declare(
  Catch2
  GIT_REPOSITORY https://github.com/catchorg/Catch2.git
  GIT_TAG v3.7.1
)
FetchContent_MakeAvailable(Catch2)

file(GENERATE
  OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/yana_test_config.h"
  CONTENT "#pragma once
#define YANA_DATA_DIR \"${CMAKE_SOURCE_DIR}/src\"
#define YANA_BIN \"$<TARGET_FILE:yana>\"
"
)

add_executable(yana_tests integration_tests.cpp)
target_include_directories(yana_tests PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(yana_tests PRIVATE Catch2::Catch2WithMain)
add_dependencies(yana_tests yana)

list(APPEND CMAKE_MODULE_PATH ${catch2_SOURCE_DIR}/extras)
include(Catch)

catch_discover_tests(
  yana_tests
  TEST_PREFIX "yana."
  REPORTER compact
)
