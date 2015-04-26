// File dictionary.h

#ifndef _dictionary_H_
#define _dictionary_H_

// DEFINES

// Max word length that can be parsed from the HTML. arbitrarily large
#define MAX_WORD_LENGTH 1000

// Max hash slot allowed
#define MAX_HASH_SLOT 10000

//max path slot allowed
#define MAX_PATH_LENGTH 1000

#define MAX_URL_LENGTH 1000

#define KEY_LENGTH 1000

//DATA STRUCTURES


typedef struct _DocumentNode {
  struct _DocumentNode* next;
  int document_id;
  int page_word_frequency;
} __DocumentNode;

typedef struct _DocumentNode DocumentNode;


// Dictionary Node. This is a general double link list structure that
// holds the key (URL - we explained into today's lecture why this is there)
// and a pointer to void that points to a URLNODE in practice. 
// key is the same as URL recall.

typedef struct _DNODE {
  struct _DNODE* prev;
  struct _DNODE* next;
  void* data;
  char key[MAX_WORD_LENGTH];
} __DNODE;

typedef struct _DNODE DNODE;


// The DICTIONARY holds the hash table and the start and end pointers into a double 
// link list. This is a unordered list with the exception that DNODES with the same key (URL) 
// are clusters along the list. So you hash into the list. Check for uniqueness of the URL.
// If not found add to the end of the cluster associated wit the same URL. You will have
// to write an addElement function.

typedef struct _DICTIONARY {
  DNODE *start;
  DNODE *end;
  DNODE *hash[MAX_HASH_SLOT];
} __DICTIONARY;

typedef struct _DICTIONARY DICTIONARY;

// Define the dict structure that holds the hash table 
// and the double linked list of DNODES. Each DNODE holds
// a pointer to a URLNODE. This list is used to store
// unique URLs. The search time for this list is O(n).
// To speed that up to O(1) we use the hash table. The
// hash table holds pointers into the list where 
// DNODES with the same key are maintained, assuming
// the hash(key) is not NULL (which implies the URL has
// not been seen before). The hash table provide quick
// access to the point in the list that is relevant
// to the current URL search. 
extern DICTIONARY *dict;


// This function initilizes the INVERTED_INDEX
// NO INPUTS/OUTPUTS
int initLists(void);



// This function will find the word node associated with a given key(word)
// INPUT: word
// OUTPUT: pointer to wordNode

DNODE *getWordWithKey(char *key);



// This function creates a word node and adds it to the
// hash table.
// INPUT: word string, wordnode, new wordnode is to go after
//        NULL means that it can go at the end. DocId-if less than zero - will not add
// OUTPUT: nothing
DNODE *addElement(char *word,DNODE *w);



// This function will get the last DNODE in a cluster
// by hasing it and then traversing down till the end
// INPUT: word string
// OUTPUT: pointer to DNODE
DNODE *getlastNodeInCluster(char *word);

// This function reads the Indexfile (with the given input path)
// it will initilize the INVERTED_INDEX and rebuild the whole
// index using the information in the index.dat file
int readIndexFromFile(char *path);


// This function gets the last Document node in the list.
// INPUT: pointer to wordnode
// OUTPUT: pointer to document node that is the last one in the list
DocumentNode *getLastDocNode(DocumentNode *d);

// This function creats a document node with the given DocId and
// the given frequency as inputs. returns the created document node
DocumentNode *addDocNode(int DocId, int frequency);


// This function will find the word node associated with a given key(word)
// INPUT: word
// OUTPUT: pointer to wordNode
DNODE *getWordNodeWithKey(char *key);


// This function will return the Document node associated with the given
// document id and in the given wordNode list.
// INPUT: wordnode to search, docId of corresponding documentnode desired
// OUTPUT: document node, if NULL then it doesn't exist

DocumentNode *getDocNodeWithWNode(DNODE *w,int DocId);


// This function will count all the Document Nods associated
// with a given DNODE
// INPUT: DNODE
// OUTPUT: number of DocNodes
int DocNodes(DocumentNode *d);

// This Function will free all the DocumentNodes in a list
// of document nodes
// INPUT: document node list
// OUTPUT: VOID
void freeDocNodeList(DocumentNode *d);


// This function will clean out the INVERTED_INDEX
// takes no input (assumes global dictionary)
// INPUT: VOID
// OUTPUT: VOID
void cleanINVERTED_INDEX(void);


// This function will get a DocumentNode in a list
// INPUT: documentNodeList, document ID
// OUTPUT: document node corresponding to given ID
//         (NULL if no Document Node)
DocumentNode *getDocNode(DocumentNode *d,int DocId);

#endif
