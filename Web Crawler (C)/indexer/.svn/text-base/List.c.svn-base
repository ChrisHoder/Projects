// File: List.c


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "index.h"
#include "../utl/header.h"
#include "../utl/hash.h"


// First checks to see if the word node exists
// if it doesn't then it adds a new wordnode
// if it does it will find the corresponding docNode
// if that doesn't exist it will create it
// if it does it will add 1 to the frequency

/*
  pseudocode
  
  1) look to see if DNODE, w, exists - Call: getWordWithKey
  2) IF (w does not exist ) THEN
        - create DNODE for word at end of cluster
	    - use getlastNodeInCluster
	- add DocumentNode with DocId
  3) ELSE
        - look for corresponding DocumentNode in DNODE
	IF (documentNode exists) THEN
	    - update frequency by one
	ELSE
	    - create new Document Node with frequency 1 to end of DocumentNode list
	END
     END
  4) return 0
*/


int addWordToIndex(int DocID,char *word){
  DNODE *w;
  DocumentNode *d;
  w = getWordNodeWithKey(word);
  
  //this word node does not exist
  if(!w){
    DNODE *w2;
    if ((w = getlastNodeInCluster(word))){
      w2 = addElement(word,w);
    }
    else{
      w2 = addElement(word,NULL);
    }
    d = addDocNode(DocID,1);
    w2->data = d;
    return 0;
  }
  else{
    //found the word node. now find the document id;
    d = getDocNodeWithWNode(w,DocID);
    //first time word appeared in document
    if (!d){
      //get last docNode to add to, 
      d = getLastDocNode((DocumentNode *)w->data);
   
      DocumentNode *d2;
      d2 = addDocNode(DocID,1);
      d->next = d2;
    }
    else {
      //Increment the frequency
      d->page_word_frequency += 1;
    }
  }
  return 0;
}




