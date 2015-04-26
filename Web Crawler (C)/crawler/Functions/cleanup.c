// FILE: cleanup.c

#include <stdio.h>
#include <stdlib.h>
#include "crawler.h"
// This function cleans up the data releasing all
// the malloced data such as the dictionary and the
// DNODES and URLNODES associated with it.
// 
// INPUT: the path created in the function
// OUTPU: nothing

void cleanup(void){
  //frees up the directory path created
  free(url_list);
  DNODE *d;
  URLNODE *n;
  
  //will loop down the DNODES to free every
  //DNODE and URLNODE before 
  //freeing up the dictionary memory
  d = dict->start;
  //if no DNODES then just free the dictionary
  if (!d){
    free(dict);
    return;
  }
  //loop down the DNODES until you get a NULL DNODE
  while(d){
    n = ( URLNODE *)(d->data);
    free(d->prev);
    d = d->next;
    free(n);
 }
  free(dict->end);
  free(dict);
  }
