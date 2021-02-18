/*
 * This file assigns a random color to each char from stdin and passes it to stdout.
 * zoulamar, 20200210
 */

#include <stdio.h>
#include <time.h>
#include <stdlib.h>

// These are ANSI escape codes. Some terminals recognise such sequences and behave accordingly.
// In particular, these codes change color of following text.
#define CRED "\x1B[31m"
#define CGRN "\x1B[32m"
#define CYEL "\x1B[33m"
#define CBLU "\x1B[34m"
#define CMAG "\x1B[35m"
#define CCYA "\x1B[36m"
#define CNRM "\x1B[0m" // This is a default color.

int main () {

  // Strings in array may be indexed during runtime.
  char * colors [] = {CRED, CGRN, CYEL, CBLU, CMAG, CCYA};
  
  // Sadly, in C we cannod do pythonic len(colors)...
  unsigned int colors_cnt = 6;
  
  // This method seeds random number generator with current time.
  srand(time(NULL)); 

  // Process all chars in input
  while(!feof(stdin)){
    int c = getc(stdin);
    if(c < 0) return 0; // Check for End-Of-File indicator

    // Determine which color will be used for this char
    int idx = (unsigned int) rand() % colors_cnt;

    // Print the colored char
    printf("%s", colors[idx]); // Set the color by escape code
    putc(c, stdout); // Print char, now colored
    printf("%s", CNRM); // Set color back

    // Create debug log to stderr
    fprintf(stderr, "Printing %c with color %u.\n", c, idx);
  }
  return 0;
}
