#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <arpa/inet.h>
#include <unistd.h>


#define MAXLINE 4096 /*max text line length*/
#define SERV_PORT 6001 /*port*/
#define MAX_REQUEST 3

int
main(int argc, char **argv) 
{
 int sockfd;
 //array of requests to be made
 char request[3][MAXLINE] = { "TEMPERATURE" , "HUMIDITY", "LIGHT" };
 struct sockaddr_in servaddr;
 char recvline[MAXLINE];
	
 //basic check of the arguments
 //additional checks can be inserted
 if (argc !=2) {
  perror("Usage: TCPClient <IP address of the server"); 
  exit(1);
 }
	
 //Create a socket for the client
 //If sockfd<0 there was an error in the creation of the socket
 if ((sockfd = socket (AF_INET, SOCK_STREAM, 0)) <0) {
  perror("Problem in creating the socket");
  exit(2);
 }
	
 //Creation of the socket
 memset(&servaddr, 0, sizeof(servaddr));
 servaddr.sin_family = AF_INET;
 servaddr.sin_addr.s_addr= inet_addr(argv[1]);
 servaddr.sin_port =  htons(SERV_PORT); //convert to big-endian order
	
 //Connection of the client to the socket 
 if (connect(sockfd, (struct sockaddr *) &servaddr, sizeof(servaddr))<0) {
  perror("Problem in connecting to the server");
  exit(3);
 }
 printf("Connected to server!\n");
 printf("Data returned by the server\n");

 int q,j;
 //will get 20 data points and print them out
 for(q=0;q<20;q++){
   //for each data line need to get one for each variable
   for(j=0;j<3;j++){
     send(sockfd, request[j],strlen(request[j])+1, 0);
    
     if (recv(sockfd, recvline, MAXLINE,0) == 0){
       //error: server terminated prematurely
       perror("The server terminated prematurely"); 
       exit(4);
     }
     //print what was recieved
     printf("%s = %s ",request[j],recvline);
 
   }
   printf("\n");
   //sleep for 1 second before repeating (so that the server
   //will have updated
   sleep(1);
 }

 
 exit(0);
}
