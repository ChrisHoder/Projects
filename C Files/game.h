#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main();

/* This function will print out the starting information of the program */
void printStart();

/* this function will play rps with the user and generate random
   computer plays */
void gameRun();

/* This function will output the current game stats */
void gameStats();



/* this function takes the computer generated choice and the 
   user's choice and then compares them to see who won.
   the function will then call a win or loose or tie function
   to update stats and output the winner.
*/
void playGame(char, char);
 
/* this func    prints the commands that can be input into the program */
void helpFunc();

/* This function randomly find out what the computer
   will choose by using the rand() function. The srand() was set
   before calling this function. returns r, p or s char */
char computerChoice();


/* This function will output that the user is the looser
   and update the game stats
*/
void looseFunc();

/* This function will output that the user was the winner
   and update the game stats
*/
void winFunc();



/* This function will output that the user and computer
   tied. and update the game stats
*/
void tieFunc();


/* user data */
struct 
 {
  int wins;
  int loss;
  int ties;
  int total;
} user;
