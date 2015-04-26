// FILE: extractURLs.c


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../../utl/header.h"
#include "../../utl/hash.h"
#include "../../utl/html.h"
#include "crawler.h"




char **extractURLs(char *html_buffer, char *current){
  //counter
  int k = 0;

  //zeroes the url_list so that there are no left over poitners
  //to used urls from the last page
  BZERO(url_list, MAX_URL_PER_PAGE);

 
  //pos, pos of url found, URLLocation points to point in url-list
  int pos=0;
  char **URLLocation;
  //will be used to check if the url starts with the appropriate prefix
  char *prefixCheck;
  //result will be what the getNextUrl will put the url in
  char *result;
  result = (char *)malloc(MAX_URL_LENGTH);
  //zeroes the array
  BZERO(result,MAX_URL_LENGTH);
  //URLLocation is pointing to the first element in the url_list
  URLLocation = url_list;
  
  //will be used to point to the new memory alloted for the url
  char *newURL;


  //loops through the html code and gets all the urls out of it
  while ( (pos = GetNextURL(html_buffer,current,result,pos)) > 0){
  
    if ((strcmp(result,"\a") != 0) && (result != 0) && (strncmp(result," ",1) != 0) && (strlen(result)!=0)){
     int q;
     q = NormalizeURL(result);
     if (q == 1){
       
       //check prefix
      //this should also get rid of the potential for a 0 url return
       prefixCheck = strstr(result,URL_PREFIX);
      //if strstr returns a pointer to the start of the url then the url starts
      //with the prefix
       if (prefixCheck==result){
	 //add to url_list
	 newURL = (char *)malloc(MAX_URL_LENGTH);
	 MALLOC_CHECK(newURL);
	 BZERO(newURL,MAX_URL_LENGTH);
	 strcpy(newURL,result);
	 *URLLocation =  newURL;
	 
	 //log the new url
	 char *m;
	 m = (char *)malloc(COMMAND_MAX_LENGTH);
	 MALLOC_CHECK(m);
	 BZERO(m,COMMAND_MAX_LENGTH);
	 
	 //create a string with the info in it
	 snprintf(m,COMMAND_MAX_LENGTH,"Parser found URL: %s",result);
	 LOG(m);
	 //frees the memory used
	 free(m);
	 
	 URLLocation++;
      }
     }
   }

    //zeros the result to be used to hold the next url
    BZERO(result,MAX_URL_LENGTH);
    k++;
  } 
  //returns the list of pointers to the urls
  free(result);
  return (url_list);
}

