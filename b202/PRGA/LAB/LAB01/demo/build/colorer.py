#!/usr/bin/python3
#
# This file assigns a random color to each char from stdin and passes it to stdout.
# zoulamar, 20200210
#

import random
import sys

# These are ANSI escape codes. Some terminals recognise such sequences and behave accordingly.
# In particular, these codes change color of following text.
# Also, we could use libraries / packages "colored" or "termcolor"
CRED = "\x1B[31m"
CGRN = "\x1B[32m"
CYEL = "\x1B[33m"
CBLU = "\x1B[34m"
CMAG = "\x1B[35m"
CCYA = "\x1B[36m"
CNRM = "\x1B[0m" # This is the default color.

# Strings in array may be indexed during runtime.
colors = [CRED, CGRN, CYEL, CBLU, CMAG, CCYA]
  
# Sadly, in C we cannot do pythonic len(colors)...
colors_cnt = 6

# Process all chars in input
for c in input():

    # Determine which color will be used for this char
    color = random.choice(colors)

    # Print the colored char
    print(color,end="") # Set the color by escape code
    print(c,end="") # Print char, now colored
    print(CNRM,end="") # Set color back

    # Create debug log to stderr
    print(f"Printing {c} with color {color}.", file=sys.stderr);
