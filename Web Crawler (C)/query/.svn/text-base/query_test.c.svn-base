//FILE: query_test.c


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include "../utl/dictionary.h"
#include "../utl/header.h"
#include "QueryEngine.h"

// Useful MACROS for controlling the unit tests.

// each test should start by setting the result count to zero

#define START_TEST_CASE  int rs=0

// check a condition and if false print the test condition failed
// e.g., SHOULD_BE(dict->start == NULL)

#define SHOULD_BE(x) if (!(x))  {rs=rs+1; \
    printf("Line %d Fails\n", __LINE__); \
  }


// return the result count at the end of a test

#define END_TEST_CASE return rs

//
// general macro for running a best
// e.g., RUN_TEST(TestDAdd1, "DAdd Test case 1");
// translates to:
// if (!TestDAdd1()) {
//     printf("Test %s passed\n","DAdd Test case 1");
// } else { 
//     printf("Test %s failed\n", "DAdd Test case 1");
//     cnt = cnt +1;
// }
//

#define RUN_TEST(x, y) if (!x()) {              \
    printf("Test %s passed\n", y);              \
} else {                                        \
    printf("Test %s failed\n", y);              \
    cnt = cnt + 1;                              \
}
   

// To avoid linking in the dictionary header file
// these dictionary files are included here to avoid
// problems with multiple definitio of our fake functions below
 

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

void freeDocNodeList(DocumentNode *d){
  DocumentNode *d2;
  while(d != NULL){
    d2 = d->next;
    free(d);
    d = d2;
  }
 
}


DocumentNode *getDocNode(DocumentNode *d, int DocId){
  while(d){
    if ( DocId == d->document_id){
      return d;
    }
    d = d->next;

  }
  return NULL;

}




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






// Dumming out routines 
// We want to isolate this set of functions and test them and control
// various conditions with the hash table and function. For example,
// we want to create collisions. So in order to do this we dummy out the
// hash function and make it return whatever the current value of hash is
// In out test suite we mainpulate the value of hash so when the "real code"
// calls our dummy hash function it always returns the value we set in hash.
// Devious, hey?

// what we want the hash function to return

unsigned long hash = 0;

// The dummy hash function, which returns the value we set up in hash

unsigned long hash1(char* str) {
  return hash;
}

//what we want the getWordNodeWithKey to return
DNODE *w;

DNODE *getWordNodeWithKey(char *key){
  return w;
}



//what we want the getLastDocNode to return

DocumentNode *dLast;

DocumentNode *getLastDocNode(DocumentNode *d){
  return dLast;
}

// normalize word does nothing here
void NormalizeWord(char *w){
}




// Test case: TestgetDocList1
// no DNDOE for getDocList to get
int TestgetDocList1(){
  START_TEST_CASE;

 
  w = NULL;
  DocumentNode *d;
  char key[]="a";
  d = getDocList(key);
  SHOULD_BE(d == NULL);
 

  END_TEST_CASE;

}

// Test case: TestgetDocList2
// will find DNODE and copy the DocNodes

int TestgetDocList2(){
  START_TEST_CASE;
  
  
  DocumentNode *d;
  char key[]="a";
  w = (DNODE *)malloc(sizeof(DNODE));
  w->data = addDocNode(10,1);
 
  d = getDocList(key);
  
  SHOULD_BE(((DocumentNode *)w->data)->document_id == d->document_id);
  SHOULD_BE(((DocumentNode *)w->data)->page_word_frequency == d->page_word_frequency);
  SHOULD_BE( d->next == NULL);
  
 
  free((DocumentNode *)w->data);
  freeDocNodeList(d);
  free(w);
  END_TEST_CASE;
}



// Test Case: TestAND1
// will test the AND function with a null final list

int TestAND1(){
  START_TEST_CASE;

  DocumentNode *FL,*d;
  FL=NULL;
  d = addDocNode(0,1);
  FL = AND(FL,d);
  
  SHOULD_BE( d != NULL );
  SHOULD_BE( FL == NULL );

  freeDocNodeList(d);
 
  END_TEST_CASE;
}

// Test Case: TestAND2
// will test the AND function with a non-null final list
// and a null Templist (d)

int TestAND2(){
  START_TEST_CASE;

  DocumentNode *FL,*d;
  FL = addDocNode(0,1);
  d = NULL;
  
  FL = AND(FL,d);
 
  SHOULD_BE( FL == NULL );
  
 
  
  END_TEST_CASE;
}


// Test Case: TestAND3
// will test the AND function with
// anding two lists. the first element in the Final list
// is not in the list being anded with it. can also
// check that frequencies add

int TestAND3(){
  START_TEST_CASE;

  DocumentNode *FL,*d;
  FL = addDocNode(0,1);
  FL->next = addDocNode(1,2);
 
  d = addDocNode(1,5);
  FL = AND(FL,d);

  SHOULD_BE( FL->document_id == 1 );
  SHOULD_BE( FL->page_word_frequency == 7);
  SHOULD_BE( FL->next == NULL );


  freeDocNodeList(FL);
  freeDocNodeList(d);
  END_TEST_CASE;
}



