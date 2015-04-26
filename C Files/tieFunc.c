/*
  File: tieFunc.c
  
  Description: prints that the user tied. updates stats, assumes
               structure exists

  Input: nothing

  Output: nothing

*/

#include "game.h"

/* This function will output that the user and computer
   tied. and update the game stats
*/
void tieFunc(){
  printf("Tie Game\n\n");
  ++user.ties;
}

