typedef struct {
	int rAngle;
   int sAngle;
   int gpsState;
} sailState;

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
#define BAUD_GPS 38400

#define PWM0_OPTION 0
#define PWM1_OPTION 0
#define PWM_FREQ 450ul

// Min and max sail angles
#define MIN_SAIL -90
#define MAX_SAIL 90

// min an max rudder angles
#define MIN_RUDDER -90
#define MAX_RUDDER 90


#use GPS4.LIB
#use BL26XX.LIB

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

void initGPS()
{
	//memset(gps.gps_string, 0x00, MAX_SENTENCE);
	//string_pos = 0;
	//serCopen(BAUDGPS);
   // Flush Buffers
   serCwrFlush();
	serCrdFlush();
	writeGPSString("$PGRMO,GPRMC,2"); //Disable all strings
	writeGPSString("$PGRMO,GPRMC,1");  //enable GPRMC string
   //writeGPSString("$PGRMC1,1,2,2,,,,2,W,N,,,,1");
   writeGPSString("$PGRMC1,1,1,2,,,,2,W,N,,,,1"); //enable NMEA 0183 2.3
   writeGPSString("$PGRMI,,,,,,,R");
   writeGPSString("$PGRMO,GPGSA,1"); //get sat info
	printf("using garmin GPS\n");
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



int *getXbee(char *buffer_xbee, int length, int position)
{
  auto int i;
  auto char ch;
  /* Lines in GPS code
  serEwrFlush();
  serErdFlush();
  WrPortI(PBDDR, &PBDDRShadow, 0xFF);   */
  memset(buffer_xbee, 0x00, sizeof(buffer_xbee));  //clear the string to 0's
  i = 0;
  serEread(buffer_xbee, length);
  printf("read in %s\n",*buffer_xbee);
  // Parse the message
  /*
  while( ch = serEgetc() != -1)
  {
  		printf("Stuck here, ch = %c,%d", ch,(int)ch);
  		if( ch != -1)
      {
         buffer_xbee[i++] = ch;
         printf("ch: %c\n",ch);
      } //endif
  }// end while (getting message)


  buffer_xbee[i++] = ch; // copy '\r' to the data buffer
  */
  buffer_xbee[i] = '\0'; // terminate the ancii string
  return i;
  //return buffer_xbee;
} // end getXbee

int update_Sail_State(sailState *newstate, char *sentence){
	auto int i, valid;
   auto int angle;
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
       angle = atoi(sentence);
       if( angle > MAX_RUDDER){
        	angle = MAX_RUDDER;
       }
       else if( angle < MIN_RUDDER){
        	angle = MIN_RUDDER;
       }

       newstate->rAngle = angle;
   }
   // sail angle setting
   else if( sentence[0] == 'S'){
   //else if( strncmp(sentence, "S",1) == 0){
       sentence = strchr(sentence,',');
       angle = atoi(sentence);
       if( angle > MAX_SAIL ){
        	angle = MAX_SAIL;
       }
       else if( angle < MIN_SAIL){
        	angle = MIN_SAIL;
       }
       newstate->sAngle = angle;

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


int set_angle(int channel, int angle)
{
// -90 degrees  at  42% duty  or 430 cnt    .93ms width
// 0 degrees at 68% or 696                  1.51  width
// +90 degrees at 97%  or 933               2.15  width

   auto int pwm;
   	pwm =(int)(690 + (float)angle*512/180);
   switch(channel)
   {
      case 0:
      	pwm_set(0, pwm, PWM0_OPTION);
         break;
      case 1:
      	pwm_set(1, pwm, PWM1_OPTION);
         break;
   }
   return pwm;
}

// nodebug
void msDelay(unsigned int delay)
{
	auto unsigned long done_time;

	done_time = MS_TIMER + delay;
   while( (long) (MS_TIMER - done_time) < 0 );
}

void main()
{
   int i,n,g, rvalue,temp;
   int sail_Flag;
   auto char c;
   int sendMsg;
   auto int nIn;
   auto char cOut,ch;
   GPSPosition GPS_Location;
   auto char sentence[MAX_SENTENCE];
   auto char gpsString[MAX_SENTENCE];
   auto char xBeeString[MAX_SENTENCE];
   auto char xBee_write_buffer[MAX_SENTENCE];
   sailState state;

   auto int pwm, head;
   auto long freq;


   //memset(xBee_write_buffer,0x00,sizeof(xBee_write_buffer));
   //ch = '\0';
   //xBee_write_buffer[0] = '\0';
   //strncpy(xBee_write_buffer,&ch,1);
   //(&xBee_write_Buffer)[0] = '\0';


   // initialize program state
   state.rAngle = 0;          // degrees
	state.sAngle = 0;          // degrees
   state.gpsState = 2;        // send raw gps data on xbee
   sail_Flag = 0;

   brdInit();

   // setup Xbee
   serEopen(BAUD_XBEE);
   serErdFlush();
   serEwrFlush();
   serMode(0);

   // Set up GPS
   serCopen(BAUD_GPS);
   serCrdFlush();
   serCwrFlush();
   serMode(0);

   initGPS(); //initialize gps

   // initialize PWM / Servo motors
   freq = pwm_init(50ul);

   printf("PWM Frequency: %d",freq);

   printf("Starting Program\n");
   //memset(&sentence,0x00,sizeof(&sentence));
   sendMsg = 0;
   while(1)
	{
   	costate xBeeWr always_on
      {
       //ch ='\0';
       waitfor( sendMsg == 1 ); // wait for a message to be loaded into the buffer

       writeXBeeString(xBee_write_buffer);      // send xbee message
       printf("wrote message to xBee\n%s\n",xBee_write_buffer);
       memset(xBee_write_buffer,0x00,sizeof(xBee_write_buffer));
       //xBee_write_buffer[0] = '\0'; //reset the string length to 0
       sendMsg = 0;
      }

   	costate XbeeRead always_on
      {
      	waitfor(serErdUsed() > 0); // wait for a message

         // read until finding the begining of the string then wait
         while(1)
         {
         	//printf("stuck here\n");
         	c = serEgetc();
            if( c == -1)
            {
            	serErdFlush();
               abort;
            }
            else if( c == '$')
            {

            	//printf("Message Recieved starting with: %c\n",c);
               //c = serEgetc();
               //printf("read second char: %c\n",c);
               waitfor(DelayMs(100)); // get entire message
               //printf("read third char: %c\n",serEgetc());
               break;

            }
          } // end while(1)

          temp = serErdUsed();
          printf("temp: %d\n",temp);
          serEread(xBeeString,temp,0);
          xBeeString[temp] = '\0';
          printf("xbee read: %s \n",xBeeString);
          printf("sail state %d\n",state.sAngle);

          //getXbee(xBeeString,temp,0);   // load in string
     /*
            i = 0;

  			 	// Parse the message
  				while( ch = serEgetc() != -1)
  				{
  	 				printf("Stuck here, ch = %c,%d", ch,(int)ch);
  	  				if( ch != -1)
     		   	{
        				 (&buffer_xbee)[i++] = ch;
        				 printf("ch: %c\n",ch);
      			 } //endif
				}// end while (getting message)

  				(&buffer_xbee)[i++] = ch; // copy '\r' to the data buffer
  				(&buffer_xbee)[i] = '\0'; // terminate the ancii string
                           */

          printf("Got Xbee message\n%s\n",xBeeString);
          update_Sail_State(&state, xBeeString); // update state
          sail_Flag = 1;


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
            //printf("%c\n",c);
            if (c == -1)
				{
					serCrdFlush();
					abort;
				}
				else if( c == '$')
				{
            	//i = 0;
               //gpsString[i++] = c;
            	waitfor(DelayMs(200));  //should only take 5ms or so at 115200 baud
					break;
				}
			}//end while(1)

			// now that 20 ms have passed, read in the gps string (it must all
			// be there by now, since so much time has passed

  			getgps(gpsString); // read in string
         //printf("read in GPS\n%s\n",gpsString);
         rvalue = gps_get_position(&GPS_Location,gpsString);
      	//printf("rvalue: %d\n",rvalue);
         if( rvalue == 0){
         	printGPSPosition(&GPS_Location);
         	if( state.gpsState == 2){
      		 //transmit raw data
             strncpy(xBee_write_buffer,gpsString,strlen(gpsString));
             sendMsg = 1; // send message flag
             }
         }
         else if( rvalue == 1 ) {
          	// transmit errors
            strcpy (xBee_write_buffer,"ERROR: ");
			   strcat (xBee_write_buffer,gpsString);
            sendMsg = 1; // send message flag
         }



      //memset(sentence,0x00,sizeof(sentence));

		}//end GPS costate

      costate sailAngle always_on
      {
           waitfor(sail_Flag == 1);
           //if( sail_Flag == 1){
           		pwm = set_angle(0,state.sAngle);
               sail_Flag = 0;
           //}
           // printf("sail angle: %d\n",state.sAngle);

      }// end sailAngle costate

      costate rudderAngle always_on
      {
          // pwm = set_angle(1,state.rAngle);
           // printf("rudder angle: %d\n",state.rAngle);
      }// end rudderAngle costate


	}// end while(1)
}//end main()