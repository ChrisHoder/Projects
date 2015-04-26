// File index.h


#ifndef _index_H_
#define _index_H_

#include "../utl/dictionary.h"





//prototypes

//this function will get a list of all the files in the given directory
// INPUT: directory path
// OUTPUT: list of pointers to structures about each file (see dirent structure), alpha sorted
struct dirent **getFiles(char *path);


// This function will add a given word to the directory. It will also add a DocNode at the given DocId and a
// word node if necessary. If the docNode already exists then it will update the frequency by one.
// INPUT: documentId where this occurance was found, word found
// OUTPUT: 0 if good
int addWordToIndex(int DocID,char *word);

// This function will get the docNode corresponding to the given ID in the list with
// the given word node
// INPUT: DNODE pointer, DocId
// OUTPUT: DocumentNode for DocId in DNODE list
DocumentNode *getDocodeWithWNode(DNODE *w,int DocId);

// This function will read the index from the file and parse it to build the INVERTED_INDEX back
// input path, output 0 if good
//int readIndexFromFile(char *path);


// This function will save the INVERTED_INDEX to a given file. fN is the file name
// INPUT: filename
// OUPUT: 0 if good
int saveIndexToFile(char *fN);

//This function checks to see if there was a directory

int is_directory(char *path);


#endif
