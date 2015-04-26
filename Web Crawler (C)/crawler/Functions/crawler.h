#ifndef _CRAWLER_H_
#define _CRAWLER_H_


#include "../../utl/dictionary.h"

// *****************Impementation Spec********************************
// File: crawler.h
// This file contains useful information for implementing the crawler:
// - DEFINES
// - MACROS
// - DATA STRUCTURES
// - PROTOTYPES



// DEFINES



#define INTERVAL_PER_FETCH 1

// The URL we crawled should only starts with this prefix. 
// You could remove this limtation but not before testing.
// The danger is a site may block you

#define URL_PREFIX "http://www.cs.dartmouth.edu"



// Unlikely to have more than an 1000 URLs in page
 
#define MAX_URL_PER_PAGE 10000

#define COMMAND_MAX_LENGTH 10000

#define NUMBERSMAX 10

//max depth universal number

extern int MaxDepth;

//Page crawled number
extern int URLNumber;


// DATA STRUCTURES. All these structures should be malloc 'd



// This is the key data structure that holds the information of each URL.

typedef struct _URL{
  char url[MAX_URL_LENGTH];      // e.g., www.cs.dartmouth.edu
  int depth;                     //  depth associated with this URL.
  int visited;                   //  crawled or not, marked true(1), otherwise false(0)
} __URL;

typedef struct _URL URLNODE;


// This is the table that keeps pointers to a list of URL extracted
// from the current HTML page. NULL pointer represents the end of the
// list of URLs.

//char *url_list[MAX_URL_PER_PAGE];
extern char **url_list;

//PROTOTYPES used by crawler.c You have to code them.




char *inputCheck(int argc, char **argv);



// getPage: Assumption: if you are dowloading the file it must be unique. 
// Two cases. First its the SEED URL so its unique. Second, wget only getpage 
//once a URL is computed to be unique. Get the HTML file saved in TEMP 
// and read it into a string that is returned by getPage. Store TEMP
// to a file 1..N and save the URL and depth on the first and second 
// line respectively.


char *getPage(char* url, int depth,  char* path);

// extractURL: Given a string of the HTML page, parse it (you have the code 
// for this GetNextURL) and store all the URLs in the url_list (defined above).
// NULL pointer represents end of list (no more URLs). Return the url_list

char **extractURLs(char* html_buffer, char* current);

// setURLasVisited: Mark the URL as visited in the URLNODE structure.

void setURLasVisited(char* url);

// updateListLinkToBeVisited: Heavy lifting function. Could be made smaller. It takes
// the url_list and for each URL in the list it first determines if it is unique.
// If it is then it creates a DDNODE (using malloc) and URLNODE (using malloc).
// It copies the URL to the URNODE and initialises it and then links it into the
// DNODE (and initialise it). Then it links the DNODE into the linked list dict.
// at the point in the list where its key cluster is (assuming that there are
// elements hashed at the same slot and the URL was found to be unique. It does
// this for *all* URL in the ur-list

void updateListLinkToBeVisited(char **url_list, int depth);

// getAddressFromTheLinksToBeVisited: Scan down thie hash table (part of dict) and
// find the first URL that has not already been visit and return the pointer 
// to that URL. Note, that the pointer to the depth is past too. Update the
// depth using the depth of the URLNODE that is next to be visited. 

char *getAddressFromTheLinksToBeVisited(int *depth);


// this function will get the URLNODE data from a url key which is the input
URLNODE *GetDataWithKey(char* url);

// This function will go into the DNODES from the hash table
// and find out whether or not the given url is unique by
// traversing down the DNODES unit a different hashId is found
//
// INPUT: url string, depth
// OUTPU: void

void checkDNODES(char *url,int depth);


void cleanup(void);


#endif
