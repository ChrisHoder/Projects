// FILE setURLasVisited.c

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <string.h>
#include "../../utl/header.h"
#include "../../utl/hash.h"
#include "crawler.h"



// This function will set the given url as visited within the URLNODE
//
// INPUTS: url, one that has already been added to the dictionary
// OUTPUTS: nothing, void

void setURLasVisited(char *url){
  //getDNODE with key
  DNODE *d;
  if(!(d = getWordNodeWithKey(url))){
    LOG("Error attempt to update unkown URL");
    exit(-1);
  }
  ((URLNODE *)d->data)->visited = 1;
}
  /*  URLNODE *URLNODEdata;
  URLNODEdata = GetDataWithKey(url);
  // check to make sure that the given url was actually in the table
  if (URLNODEdata != NULL){
  URLNODEdata->visited = 1;
  }
}
  */

/*
// This function will get the URLNODE for the given url string
// uses hash, needs that header file
// OUTPUTS: URLNODE of the given url
// INPUT: url
URLNODE *GetDataWithKey(char *url){
  unsigned long hashId;
  // gets the hashId of the given url - will search DNODES via hash table
  hashId = hash1(url)%(MAX_HASH_SLOT-1);
  DNODE *DNODE_check;
  DNODE_check=dict->hash[hashId];
  
  // If there is no DNODE in that hash element then a incorrect url was passed
  //  to the function -- logs it and returns null
  if(DNODE_check == NULL){
    LOG("Attempted to update visit status of incorrecrt url");
    return NULL;
  }

  //goes down the DNODE cluster till it finds a dnode with the same url
  while(strncmp(DNODE_check->key,url,MAX_URL_LENGTH) != 0){
    //    printf("DNODEKEY: %s\n\nURL:%s\n\nCompare:%d",DNODE_check->key,url,strncmp(DNODE_check->key,url,sizeof(url)));
    DNODE_check=DNODE_check->next;
  }
  //((URLNODE *)DNODE_check->data)->visited=1;
  return((DNODE_check->data));

}
*/
