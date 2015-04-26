/*

File: sort.c

Description: This program will implement the sort bash command. This program can handle the switches that
             are -r for reverse, -u to only display unique numbers, -n to sort numerically. You can also
	     combine the switches any way you want -run, -ru, -un etc. Also you can do -rrr or multiple
	     switches but this will not effect whether or not the switch is used.

Input:       Input the filename with the numbers in it. You can also have some combination of -r, -u and -n
             of the switches.

Output:      This will print out the sorted version of the txt document depending on the switches input.

 */


/* use int atoi(string) to convert an ASCII string to an integer */


/* Program code adapted from the sort.c program used in class and the sort code provided in the
   "The Fist Book of ANSCI C 4th Ed by Gary J. Bronson pg430. */

#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int getFile(char*);
void sort(int,int);
void sortChar(int,int);
void sortNum(int,int);
int stepper(int,int);
int stepperNum(int,int);

/* arbitrary max number of numbers and lenght
   of a number set */
#define MAX 400
char numbers[MAX][MAX];

/* This function will sort a given file 3 different ways depending on the switches, r - reverse,
   n - numerically, u - unique */
int main(int argc, char *argv[]) {

  int unique, reverse, numsort;

  /* Checks to see that something has been input */
  if ( argv[1] == NULL ){
    printf("input a file\n");
    return 1;
  }

  /* Checks to see if there are any switches before the filename */
  while((argc > 1) && (argv[1][0] == '-')){
    int i=1;
    while ( i < 4 ){
    // argv[1][1] is the actual option
    if ( argv[1][i] ){
    switch (argv[1][i]) {

    case 'r': 
	reverse = 1;
        break;
    case 'u':
      	unique = 1;
        break;
    case 'n':
      	numsort = 1;
        break;

    default:
      printf("Usage: bad option %s\n", argv[1]);
      return 1;
    }
    }
    else
      break;
    
      i++;
    }

    // decrement the number of arguments left
    // increment the argv pointer to the next argument

    argc--; argv++;
  }

  // This checks to see that there is a filename given and that there are no
  // more inputs given to the program.
  if ( argv[2] != NULL  || argv[1] == NULL ) {
    printf("Input a file containing the numbers only\n");
    return 1;
  }


  /* j will be the length of the file */
  int j;

  j = getFile(argv[1]);

  // The only ways that the length of the file (i.e. numbers) is zero is if the file has no numbers
  // or the the filename was bad (set in the getFile function).
  if ( j == 0 ){
    printf("Bad filename or no numbers within the file\n\n");
    return 1;
  }

/*this calls the sorting functions */
  sort(j-1,numsort);

  // This series of code will print out the sorted array of numbers depending on the switches
  // chosen.

  // if the reverse switch
  if (reverse == 1) {
    int q;
    q=j;

    //counts down from the top
        while (q>=0){

	  // if the unique switch is on then this will check to make sure that the next element is not the same
	  // if it is the same it will not print that element.
	  if ( unique == 1 ){
	    if ( strcmp(numbers[q],numbers[q+1]) != 0){
		printf("%s\n",numbers[q]);
	    }
	  }
	  else{
	    printf("%s\n",numbers[q]);
	  }
	  q--;
	}
  }

  // Normal direction of sort
  else {
    int k=0;
    while ( k <= j ){

      //if unique switch is on - checks the same method as above description.
      if ( unique == 1 )
	{
	    if ( strcmp(numbers[k],numbers[k+1]) != 0){
		printf("%s\n",numbers[k]);
	    }
	}
      else{
	printf("%s\n",numbers[k]);
      }
      k++;
    }

  }

  return 0;
}


/* This function will get the numbers from the given file name. This saves to a global array defined at the 
   top of the function. This function will check to make sure that the file exists. Assumes that each line is
   one number. scans in creating an array of strings. Returns an int of the number of lines or numbers */
