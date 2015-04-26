// FILE: inputCheck.c

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <dirent.h>
#include "../../utl/header.h"
#include "../../utl/file.h"
#include "crawler.h"

// This function will validate the input for the crawler
// it does not check the url which will be checked by the
// getPage. it will return NULL if there is a problem
// or will return a string that is the path (with the /) 
// at the end if everything checks out

char *inputCheck(int argc, char **argv){

  //makes sure that there are only 3 inputs.
  if (argv[1] == NULL || argv[2] == NULL || argv[3] == NULL || argv[4] != NULL  ){
    printf("./crawler [SEED_URL] [TARGET_DIRECTORY WHERE TO PUT THE DATA] [CRAWLING_DEPTH]\n\n");
      return NULL;
  }

  //Checks the max depth
  if (atoi(argv[3]) == 0){
    printf("./crawler [SEED_URL] [TARGET_DIRECTORY WHERE TO PUT THE DATA] [CRAWLING_DEPTH]\n\n");
    return NULL;
  }
  //set MaxDepth
  else{
    MaxDepth = atoi(argv[3]);
  }
 


  //this will check that we can open the directory
  DIR *directoryLoc;
  if ((directoryLoc = opendir(argv[2])) == NULL){
    printf("Input included a bad directory\n\n");
    return NULL;
  }

  //exit out of the director
  closedir(directoryLoc);
  /*  
  //malloc the path variable for where everything is going to be 
  //saved to.
  char *path;
  int pL;
  // create a string for the full path to go into
  pL = strlen(argv[2])+2;
  path = ( char *)malloc(pL);
  MALLOC_CHECK(path);
  BZERO(path,pL);

  //check if there is a / at the end of the path. if not it will add it
  if ((char)argv[2][pL-3] != '/'){
    snprintf(path,pL,"%s/",argv[2]);
  }
  else{
    strncpy(path,argv[2],pL);
  }
  */
  char *path;
  path = checkPath(argv[2]);
  return(path);
}



    




    
