CXXFLAGS=--std=c++11 -Wno-deprecated-register

SAMPLES=test.asm sprites.asm
BINARIES=$(SAMPLES:.asm=.nes)
CMP_BINARIES=$(BINARIES:.nes=_nesasm.nes)

default: clean yana

test: default $(CMP_BINARIES)

%_nesasm.nes: %.nes
	cmp $^ $@

%.nes: %.asm
	./yana -o $@ $<

clean:
	rm -f yana parser.c parser.h scanner.cpp $(BINARIES)

yana: main.cpp opcodes.c parser.c scanner.cpp symbol.cpp bank.cpp
	$(CXX) $(CXXFLAGS) -o $@ $^

parser.c: parser.y
	bison -o $@ -d $^

scanner.cpp: scanner.l
	flex -o $@ $^
