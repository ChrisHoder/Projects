/*
  File: printStart.c
  
  Description: This function prints the start menu for the
               rock paper sissors game.
  Input: no inputs
  Output: prints the menu, returns nothing
*/

#include "game.h"

void printStart(){
  printf("So you want to chance your luck against the computer\n");    
  printf("for a game of rock (r), paper (s), sissors (s) \n\n");
  printf("Rules:\npaper covers the rock and wins\n");
  printf("rock breaks the sissors and wins\n");
  printf("sissors cuts the paper and wins\n\n");
  printf("You and the computer will now play.\nWe will keep playing until\
you (e)exit.\n\n");
  printf("Menu:\ng - game status\nh - help\ne - exit\n\n");

    }
