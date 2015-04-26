/*
  File: looseFunc.c
  
  Description: Prints out that the player lost, updates stats
  Input: nothing
  Output: nothing
*/

#include "game.h"

/* This function will output that the user is the looser
   and update the game stats
*/
void looseFunc(){
  printf("You Loose!\n\n");
  ++user.loss;
}
