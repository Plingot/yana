CXXFLAGS=--std=c++11 -Wno-deprecated-register

default: clean yana

test: default
	./yana
	cmp test.nes test_nesasm.nes

clean:
	rm -f yana parser.c parser.h scanner.cpp

yana: opcodes.c parser.c scanner.cpp symbol.cpp bank.cpp
	$(CXX) $(CXXFLAGS) -o $@ $^

parser.c: parser.y
	bison -o $@ -d $^

scanner.cpp: scanner.l
	flex -o $@ $^
