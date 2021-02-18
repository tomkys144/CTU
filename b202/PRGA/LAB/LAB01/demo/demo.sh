# This script is inteded as a motivation...
# zoulamar@fel.cvut.cz, 2020-02-09

# Detect directory of this file
DIR_THIS="$( cd "$(dirname "$0")" ; pwd -P )"

# Create output directory
mkdir -p $DIR_THIS/../out

# Check if everything was made properly
if [ $? -ne '0' ] # $? is a variable containing the last exit code. In python: No trivial equivalent.
then
  # Echo prints the argument to stdout. In python: print "...";
  echo "Mindboggingly tedious error was encountered: The makefile failed doing what had to be done." 
  exit 42 # This raises a system exit. in python: raise SystemExit;
fi

# Detect input argument if any
if [ -z ${1+x} ]
then
  echo "Setting default subject's code to PRGA"
  PRGCODE="PRGA"
else
  echo "Subject's code from argument: $1"
  PRGCODE=$1
fi

# Prepare a program code depending on subject's flavor
echo -n "$PRGCODE " > $DIR_THIS/../out/prgcode.txt 

# Measure performance of C vs. Python vs. Bash
time sh -c "echo -n 'I '; $DIR_THIS/heartprinter; echo -n ' '; cat $DIR_THIS/../out/prgcode.txt | $DIR_THIS/colorer 2>> $DIR_THIS/stderr.out | tee; echo -n '. (C-program)'"
time sh -c "echo -n 'I '; $DIR_THIS/heartprinter; echo -n ' '; cat $DIR_THIS/../out/prgcode.txt | $DIR_THIS/colorer.py 2>> $DIR_THIS/stderr.out | tee; echo -n '. (Python script)'"
time sh -c "echo -n 'Do you love it too? (Bash)'"