int getFile(char fileName[]){
  FILE *fp;
  fp = fopen(fileName,"r");
  int i=0;
  if ( fp == NULL ){
    printf("Incorrect File");
    return 0;
  }
  else{
    while( fscanf(fp,"%s\n",numbers[i]) != EOF && i < MAX  ){
      i++;
    }
  }

  /*returns the length/how many numbers */
  return i;
}


/* this function will determine if the numbers should be sorted
   normally or numerically based on the value of numsort3. 1 - sort by numbers
   returns nothing.
*/

void sort(int length, int numsort3){
  if (numsort3 == 1){
   sortNum(0,length);
  }
  else if (numsort3 == 0){
    sortChar(0,length);
  }
}


/* This is the recursive sort part for the sort method for the character sort.
   takes the lower index and the upper index as inputs and sorts the global array
*/
void sortChar( int lower, int upper){
  int  pivPt;
  /*  initial call */
  pivPt = stepper(lower,upper);

  /* sorts below the new pivPt location */
  if ( lower < pivPt ){
    sortChar(lower, pivPt-1);
  }
  /* sorts the upper side of the array above the pivPt */
  if (upper > pivPt){
    sortChar(pivPt+1, upper);
  }
}


/* This is the recursive sort part for the sort method for the numerical sort.
   takes the lower index and the upper index as inputs and sorts the global array.
   returns nothing */
void sortNum(int lower,int upper){
  int pivPt;
  pivPt = stepperNum(lower, upper);

  /*sorts below the new pivPt location */
  if (lower < pivPt ) {
    sortNum(lower, (pivPt-1));
  }
  /*pivPt > upper . sorts the upper side of the array above the pivPt*/
  if (upper > pivPt){
    sortNum((pivPt+1), upper);
  }
} 


/* This function runs the index back and forth for the character sort.
   takes the lower and upper index as inputs and sorts the numbers global array
   and returns the new pivotpt location. follows the quicksort algorythm based on p430 of
   Bronson's book */
int stepper (int lower,int upper){
  char piv[MAX];
  /* copies the pivot point number to a temp location -- frees a spot */
  strcpy(piv,numbers[lower]);


  while (lower < upper){
    /* goes right to left and skips over all the numbers greater than piv */
    while (strcmp(numbers[upper],piv) >= 0  && lower<upper){
      upper--;
    }
    /* puts the smaller number in the old piv location */
    if (upper != lower){
      strcpy(numbers[lower],numbers[upper]);
      lower++;
    } 
    /* scans left to right skipping all numbers less than pivot */
    while( strcmp(numbers[lower],piv) <= 0 && lower<upper){
      lower++;
	}
    /* puts the larger number in the open spot */
    if (lower != upper){
      strcpy(numbers[upper],numbers[lower]);
      upper--;
   }
  }

  /* copies the piv number that is being held temporarily */
  strcpy(numbers[lower],piv);
  /* returns the pivot location index */
  return(lower);
}


/* This function runs the index back and forth for the numerical sort.
   takes the lower and upper index as inputs and sorts the global array numbers numerically
   and returns the new pivot point location. this follows the quicksort algorythm based on p430
   of Bronson's book
*/
int stepperNum(int lower,int upper2){
  int piv;
  char pivPt[MAX];
  /* copies the pivot point to temp location */
  strcpy(pivPt,numbers[lower]);
  /* converts the number to an integer from string */
  piv = atoi(numbers[lower]);

  while (lower < upper2){
    
    /* scans right to left comparing numerically */
    while (atoi(numbers[upper2]) >= piv  && lower<upper2){
      upper2--;
    }
    /* exchanges new smaller number with the left index location */
    if (upper2 != lower){
      strcpy(numbers[lower],numbers[upper2]);
      lower++;
    } 
    /* scans left to right */
    while(atoi(numbers[lower]) <= piv && lower<upper2){
      lower++;
	}
    /* exchanges the larger number with the right index location */
    if (lower != upper2){
      strcpy(numbers[upper2],numbers[lower]);
      upper2--;
   }
  }
  /* copies the pivot point number back into the array and returns the pivot point index location */
  strcpy(numbers[lower],pivPt);
  return(lower);
}
