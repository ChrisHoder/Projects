/*
  File: network.c

  Descriptioin: This function has two options. The first is an automatic function which will find the
                the IP address and the submask on the computer and then compute the network address
		host address, and the prefix in the / notation. In the other option the user can 
		manually input the IP address and the prefix in the / notation and it will print out
		the subnet mask, network address and the host portion

  Input: no inputs, will be prompted for user input within the program
  
  Outputs: none, returns 0.

*/
#include<stdio.h>
#include<stdlib.h>
/*defines the functions that will be called */
void menu();
char choice();
void userInput();
void automatic();
unsigned int getTotal(unsigned int*);
int getPrefix(unsigned int);
unsigned int getHostTotal(unsigned int, unsigned int);
unsigned int getNetworkTotal(unsigned int, unsigned int);
void getAddr(unsigned int);
unsigned int getMaskPrefix(unsigned int);


/* This function runs the program and recursively calls itself to 
   continue running until the user exits */
int main(){

  /*menu prints out the options to the user */
  menu();

  /* the input can be a string but only the first letter will be read */
  char strchoice[10];
  fgets(strchoice,sizeof(strchoice),stdin);
  printf("\n\n");
  /* choices for the user are sorted with a switch */
  switch (strchoice[0]){
    /*user input case */
  case 'i':
	userInput();
	break;
 /*automatic case */
  case 'a':
	automatic();
        break;
  /*User wants to exit */
  case 'e':
	/*exits the function/program */
	return 0;
	break;

  /*first character of input by user is not a correct character */
  default:
    printf("Please input a correct character \n\n");
  }
  /* recursive call of the function to have a loop */
      main();
}

/* This function prints the menu of options for the user */
void menu() {
  printf("Menu \n");
  printf("i - to print the IP address details with user input\n");
  printf("a - to print the IP address details automatically\n");
  printf("e - to exit the program\n");
  printf("\n\n Enter Command:  ");
}


/* This function will take in the user's input IP addr and prefix.
   calculate the mask, host addr and display it for the user.
   Function takes no inputs and has no output.
*/
void userInput() {
  /* the int array for the IP addr */
   unsigned int IP[4];
   printf("Enter host address <x.y.z.t>:   ");
   char IPin[17];
   /* gets the IP addr that the user inputs */
   fgets(IPin, sizeof(IPin),stdin); 
   sscanf(IPin,"%u.%u.%u.%u\n",&IP[0],&IP[1],&IP[2],&IP[3]);
   int i;
   int Check=0;
   for (i=0; i<4; i++){
     if (IP[i]<0 || IP[i]>255){
       Check=1;
     }
   }
   if (Check == 0){
  /* gets the prefix that the user inputs */
     char strImp[100];
     printf("Enter prefix:  ");
     fgets(strImp, sizeof(strImp),stdin);
     int prefix;
     sscanf(strImp,"%d", &prefix);
     /*Checks the prefix for the right value */
     if ( prefix < 0 || prefix > 32 ){
       printf("Please input a correct prefix between 0 and 32\n\n");
       /* calls the function again for the user to try again */
       userInput();
     }
     else {
       printf("\n\n");

       /* gets all the data into single int form for the IP, Mask, Network, Host */

       unsigned int totalIP;
       totalIP = getTotal(IP);
       unsigned int totalMask;
       totalMask = getMaskPrefix(prefix);
       unsigned int Net;
       Net = getNetworkTotal(totalIP,totalMask);
       unsigned int Host;
       Host = getHostTotal(Net, totalIP);

       /* Prints out the block of info for the user to read all the Addr
	  info */
       printf("Addresses:\n");
       printf("Full IP Address:%5u.%u.%u.%u\n", IP[0], IP[1], IP[2], IP[3]);
       printf("Subnet Mask:    ");
       /*calls getAddr to convert to the readable form of x.y.z.t */
       getAddr(totalMask);
       printf("\n");
       printf("Prefix:           /%d\n",prefix);
       printf("Host Portion  ");
       getAddr(Host);
       printf("\n\n");
     }
   }
   else{
     printf("Please input a correct IP address.\n\n"); 
     userInput();
   }
 }


