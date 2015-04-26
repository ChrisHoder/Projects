#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <unistd.h>
#include <time.h>


#define MAXLINE 4096 /*max text line length*/
#define SERV_PORT 6001 /*port*/
#define LISTENQ 8 /*maximum number of client connections*/
#define MAX 10 /* max length of variable */
#define VARIABLES 3 /* number of variables reading */
#define MAX_VALUES 200  /* max number of reads */


int main (int argc, char **argv)
{
 int listenfd, connfd, n;
 pid_t childpid;
 socklen_t clilen;
 // this will be what is recieved from client
 char buf[MAXLINE];
 //response to client
 char response[MAXLINE];
 //temp string
 char Temp[MAX];
 //this will hold all the data read from files at start
 char data[VARIABLES][MAX_VALUES][MAX];
 //this is the files in an array
 char request[VARIABLES][MAXLINE] = { "temperature.dat" , "humidity.dat", "light.dat" };
 //this will get the length of each data array
 int modifier[VARIABLES];
 struct sockaddr_in cliaddr, servaddr;

 //Create a socket for the soclet
 //If sockfd<0 there was an error in the creation of the socket
 if ((listenfd = socket (AF_INET, SOCK_STREAM, 0)) <0) {
  perror("Problem in creating the socket");
  exit(2);
 }

 //read in the data
 int i;
 //for each variable
 for (i=0;i<3;i++){
   FILE *fp;
   //open file
   if(( fp = fopen(request[i],"r")) == NULL){
     printf("error\n");
     exit(-1);
   }
   int j=0;
   //get each line and store into array
   while( fscanf(fp,"%s",Temp) != EOF){
     strcpy(data[i][j],Temp);
     j++;
   }
   //store number of elements
   modifier[i] = j;
 }
 


 //preparation of the socket address
 servaddr.sin_family = AF_INET;
 servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
 servaddr.sin_port = htons(SERV_PORT);

 //bind the socket
 bind (listenfd, (struct sockaddr *) &servaddr, sizeof(servaddr));

 //listen to the socket by creating a connection queue, then wait for clients
 listen (listenfd, LISTENQ);

 printf("%s\n","Server running...waiting for connections.");

 for ( ; ; ) {

  clilen = sizeof(cliaddr);
  //accept a connection
  connfd = accept (listenfd, (struct sockaddr *) &cliaddr, &clilen);

  printf("%s\n","Received request...");

  if ( (childpid = fork ()) == 0 ) {//if it’s 0, it’s child process

    printf ("%s\n","Child created for dealing with client requests");
    
    //close listening socket
    close (listenfd);
    //record start connection time
    time_t start = 0;
    time_t end = 0;
    int elapsed = 0;
    start = time(NULL);
    //while recieving data
    while ( (n = recv(connfd, buf, MAXLINE,0)) > 0)  {
      end = time(NULL);
      //elapsed time
      elapsed = end-start;
      printf("%s","String received from and resent to the client:");
      printf("%s\n",buf);
      //check to see what the request was and create a string with the correct
      // data and unit depending on time since connection
      if(strcmp(buf,"TEMPERATURE") == 0){
	snprintf(response,3,"%s",data[0][(elapsed%modifier[0])]);
      }
      else if(strcmp(buf,"HUMIDITY") == 0){
	//	sprintf(response,"%s",data[1][(elapsed%modifier[1])]);
	snprintf(response,3,"%s",data[1][(elapsed%modifier[1])]);
      }
      else if(strcmp(buf,"LIGHT") == 0){
	//sprintf(response,"%s",data[2][(elapsed%modifier[2])]);
	snprintf(response,3,"%s",data[2][(elapsed%modifier[2])]);
      }
      //print to stdout
      puts(response);
      //send to client
      send(connfd, response,3, 0);
    }

    if (n < 0)
      printf("%s\n", "Read error");
    exit(0);
      
  }
  //close socket of the server
  close(connfd);
 }
}
