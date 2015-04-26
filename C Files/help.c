/*
  File: help.c
  
  Description: Prints out the help information with the commmands.
  Input: nothing
  Output: nothing

*/

#include "game.h"


/* This function prints the commands that can be input into the program */
void helpFunc(){
  printf("\n\nThe following characters can be used for input:\n");
  printf("\t p \t for paper\n");
  printf("\t r \t for rock\n");
  printf("\t s \t for sissors\n");
  printf("\t g \t print the game status\n");
  printf("\t h \t help, print this list\n");
  printf("\t e \t exit this game\n");

}
