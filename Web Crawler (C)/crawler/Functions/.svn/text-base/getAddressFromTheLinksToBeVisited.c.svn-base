// FILE: getAddressFromTheLinksToBeVisited.c

#include <stdio.h>
#include <stdlib.h>
#include "../../utl/header.h"
#include "../../utl/dictionary.h"
#include "crawler.h"



//This function takes the depth as an input and outputs a url address that is the
//next to be visited by the function. If there are no more urls to be vistied
//then the function will return NULL. The next url is found by starting at the 
//first DNODE and then checking each URLNODE associated with the DNODE if it 
//has been visited. If it has not been visited then the depth of the url
//is checked against the max depth before returning that url
char *getAddressFromTheLinksToBeVisited(int *depth){
  DNODE *nwD;
  nwD=dict->start;
  //searches through all the DNODES from the start, until the end
  //where the DNODE will have a DNODE next == NULL
  while (nwD){
    //if the url has not been visited and it is less than the max depth
    if ((((URLNODE *)nwD->data)->visited == 0) && (((URLNODE *)nwD->data)->depth <= MaxDepth) ){
      *depth = (( URLNODE *)nwD->data)->depth;
     return(nwD->key);
    }
    else{
      nwD = nwD->next;
    }
    
  }

  //nothing left to crawl
  return NULL;

}
    
  