// Test Case; TestAND4
// will test the AND function with
// anding two lists. a "middle" element in the list
// needs to be removed because it is not on both lists.
// this can also check that frequencies add

int TestAND4(){
  START_TEST_CASE;

  DocumentNode *FL,*d;
  FL = addDocNode(0,1);
  FL->next = addDocNode(1,2);
  FL->next->next = addDocNode(2,3);

  d = addDocNode(2,10);
  d->next = addDocNode(0,8);

  FL = AND(FL,d);
  
  SHOULD_BE( FL->document_id == 0 );
  SHOULD_BE( FL->page_word_frequency == 9 );
  SHOULD_BE( FL->next->document_id == 2 );
  SHOULD_BE( FL->next->page_word_frequency == 13 );
  SHOULD_BE( FL->next->next == NULL );

  freeDocNodeList(FL);
  freeDocNodeList(d);

  END_TEST_CASE;
}


// Test Case: TestAND5
// will test the AND function
// with the last element in FL needing to be removed
// because it is not in d, also check that frequencies add

int TestAND5(){
  START_TEST_CASE;

  DocumentNode *FL,*d;
  FL = addDocNode(0,1);
  FL->next = addDocNode(1,2);
  FL->next->next = addDocNode(2,3);

  d = addDocNode(0,3);
  d->next = addDocNode(1,20);

  FL = AND(FL,d);

  SHOULD_BE( FL->document_id == 0 );
  SHOULD_BE( FL->next->document_id == 1 );
  SHOULD_BE( FL->next->next == NULL );
  SHOULD_BE( FL->page_word_frequency == 4 );
  SHOULD_BE( FL->next->page_word_frequency == 22 );


  freeDocNodeList(d);
  freeDocNodeList(FL);

  END_TEST_CASE;

}



// Test Case: TestAND6
// will test the AND function
// where both lists are non null but no similar elements

int TestAND6(){
  START_TEST_CASE;
  
  DocumentNode *FL, *d;
  FL = addDocNode(0,1);
  d = addDocNode(1,2);

  FL = AND(FL,d);

  SHOULD_BE( FL == NULL );

  freeDocNodeList(d);

  END_TEST_CASE;

}



// Test Case: TestOR1
// will test the OR function
// where there is no DNODE associated with
// given word

int TestOR1(){
  START_TEST_CASE;
  
  

  w = NULL;
  char key[]="a";

  DocumentNode *d,*dReturn;
  d = addDocNode(0,1);
  
  dReturn = OR(d,key);
  
  SHOULD_BE( dReturn->document_id == 0 );
  SHOULD_BE( dReturn->page_word_frequency == 1 );
  SHOULD_BE( dReturn->next == NULL );
  SHOULD_BE( dReturn == d );

  
  freeDocNodeList(d);
  free(w);
  END_TEST_CASE;
}

// Test Case: TestOR2
// will test the OR function
// word node exists. DocumentNode exists in d - should
// update frequencies

int TestOR2(){
  START_TEST_CASE;
 
  w = (DNODE *)malloc(sizeof(DNODE));
  w->data = addDocNode(0,55);
 
  char key[]="a";

  DocumentNode *d;
  d = addDocNode(0,1);

  d = OR(d,key);
  
  SHOULD_BE( d->next == NULL );
  SHOULD_BE( d->document_id == 0 );
  SHOULD_BE( d->page_word_frequency == 56 );
  
  free((DocumentNode *)w->data);
  free(w);
  freeDocNodeList(d);
  END_TEST_CASE;
}


// Test Case: TestOR3
// will test the OR function
// word node exists. DocumentNode in wordnode that
// needs to be added to d. Not the first element in list

int TestOR3(){
  START_TEST_CASE;
  


  w = (DNODE *)malloc(sizeof(DNODE));
  w->data = addDocNode(0,55);
  char key[]="a";


  DocumentNode *d;
  d = addDocNode(1,2);

  dLast = d;
  
  d = OR(d,key);

  SHOULD_BE( d->document_id == 1 );
  SHOULD_BE( d->page_word_frequency == 2 );
  SHOULD_BE( d->next->document_id == 0 );
  SHOULD_BE( d->next->page_word_frequency == 55 );

  free((DocumentNode *)w->data);
  free(w);
  freeDocNodeList(d);

  END_TEST_CASE;
}


// Test Case: TestOR4
// will tset the OR function
// word node exists, but d is empty
// will add elements to d

