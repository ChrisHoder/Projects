// File: file.c

#include <stdio.h>
#include <stdlib.h>
#include "header.h"
#include <dirent.h>
#include <memory.h>
#include <sys/stat.h>

#include "file.h"


// This function will get the HTML from the given path
// and place it in a single string
// INPUT: path to HTML file
// OUTPUT: string of HTML

/* 
   pseudocode

   1) open up the given path
   2) Find the length of the file
   3) create a string as long as the file
   4) load file into the string
   5) IF (cannot read file) THEN
       - log error
       - exit program
      END
   6) IF (did not read whole file) THEN
       - log error
       - exit program
      END
   7) close file
   8) return HTML string
*/


char *getHTMLFromFile(char *path){

  long int L;
  FILE *fp;
  char *HTML;
  
  //check to see if the file can be opened
  if ((fp = fopen(path,"r")) == NULL){
    perror("error in file access");
    return NULL;
  }

  //find the end of the file
  fseek(fp,0L,SEEK_END);
  L = ftell(fp);

  //go back to begining of file
  rewind(fp);
  
  //malloc a string as long as the file
  HTML = (char *)malloc(L+1);
  MALLOC_CHECK(HTML);
  BZERO(HTML,L+1);

  //read all the file into the HTML string  
  int a,b;
  b=0;
  while ((a = fread(HTML+b, sizeof(char),L,fp)) > 0){
      b += a;
  }
    
  if ( b != L ){
    perror("Read file failed\n");
    exit(14);
  }
  HTML[L] = '\0';
  
  //close file
  fclose(fp);
  return HTML;
}


// This function checks the path given by the user
// if the path does not end with a / it will add it
// INPUT: path
// OUTPUT: path 
/*
  pseudocode

  1) get string length
  2) malloc a new string
  3) IF(no / at end of path) THEN
     - print path to string with /
     ELSE
     - print path to string as is
     FI
  4) return string

*/
char *checkPath(char *path){
  int pL;
  char *Newpath;
  pL = strlen(path)+2;
  
  Newpath = (char *)malloc(pL);
  MALLOC_CHECK(Newpath);
  BZERO(Newpath,pL);
  
  if( (char)path[pL-3] !='/'){
    snprintf(Newpath,pL,"%s/",path);
  }
  else{
    strncpy(Newpath,path,pL);
  }

  return Newpath;

}
