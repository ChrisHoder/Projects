#include <stdio.h>

#define MAX 1000

int main(int argc, char *argv[]){
  FILE *fp;
  fp = fopen(argv[1],"r");
  char numbers[MAX][MAX];
  unsigned int numbers2[MAX];
  int i=0;
  char n[MAX];
  unsigned int k;
  unsigned int k2;

  while( fscanf(fp,"%u\n",&numbers2[i]) != EOF || i == MAX-1  ){
    printf("%u\n",numbers2[i]);
    i++;
  }

}
