cmake_minimum_required(VERSION 3.16)

project(yana LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wno-deprecated-register)
endif()

enable_testing()

add_subdirectory(src)
add_subdirectory(tests)
