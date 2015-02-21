default: clean yana

test: default
	cd src/ ; ./yana

clean:
	cd src/ ; make clean

yana:
	cd src/ ; make yana
