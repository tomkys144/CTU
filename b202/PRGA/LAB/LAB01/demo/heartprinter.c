/*
 * This file prints UTF-8 heart symbol to stdout.
 * zoulamar, 20200210
 */

#include <stdio.h>

int main () {
  // UTF-8 ecoding of a single character may consist of several bytes instead of single byte as it is with ASCII.
  // ASCII is a subset of UTF-8 - UTF-8 is backward-compatible with ASCII
  char heart_utf8 [] = {0xE2, 0x9D, 0xA4};

  // The only thing we need to do is to pass all three bytes to stdout and pray, that the terminal emulator has got support for UTF-8
  for(int i = 0; i < 3; i++){
    putc(heart_utf8[i], stdout);
  }
}
