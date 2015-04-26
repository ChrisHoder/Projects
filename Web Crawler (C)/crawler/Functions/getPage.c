// FILE: getPage.c

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include "../../utl/header.h"
#include "../../utl/file.h"
#include "crawler.h"

// This function gets the HTML page from the given url
// it will save it to a Temp file first in the given path
// then read it into a HTML string
// then resave it to a the file with the number of download file
// with the url on the first line and the depth on the 2nd
// 
// INPUT: url, depth, save path
// OUTPUT HTML string

char * getPage(char* url, int depth, char* path){
  FILE *fp;
  char *HTMLString;

  //creates a path to the temp file.
  char FileLocation[sizeof(path)+10];
  //strcpy(FileLocation,path);
  //strcat(FileLocation,"Temp");

  snprintf(FileLocation,sizeof(path)+10,"%sTemp",path);

  //creates the command that will be issued
  char command[COMMAND_MAX_LENGTH];

  //This creates the command string to call wget. The temp file will be set at the given path
  //and the number of tries is 3 if the page doesn't exist.
  snprintf(command,COMMAND_MAX_LENGTH,"wget -qO %sTemp -t 3 \"%s\"",path, url);
  // add that system call will return non zero if the page doesn't exist
  // can then decide if it should be skipped
  int j=0;
  j = system(command);
  if ( j != 0){
    return NULL;
  }
  
  HTMLString = getHTMLFromFile(FileLocation);
  

  //open the file where the html data will be saved
  //converts URLNumber to a string
  char URLNumberString[NUMBERSMAX];
  sprintf(URLNumberString,"%d",URLNumber);
  URLNumber++;
  char filePath[sizeof(path)+NUMBERSMAX];
  strcpy(filePath,path);
  strcat(filePath,URLNumberString);

  //checks if the file is created
  if ((fp= fopen(filePath,"w")) == NULL){
    LOG("could not open file to save");
    exit(-1);
   }

  //puts information in the file/closes file
 fprintf(fp,"%s\n%d\n%s",url,depth,HTMLString);
 //closes the file now that we are done with it
 fclose(fp);
 printf("\nFile Number %d depth %d\n",URLNumber,depth);
 //returns the HTML string
return (HTMLString);
}

