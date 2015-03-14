CXXFLAGS=-std=c++0x -stdlib=libc++ -Wno-deprecated-register

BINDIR=../bin
TESTDIR=../tests
SAMPLES=simple.asm sprites.asm sprites2.asm background3.asm pong2.asm controller.asm scrolling5.asm
BINARIES=$(SAMPLES:.asm=.nes)
CMP_BINARIES=$(BINARIES:.nes=)

default: clean yana

test: default $(CMP_BINARIES)

%: %.nes
	cmp $^ $(TESTDIR)/$@_nesasm.nes

%.nes: $(TESTDIR)/%.asm
	$(BINDIR)/yana -o $@ $<

clean:
	rm -f $(BINDIR)/yana parser.c parser.h scanner.cpp $(BINARIES)

yana: main.cpp opcodes.c parser.c scanner.cpp symbol.cpp bank.cpp
	$(CXX) $(CXXFLAGS) -o $(BINDIR)/$@ $^

parser.c: parser.y
	bison -o $@ -d $^

scanner.cpp: scanner.l
	flex -o $@ $^
