// FILE: QueryEngine.h

#ifndef _QueryEngine_H_
#define _QueryEngine_H_


#define MAX_INPUT_LENGTH 1000

#include "../utl/dictionary.h"

DocumentNode *getList(char *input);

DocumentNode *getDocList(char *key);

DocumentNode *AND(DocumentNode *FL, DocumentNode *d);


DocumentNode *OR(DocumentNode *d,char *word);



int getWord(char *string,char *result, int pos);

void printList(DocumentNode *FL,char *FilePath);

DocumentNode *sortList(DocumentNode *dStart);

DocumentNode *swapDocNode(DocumentNode *d,DocumentNode *dStart,int first );


#endif
