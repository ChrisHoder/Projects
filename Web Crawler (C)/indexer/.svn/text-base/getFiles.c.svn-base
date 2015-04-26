// File getFiles.c


#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include "../utl/html.h"
#include "index.h"

// This function gets the file names for all the files in a directory
// INPUT: directory path
// OUTPUT: returns a pointer to a list of file paths.

// this code is burrowed from the example provided on
//  linux.about.com/library/cmd/blcmdl3_scandir.htm
//      this is the site linked to from the lab5 page

/*
pseudocode
   1) Get a list of all the files in the directory
   2) return this list
   3) Exit if bad directory

 */
struct dirent **getFiles(char *path){
  struct dirent **namelist;
  int n;
  //calls scandir
  n = scandir(path, &namelist,0,alphasort);
  if (n < 0){
    perror("Bad Directory");
    exit(-1);
  }
  //returns the directory information
  return namelist;
}


//This function checks to see if there was a directory
int is_directory(char *path){
  struct stat buf;
  int i = stat(path, &buf);
  if(i<0)
    return 0;
  return S_ISDIR(buf.st_mode);
}
