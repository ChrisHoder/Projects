// File: getDocList.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../utl/header.h"
#include "QueryEngine.h"


// This function copies all the docNodes in the INDEX
// associated with a given word.
// INPUT: word
// OUTPUT: DocumentNode list associated with word

/*
  pseudocode
 
  1) get DNODE associated with key
  2) IF(no DNODE) THEN
     - return NULL
     FI
  3) FOR (each DocNode in list) DO
     - malloc copy of DocNode and add to new list
     END
  4) return pointer to start of new DocNode list


*/
DocumentNode *getDocList(char *key){
  DNODE *w;
  if(!(w = getWordNodeWithKey(key))){
    return NULL;
    }
  DocumentNode *d,*d2,*dPoint;
  d = (DocumentNode *)w->data;
  dPoint = addDocNode(d->document_id,d->page_word_frequency);
  d2 = dPoint;
  while((d->next) != NULL){
    d = d->next;
    d2->next = addDocNode(d->document_id,d->page_word_frequency);
    d2 = d2->next;
  }
  return dPoint;

}

// This function will AND two lists together and return a pointer
// to the ANDed list
// INPUT: pointer to Final List, pointer to DocumentList to And to final list
// OUTPUT: updated Final List

/*
  pseudocode

  1) IF(either DocLists are empty) THEN
     - free all docNodes in the final list
     - return NULL
     FI 
  2) WHILE(not at end of FinalList) DO
     - check to see if DocNode exists on DocList, d
     IF(DocNode exists) THEN
       - update the frequency in finalList
     ELSE
       - remove DocNode from final list
       - free removed docnode
     END
  3)return pointer to start of FinalList

*/
DocumentNode *AND(DocumentNode *FL,DocumentNode *d){
  DocumentNode *d2,*dCheck,*dPrev;
  d2 = FL;
  if ((FL == NULL) || (d==NULL)){
    freeDocNodeList(FL);
    return NULL;
  }
 
  dPrev = FL;
  while(d2){
    if (!(dCheck = getDocNode(d,d2->document_id))){
      //remove this documentNode from the list
      //first element in the list
      if ( d2 == FL ){
	FL = d2->next;
       	free(d2);
       	d2 = FL;
	dPrev = FL;
	continue;
      }
      //not the first element in the list
      else{
	if(d2->next){
	  d2 = d2->next;
	  free(dPrev->next);
	 
	  dPrev->next  = d2;
	}
	//last element in the list
	else{
      	  free(d2);
	  dPrev->next = NULL;
	  d2 = NULL;
	}
      }
    }

    //Add the frequencies together
    else{
      d2->page_word_frequency += dCheck->page_word_frequency;
      dPrev = d2;
      d2 = d2->next;
    }
  }
  
  //checked all the Lists
  //return the pointer to the begining of the DocList
  return FL;
}


// This function will OR the DocumentNode input and the DocumentNodes associated with the word given
// INPUT: DocumentList to add to
// OUTPUT: pointer to beiging of DocumentNode list

/*
  pseudocode
  
  1)IF(no DNODE associated with key) THEN
    - return DocumentList
    FI
  2)WHILE(not end of Document Node list in DNODE) DO
        - IF( DocumentNode also exists on DocList input) THEN
	    - add frequencies on DocList
	  ELSE
	    - add Document Node to the list of DocumentNodes
	  FI
    END
  3)return pointer to start of DocumentNode List

*/
DocumentNode *OR(DocumentNode *d, char *word){
  DNODE *dNODE;
  if(!(dNODE = getWordNodeWithKey(word))){
    return d;
  }
  DocumentNode *dNew,*dCheck;
  dNew = (DocumentNode *)dNODE->data;
  //while( not at end of DocumentNodes associated with input word)
  while(dNew){
    //DocId is already on the list, all that needs to be done
    //is update the frequency
   if ( (dCheck = getDocNode(d,dNew->document_id))){
     dCheck->page_word_frequency = dCheck->page_word_frequency + dNew->page_word_frequency;
    }
   //DocId is not on the list, it needs to be added in a sorted manner?
   //NOT SORTED AT THE MOMENT
   else {
     dCheck = getLastDocNode(d);
     //first element in the d list. i.e. d would be NULL also
     if(!dCheck){
       d = addDocNode(dNew->document_id,dNew->page_word_frequency);
     }
     //not the first element in the list
     else{
       dCheck->next = addDocNode(dNew->document_id,dNew->page_word_frequency);
     }
   }
   //go to next DocNode
   dNew = dNew->next;
  }
  //return pointer to start of list
  return d;
}

