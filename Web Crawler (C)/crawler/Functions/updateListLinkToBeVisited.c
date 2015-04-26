// FILE: updateListLinkToBeVisited.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../../utl/header.h"
#include "../../utl/hash.h"
#include "crawler.h"

/*
// This function will take the url list from the url page
// and will find out which ones are new and while ones are
// repeats from one within the table
//
// INPUT: url_list - point to pointer to string, depth
// OUTPU: void
void updateListLinkToBeVisited(char **url_list, int depth){
  int i=0;
  while(url_list[i] != NULL){
    
    unsigned long hashId;
    hashId = hash1(url_list[i])%(MAX_HASH_SLOT-1);
    //printf("url %s\n\nhashid:%lu\n\n",url_list[i],hashId);
    //checks to see if there is a pointer in the hash slot
    // if it is empty then we know that the addr is unique
    if(dict->hash[hashId] == NULL){
      //adds the element to the end of the DNODE list
      //pointer to the DNODE,will be used to add to the hash table
      //DNODE *urlPt;
      //adds the element to the hash table/creates DNODES/creates URLNODE.
      //1 signifies that it is a new entry to the hash table
      addElement(url_list[i],dict->end,depth,1);
   }

    //there was already a pointer in the hash location, must check the cluster
    //in the DNODE to know if it is unique
    else{
      //a function that will check the cluster
      checkDNODES(url_list[i],depth);
    }
   
    BZERO(url_list[i], strlen(url_list[i]));
    
    free(url_list[i]);
    
    url_list[i]=NULL;
    
    i++;
  }

}
*/

void updateListLinkToBeVisited(char **url_list,int depth){
  int i=0;
  while(url_list[i]){
    checkDNODES(url_list[i],depth);
    BZERO(url_list[i],strlen(url_list[i]));
    free(url_list[i]);
    i++;
 
  }
}



void checkDNODES(char *url,int depth){
  DNODE *d, *d2,*dNew;
  if(!(d = getWordNodeWithKey(url))){
  
    if((d2 = getlastNodeInCluster(url))){
      dNew = addElement(url,d2);
    }
    else{
      dNew = addElement(url,NULL);
    }

    URLNODE *newNode;
    newNode = (URLNODE *)malloc(sizeof(URLNODE));
    MALLOC_CHECK(newNode);
    BZERO(newNode->url,MAX_URL_LENGTH);
    strncpy(newNode->url,url,MAX_URL_LENGTH);
    newNode->depth = depth;
    newNode->visited = 0;
    dNew->data = newNode;
  }
}

/*

// This function will go into the DNODES from the hash table
// and find out whether or not the given url is unique by
// traversing down the DNODES unit a different hashId is found
//
// INPUT: url string, depth
// OUTPU: void

void checkDNODES(char *url,int depth){
  unsigned long hashId;
  //get the hash id of the url
  hashId = hash1(url)%(MAX_HASH_SLOT-1);
  //pointer to the DNODE in the cluster
  DNODE *DNODE_LookUp;
  DNODE_LookUp = dict->hash[hashId];
  if (!DNODE_LookUp){
    LOG("Error updating list - unknown url/hashid");
  }
  while (hash1(DNODE_LookUp->key)%(MAX_HASH_SLOT-1) == hashId){
    if (strcmp(DNODE_LookUp->key,url) == 0){
      //not unique url
       return;
    }
    else{
      if(DNODE_LookUp->next == NULL){
	break;
      }
      DNODE_LookUp=DNODE_LookUp->next;
    }

  }
  //exits without a match so we know that it is unique, add to the end of the list
  addElement(url,DNODE_LookUp->prev,depth,0);
}


// This function will add a new element to the DNODE/DICTIONARY
// 
// INPUT: url string, pointer to the DNODE where the url is
//        to be put after on the DNODE list, the depth of the url
//        and a boolean unique which is 1 if the url has a new
//        hashId and needs to be connected to this table.
void addElemenhlt(char *urlNew,DNODE *DNODE_End,int depth,int unique){

  //create URLNODE
  URLNODE *URLNODE_pt;
  URLNODE_pt = (URLNODE *)malloc(sizeof(URLNODE));
  MALLOC_CHECK(URLNODE_pt);
  BZERO((URLNODE_pt->url),strlen(urlNew));

  //update info in the URLNODE
  strncpy((URLNODE_pt->url),urlNew,strlen(urlNew));
  URLNODE_pt->depth = depth;
  URLNODE_pt->visited = 0;
  
  //create DNODE for the url
  DNODE *DNODE_pt;
  DNODE_pt = (DNODE *)malloc(sizeof(DNODE));
  MALLOC_CHECK(DNODE_pt);
  BZERO(DNODE_pt,sizeof(DNODE));
  
  //adds elements to DNODE_pt
  //adds the url key string
  strncpy(DNODE_pt->key,urlNew,strlen(urlNew));
  DNODE_pt->data = URLNODE_pt;

  //checks to see if the new DNODE is being added to the end/should be added
  //to the hash table, in this case it will also check to see if it is the first element
  if ( unique == 1){
    dict->end = DNODE_pt;
    //checks to see if the dict start pointer exists. if not then this is the first DNODE
    //or the SEED_URL
    if (dict->start == NULL ){
      dict->start = DNODE_pt;
    }
    else{
      DNODE_pt->prev = DNODE_End;
      DNODE_End->next = DNODE_pt;
    }
    //adds the dnode to the hash table
    dict->hash[hash1(urlNew)%(MAX_HASH_SLOT-1)] = DNODE_pt;
    dict->end = DNODE_pt;
    
  }
  //if the DNODE being added is not part of a unique hashID
  else{
    DNODE_pt->prev = DNODE_End;
    DNODE_pt->next = DNODE_End->next;
    
    //change the pointers for the DNODEs on either side
    DNODE_End->next->prev = DNODE_pt;
    DNODE_End->next = DNODE_pt;

  }
}
*/