/* this function is called when the network information wants to be gatehered automatically
   This takes no inputs and has no outputs. Will call bash script getadr.sh which
   needs to be present in the same folder. will print out all addr information
*/
void automatic() {
   /* calls a bash script to get the ip and mask addresses */
   char command[]="./getadr.sh address.dat";
   system(command);

   /* opens the file containing the ip and mask addr */
   FILE *fp;
   fp = fopen("address.dat","r");
  
   /*int arrays to get the IP and the Mask from the script data saved
     in the .dat file */
   unsigned int IP[4];
   unsigned int Mask[4];

   /*checks to see if there is a file (which there should be always) */
   if (fp == NULL) {
     printf("no file");
	 }
   else {
     /* gets the IP address and the Mask and sorts it out */
     /* to an array for each */
     fscanf(fp,"%u.%u.%u.%u",&IP[0],&IP[1],&IP[2],&IP[3]);
     fscanf(fp,"%u.%u.%u.%u", &Mask[0], &Mask[1], &Mask[2], &Mask[3]);
     fclose(fp);

     /* sends data to various functions to conver the IP and mask to
	one large int form to have binary operations on them to get
	the network Addr, and the prefix */
     unsigned int totalIP;
     totalIP = getTotal(IP);
     unsigned int totalMask;
     totalMask = getTotal(Mask);
     unsigned int prefix;
     prefix = getPrefix(totalMask);
     unsigned int Net;
     Net = getNetworkTotal(totalIP, totalMask);
     unsigned int Host;
     Host = getHostTotal(Net,totalIP);


     /*This prints out all the info block of the Network data */
     printf("Addresses:\n");
     printf("Full IP Address:%5u.%u.%u.%u\n",IP[0],IP[1],IP[2],IP[3]);
     printf("Subnet Mask:    %5u.%u.%u.%u\n",Mask[0],Mask[1],Mask[2],Mask[3]);
     printf("Network Address:");
     getAddr(Net);
     printf("\n");
     printf("Prefix:           /%u\n",prefix);
     printf("Host Portion: ");
     getAddr(Host);
     printf("\n\n");


    }
 }


/* This function gets the total value of an addr that is the format
   <x.y.z.t> and converts it to one unsigned 32 bit integer. This function
   takes a unsigned int array of assumed length 4 and outputs a unsigned
   int */
unsigned int getTotal(unsigned int* PI){
  int i;
  unsigned int numPart;
  unsigned int totalIP=0;
  int shifter;
  /*loops through all the parts of PI and shifts accordingly */
  for (i=0; i < 4; i++){
    numPart=0;
    /*number of bits to shift based on each number being origionally in
      a 8 bit format. so max shift is 24 to put the first number in the 
      largest int location */
    shifter = 24 - (8*i);
    numPart = PI[i] << shifter;
    /* adds current number to the totalIP number using or bitwise op */
    totalIP = totalIP | numPart;
  }
  /* returns this total unsigned int */
  return(totalIP);
}


/* This function calculates the Network total or the full number corresponding
   to the Network Addr. Input is the IP as one int and the Mask as one Int */
unsigned int getNetworkTotal(unsigned int IP,unsigned int Mask){
  unsigned int network;
  /*network addr is the bitwise and between IP and Mask */
  network = IP & Mask;
  return(network);
}

/* This function calcuates the Host part of the IP addr using an input of the
   network addr and the ip addr in the form of one long int form of the 
   <x.y.z.t> addr. the Host is the xand of the two */
unsigned int getHostTotal(unsigned int Net,unsigned int IP){
  int Host;
  /* takes the bitwise xand between the IP and Network Addr */
  Host=IP ^ Net;
  return(Host);
}

/* This function gets the prefix in CIDR form from the
   version of the subnet mask of the int form.
   input is the Mask in the single int form. output is the
   prefix which is a single int also.
*/
int getPrefix(unsigned int Mask){
  int prefix=0;

  /* steps the number to the right and counts the number
     of steps till the number is 0. This is the prefix */
  while (Mask != 0) {
    Mask = Mask << 1;
    prefix += 1;
  }

  return (prefix);
}

/* This function changes an addr from the
   one int form to the <x.y.z.t> form and
   prints out this form with no carrige return
*/
void getAddr(unsigned int total){
  unsigned int num;
  unsigned int num2;
  unsigned int Addr[4];
  int i;
  for (i=0;i<4;i++){
    /* first shifts left so that the 8 bit section of importance is
       in the highest spot */
    num = total << (8*i);
    /* shifts right so that the 8 bit section is the right most 8 bits
       and there for the num2 is the number desired */
    num2 = num >> 24;
    Addr[i]=num2;
  }
  /*prints it out in the <x.y.z.t> form */
  printf("%5u.%u.%u.%u",Addr[0],Addr[1],Addr[2],Addr[3]);
}


/*This function gets the mask in a single integer form, representing the
  binary from the CIDR notation input by the user */
unsigned int getMaskPrefix(unsigned int prefix){
  unsigned int maskTotal=0;
  int i;
  /*will create a number 1 and then shift it a given bits right
    and then or's it with the total number to create
    a binary number with the desired number of 1's from
    left to right */
  for (i=31;i>(31-prefix);i--){
    unsigned int number = 1;
    unsigned int num2;
    num2 = number << i;
    maskTotal = maskTotal | num2;
  }
  return (maskTotal);

}
