/*
  File: gameStats.c
  
  Description: this function prints out the game stats at the moment

*/


#include "game.h"

void gameStats(){
  /* prints all the stat info kept in the user structure */
  printf("Game status:\n");
  printf("\tWin:\t%3d\n",user.wins);
  printf("\tLose:\t%3d\n",user.loss);
  printf("\tTie:\t%3d\n",user.ties);
  printf("\tTotal:\t%3d\n\n",(user.wins+user.loss));
  
  /* determines who the overal winner was */
  if (user.wins > user.loss)
    printf("Darn it you won!\n\n");
  else if ( user.loss > user.wins )
    printf("The computer wins!\n\n");
  else if ( user.loss == user.wins )
    printf("Nobody wins! It's a tie\n\n");

}
