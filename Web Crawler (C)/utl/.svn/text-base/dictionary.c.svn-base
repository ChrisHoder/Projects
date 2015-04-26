// File: dictionary.c


#include <stdio.h>
#include <stdlib.h>
#include "header.h"
#include <string.h>
#include "dictionary.h"
#include "hash.h"
//#include "../crawler/Functions/crawler.h"


// This function initilizes the INVERTED_INDEX
// NO INPUTS/OUTPUTS
/*
  pseudocode
  
  1) assign extern pointer dict to allocated dictionary memory
  2) make sure memory was allocated
  3) zero all allocated memory
  4) return 0

*/

int initLists(void){
  dict = (DICTIONARY *)malloc(sizeof(DICTIONARY));
  MALLOC_CHECK(dict);
  BZERO(dict, sizeof(DICTIONARY));
  return 0;
}


// This function will find the word node associated with a given key(word)
// INPUT: word
// OUTPUT: pointer to wordNode

/*
  pseudocode

  1) get hashId of key
  2) go to the corresponding slot in hash table
  3) WHILE (DNODE has same hashid) DO
      - check to see if it has the same key
      - IF (keys are the same) THEN
           - return DNODE
	ELSE
	   - go to next DNODE
  4) IF (no DNODE with same key) THEN
      - return NULL
     
 */
DNODE *getWordNodeWithKey(char *key){
  long unsigned int hashId;
  hashId = hash1(key)%(MAX_HASH_SLOT-1);
  DNODE *w;
  if ((w = dict->hash[hashId]) == NULL){
    return NULL;
  }
  while((hash1(w->key)%(MAX_HASH_SLOT-1)) == hashId){
    if( strcmp(w->key,key)==0){
      return w;
    }
    else{
      w=w->next;
      if (!w){
	return NULL;
      }
    }
  }
  return NULL;
}





// This function creates a word node and adds it to the
// hash table.
// INPUT: word string, wordnode, new wordnode is to go after
//        NULL means that it can go at the end. DocId-if less than zero - will not add
// OUTPUT: nothing

/* 
   pseudocode
   
   1) create new DNODE
   2) update key
   3) IF (DNODE,w (input) exists) THEN
      - add new DNODE into list after w
      - CHECK edge cases
           - end of DNODE list
	   - begining of DNODE list
      ELSE (DNODe input does not exist)
      - add DNODE to end of list
      - update Dict pointers
   4) return new DNODE

*/

DNODE *addElement(char *word,DNODE *w){
  //create WordNode
  DNODE *wNew;
  wNew = (DNODE *)malloc(sizeof(DNODE));
  MALLOC_CHECK(wNew);
  BZERO(wNew,sizeof(DNODE));
  
  //add information
  strncpy(wNew->key,word,MAX_WORD_LENGTH);

  //if w is NULL then we know that this is unique and being added
  // to the hash table
  if(!w){
    //add the wordNode to the hash table
    dict->hash[hash1(word)%(MAX_HASH_SLOT-1)]=wNew;
    //if this is the first wordNode in the index
    if(dict->start == NULL){
      dict->start = wNew;
    }
    //add to the end of the WordNodes but not the first
    if(!(dict->end)){
      dict->end = wNew;
    }
    else{
      wNew->prev = dict->end;
      dict->end->next=wNew;
      dict->end=wNew;
    }
  }
  //WordNode being added at the end of 
  else{
    wNew->prev=w;
    //change the pointers for the nodes on either side
    if ((w->next) != 0){
      w->next->prev = wNew;
      wNew->next=w->next;
      w->next = wNew;
    }
    else {
      w->next = wNew;
     dict->end = wNew;
    }
  }

  return wNew;
}

// This function will get the last DNODE in a cluster
// by hasing it and then traversing down till the end
// INPUT: word string
// OUTPUT: pointer to DNODE
 
/*
  pseudocode

  1) get hashId of word (hash1)
  2) go to corresponding slot in the dict hash table
  3) IF (no DNODE in hash table) THEN
      - return NULL
     END
  4) WHILE (DNODE key has same hash value) DO
      - IF( next DNODE) THEN
          - Go to Next DNODE
        ELSE
	  return DNODE
	END
     END
  5) return previous DNDOE

*/

DNODE *getlastNodeInCluster(char *word){
  long unsigned int hashId;
  hashId = hash1(word)%(MAX_HASH_SLOT-1);
  DNODE *w;
  w = dict->hash[hashId];
  if(!w){
    return NULL;
  }
  // while still in the cluster (hashIds are the same)
  while ((hash1(w->key)%(MAX_HASH_SLOT-1)) == hashId){
    //if there is no DNODE - at end of list
    if ((w->next) == NULL){
      return w;
      //return NULL;
    }
    w= w->next;
  }
  return w->prev;
  //return w->prev;
}


// This function gets the last Document node in the list.
// INPUT: pointer to wordnode
// OUTPUT: pointer to document node that is the last one in the list

/*
  pseudocode

  1) gets first document node in list from corresponding wordnode,w
  2) WHILE( document node exists) DO
     - if (no next document node) THEN
         - return document node
       ELSE
         - go to enxt document node
       END
    END
   3)return NULL
*/
DocumentNode *getLastDocNode(DocumentNode *d){
  
  while(d){
    if (!d->next){
      return d;
    }
    d = d->next;
  }
return NULL;
  
}


// This function will get a DocumentNode in a list
// INPUT: documentNodeList, document ID
// OUTPUT: document node corresponding to given ID
//         (NULL if no Document Node)