int TestOR4(){
  START_TEST_CASE;
  
  w = (DNODE *)malloc(sizeof(DNODE));
  w->data = addDocNode(0,55);
  char key[]="a";

  DocumentNode *d;
  d = NULL;

  dLast = NULL;

  d = OR(d,key);

  SHOULD_BE( d != NULL );
  SHOULD_BE( d->next == NULL );
  SHOULD_BE( d->document_id == 0 );
  SHOULD_BE( d->page_word_frequency == 55 );

  free((DocumentNode *)w->data);
  freeDocNodeList(d);
  free(w);
  END_TEST_CASE;
}


// Test Case: Testswap1
// will test the swapDocNode function
// where first 2 docnodes are going to be switched
// no 3rd docnode

int Testswap1(){
  START_TEST_CASE;
  DocumentNode *d,*dStart;
  int i = 1;

  dStart = addDocNode(0,1);
  dStart->next = addDocNode(5,15);
  d = dStart;
  
  dStart = swapDocNode(d,dStart,i);

  SHOULD_BE( dStart->document_id == 5 );
  SHOULD_BE( dStart->page_word_frequency == 15 );
  SHOULD_BE( dStart->next->document_id == 0 );
  SHOULD_BE( dStart->next->page_word_frequency == 1 );
  SHOULD_BE( dStart->next->next == NULL );

  freeDocNodeList(dStart);
  END_TEST_CASE;
}

// Test Case: Testswap2
// will test the swapDocNode function
// were swapping the last element in the list

int Testswap2(){
  START_TEST_CASE;
  DocumentNode *d,*dStart;
  int i = 0;
  dStart = addDocNode(0,15);
  dStart->next = addDocNode(1,10);
  dStart->next->next = addDocNode(2,1);
  dStart->next->next->next = addDocNode(3,8);
  d = dStart->next;
  dStart = swapDocNode(d,dStart,i);


  SHOULD_BE(dStart->document_id == 0 );
  SHOULD_BE(dStart->next->document_id == 1 );
  SHOULD_BE(dStart->next->next->document_id == 3 );
  SHOULD_BE(dStart->next->next->next->document_id == 2);
  SHOULD_BE(dStart->next->next->next->next == NULL );


  freeDocNodeList(dStart);
  END_TEST_CASE;
}


// Test Case: TestsortList1
// will test the sortList function
// with an empy input Document node list

int TestsortList1(){
  START_TEST_CASE;

  DocumentNode *d;
  d = NULL;
  d = sortList(d);
  
  SHOULD_BE( d == NULL );
  
  freeDocNodeList(d);
  
  END_TEST_CASE;
}

// Test Case: TestsortList2
// will test the sortList function




// Test Case: TestgetWord1
// will test getWord function with
// no input (i.e empty string);

int TestgetWord1(){
  START_TEST_CASE;

  char string[] = "";
  char *result;
  int pos = 0;

  result = (char *)malloc(1000);
  MALLOC_CHECK(result);
  BZERO(result,1000);

  pos = getWord(string,result,pos);
  

  SHOULD_BE( pos == -1 );
  SHOULD_BE( strcmp(result,"") == 0);
  
  free(result);
  
  END_TEST_CASE;
}





// Test Case: TestgetList1
// This will test the function getList
// with one input word

int TestgetList1(){
  START_TEST_CASE;

 
  char input[] = "hello";
 
  w = (DNODE *)malloc(sizeof(DNODE));
  w->data = addDocNode(0,1);
 
  DocumentNode *FL;
 
  FL = getList(input);
  
  SHOULD_BE( FL->document_id == 0 );
  SHOULD_BE( FL->page_word_frequency == 1 );
  SHOULD_BE( FL->next == NULL );

  freeDocNodeList(FL);
  free((DocumentNode *)w->data);
  free(w);

  END_TEST_CASE;
}



DICTIONARY *dict = NULL;

int main(){
  int cnt = 0;
  RUN_TEST(TestgetDocList1,"getDocList Test Case 1");
  RUN_TEST(TestgetDocList2,"getDocList Test Case 2");
  RUN_TEST(TestAND1,"AND Test Case 1");
  RUN_TEST(TestAND2,"AND Test Case 2");
  RUN_TEST(TestAND3,"AND Test Case 3");
  RUN_TEST(TestAND4,"AND Test Case 4");
  RUN_TEST(TestAND5,"AND Test Case 5");
  RUN_TEST(TestAND6,"AND Test Case 6");
  RUN_TEST(TestOR1,"OR Test Case 1");
  RUN_TEST(TestOR2,"OR Test Case 2");
  RUN_TEST(TestOR3,"OR Test Case 3");
  RUN_TEST(TestOR4,"OR Test Case 4");
  RUN_TEST(Testswap1,"swapDocNodes Test Case 1");
  RUN_TEST(Testswap2,"swapDocNodes Test Case 2");
  RUN_TEST(TestsortList1,"SortList Test Case 1");
  RUN_TEST(TestgetWord1,"getWord Test Case 1");
  RUN_TEST(TestgetList1,"getList Test Case 1");

  if(!cnt){
    printf("All passed!\n"); return 0;
  }
  else{
    printf("Some fails!\n"); return 1;
  }
}
