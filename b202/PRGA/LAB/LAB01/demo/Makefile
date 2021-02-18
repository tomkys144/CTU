# Makefile example with simplified explanation.
# zoulamar, 20200210

# Makefile is made of "rules".
# First line of rule is formated as "<target> : <prequisities>".
#   Target serves as a key when calling make with arguments (Eg. make demo.) or searching for prequisite. 
#   Prequisities are filenames or other targets which are needed to be up-to-date in order to make the target.
#     Target-Prequisities are recursively checked on their prequisities.
#     File-Prequisities are checked on modification time against cached data.
# Other lines forms a "recipe" - commands to be executed in the case when any prequisity was modified since last make.

# Make always prints command wich is to be executed unless muted.

# First rule is the default one. (When make is called without arguments.)
# We want this reciepe to zip some executable demo.sh. 
#   But we know, that the script relies on some other executables.
#   So we need to specify these dependencies as prequisities.
#   When these prequisities are ready, we may proceed with zipping demo.sh itself.
#   At last we can are certain that the build/demo.sh script has got everything it needs.
build/demo.zip: build/demo.sh
	zip $@ *.c *.sh *.py Makefile

build/demo.sh: demo.sh build build/heartprinter build/colorer build/colorer.py
	@echo "Copying 'demo.sh' and setting executable rights."
	cp demo.sh build/demo.sh
	chmod 700 build/demo.sh # We need to change permission to "read-write-execute".

# This rule specifies, that in order to compile heartprinter executable, heartprinter.c file is required to be up-to-date.
#   ... This rule could be handy for automating your homework.
build/heartprinter: heartprinter.c
	@echo "Compiling heartprinter executable." # Make always prints commands to be executed.
	gcc heartprinter.c -o build/heartprinter

build/colorer.py: colorer.py
	@echo "Copying colorer - python version."
	cp colorer.py build/colorer.py
	chmod 700 build/colorer.py

build/colorer: colorer.c
	@echo "Compiling colorer - C-version."
	gcc colorer.c -o build/colorer

# This rule has no prequisities and thus commands are executed always. In fact it serves as an alias for complex commands.
clean:
	@echo "Cleaning all binaries and runtime-created files."
	rm -r -f build out

# Rule to make a directory if it is missing. Why it triggers even tough no prequisities are present? See https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html
build: 
	@echo "Making directory 'build'"
	mkdir -p build

