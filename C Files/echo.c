/*
  File: echo.c
  
  Description: implements the bash echo command. includes the -n option if the user enters it on the command line.

  Outputs: returns 0.
  
  Inputs: what you wanted printed, can use the -n option first to not print the character return.
*/

#define MAXL 3;

#include <stdio.h>
#include <string.h>

/* This function will implement the echo function of bash but only allowing the
   -n option. If a different option is input it will ignore it and print it out
   as part of the echo statement, similar to what would happen with echo in bash */
int main(int argc, char *argv[]) {
  int i;
  int modifier = 0;
  char stringCheck[] = "-n";
  for (i = 1; i <  argc; i++)
    {
      /* checks to see if the first character is the -n modifier */
      if (i==1){
	int cmp;
	cmp = strcmp(stringCheck,argv[i]);
	if ( cmp == 0 ) {
	  modifier = 1;
	}
	/* no modifier will just print the input character */
	else
	  printf("%s ",argv[i]);
      }
      else
	printf("%s ",argv[i]);
    }
  
  /* if the -n switch hasn't been used then it will print this line return */
  if ( modifier == 0 ) {
    printf("\n");
  }
  

  return 0;
}
