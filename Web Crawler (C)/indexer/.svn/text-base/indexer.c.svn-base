// FILE: indexer.c
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../utl/header.h"
#include "../utl/file.h"
#include "index.h"
#include "../utl/html.h"


DICTIONARY *dict = NULL;

// This function runs the indexer, and needs all the other indexer functions
// INPUT:  [TARGET_DIRECTORY] [RESULTS FILENAME] [RESULTS FILENAME] [REWRITTEN FILENAME]
//         the last 2 are optional
// OUTPUT: list of words and their occurances in teh given directory files


/* pseudocode
   
   1) input checking
         - either 3 or 5 arguments
	 - directory exists
   2) get number of files in directory - call: getFiles
   3) FOR EACH FILE IN DIRECTORY 
       DO
       - get HTML string - call: getHTMLFromFile
       - FOR EACH WORD IN HTML
         - parse out of HTML
	 - call: GetNextWord
	 - normilize (all lowercase)
	 - call: normilizeWord
	 END
       - free the file pointer
       - free the html string
       END
   4) SaveIndex to file given 
       - frees up dictionary as you go
       - call: saveIndexToFile

   5) IF ( 5 arguments ) THEN
      - test mode
      - readIndex file and recreate INDEX - call: readIndexFromFile
      - save index to new file - call: saveIndexToFile
      END
    6) return 0


*/


int main(int argc, char *argv[]){
  //input validation
  if (argc < 3 || argc > 5 || argc == 4){
    printf("Usage: indexer [TARGET_DIRECTORY] [RESULTS FILENAME] [RESULTS FILENAME] [REWRITTEN FILENAME]\n");
    exit(-1);
  }
  //find out the number of files
  struct dirent **files;
  files = getFiles(argv[1]);
  
  int i, j, pos;
  char *word;
  word = (char *)malloc(MAX_WORD_LENGTH);
  MALLOC_CHECK(word);
  BZERO(word,MAX_WORD_LENGTH);
  
  //initialize the directory
  initLists();
  i=2;
  free(files[1]);
  free(files[0]);
  //Loop that goes through every file
  while(files[i]){

    //crawler saves a temp file in this directory
    if(strcmp(files[i]->d_name,"Temp") == 0 ){
      free(files[i]);
      i++;
      continue;
    }
   

    char *HTML;
    char *path;
    //creates a path to the file
    path = (char *)malloc(MAX_PATH_LENGTH);
    MALLOC_CHECK(path);
    BZERO(path,MAX_PATH_LENGTH);
    

    

    snprintf(path,MAX_PATH_LENGTH,"%s/%s",argv[1],files[i]->d_name);

    if(is_directory(path) == 1){
      free(files[i]);
      free(path);
      i++;
      continue;
    }

    //gets the HTML string
    HTML = getHTMLFromFile(path);
    //path is no longer needed
    free(path);

    pos = 0;
    // Loops through the HTML string and gets all of the words and
    // adds them to the INVERTED_INDEX
    while( (pos = GetNextWord(HTML,word,pos)) > 0){
      if(word && (strcmp(word,"") != 0)){
	j=0;
	//normilizes words so that indexer is not case sensitive
	NormalizeWord(word);
	j = addWordToIndex(atoi(files[i]->d_name),word);
	BZERO(word,MAX_WORD_LENGTH);
      }
      }
    //frees up the file
    free(files[i]);
    // frees up the HTML string
    free(HTML);
    //increments to the next file
    i++;
  }

  //free up memory
  free(files);
  free(word);
  //saves the INVERTED_INDEX to the given filename
  saveIndexToFile(argv[2]);

  if (argc == 5){
    readIndexFromFile(argv[3]);
    saveIndexToFile(argv[4]);
  }
  return 0;
}
