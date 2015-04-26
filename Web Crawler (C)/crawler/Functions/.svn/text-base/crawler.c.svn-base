// FILE: main.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "../../utl/header.h"
//#include "../../utl/html.h"
//#include "../../utl/hash.h"
#include "crawler.h"

int MaxDepth;
int URLNumber = 0;
DICTIONARY *dict = NULL;
char **url_list;


// This function will run the crawler. It will take as its inputs
// the SEED_URL TARGET_DIRECTORY CRAWLING DEPTH
// OUTPUT: Creates an HTML file for all the url parsed in the given directory

int main(int argc, char *argv[]){
  int check,depth;
  int *depth_pt;
  //if the initLists is able to complete it will return 0
  check = initLists();
  if (check != 0){
    LOG("Failure to initialize data structures and resources");
    return 1;
      }
  
  //input Handling
  char *path;
  //this function checks the input and creates the path.
  path = inputCheck(argc, argv);
  //NULL means there was an error in the input.
  if (path == NULL){
    return 1;
      }
  //create a pointer to the depth
  depth = 0;
  depth_pt = &depth;

  //creates a pointer to the html string
  char *page;
  //gets the HTML page as a string
  page = getPage(argv[1],depth,path);

  // if page is NULL then the url could not be crawled
  // with the SEED_URL this will end the program
  if (page == NULL || strlen(page) == 0) {
    LOG("Cannot crawl the SEED_URL");
    return 1;
  }
  
  //a list pointer is malloced and passed to extract the URL
  url_list = (char **)malloc(MAX_URL_PER_PAGE*sizeof(char*));
  BZERO(url_list,MAX_URL_PER_PAGE*sizeof(char*));
  url_list = extractURLs(page,argv[1]);

  //free the page now that we are done
  free(page);
 
  //add the SEED_URL to the DNODE list
  DNODE *d;
  d = addElement(argv[1],NULL);
  URLNODE *u;
  u = (URLNODE *)malloc(sizeof(URLNODE));
  MALLOC_CHECK(u);
  BZERO(u,sizeof(URLNODE));
  strncpy(u->url,argv[1],MAX_URL_LENGTH);
  d->data = u;
  

  // takes the list of parsed URLS and finds the unique ones
  // and adds them to the dictionary
  updateListLinkToBeVisited(url_list,depth+1);
  
  //set the SEED_URL as visited
  setURLasVisited(argv[1]);
  
  // Finds the next url to be visited
  char *URLToBeVisited;
  URLToBeVisited = getAddressFromTheLinksToBeVisited(depth_pt);


  //while URLToBeVisited is not NULL, ie there are still urls to crawl
  //the crawler will continue to run in this loop going through the pages
  while (URLToBeVisited){
    //gets the next HTML string
    page = getPage(URLToBeVisited,depth,path);
    printf("crawled %s\n\n",URLToBeVisited);
    // If page is NULL then the url could not be crawled
    if (page == NULL){
      LOG("could not crawl this page");
   }
    else{
      // gets the next list of parsed URLs
      // and adds the new unique URLS to the
      // dictionary
      url_list = extractURLs(page,URLToBeVisited);
      updateListLinkToBeVisited(url_list,depth+1);
    }
    
    // frees the page because we are done
    free(page);
    //sets the url as visited
    setURLasVisited(URLToBeVisited);
    /*
    //sleep for an interval
    // creates a command to make the sleep call
    char *command = (char *)malloc(COMMAND_MAX_LENGTH);
    MALLOC_CHECK(command);
    BZERO(command,COMMAND_MAX_LENGTH);
    snprintf(command,COMMAND_MAX_LENGTH,"sleep %d",INTERVAL_PER_FETCH);
    system(command);
    // frees the memory
    free(command);

    */
    sleep(INTERVAL_PER_FETCH);
    // gets the next URL to be visited
    URLToBeVisited = getAddressFromTheLinksToBeVisited(depth_pt);
  }
  
  // done with crawling
  LOG("nothing more to crawl, good job, we are done");
  printf("\nnumber of Files: %d",URLNumber);
 
  // frees all allocated memory before exit
  free(path);
  cleanup();
			 

  




}
