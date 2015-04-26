


#ifndef PI
#define PI  3.141592654
#endif
#define serPORT(Baud) serCopen(Baud)

#define CINBUFSIZE 511
#define COUTBUFSIZE 511
#define EINBUFSIZE 511
#define EOUTBUFSIZE 511

#define GPS_POSITION_LENGTH 28
#define MAX_SENTENCE 85 // max sentence length for GPS as specified
//Define return states
#define GPS_INCOMPLETE 0
#define GPS_INVALID_MESSAGE 1
#define GPS_VALID_POSITION 2
#define GPS_VALID_SATELLITE 3

#define BAUD_XBEE 9600
#define BAUD_GPS 9600

#use GPS4.LIB
/*** BEGIN HEADER  */
//void initGPS();
//void writeGPSString(char* str);
//void printGPSPosition(GPSPosition* pos);
//int set_angle(int channel, int angle);
//void msDelay(unsigned int delay);
/*** END HEADER */




void writeGPSString(char* str);

void writeGPSString(char* str)
{
 	int lenStrMsg;
	int n;

	lenStrMsg = strlen(str);
	//printf("string length: %d",len);
	//printf("string %s\n",str);
    for(n=0;n<lenStrMsg;n++) {
		serCputc(str[n]);
	}
	serCputc('*');
	serCputc(13);
	serCputc(10);
}

void initGPS()
{
	//memset(gps.gps_string, 0x00, MAX_SENTENCE);
	//string_pos = 0;
	//serCopen(BAUDGPS);
   // Flush Buffers
   //serCwrFlush();
	// serCrdFlush();
	writeGPSString("$PGRMO,GPRMC,2"); //Disable all strings
	writeGPSString("$PGRMO,GPRMC,1");  //enable GPRMC string
   //writeGPSString("$PGRMC1,1,2,2,,,,2,W,N,,,,1");
   writeGPSString("$PGRMC1,1,1,2,,,,2,W,N,,,,1"); //enable NMEA 0183 2.3
   writeGPSString("$PGRMI,,,,,,,R");
   writeGPSString("$PGRMO,GPGSA,1"); //get sat info
	printf("using garmin GPS\n");
}

void printGPSPosition(GPSPosition* pos)
{
 	printf("\nLat degrees: %d\n",pos->lat_degrees);
   printf("Lat minutes: %f\n",pos->lat_minutes);
   printf("Lat Direction: %c\n",pos->lat_direction);
	printf("Lon degrees: %d\n",pos->lon_degrees);
	printf("Lon minutes: %f\n",pos->lon_minutes);
   printf("Lon Direction: %c\n",pos->lon_direction);
   printf("speed over ground: %f\n",pos->sog);
   printf("heading (deg): %f\n",pos->tog);
}



/*** BeginHeader update_Sail_State */
//int update_Sail_State(sailState *newstate, char *sentence);
/*** EndHeader */



char *getXbee(char *buffer_xbee)
{
  auto int i;
  auto char ch;
  serEwrFlush();
  serErdFlush();
  memset(buffer_xbee, 0x00, sizeof(buffer_xbee));  //clear the string to 0's
  i = 0;

  // Parse the message
  while( ch = serEgetc() != '\n')
  {
  		if( ch != -1)
      {
         buffer_xbee[i++] = ch;
      } //endif
  }// end while (getting message)

  buffer_xbee[i++] = ch; // copy '\r' to the data buffer
  buffer_xbee[i] = '\0'; // terminate the ancii string
  return buffer_xbee;
} // end getXbee

void writeGPSString(char* str)
{
 	int len;
	int n;

	len = strlen(str);
	//printf("string length: %d",len);
	//printf("string %s\n",str);
    for(n=0;n<len;n++) {
		serCputc(str[n]);
	}
	serCputc('*');
	serCputc(13);
	serCputc(10);
}

void writeXBeeString(char *str)
{
 	int len, i;

   len = strlen(str);
   for(i=0;i<len;i++){
    	serEputc(str[i]);
   }
   serEputc((char)10); // add the LF character at the end
}


