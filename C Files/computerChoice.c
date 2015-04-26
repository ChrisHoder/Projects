/*
  File: computerChioce.c
  
  Description: determines the computer's random pick
  Input: nothing, though assumed that the seed for random has been run
  Output: character chioce (r,p or s)

*/

#include "game.h"


/* This function randomly find out what the computer
   will choose by using the rand() function. The srand() was set
   before calling this function. returns r, p or s char */

char computerChoice(){
  char compLetter;
  int rLetter;
  rLetter = rand()%3;
  if (rLetter == 0)
    compLetter='r';
  else if (rLetter == 1)
    compLetter='p';
  else 
    compLetter='s';
  return(compLetter);
}

