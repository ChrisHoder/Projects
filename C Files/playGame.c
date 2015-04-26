/*
  File: playGame.c
  
  Description: Decides the winner
  Input: computer's choice character, user's choice character
  Output: nothing

*/

#include "game.h"




/* this function takes the computer generated choice and the 
   user's choice and then compares them to see who won.
   the function will then call a win or loose or tie function
   to update stats and output the winner.
*/
void playGame(char computer, char user){
  printf("You: %8c\n",user);
  printf("Computer: %3c\n",computer);
  /* checks to see if there is a tie */ 
 if ( computer == user){
    tieFunc();
  }

 /* no tie. checks to see who wins by going down what the user could have. */
  else {
    /* user said rock */
    if (user == 'r'){
      /* user wins if computer said sissors */
      if (computer == 's'){
	winFunc();
      }
      /* user looses if the computer says paper (only remaining option)*/
      else {
	looseFunc();
      }
    }
    /* user said paper */
    else if ( user == 'p' ){
      /* user wins if the computer said rock */
      if ( computer == 'r' ){
	winFunc();
      }
      /* user looses if the computer said sissors (only remaining option) */ 
      else {
	looseFunc();
      }
 
    }

    /* user sasy rock */
    else if (user == 's'){
      /* user looses if the computer says rock */
      if ( computer == 'r' ){
	looseFunc();
      }
      /* user wins if the computer says papper (only remaining option) */
      else {
	winFunc();
      }
    }
  }
}
