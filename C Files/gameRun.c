
/*
  File: gameRun.c
  
  Description: Main run function of hte rpc game. this is the game.
  Input: nothing
  Output: nothing

*/

#include "game.h"



/* this function will play rps with the user and generate random computer plays */



void  gameRun() {
  user.wins = 0;
  user.loss = 0;
  user.ties = 0;
  user.total = 0;
  printStart();
  int i=0;

  while (i == 0){
    char comp;
    printf("Enter p, r, or s: ");
    char strchoice[10];
    fgets(strchoice,sizeof(strchoice),stdin);

/* decides action based on input. Either starts game, help, exit or wrong input */
    switch(strchoice[0]) {

      case 'r':
      case 'p':
      case 's':
	/* gets the computer's choice in the game */
	comp = computerChoice();
	/* this function will compare the two choices to determine winner */
	srand(time(NULL));
	playGame(comp,strchoice[0]);
	break;

     case 'h':
      helpFunc();
      break;

    case 'g':
     gameStats();
     break;
  
    case 'e':
      i=1;
      break;

    default:
      printf("\n\nPlease type a correct input character");
      helpFunc();
    }
  }

}


