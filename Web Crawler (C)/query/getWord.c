// File: getWord.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../utl/header.h"
#include "QueryEngine.h"



// This function parses the input string by word. it will return the position of the space
// after the word (or EOF,\n,\0)
// INPUT: string to be parsed, string to place result, position to start search in string
// OUTPUT: copies word to result, returns position of character after word

/*
  pseudocode


  1) IF ( not first call) THEN
     - go to first non space character (or end of string)
     FI
  2) save position - pos
  3) WHILE(not end of string) DO
     - IF (chacter is space,newline,end of file, or end of string) THEN
        - break
       ELSE
        - go to next chacter
       FI
     - copy characters between pos and current pos to result string
     -  return position of character after the word
     END
  4) return -1 (at end of string)

*/
int getWord(char* string,char *result,int pos){
  char c;
  //go to start of next word. (assumes that previous call returned the space or end of string
  if(pos != 0){
    while ( 0 != (c= string[pos])){
      //if not space stop moving right
      if ( c != 32 ){
	break;
      }
      pos++;
    }
  }
  
  //While not end of string
  c = string[pos];
  while(c){
    int pos2=pos;  
    //find the character after the end of the word
    while ( 0 != (c = string[pos2])){
      //if space, newline,end of file, end of string
      if ( (c == 32) || (c == '\n') || (c == EOF) || (c == '\0')){
	break;
      }
      pos2++;
    }
    
    // if we havn't moved then we are at the end of the string
    if( (pos2 == pos) ){
     return -1;
    }
    
    //copy the word, which is between the two positions
    char *pt;
    pt = &string[pos];
    strncpy(result,pt,pos2-pos);
    //return current position in string
    return (pos2);
  }
  return -1;
}
