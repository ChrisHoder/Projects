/*
  File: rps.c
  
  Description: play the game rock, paper sissors with stats kept track of

*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void printStart();
void gameRun();
void gameStats();
void playGame(char, char);
void helpFunc();
char computerChoice();
void looseFunc();
void winFunc();
void tieFunc();
char userInput();

/* user data */
struct 
 {
  int wins;
  int loss;
  int ties;
  int total;
} user;


/* Starts the rpc program an initializes the variables */
int main(){
  gameRun();
  return 0;
}

/* This function will print out the starting information of the program */

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



/* This function will output the current game stats */
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

/* This function will output that the user was the winner
   and update the game stats
*/
void winFunc(){
  printf("You Win!\n\n");
  ++user.wins;
}

/* This function will output that the user is the looser
   and update the game stats
*/
void looseFunc(){
  printf("You Loose!\n\n");
  ++user.loss;
}

/* This function will output that the user and computer
   tied. and update the game stats
*/
void tieFunc(){
  printf("Tie Game\n\n");
  ++user.ties;
}

