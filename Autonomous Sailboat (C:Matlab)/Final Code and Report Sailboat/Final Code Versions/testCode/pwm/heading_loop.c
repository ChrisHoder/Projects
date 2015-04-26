// set heading loop to put into function

#use GPS4.lib
#ifndef PI
#define PI  3.141592654
#endif
#define serPORT(Baud) serCopen(Baud)
// serial baud rate
#define BAUDGPS 38400   // 3840 chr per second
// serial buffer configuration
#define CINBUFSIZE 511
#define COUTBUFSIZE 511
#define GPS_POSITION_LENGTH 28
#define MAX_SENTENCE 85 // max sentence length for GPS as specified
//Define return states
#define GPS_INCOMPLETE 0
#define GPS_INVALID_MESSAGE 1
#define GPS_VALID_POSITION 2
#define GPS_VALID_SATELLITE 3

#define PWM0_OPTION 0
#define PWM1_OPTION 0

/*** BEGIN HEADER  */
void initGPS();
void writeGPSString(char* str);
void printGPSPosition(GPSPosition* pos);
int set_angle(int channel, int angle);
void msDelay(unsigned int delay);
/*** END HEADER */

//declare some global variables
char sentence[MAX_SENTENCE];
char string_pos;



void initGPS()
{
	//memset(gps.gps_string, 0x00, MAX_SENTENCE);
	string_pos = 0;
	serCopen(BAUDGPS);
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


void printGPSPosition(GPSPosition* pos)
{
 	//printf("\nLat degrees: %d\n",pos->lat_degrees);
	//printf("Lon degrees: %d\n",pos->lon_degrees);
	//printf("Lat minutes: %f\n",pos->lat_minutes);
	//printf("Lon minutes: %f\n",pos->lon_minutes);
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

nodebug
void msDelay(unsigned int delay)
{
	auto unsigned long done_time;

	done_time = MS_TIMER + delay;
   while( (long) (MS_TIMER - done_time) < 0 );
}

void main()
   {
	auto int chan, ang, rvalue;
   auto float dist;
   auto int pwm, r_head, r_head2, head;
   auto long freq;
   auto char tmpbuf[128], c;
	char gpsString[MAX_SENTENCE];
   GPSPosition testPoint, testPoint_old;



	brdInit();
   serPORT(BAUDGPS);
   //serCopen(BAUDGPS);
   serMode(0);
   serCrdFlush();// main loop

   initGPS();
   freq = pwm_init(450ul);
   printf("pick heading: ");
   r_head = atoi(gets(tmpbuf));

   //while(1)
  // {
   /*goal.lat_degrees = 43;
   goal.lat_minutes = 7036;
   goal.lon_degrees = 72;
   goal.lon_minutes = 2811;
   goal.lat_direction = 'N';
   goal.lon_direction = 'W';
   goal.sog = 0;
   //goal.tog =
   */

   if ((r_head > 90) || (r_head < -90))
   	{
      printf("\nbad heading ");
     	}
   else {
   	while (1)
   		{
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
					if (c == -1)
						{
						serCrdFlush();
					  	abort;
						}
					else if (c == '$')
						{
						waitfor(DelayMs(20));  //should only take 5ms or so at 115200 baud
						break;
						}
				  	}//end while(1)

				// now that 20 ms have passed, read in the gps string (it must all
				// be there by now, since so much time has passed

				getgps(gpsString);
         	rvalue = gps_get_position(&testPoint,gpsString);
         	if( rvalue != -1)
         		{
         	  	printGPSPosition(&testPoint);
         		}
         	//printf("gps: %u \n",strlen(test2));
				printf("gps: %s ",gpsString);
            //printGPSPosition(&testPoint);
				//puts(gpsString);
				//puts(":   end gps \n");

         //dist = gps_ground_distance(&testPoint, &testPoint_old);
         //head = (int)gps_bearing(&testPoint, &testPoint_old, dist);
         //testPoint_old = testPoint;
         head = testPoint.tog;	// grab current heading
      	r_head2 = r_head-head;
         pwm = set_angle(0, r_head2);
         printf("angle: %d, head %d \n",pwm, head);
				}//end costate



  			}	// end while
   	}  // end else
	//} // end first while
	} // end main






