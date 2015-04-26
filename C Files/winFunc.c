/*
  File: winFunc.c
  
  Description: prints out that the player won; updates stats
  Input: nothing
  Output: nothing
*/

#include "game.h"

/* This function will output that the user was the winner
   and update the game stats
*/
void winFunc(){
  printf("You Win!\n\n");
  ++user.wins;
}
