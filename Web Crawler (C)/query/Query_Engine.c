//FILE: Query_Engine.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include "../utl/header.h"
#include "../utl/file.h"
#include "QueryEngine.h"

DICTIONARY *dict = NULL;

// This function runs the Query Engine. It will keep an infinite loop
// until user exits
// INPUT: [INDEX] [TARGET_DIRECTORY]
// OUTPUT: 0 upon good completion

/*
  pseudocode

  1) Check inputs -- should be 3
  2) get correct path string to directory
  3) read index from the index file and create INVERTED_INDEX
  4) WHILE ( TRUE ) DO
      - get user query
      - q for quit, h for help
      - parse user query and get unsorted list
      - sort list
      - print list
      - free list for next loop
      - free input for next loop
      END
   5) Clear index


*/

int main(int argc, char *argv[]){
  //input validation. The validity of the index and the directory
  //                  will be validated when they are called
  if ( argc != 3 ){
    printf("Usage: ./Query_Engine [INDEX] [TARGET_DIRECTORY]\n");
    exit(-1);
  }

  

 
  DocumentNode *FL;
  char *input,*path;
  //malloc memory for the input from user to go with arbitrary max length
  input = (char *)malloc(MAX_INPUT_LENGTH);
  MALLOC_CHECK(input);
  BZERO(input,MAX_INPUT_LENGTH);

  // get the path to read files from
  path = checkPath(argv[2]);

  //read index from file and recreate the INVERTED_INDEX
  readIndexFromFile(argv[1]);
  

  //Inifinite loop for the user to continuously query search
  while( 1 ){

    printf("\nInput to tinysearch - type keywords:\n\nTinySearch>");
 
   //read user query search    
    fgets(input,MAX_INPUT_LENGTH,stdin);

    // if user input q -- quit the program
    if((input[0] == 'q') && (strlen(input) == 2)){
      break;
    }


    //if the user input h -- show the help diagram    
    if( (input[0] == 'h') && (strlen(input) == 2)){
      printf("\n\tHELP MENU\n\n");
      printf("h - Help Menu (this information)\n");
      printf("q - quit Query Engine\n");
      printf("Switches:\n");
      printf("\tAND OR\n");
      continue;
    }

    //if the user inputs nothing - show them usage
    if( strlen(input) < 2 ){
      printf("usage ./Query_Engine [INDEX] [TARGET_DIRECTORY]\n\n");
      continue;
    }

   
    // this will get the unsorted list from the input request
    FL = getList(input);
    // sort the list based on frequency
    FL = sortList(FL);
    
    //print the sorted list to the screen
    printList(FL,path);
    //zero the input to repeat
    BZERO(input,MAX_INPUT_LENGTH);
    freeDocNodeList(FL);
  }
  
  

  //clear INVERTED_INDEX
  cleanINVERTED_INDEX();


  free(input);
  free(path);
  //cleanINDEX();
  
  // dict = NULL;

  free(dict);
  return 0;
}

