#include <stdio.h>

void IPtoBinary();
void getIP();

int main(){
  getIP();
}

void IPtoBinary(){
  char IP[16] = "192.168.5.10";
  int IpBinary;
  int number;
  char *strNumber = NULL;
  int i=0;
  while (i < 4){
    strNumber = strtok(IP,".");
    number =  atoi(strNumber);
    printf("this %s is the integer %d\n",IP, number);
    i++;
  }


  }

#define MAX 100

void getIP (){
  char A0[MAX];
  char A1[MAX];
  char A2[MAX];
  char A3[MAX];
  char S[MAX];
  int n;
  fgets(S,sizeof(S),stdin);
    n = sscanf(S,"%s%s . %s . %s",A0,A1,A2,A3);
  printf("strings read:\t%d\n",n);
  printf("A0:\t%s\n",A0);
  printf("A1:\t%s\n",A1);
  printf("A2:\t%s\n",A2);
  printf("A3:\t%s\n",A3);



}