/*
  pseudocode

  1)WHILE (not end of DocumentNodes) DO
    - IF (DOCID matches input id) THEN
         - return DocNode
      FI
    - go to next Document Node
    END
  2)RETURN NULL

*/

DocumentNode *getDocNode(DocumentNode *d, int DocId){
  while(d){
    if ( DocId == d->document_id){
      return d;
    }
    d = d->next;

  }
  return NULL;

}




// This function creats a document node with the given DocId and
// the given frequency as inputs. returns the created document node

/*
  pseudocode

  1) create Document Node
  2) update frequency,id
  3) return pointer to document node
*/

DocumentNode *addDocNode(int DocId, int frequency){
  
  //create Document Node
  DocumentNode *dNew;
  dNew = (DocumentNode *)malloc(sizeof(DocumentNode));
  MALLOC_CHECK(dNew);
  BZERO(dNew,sizeof(DocumentNode));
  
  //update Document Node
  dNew->document_id = DocId;
  dNew->page_word_frequency = frequency;
 
  //return the new DocNode
  return dNew;
 

}



// This function will return the Document node associated with the given
// document id and in the given wordNode list.
// INPUT: wordnode to search, docId of corresponding documentnode desired
// OUTPUT: document node, if NULL then it doesn't exist


/*
  pseudocode

  1) get first documentNode in list on DNODE,w
  2) WHILE(document Node) DO
     - IF (docId = DocumentNode's id) THEN
         - return documentNode
       ELSE
         - go to next document node
       END
     END
  3) no corresponding document node -- return NULL

*/

DocumentNode *getDocNodeWithWNode(DNODE *w,int DocId){
  //  WordNode *w2;
  DocumentNode *d;
  d = (DocumentNode *)(w->data);
  while (d){
    if ( DocId == d->document_id ) {
      return d;
    }
    d = d->next;
  }
  return NULL;



}


// This function will count all the Document Nods associated
// with a given DNODE
// INPUT: DNODE
// OUTPUT: number of DocNodes

/*
  pseudocode

  1) go to first Document Node
  2) while (Document Node) DO
      - incremetn counter
      - go to next document node
     END
  3) return counter

*/
int DocNodes(DocumentNode *d){
  int c=0;
  //go down all the document nodes and count the number of them before you reach
  // a null d->next
  while(d){
    d = d->next;
    c++;
  }
  //return the count
  return(c);
}


// This function will clean out the INVERTED_INDEX
// takes no input (assumes global dictionary)
// INPUT: VOID
// OUTPUT: VOID

/*
  pseudocode

  1) go to first DNODE
  2) WHILE (not end of DNODEs) DO
     - free all DocumentNodes
     - free DNODE
     - go to next DNDOE
     END


*/

void cleanINVERTED_INDEX(void){
  DNODE *w,*w2;
  w = dict->start;
  while(w != NULL){
    freeDocNodeList((DocumentNode *)w->data);
 
    w2 = w->next;
    free(w);
    w = w2;
  }
}


// This Function will free all the DocumentNodes in a list
// of document nodes
// INPUT: document node list
// OUTPUT: VOID
/*
  pseudocode
  
  1) WHILE(not end of list) DO
     - hold next docnode in a temp slot
     - free docnode
     - go to next docnode (from temp slot)
     END

*/

void freeDocNodeList(DocumentNode *d){
  DocumentNode *d2;
  while(d != NULL){
    d2 = d->next;
    free(d);
    d = d2;
  }
 
}



// This function reads the Indexfile (with the given input path)
// it will initilize the INVERTED_INDEX and rebuild the whole
// index using the information in the index.dat file

/*
  pseudocode

  1) initialize dictionary - call: initLists
  2) open given index file
  3) IF (can't open) THEN
     - log error
     - exit
     END
  4) WHILE (scan word, number of files) DO
      - create DNODE for word
      - FOR (each file) DO
         - read in the file id (int) and the frequencies (int)
	 - create document node, with given frequency
	 - add to wordnode list
	END
     END
  5) close file
  6) return 0



*/


int readIndexFromFile(char *path){
  int i;
  
  //inititializes the index
  i = initLists();
  if (i != 0){
    perror("problem initilizing index");
    exit(-1);
  }
  
  //begin to read the file
  FILE *fp;
  if ( (fp = fopen(path,"r")) == NULL){
    perror("Cannot open the given index file");
    exit(-1);
  }
  int DocId, occurances, frequency;
  //create string for the word to go into
  char *word;
  word = (char *)malloc(MAX_WORD_LENGTH);
  MALLOC_CHECK(word);
  BZERO(word,MAX_WORD_LENGTH);



  DocumentNode *d, *d2;
  DNODE *w,*wCheck;
  while( fscanf(fp,"%s %d",word,&occurances) != EOF){
    //create wordnode
    // null means that there is no word node before it, -1 means that
    // there is no associated document node to be created
    if((wCheck = getlastNodeInCluster(word))){
      w = addElement(word,wCheck);
    }
    else{
      w = addElement(word,NULL);
    }
    if (!w){
      perror("problem creating index");
      exit(-1);
    }

    //get all the docID's that match and their frequency
    int j=0;
    for (j=0;j<occurances;j++){
      i = fscanf(fp,"%d %d",&DocId,&frequency);
      d = getLastDocNode((DocumentNode *)w->data);
      //if this is the first docId scanned
     if(!d){
	d = addDocNode(DocId,frequency);
	w->data = d;
      }
      else {
      //update the list so it points to the new DocumentNode;
	d2 = addDocNode(DocId,frequency);
	d->next = d2;
      //change it so that d is now the new document node
      d = d2;
      }
    }
  
  }
  //close connections/free up memory
  fclose(fp);
  free(word);
  return 0;
}

