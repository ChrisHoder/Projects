

#include <stdio.h>
#include <stdlib.h>
#include "index.h"


// This function will save the INVERTED_INDEX to a file
// given as in put. returns 0 if good. it will also
// free all the allocated memory associated with the index

// INPUT: file pathname
// OUTPUT: index in a file


/*
  pseudocode
  
  1) Create file, fN
     - overwrite existing
     IF (cannot open) THEN
        exit - log error
     END
  2) FOR (each DNODE,w) DO
       - count number of DocumentNodes - call: DocNodes
       - print "word number of document occurances" to file
       FOR (each document node) DO
           - print "docId frequency" to file,fN
	   - free Document Node memory
       END
       - increment to next DNODE
       - free old DNODE memory
       - pritn new line
    END
  3) free dictionary memory
  4) close file
  5) return 0


*/

int saveIndexToFile(char *fN){
  int i=0;
  FILE *fp;
  
  if ( (fp = fopen(fN,"w")) == NULL){
    perror("Cannot Create file");
    exit(-1);
  }

  DNODE *w, *w2;
  w=dict->start;
  DocumentNode *d, *d2;

  //for each wordnode
  while(w){
    int count = 0;
    count = DocNodes((DocumentNode *)w->data);
    fprintf(fp,"%s %d",w->key,count);
    d = (DocumentNode *)(w->data);

    //go to each document node and print the docId and
    //number of occurances
    while(d){
      fprintf(fp," %d %d",d->document_id,d->page_word_frequency);
      d2=d->next;
      free(d);
      d=d2;
    }
    
    fprintf(fp,"\n");
    //go to the next word node
    w2 = w->next;
    free(w);
    w = w2;
  }

  //done writing to the file
  fclose(fp);

  //free the dictionary memory
  free(dict);

  return i;
}

