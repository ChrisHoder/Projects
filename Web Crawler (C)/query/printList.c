// FILE: printList.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "QueryEngine.h"
#include "../utl/header.h"

// This function will print the list of DocNodes given
// in the form:
//            Document ID: [ID] URL: [URL]
// INPUT: Document Node list, directory location of HTML files
// OUTPUT: prints list to screen

/*
  Pseudocode

  1)count DocNodes, count
  2) While (not end of DocNodes) DO
     - open corresponding HTML document
     - read URL address
     - close connection
     - print to screen:
          - Document ID: [ID] URL: [URL]
     END
  3)free allocated memory

*/
void printList(DocumentNode *FL,char *FilePath){

  // get number of Document Nodes
  int count;
  count = DocNodes(FL);


  //malloc memory for the file path and the URL to be read
  char *path, *url;
  FILE *fp;
  path = (char *)malloc(MAX_PATH_LENGTH);
  MALLOC_CHECK(path);
  BZERO(path,MAX_PATH_LENGTH);

  url = (char *)malloc(MAX_URL_LENGTH);
  MALLOC_CHECK(url);
  BZERO(url,MAX_URL_LENGTH);


  //While (not end of DocNode list)
  while(FL){
    //create path to directory to call
    snprintf(path,MAX_PATH_LENGTH,"%s%d",FilePath,FL->document_id);

    //make sure it exists -- if not exit program
    if ((fp = fopen(path,"r")) == NULL){
      LOG("Bad Directory path / Document HTML does not exist");
      exit(-1);
    }
    
    //read in the URL
    fgets(url,MAX_URL_LENGTH,fp);

    //close connection, check to make ure
    if(fclose(fp) == EOF){
      LOG("Could Node Close File");
      exit(-1);
    }

    //print to screen the ID and the URL
    printf("Document ID:%d  URL:%s\n",FL->document_id,url);

    // zero out path,url for next call
    BZERO(path,MAX_PATH_LENGTH);
    BZERO(url,MAX_URL_LENGTH);

    //go to next docnode
    FL = FL->next;
  }
  

  printf("Number of DocNodes: %d\n\n",count);

  //free the path,url memory at end
  free(path);
  free(url);
}
