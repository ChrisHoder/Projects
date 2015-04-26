
 // This will loop back any serial communication that is recieved.

#define EINBUFSIZE 511
#define EOUTBUFSIZE 511
//declare some global variables
char sentence[100];
char string_pos;



/** USEFUL SENTENCES

int gps_get_sog(GPSPosition *newpos, char *sentence)


*/


void main()
{
   int test,c,i,n,g, rvalue;
   auto int nIn;
   auto char cOut;
   test = serEopen(9600);
  	printf("test: %d\n",test);
  // serPORT(9600);
   //serCopen(BAUDGPS);
   serMode(0);
   serErdFlush();// main loop
   serEwrFlush();
	serErdFlush();
   printf("starting the loop");
   memset(sentence,0x00,sizeof(sentence));
   while(1)
	{

		// this costate will check if the GPS has sent some data or not and
		// call the appropriate functions to process the data
		costate Xbee always_on
		{
			// wait until gps mode is engaged and a gps string has been recieved
			waitfor(serErdUsed() > 0);
			//printf("gps read:   ");
         printf("message recieved\n");
			// read until finding the beginning of a gps string then wait
			while(1)
			{
            //int test2;
            c = serEgetc();
            printf("%c\n",c);
            if (c == -1)
				{
					serErdFlush();
					abort;
				}
				else
				{
            	i = 0;
               sentence[i++] = c;
            	waitfor(DelayMs(200));  //should only take 5ms or so at 115200 baud
					break;
				}
			}//end while(1)

			// now that 20 ms have passed, read in the gps string (it must all
			// be there by now, since so much time has passed

      //serCwrFlush();
      //serCrdFlush();

      //i = 0;
      while((nIn=serEgetc()) != -1){
        sentence[i++] = nIn;

      }
      for(n = 0; n<i;n++){
       	serEputc(sentence[n]);
      }
      sentence[i] = '\0';

      printf("%s\n",sentence);
      memset(sentence,0x00,sizeof(sentence));
		}//end costate
	}// end while(1)
}//end main()