int update_Sail_State(sailState *newstate, char *sentence){
	auto int i, valid;
   //auto char temp[8];
   valid = 0;
   // at a minimum the sentence should have verb, which is 2 characters
   if( strlen(sentence) < 2) {
   	return -1;
      }
   // switch on the types

   // rudder angle setting
   if( sentence[0] == 'R'){
   //if( strncmp(sentence, "R",1) == 0){
       sentence = strchr(sentence,',');
       newstate->rAngle = atof(sentence);
   }
   // sail angle setting
   else if( sentence[0] == 'S'){
   //else if( strncmp(sentence, "S",1) == 0){
       sentence = strchr(sentence,',');
       newstate->sAngle = atof(sentence);
   }
   else if( sentence[0] == 'G' ){
   //else if( strncmp(sentence, "G",1) == 0){
       sentence = strchr(sentence,',');
       newstate->gpsState = atoi(sentence);
   }
   else{
    	valid = 1;
   }


   return valid;
}
//char sentence[100];
//char string_pos;
char sentence[MAX_SENTENCE];
char string_pos;


void main()
{
   int c,i,n,g, rvalue;
   auto int nIn;
   auto char cOut,ch;
   GPSPosition GPS_Location;
   auto char gpsString[MAX_SENTENCE];
   auto char xBeeString[MAX_SENTENCE];
   auto char xBee_write_buffer[MAX_SENTENCE];
   sailState state;



   memset(xBee_write_buffer,0x00,sizeof(xBee_write_buffer));
   ch = '\0';
   strncpy(xBee_write_buffer,&ch,1);
   //(&xBee_write_Buffer)[0] = '\0';


   // initialize program state

   state.rAngle = 0;          // degrees
	state.sAngle = 0;          // degrees
   state.gpsState = 2;        // send raw gps data on xbee


   brdInit();

   // setup Xbee
   serEopen(BAUD_XBEE);
   serErdFlush();
   serEwrFlush();

   // Set up GPS
   serCopen(BAUD_GPS);
   serCrdFlush();
   serCwrFlush();
   serMode(0);

   initGPS(); //initialize gps

   printf("Starting Program");
   memset(sentence,0x00,sizeof(sentence));
   while(1)
	{
   	costate xbeeWr always_on
      {
       //ch ='\0';
       waitfor( xbee_write_Buffer[0] == '\0' ); // wait for a message to be loaded into the buffer

       writeXBeeString(xbee_write_Buffer);      // send xbee message

       xbee_write_Buffer[0] = '\0'; //reset the string length to 0

      }

   	costate XbeeRead always_on
      {
      	waitfor(serErdUsed() > 0); // wait for a message

         // read until finding the begining of the string then wait
         while(1)
         {
         	c = serEgetc();
            if( c == -1)
            {
            	serErdFlush();
               abort;
            }
            else if( c == '$')
            {
               waitfor(DelayMs(20)); // get entire message
               break;

            }
          } // end while(1)

          getXbee(xBeeString);   // load in string
          update_Sail_State(&state, xBeestring); // update state



          }//end get message

      }// end XbeeRead Costate

		// this costate will check if the GPS has sent some data or not and
		// call the appropriate functions to process the data
		costate GPSRead always_on
		{
			// wait until gps mode is engaged and a gps string has been recieved
			waitfor(serCrdUsed() > 0);
			//printf("gps read:   ");

			// read until finding the beginning of a gps string then wait
			while(1)
			{
            //int test2;
            c = serCgetc();
            printf("%c\n",c);
            if (c == -1)
				{
					serCrdFlush();
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

  			getgps(gpsString) // read in string
         rvalue = gps_get_position(&GPS_Location,gpsString);

         if( rvalue == 0 && state.gspState == 2){
      		// transmit raw data
            strncpy(xBee_write_Buffer,gpsString,strlen(gpsString));

         }
         else if( rvalue == 1 ) {
          	// transmit errors
            strcpy (xBee_write_Buffer,"ERROR: ");
				strcat (xBee_write_Buffer,gpsString);
         }



      memset(sentence,0x00,sizeof(sentence));
		}//end GPS costate
	}// end while(1)
}//end main()