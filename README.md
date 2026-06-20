[![Build Status](https://travis-ci.org/Plingot/yana.svg)](https://travis-ci.org/Plingot/yana)

# YANA - Yet Another NES Assembler

This is pretty much NESASM, but only supports mapper 0 - so not even as good. But I wrote it and I know how it works. ;)
I will continue developing this for as long as it is fun, and hopefully surpass NESASM in functionality while doing so.

Tested on OSX, should compile on Linux using Clang++ 3.4+ (that's what I use for Travis).

## To build

```sh
cmake -S . -B build
cmake --build build
```

Or:

```sh
make
```

The `yana` binary is written to `build/src/yana`.

## To test

```sh
ctest --test-dir build --output-on-failure
```

Or:

```sh
make test
```

Tests are written with [Catch2](https://github.com/catchorg/Catch2) and registered with CTest. They cover:

- Assembly output comparisons against NESASM3 reference ROMs
- Expected assembler failures such as unresolved symbols, out-of-range branches, and missing `.incbin` files

## License

MIT Licensed. Please contribute if you like this.
