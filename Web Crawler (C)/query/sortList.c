// File: sortList.c


#include <stdio.h>
#include <stdlib.h>
#include <stdlib.h>
#include "QueryEngine.h"


// Bubblesort algorith to sort the DocNodes based on their frequency
// Algorithm taken from pseudocode on Wikipedia for an optimized bubblesort
// adapted for the case of a list and not an array

// Unlike a simple bubble sort, this function takes advantage of the fact that
// the smallest frequency elements will brought to the end of the list in the first
// pass and then shortens the next sweep accordingly

// This function sorts Document List
// INPUT:pointer to start of Document List
// OUTPUT:pointer to sorted Document List

/*
  pseudocode

  1) count document nodes, n
  2) WHILE (count is greater than 1) DO
     - FOR (each Doc Node up to the 2nd to last) DO
           - IF ( (doc node frequency) < (next docNode frequency)) THEN
	        - swap the two doc nodes
		- newN count = loop index + 1
           - ELSE
                - Go to next Document Node
	     FI
       END
     - n = newN count (i.e. repeat for loop with new n count)
     END
  3)return pointer to start of sorted DocumentList

*/
DocumentNode *sortList(DocumentNode *dStart){
  DocumentNode *d;
  DocumentNode *d2;
  int n,newN,i;
  n = DocNodes(dStart);

 
  while(n>1){
    d2 = dStart;
    d = dStart;
    newN = 0;
    //for each element in the list (up to the last unsorted element)
    for (i = 0;i<n-1; i++){
      // if (doc node frequency) < (next doc node frequency)
      if(d2->page_word_frequency < d2->next->page_word_frequency){
	// d2 is the first element in the list
	if (d2 == dStart){
	  //calls swapDocNode telling it that it is the first 2 that need to be swapped
	  //start pointer is also changed
	  dStart = swapDocNode(d,dStart,1);
	  d = dStart;
	}
	// d2 is not the first element in the list
	else{
	  dStart = swapDocNode(d,dStart,0);
	  d = d->next;
	}
	//update newN which tells where the last unsorted docnode is
	newN = i+1;

      }
      //these next two elements are already in the right order
      else{
	d = d2;
	d2 = d2->next;
      }
    }
    //change the loop index
    n = newN;
  }
  //return pointer to start of Document Nodes
  return dStart;
}


// This function swaps the DocNodes of the the next two DocNodes in the List.
// INPUT: document Node in list that is before the 2 Document nodes(1st docNode) that need to be
//        switched. Document Node that points to the start of the list. boolean integer (1 if the first
//        2 elements in the list need to be switched. 0 otherwise)
// OUTPUT: pointer to start of Document List

/*
  pseudocode

  1)store pointer to 1st DocNode to be switched (2nd DocNode)
  2)set next pointer for 1st DocNode to 3rd DocNode
  3) IF (NOT FIRST 2 ELEMENTS) THEN
      - IF (not the last two elements) THEN
            - point new 2nd DocNode to 4th DocNode
        ELSE
	    - set 'next' pointer in new 2nd DocNode to NULL
	FI
     FI
  4)IF (FIRST 2 ELEMENTS) THEN
      - point new first DocNode to old first DocNode
      - return new first DocNode
    FI
  5)return pointer to start of DocNodes
*/
DocumentNode *swapDocNode(DocumentNode *d,DocumentNode *dStart,int first){
  DocumentNode *d2;
  //set d2 to new 2rd docNode
  d2 = d->next;
  //set 1st element to point to 3rd docnode
  d->next = d2->next;
  //if not switching first 2 docnodes
  if(first == 0 ){
    //if switching the last two docnodes in a list
    if(d2->next->next){
      d2->next = d2->next->next;
    }
    //new end of list DocNode - next points to null
    else{
      d2->next = NULL;
    }
    //point to 4th DocNode
    d->next->next = d2;
  }
  //switching first 2 elements. i.e. start pointer needs to be changed
  if(first ==1){
    d2->next = d;
    //return new start poitner
    return d2;
  }
  //return point to start of doc nodes
  return dStart;
}
