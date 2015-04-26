// FILE: getList.c

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "../utl/header.h"
#include "../utl/html.h"
#include "QueryEngine.h"


// This function will generate the list of DocNodes corressponding to the input
// query (unsorted) and will return this list.
// INPUT: input string to be inspected
// OUTPUT: pointer to 1st Document Node in List from Query Responses (unsorted)

/*
  pseudocode

  1) Get first word
  2) check to make sure its not 'AND' or 'OR' or no word
  3) Normalize word
  4) store all DocNodes in Templist
  5) WHILE(not end of input) DO
      - get next word, w
      - IF (word is AND) THEN
         - FLAG is 1
	 - continue (return to top of loop)
      - ELSE IF (word is OR) THEN
         - FLAG is 2
	 - continue (return to top of loop)
      - ELSE (i.e. it is a word)
         - IF (FLAG > 2) THEN
	    - IF ( First add to final list) THEN
	        - FinalList = TempList
	      ELSE
	        - AND FinalList and TempList
	      FI
	    - Free TempList
	    - Normalize w
	    - store all DocNodes for w in Templist
	   FI
	 - IF (FLAG == 2 ) THEN
	    - normalize w
	    - OR ( Templist and w DocNodes)
        FI
      - FLAG = 0
    DONE
  6) Free allocated memory
  7) return Final List
	    

*/
DocumentNode *getList(char *input){
  char *w;
  int pos,FLAG,count;
  DocumentNode *TempList,*FL;
 

  //malloc space for 2 words
  w = (char *)malloc(MAX_WORD_LENGTH);
  MALLOC_CHECK(w);
  BZERO(w,MAX_WORD_LENGTH);

  pos = 0;
  count = 0;
  FLAG = 0;
  //while not end

  //first call, can't start with 'AND' or 'OR'
  if( ((pos = getWord(input,w,pos)) < 0) || (strcmp(w,"AND") == 0) || (strcmp(w,"OR") == 0) ){
    LOG("BAD INPUT!");
    exit(-1);
  }
  //normalize/get all DocNodes with first word
  NormalizeWord(w);
  TempList = getDocList(w);
  BZERO(w,MAX_WORD_LENGTH);

  //while not end of string
  while( (pos = getWord(input,w,pos)) > 0){
 
    // Input checking and operation determination
    
    //not OR
    if (strcmp(w,"OR") !=0){
      //word is AND
      if( strcmp(w,"AND") == 0){
	//Bad input -- exit
	if( FLAG > 0 ){
	  LOG("Cannot input two operators in a row");
	  exit(-1);
	}
	FLAG = 1;
	BZERO(w,MAX_WORD_LENGTH);
	continue;
      }
    }
    // word is OR
    else {
      //bad input -- exits file
      if ( FLAG > 0 ){
	LOG("Cannot input two operators in a row");
	exit(-1);
      }
      //we are good
      FLAG = 2;
      BZERO(w,MAX_WORD_LENGTH);
      continue;
    }
   
    //Word is actually a word and not 'AND' or 'OR'
    //now will update the finalList or Templist

    // either a space or AND previously
    if( FLAG < 2 ){
      //if first call to Final List
      if( count == 0){
	FL = TempList;
	count = 1;
	TempList = NULL;
      }
      //Already initilized the final list
      else{
	FL = AND(FL,TempList);
      }
      //empy the templist
      //store new word in the templist
	NormalizeWord(w);
	freeDocNodeList(TempList);
	TempList = getDocList(w);
    }
    //previously was an OR
    //need to add word to old word list
    if( FLAG == 2 ){
      NormalizeWord(w);
      TempList = OR(TempList,w);
    }
    //set flag to zero (i.e. last getWord was a word and not a switch
    FLAG = 0;


    BZERO(w,MAX_WORD_LENGTH);
  }

  //all words parsed out of string

  //if no calls to the final list yet
  if( count == 0 ){
    FL = TempList;
    count = 1;
    TempList = NULL;
  }
  //end of string is always AND
  else{
   FL=AND(FL,TempList);
  }
  //free allocated memory
  free(w);
  freeDocNodeList(TempList);

  //return DocNode List
  return FL;
}
