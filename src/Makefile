CXXFLAGS=-std=c++0x -stdlib=libc++ -Wno-deprecated-register

SAMPLES=simple.asm sprites.asm sprites2.asm background3.asm pong2.asm controller.asm scrolling5.asm
BINARIES=$(SAMPLES:.asm=.nes)
CMP_BINARIES=$(BINARIES:.nes=)

default: clean yana

test: default $(CMP_BINARIES)

%: %.nes
	cmp $^ $@_nesasm.nes

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
