typedef struct {
	int rAngle;           // rudder servo angle
   int sAngle;           // sail servo angle
   int gpsState;         // GPS sending state
   int boatState;        // Boat state values
   int controlState;     // control state of the sailboat
   float Kri;				 // rudder integral gain param
   float Krp;            // rudder proportional gain param
  // int Ksi;				 // sail integral gain param
   float desiredHeading; // desired heading angle
   float windDir;        // Current realtive wind direction   (degrees)
   float windVel;        // Current relative wind velocity     (m/s)
   float trueDir;        // True wind direction
   float trueVel;        // True wind velocity
   int initialize_Wind;  // flag to initialze the wind
   int windSet;          // flag for xBee ack
   int Abort;            // abort flag
   int Goal;				 // Waypoint goal

   float NO_SAIL;        //How far from the wind direction we must sail to avoid being stuck in irons (degrees)
   float TACK_LENGTH;    //Maximum length between tacks (km)
   float ANG_OFF_WIND;   //How far off the wind we want to sail between tacks (degrees)
   int TACK;             // current boat tack
   int tackFlag;


   //maximization info
   float SAIL_GRAD_STEP;// 	.1		// stepsize of gradient search
   float sailDeadband; //	  	.05   // zero determination
   float HEAD_GRAD_STEP;//  .1

   //min/max rudder info
   int MIN_RUDDER;// -45
   int MAX_RUDDER;// 45
} sailState;
// This structure will be used to hold the state of the sailboat as well as any
// control and debug information
typedef struct {
 float velocity; //wind velocity
 long old_anem_pos_st;//old anemometer position
 } velOutput;
//Dynamic C is stupid and doesn't like global variables and pointers

#ifndef PI
#define PI  3.141592654
#endif

//Force functions to be compiled to extended memory.  Helps when the
// program gets large
#memmap xmem


/** DEBUGGING DEFINES     */
// comment out to shut off different debug/settings

//#define _debug_
//#define _debugXbee_   // prints out all xbee writes
//#define _debugWind_   // prints out the true wind speed and directoin calc
#define _debugHeadingControl_   // prints out heading information
//#define _debugWindReadings_  // prints out wind velcity and direction measurements
//#define _debugStrategy_  // prints strategy selected
//#define _printState_
//#define _wayCheck_
//#define _bearingPrint_
//#define _sailPrint_
#define _statusChange_
//#define _GPS_Debug_
//#define _xBeeDebug_



#define _send_xBee_ //turns on xbee communication out

/** END DEBUGGING DEFINTES


/*** SET BUFFER SIZES */
#define CINBUFSIZE 511
#define COUTBUFSIZE 511
#define EINBUFSIZE 511
#define EOUTBUFSIZE 511
#define FINBUFSIZE 31
#define FOUTBUFSIZE 31
/*** END BUFFER SIZES */


/*** DEFINE GPS DEFAULTS */

#define GPS_POSITION_LENGTH 28
#define MAX_SENTENCE 200 // max sentence length for GPS as specified
//Define return states
#define GPS_VALID 0
#define GPS_PARSING_ERROR -1
#define GPS_INVALID_MESSAGE 1
//#define GPS_VALID_POSITION 2
//#define GPS_VALID_SATELLITE 3
/*** END GPS DEFINES */

/*** DEFINE GPS SERIAL PORT TO USE */
#define BAUD_GPS 38400
#define serGPSOpen(Baud)             serCopen(Baud)
#define serGPSRead(data,length,tout) serCread(data,length,tout)
#define serGPSputc(data)             serCputc(data)
#define serGPSrdFlush()			  		 serCrdFlush()
#define serGPSwrFlush()			  		 serCwrFlush()
#define serGPSrdUsed()			  		 serCrdUsed()
#define serGPSMode(value)       		 serMode(value)
#define serGPSgetc()				  		 serCgetc();
#define GPS_MODE 0

/*** DEFINE WAYPOINT ITEMS */
#define numWayPoints						2
#define latD                        43
#define longD								72
#define SOG									0
#define TOG									0
#define latN								'N'
#define longE								'E'
#define timeWay							080000


/*** DEFINE XBEE SPECFICIC SERIAL PORT TO USE */
#define BAUD_XBEE 9600
#define serXbeeOpen(Baud)         		serEopen(Baud)
#define serXbeeRead(data,length, tout) serEread(data,length,tout)
#define serXbeeputc(data)       		   serEputc(data)
#define serXbeerdFlush()			      serErdFlush()
#define serXbeewrFlush()			      serEwrFlush()
#define serXbeerdUsed()			         serErdUsed()
#define serXbeeMode(value)             serMode(value)
#define serXbeegetc()					   serEgetc()
#define XBEE_MODE 0

/** DEFINE MAXIMIZTION PARAMETERS */
// moved these to the statestruct --- can be set by radio
//#define SAIL_GRAD_STEP 	.1		// stepsize of gradient search
//#define sailDeadband	  	.05   // zero determination
//#define HEAD_GRAD_STEP  .1
#define aveNum			10  // vmg measurements before averaging
/** END MAXIMIZATION PARAMETERS */


/** SET SERVO ADDRESS VALUES */
#define serServoOpen(Baud)					serFopen(Baud)
#define serServordFlush()			      serFrdFlush()
#define serServowrFlush()			      serFwrFlush()
#define serServoMode(value)            serMode(value)

#define RUDDER 6
#define SAIL 7
/*** END SERVO VALUES */        \

/*** SERVO SETTINGS */
// Min and max sail angles
#define MIN_SAIL -40
#define MAX_SAIL 75

// min an max rudder angles
// moved to state struct to be set by radio
//#define MIN_RUDDER -45
//#define MAX_RUDDER 45
/*** END SERVO SETTTINGS */


/*** BEGIN CONTROL MODES */
#define USER_CONTROL_MODE      0
#define GPS_CONTROL_MODE       1
#define ESCAPE_CONTROL_MODE    2
#define HEADING_CONTROL_MODE   3
#define MAX_VELOCITY_MODE      4
#define MAX_HEADING_MODE       5
/*** END CONTROL MODES */

/*** BEGIN BOAT STATES */
#define BROADCAST_STATE 0
#define NO_BROADCAST_STATE 1
/* END BOAT STATES */

/*** GPS STATES */
#define GPS_BROADCAST_STATE 0
#define NO_GPS_BROADCAST_STATE 1
/* END GPS STATES

/*** START TELEMETRY SETTINGS */
#define TELEMETRY_INTERVAL 600 // time to wait between each send of GPS, state
/* END TELEMETRY SETTINGS */

/*** START WIND INFORMATION */
#define WIND_HISTORY 20
/* END WIND INFORMATION */

/*** START WAYPOINT INFO */
#define WAYPOINT_RADIUS 0.5
/* END WAYPOINT INFO */

#use GPS4.LIB
#use BL26XX.LIB

/*ENCODER DEFINITIONS*/
#define DATA 	0x00ff
#define RD     8
#define WR     9
#define CS1    10
#define CS2    11
#define YX     12
#define CD     13
#define BP_RESET    	  	0X01		// reset byte pointer
#define EFLAG_RESET		0X86		// reset E bit of flag register
#define CNT					0x01  // access control register
#define DAT					0x00  // access data register
#define BP_RESETB  		0X81		// reset byte pointer (x and y)
#define CLOCK_DATA 		2			// FCK frequency divider
#define CLOCK_SETUP 		0X98		// transfer PR0 to PSC (x and y)
#define INPUT_SETUP   		0XC1		// enable inputs A and B (x and y)
#define QUAD_X1       		0XA8	// quadrature multiplier to 1 (x and y)
#define QUAD_X2       		0XB0	// quadrature multiplier to 2 (x and y)
#define QUAD_X4       		0XB8	// quadrature multiplier to 4 (x and y)
#define CNTR_RESET    		0X02		// reset counter
#define CNTR_RESETB    		0X82		// reset counter (x and y)
#define TRSFRPR_CNTR    	0X08	// transfer preset register to counter
#define TRSFRCNTR_OL			0X90	// transfer CNTR to OL (x and y)
#define XYIDR_SETUP			0XE1	// x and y index cntrl register
#define XYIOR_SETUP			0XDB	// x and y i/o cntrl register
#define HI_Z_STATE         0xFF
/*END ENCODER DEFINITIONS*/

/*START STRATEGY DEFINITIONS*/
#define TACKING 1
#define DOWNWIND 0
/*END STRATEGY DEFINITIONS*/

/*START SAILING PARAMATERS*/
#define HEADING_ERROR 10 //accpetable heading error, degrees
#define TACK_SPEED 0.5 //minimum tacking speed, knots
/*END SAILING PARAMATERS*/



// servo serial function prototypes
void writeServo(char cmd, int serv, char data);
void initServo();
void setServoSpeed(int serv, int spd);
int setServoPosition(int serv, int ang, sailState *state);

// generic write to servo function
void writeServo(char cmd, int serv, char data)
{
   char buf[5];
	serFputc(0x80);	// start com with servo contorller
	serFputc(0x01);	// servo type id
	serFputc(cmd);		// cmd

	serFputc(sprintf(buf,"%d",serv));	// servo number
	serFputc(data);		// put in data
}

// initialize servo, open each servo pwm line
void initServo()
{
	int i;
   serFwrFlush();
	serFrdFlush();
	for (i =0 ; i<8; i++)
   {writeServo(0, i, 0x2F);	// setup servo one
   }
   setServoSpeed(RUDDER, 0);
   setServoSpeed(SAIL, 0);
}

// set the servos to instant response mode
void setServoSpeed(int serv, int spd)
{  writeServo(0x01, serv, spd);  }

/* set servo position
 takes: servo number (0-7)
 		  ang   -  the angle to go to (-90 to 90, with 0 straight ahead)
 gives: retu  - a status bit indicating
 					-1 angle set too low
               1  angle set too high
               0  angle set correctly
*/
int setServoPosition(int serv, int ang, sailState *state)
{
	int temp, retu;
   int minVal, maxVal; // maximum values
   char buf;

   serFputc((char)0x80); // start byte
   serFputc((char)0x01); // device id
   serFputc((char)0x02); // set position command (7 bit)
   serFputc((char)serv);	// set servo

   // determine what min / max val to use
   if( serv == SAIL ){
    	minVal = MIN_SAIL;
      maxVal = MAX_SAIL;
   }
   else if( serv == RUDDER ){
    	minVal = (int)state->MIN_RUDDER;
      maxVal = (int)state->MAX_RUDDER;
   }
   else{
   	minVal = (int)state->MIN_RUDDER;
      maxVal = (int)state->MAX_RUDDER;
      // printf("hi");
    	// should never get here
#ifdef _debug_
		printf("Error, not listed servo commanded\n");

#endif
   }

	if (ang < minVal)
		{
        //temp = (int) 31.75;	// set at -45
        temp = (int) (63.5*minVal/90+63.5);
        serFputc((char)temp);
      retu = -1;	// angle set too low
		}
	else if (ang > maxVal)
		{
      //temp = (int) 31.75;	// set at -45
      temp = (int)(63.5*maxVal/90+63.5);
      serFputc((char)temp);
      retu = 1;	// angle set too high
		}
	else
		{
      temp = (int) (63.5*ang/90+63.5);       //
		//printf("index = %d\n",temp);
  	   serFputc((char)temp);
		//printf("serial put value: %c\n",(char)temp);
      retu = 0;	// all is well
		}
   return retu;
}


 long old_anem_pos;
/*** Begin Header EncRead */
int EncRead(int channel, int reg);
/*** End Header */
/* START FUNCTION DESCRIPTION ********************************************
EncRead

SYNTAX:        int EncRead(int channel, int reg);
KEYWORDS:      encoder,read
DESCRIPTION:   Returns data from the encoder board, depending on input
PARAMETER 1:   channel - an int from 0 to 3 indicating which encoder is to be read
PARAMATER 2:   reg - an int which is 1 or 0 indicating whether control or data is desired
RETURN VALUE:  the requested data, as an int

END DESCRIPTION**********************************************************/
int EncRead(int channel, int reg)
{
// channel is an int from 0 to 3 indicating which encoder
// reg is an int which is 1 or 0 indicating whether control or data is desired
   int EncData;
   int i, delayvar;
   EncData = 0;

   digOutConfig(0xff00); // set data lines as inputs and everything else as outputs

   // select which chip
   if (channel <= 1)
   	digOut(CS1,0);
	else
   	digOut(CS2,0);

    // Select control or data register
    digOut(CD,reg);

   // select which channel, X or Y
   if ((channel == 0) | (channel == 3) )
   	digOut(YX,0);
  else
      digOut(YX,1);
     // assert Read low
   digOut(RD,0);

   EncData = digInBank(0);     // read the data from the data lines

//     for(i = 0; i < 5; i++)
//        { delayvar = i; }

//deassert read reads the data. Deassert delay to allow rise then deselect
   digOut(RD,1);
   digOut(CS1,1);
   digOut(CS2,1);
   return EncData;
}
/*** Begin Header EncWrite */
void EncWrite(int channel, int data, int reg);
/*** End Header */
/* START FUNCTION DESCRIPTION ********************************************
EncWrite

SYNTAX:       void EncWrite(int channel, int data, int reg);
KEYWORDS:      encoder,write
DESCRIPTION:   puts data onto registers in the encoder board
PARAMETER 1:   channel - an int from 0 to 3 indicating which encoder is to be written to
PARAMATER 2: 	data - the data to be put on the register
PARAMATER 2:   reg - an int which is 1 or 0 indicating whether control or data register is desired
RETURN VALUE: none

END DESCRIPTION**********************************************************/
void EncWrite(int channel, int data, int reg)
{
   int i, delayvar;

   digOutConfig(0xffff);// set all digI/O lines as outputs

  // select which chip - channel 0 & 1 are chip 1 and channel 2 & 3 are chip 2
   if (channel <= 1)
      digOut(CS1,0);
   else
   	digOut(CS2,0);
   // select which channel, X or Y  X = 0 and 2, Y = 1 and 3
   digOut(CD,reg);

   if ((channel == 0) | (channel == 3) )
   	digOut(YX,0);
  else
      digOut(YX,1);
       digOutBank((char)0,(char)data);

    // assert write
   digOut(WR,0);

   // deassert write
   digOut(WR,1);

   // deselect chip
   digOut(CS1,1);
   digOut(CS2,1);
   //Set all outputs to 1 so that open collector transistor is off
   digOutBank((char)0,(char)HI_Z_STATE);
   digOutConfig(0xff00);
}
/*** Begin Header EncInit */
int encInit(void);
/*** End Header */
/* START FUNCTION DESCRIPTION ********************************************
encInit

SYNTAX:       int encInit(void)
KEYWORDS:      encoder,init
DESCRIPTION:   Sets up the encoder board
RETURN VALUE:  a failute check, zero means no fault

END DESCRIPTION**********************************************************/
int encInit(void)
{
   int fail;
   int i,j;
   fail = 0;
       digOutConfig(0xff00);
   digOut(CS1,1);
   digOut(CS2,1);
   digOut(RD,1);
   digOut(WR,1);

   for (i = 0; i<4; i++)
   {
//		EncWrite(i, XYIOR_SETUP,CNT);	// Setup I/O control register
//		EncWrite(i, XYIDR_SETUP,CNT);		// Disable Index
      EncWrite(i,EFLAG_RESET,CNT);
      EncWrite(i,BP_RESETB,CNT);
      //EncWrite(i,CNTR_RESETB,CNT);
     	EncWrite(i,CLOCK_DATA,DAT);
    	EncWrite(i,CLOCK_SETUP,CNT);
     	EncWrite(i,INPUT_SETUP,CNT);
     	EncWrite(i,QUAD_X4,CNT);

      EncWrite(i,BP_RESETB,CNT);
      EncWrite(i,0x12,DAT);
      EncWrite(i,0x34,DAT);
      EncWrite(i,0x56,DAT);

      EncWrite(i,TRSFRPR_CNTR,CNT);
      EncWrite(i,TRSFRCNTR_OL,CNT);

      EncWrite(i,BP_RESETB,CNT);
      #ifdef _debug_
		printf("written = %d, read = %d\n",0x12,EncRead(i,DAT));
      printf("written = %d, read = %d\n",0x34,EncRead(i,DAT));
      printf("written = %d, read = %d\n",0x56,EncRead(i,DAT));
      #endif
    // Reset the counter now so that starting position is 0
       EncWrite(i,0x5A0,DAT);
       EncWrite(i,CNTR_RESET,CNT);
       EncWrite(i,CNTR_RESETB,CNT);

   }
   return fail;
}



/*** Begin Header getWindPos */
float getWindPos(long offset);
/*** End Header */
 /* START FUNCTION DESCRIPTION ********************************************
getWindPos

SYNTAX:        float getWindPos(long offset);
KEYWORDS:      encoder,read,vane
DESCRIPTION:   Returns the wind direction using the wind vane position
PARAMETER 1:   offset - the count treated as straight ahead (using the boat
Coordinate system)
RETURN VALUE:  the wind direction, in degrees

END DESCRIPTION**********************************************************/
float getWindPos(long offset){
  int asb, bsb, csb;
  long position;
  float floatPos  ;

   EncWrite(3, TRSFRCNTR_OL, CNT);
  	EncWrite(3,BP_RESETB,CNT);
   asb = EncRead(3,DAT);
   bsb = EncRead(3,DAT);
   csb = EncRead(3,DAT);
  //printf(" position: %d, %d, %d, \n",csb, bsb, asb);
 	position  = (long)asb;			// least significant byte
 	position += (long)(bsb << 8);
 	position += (long)(csb <<16);
   position=position-offset;
 	position= (position % 1440);
	floatPos=(position * 360.0)/1440.0;

   if (floatPos < 0 ){ return 360 + floatPos;}

   return floatPos;
}
/*** Begin Header getWindVel */
velOutput getWindVel(float dt, long old_anem_pos);
/*** End Header */
/* START FUNCTION DESCRIPTION ********************************************
getWindVel

SYNTAX:        float getWindVel(float dt);
KEYWORDS:      encoder,read,anemometer
DESCRIPTION:   Returns the wind velocity using the anemometer position
PARAMETER 1:   dt - the timestep, used in the derivitive calculation
RETURN VALUE:  the wind velocity

END DESCRIPTION**********************************************************/
velOutput getWindVel(float dt, long old_anem_pos_in){
  int asb, bsb, csb;
  float vel;
  long position;
  velOutput output;
  EncWrite(2, TRSFRCNTR_OL, CNT);
              EncWrite(2,BP_RESETB,CNT);
              asb = EncRead(2,DAT);
              bsb = EncRead(2,DAT);
              csb = EncRead(2,DAT);

//              printf("%d, %d, %d, \n",csb, bsb, asb);
              position  = (long)asb;			// least significant byte
				  position += (long)(bsb << 8);
				  position += (long)(csb <<16);
              //printf("%d, %d \n",position,old);
             vel= ((float)position-(float)old_anem_pos_in)/(dt);
             vel=(0.001*vel-0.0369)*1.944;
              if (vel<0){ vel=-vel;}
              output.velocity=vel;
              output.old_anem_pos_st=position;
              //printf("velocity: %f,dir: %f\n",output.velocity,output.old_anem_pos_st);
              return output;


}
/*** Begin Header getCount */
long getCount(int channel);
/*** End Header */
/* START FUNCTION DESCRIPTION ********************************************
getCount

SYNTAX:        long getCount(int channel);
KEYWORDS:      encoder,read
DESCRIPTION:   Returns the current encoder position in counts
PARAMATER 1: channel - an int from 0 to 3 indicating which encoder is to be written to
RETURN VALUE:  The current encoder count

END DESCRIPTION**********************************************************/
long getCount(int channel){
 int asb, bsb, csb;
 long position;
   EncWrite(channel, TRSFRCNTR_OL, CNT);
  	EncWrite(channel,BP_RESETB,CNT);
   asb = EncRead(channel,DAT);
   bsb = EncRead(channel,DAT);
   csb = EncRead(channel,DAT);
   // printf("%d, %d, %d, \n",csb, bsb, asb);
 	position  = (long)asb;			// least significant byte
 	position += (long)(bsb << 8);
 	position += (long)(csb <<16);
   return position;
}

/*** Begin Header  printGPSPosition */
void printGPSPosition(GPSPosition* pos);
/*** End Header */

/* START FUNCTION DESCRIPTION *********************************************
printGPSPosition

SYNTAX:         void printGPSPosition(GPSPosition* pos);
KEYWORDS:       gps
DESCRIPTION:    Prints out the information contained in the GPSPosition
					 structure.
PARAMETER 1:    pos - a GPSPosition structure that is to be printed out
RETURN VALUE:   none

END DESCRIPTION **********************************************************/
void printGPSPosition(GPSPosition* pos)
{
	printf("-------------------\n");
 	printf("\nLat degrees: %d\n",pos->lat_degrees);
   printf("Lat minutes: %f\n",pos->lat_minutes);
   printf("Lat Direction: %c\n",pos->lat_direction);
	printf("Lon degrees: %d\n",pos->lon_degrees);
	printf("Lon minutes: %f\n",pos->lon_minutes);
   printf("Lon Direction: %c\n",pos->lon_direction);
   printf("speed over ground: %f\n",pos->sog);
   printf("heading (deg): %f\n",pos->tog);
   printf("-------------------\n");
}


void printSailState(sailState *state)
{
	printf("\n--------------\n");
	printf("Rudder Angle: %d\n", state->rAngle );
   printf("Sail Angle: %d\n",state->sAngle);
   printf("GPS state: %d\n",state->gpsState);
   printf("--------------\n");

}


/*** Begin Header writeGPSsTRING */
void writeGPSString(char* str);
/* End Header */

/* START FUNCTION DESCRIPTION ********************************************
writeGPSString

SYNTAX:        void writeGPSString(char* str);
KEYWORDS:      gps, write
DESCRIPTION:   Takes the input string, str and sends it out to the gps in
               the correct format
PARAMETER 1:   str - string to be transmitted to the GPS
RETURN VALUE:  none

END DESCRIPTION**********************************************************/
 void writeGPSString(char* str)
{
 	int len;
	int n;

	len = strlen(str);
	//printf("string length: %d",len);
	//printf("string %s\n",str);
    for(n=0;n<len;n++) {
      serGPSputc(str[n]);
	}
   serGPSputc('*');
   serGPSputc(13);
   serGPSputc(10);
}


/*** Begin Header initGPS */
void initGPS();
/* End Header */

/* START FUNCTION DESCRIPTION ********************************************
initGPS

SYNTAX:       void initGPS()
KEYWORDS:     gps, initialize
DESCRIPTION:  Initializes the GPS to the desired settings
RETURN VALUE: none

END DESCRIPTION**********************************************************/
void initGPS()
{
   serGPSrdFlush();
   serGPSwrFlush();
	writeGPSString("$PGRMO,GPRMC,2"); //Disable all strings
	writeGPSString("$PGRMO,GPRMC,1");  //enable GPRMC string
   writeGPSString("$PGRMC1,1,1,2,,,,2,W,N,,,,1"); //enable NMEA 0183 2.3
   writeGPSString("$PGRMI,,,,,,,R");
   writeGPSString("$PGRMO,GPGSA,1"); //get sat info
  	printf("using garmin GPS\n");

}

/*** Begin Header writeXBeeString */
void writeXBeeString(char *str);
/*** End Header */


/* START FUNCTION DESCRIPTION ********************************************
writeXBeeString

SYNTAX:       void writeXBeeString(char *str)
KEYWORDS:     xbee, write
DESCRIPTION:  Writes the given string to the xbee
PARAMETER 1:  str -- string to be written to the Xbee
RETURN VALUE: None
END DESCRIPTION**********************************************************/
void writeXBeeString(char *str)
{
 	int len, i;

   len = strlen(str);
   for(i=0;i<len;i++){
      serXbeeputc(str[i]);
   }
   serXbeeputc((char)10); // add the LF character at the end (message term flag)
}
/*** Begin Header setCostates */
void setCostates(sailState *state);
/*** End Header */

/* Initialize Costate data */
   CoData  setTack, averaging,WaypointCheck, maxHeading, maxVelocity, headingControl, UserControl, generate_offset, decide_Strategy, check_speed, tacking, downwind; // costate names



/* START FUNCTION DESCRIPTION ********************************************
setCostates

SYNTAX:       void setCostates(sailState *state)
KEYWORDS:     setCostates, initialize
DESCRIPTION:  This will set the costates to the correct state (pause/resume)
              based on the current control state
PARAMETER 1:  state - sailState struct to update with information

RETURN VALUE: None
END DESCRIPTION**********************************************************/
void setCostates(sailState *state)
{
	switch (state->controlState ){
         	// only control methods remaining on
          	case (USER_CONTROL_MODE):
            	CoPause(&maxHeading);              // disable heading maximizer
               CoPause(&maxVelocity);             // disable velocity maximizer
               CoPause(&headingControl);          // disable heading controller
               CoPause(&setTack);
               CoPause(&averaging);
               CoPause(&WaypointCheck);           // no waypoint info
               CoResume(&UserControl);            // enable user control

               break;
            case( GPS_CONTROL_MODE ):
               CoResume(&maxHeading);             // enable heading maximizer
               CoResume(&maxVelocity);            // enable velocity maximizer
               CoResume(&headingControl);         // enable heading controller
               CoResume(&averaging);
               CoResume(&setTack);
               CoResume(&WaypointCheck);
               CoPause(&UserControl);           // disable user control
               break;
            case( HEADING_CONTROL_MODE):
               CoResume(&headingControl);         // enable heading controller
               CoPause(&maxVelocity);             // enable velocity maximizer
               CoPause(&maxHeading);              // disable heading maximizer
               CoPause(&averaging);
               CoPause(&WaypointCheck);
               CoPause(&UserControl);
               CoResume(&setTack);  //want to be able to tack
               break;
            case( MAX_HEADING_MODE ):
               CoResume(&maxHeading);             // enable heading maximizer
               CoPause(&maxVelocity);            // disable velocity maximizer
               CoResume(&headingControl);         // enable heading controller
               CoResume(&averaging);
               CoResume(&setTack);
               CoResume(&WaypointCheck);
               CoResume(&UserControl);           // enable (debug) user control
               break;
            case( MAX_VELOCITY_MODE):
               CoPause(&maxHeading);             // enable heading maximizer
               CoResume(&maxVelocity);            // disable velocity maximizer
               CoResume(&headingControl);         // enable heading controller
               CoResume(&averaging);
               CoResume(&setTack);
               CoResume(&WaypointCheck);
               CoResume(&UserControl);           // enable (debug) user control
               break;
            default:
               CoPause(&maxHeading);              // disable heading maximizer
               CoPause(&maxVelocity);             // disable velocity maximizer
               CoPause(&headingControl);          // disable heading controller
               CoPause(&setTack);
               CoPause(&averaging);
               CoPause(&WaypointCheck);           // no waypoint info
               CoResume(&UserControl);            // enable user control
               break;
            // IMU case could be added here
	}

}// END setCostates


/*** BEGIN GLOBAL */
GPSPosition GPS_Way[numWayPoints];
/** END */

/*** Begin Header update_Sail_State */
int update_Sail_State(sailState *newstate, char *sentence);
/*** End Header */

/* START FUNCTION DESCRIPTION ********************************************
update_Sail_State

SYNTAX:       int update_Sail_State(sailState *newstate, char *sentence)
KEYWORDS:     sailState
DESCRIPTION:  Updates the new sail state with the given sentence which is
				  assumed to come from our xBee communication
PARAMETER 1:  newstate - sailState struct to update with information
PARAMETER 2:  sentence - recieved radio communication string to parse out
RETURN VALUE: 0 if the message was parsed correctly
				  -1 invalid message
              1 right syntax but unable to parse (should never happen)
END DESCRIPTION**********************************************************/
int update_Sail_State(sailState *newstate, char *sentence)
{
	auto int i, valid;
   auto int angle;
   auto int item;
   float heading;

   //auto char temp[8];
   valid = 0;
   // at a minimum the sentence should have verb, which is 2 characters
   if( strlen(sentence) < 2) {
   	return -1;
      }
   // switch on the types

   switch( sentence[1] )
   {
   case 'A':         								// abort
   	newstate->Abort = 1;
#ifdef _statusChange_
     	printf("Abort loop\n");
#endif
      break;
   case 'R':        									// rudder action
   //if( strncmp(sentence, "R",1) == 0){
       sentence = strchr(sentence,',');
       sentence++;
       angle = atoi(sentence);
       if( angle > newstate->MAX_RUDDER){
        	angle = newstate->MAX_RUDDER;
       }
       else if( angle < newstate->MIN_RUDDER){
        	angle = newstate->MIN_RUDDER;
       }

       newstate->rAngle = angle;
#ifdef _statusChange_
       printf("rAngle: %d\n",newstate->rAngle);
#endif
       break;
   //}
   // sail angle setting
   //else if( sentence[0] == 'S'){
   //else if( strncmp(sentence, "S",1) == 0){
    case 'S':       									// sail 	action
       sentence = strchr(sentence,',');
       sentence++;
       //printf("sentence: %s\n",sentence);
       angle = atoi(sentence);
       if( angle > MAX_SAIL ){
        	angle = MAX_SAIL;
       }
       else if( angle < MIN_SAIL){
        	angle = MIN_SAIL;
       }
       newstate->sAngle = angle;
#ifdef _statusChange_
       printf("sAngle: %d\n",newstate->sAngle);
#endif
       break;
   //}
   case 'G':      									// new GPS state
   //else if( sentence[0] == 'G' ){
   //else if( strncmp(sentence, "G",1) == 0){
       sentence = strchr(sentence,',');
       sentence++;
       newstate->gpsState = atoi(sentence);
#ifdef _statusChange_
       printf("GPS state: %d\n",newstate->gpsState);
#endif
       break;
   case 'E':                                 // edit waypoint
   	// $E,1,7111,2874
      // set waypoint 1
      // lat minutes at 71.11
      // long minutes at 28.74
      //printf("got: %s\n",sentence);
   	sentence = strchr(sentence,',');
      sentence++;
      item = atoi(sentence);
      //printf("item: %d\n",item);
      if (item > numWayPoints){
      #ifdef _statusChange_
      	printf("Not enough Waypoints");
      #endif
         break;
         }
   	sentence = strchr(sentence,',');
      sentence++;
      GPS_Way[item].lat_minutes = atof(sentence);
      //printf("set lat: %f\n",GPS_Way[item].lat_minutes);
   	sentence = strchr(sentence,',');
      sentence++;
      GPS_Way[item].lon_minutes = atof(sentence);
#ifdef _statusChange_
		printf("New Waypoint set");
#endif
      break;
   case 'W':											// identify waypoint
   	sentence = strchr(sentence,',');
      sentence++;
      newstate->Goal = atoi(sentence);			// set the waypoint goal
      break;

   case 'C':       									// control state action
   //reset the control state
      sentence = strchr(sentence,',');
      sentence++;
      newstate->controlState = atoi(sentence);

      setCostates(newstate);  // update costates

#ifdef _statusChange_
      printf("Control State: %d\n",newstate->controlState);
#endif
   	break;

   case 'O':                   					// wind initialize
     newstate->initialize_Wind = 1;     // set flag
#ifdef _statusChange_
     printf("Initialize Wind set \n");
#endif
     break;
   case 'H':											// set heading
   	sentence = strchr(sentence,',');
      sentence++;
      heading=atof(sentence);
      if (heading>360.0) {heading=360.0;}
      else if (heading<0.0) {heading=0.0;}
      newstate->desiredHeading = heading;
#ifdef _statusChange_
	printf("Desired heading set \n");
#endif
		break;
   case 'K':                                  // gain param adjust
   //reset the rudder gain
   	sentence = strchr(sentence,',');
      sentence++;
      newstate->Kri = atof(sentence);

      sentence = strchr(sentence,',');
      sentence++;
      newstate->Krp = atof(sentence);

#ifdef _statusChange_
      printf("KRI: %f, KRP %f\n",newstate->Kri, newstate->Krp);
#endif
		break;
   //}

   case 'T':
      sentence = strchr(sentence,',');
      sentence++;
      newstate->TACK_LENGTH = atof(sentence);
      sentence = strchr(sentence,',');
      sentence++;
      newstate->NO_SAIL = atof(sentence);
      sentence = strchr(sentence,',');
      sentence++;
      newstate->ANG_OFF_WIND = atof(sentence);

      break;
    case 'Z':
    newstate->tackFlag=1;
    #ifdef _statusChange_
      printf("tack flag set\n");
#endif
    break;

   case 'D':
   	sentence = strchr(sentence,',');
      sentence++;
      newstate->SAIL_GRAD_STEP = atof(sentence);
      sentence = strchr(sentence,',');
      sentence++;
      newstate->sailDeadband = atof(sentence);
      sentence = strchr(sentence,',');
      sentence++;
      newstate->HEAD_GRAD_STEP = atof(sentence);
         #ifdef _statusChange_
      printf("sail grad step: %f, sail deadband: %f, heading gradient step: %f\n", newstate->SAIL_GRAD_STEP, newstate->sailDeadband, newstate->HEAD_GRAD_STEP);
#endif
      break;

   case 'F':
   	sentence = strchr(sentence,',');
      sentence++;
      newstate->MIN_RUDDER = atoi(sentence);
      sentence = strchr(sentence,',');
      sentence++;
      newstate->MAX_RUDDER = atoi(sentence);
         #ifdef _statusChange_
      printf("min rudder set: %d, max rudder set: %d \n",newstate->MIN_RUDDER,newstate->MAX_RUDDER);
#endif
      break;

   default:
    	valid = 1;
      break;
   }


   return valid;
}

int parseAddPoints(char *sentence){
			int i, points;
      	// $E,1,7111,2874
     		 // set waypoint 1
     		 // lat minutes at 71.11
     		 // long minutes at 28.74
   			sentence = strchr(sentence,',');
      		sentence++;
      		points = atoi(sentence);
      		if (points > numWayPoints){
      			printf("Not enough Waypoints");
               return -1;
				}
            else{
            	for(i = 0; i < points; i++)
            	{
               sentence = strchr(sentence,',');
      			sentence++;
      			GPS_Way[i].lat_minutes = atof(sentence);
      			//printf("set lat: %f\n",GPS_Way[i].lat_minutes);
   				sentence = strchr(sentence,',');
      			sentence++;
      			GPS_Way[i].lon_minutes = atof(sentence);
               return 0;
            	}
          	}
   }


void main()
{
 // variable initialization
   int i,n,g, temp,points;
   auto int GPSConnectionStatus; // holds a status of GPS connection
   int sail_Flag;
   auto char c;
   int sendMsg;
   auto int nIn;
   auto char cOut,ch;
   GPSPosition GPS_Location;  // current and destination
   auto char sentence[MAX_SENTENCE];
   auto char gpsString[MAX_SENTENCE];
   auto char xBeeString[MAX_SENTENCE];
   auto char xBee_write_buffer[MAX_SENTENCE];
   auto float tempFloat; // temporary float used in true wind calculation
   sailState state;
   velOutput output;


   // maximizing desired heading
   auto int newGPS_FLAG;				// denotes gps data came in valid
   auto int AVE_DONE;					// averaging done flag
   auto float wayBear, wayDist;   		// bearing, distance to waypoint
   auto int p;						// averaging indicies for vmg
   auto float sum_vmg, ave_vmg, pvmg;   // previous vmg
   auto float slope;	 		// improvement on vmg

   // maximizing sail position
   auto float sailSlope;
   auto float sum_vel, ave_vel, velLast;	// previous velocity
   auto int q;			// averaging index for velocity

   //finding true wind direction and position

   auto float histWindD[WIND_HISTORY]; //direction
   auto float histWindS[WIND_HISTORY]; //speed
   auto int rollingPointer; //pointer to location of current last wind point
   auto float windDSum;
   auto float windSSum;

   // heading control variables
   auto float ehead;
   auto int uheadm1;
   auto int uhead;


   auto int rud_stat;		// status return of setting rudder servo
   auto int sail_stat;		// status return of setting the sail servo


   auto int usedXbeeIn; // number of characters in the Xbee in buffer
   auto int usedGPSIn; // number of characters in the GPS in buffer
   auto int reachedGoal; // flag to indicate that we have reached our goal
   auto float currentToGoal; // distance to our current waypoint
   //encoder stuff
   int N2;
   float dt;
   float T0;
   long offset;
   long old_anem_pos;

   //Sailing startegy stuff
   int tack_possible;
   int strategy;
   int loop;
   GPSPosition tackOrigin;
   float bearing;
   int goal_reached;



   GPS_Location.lat_degrees =  latD;
   GPS_Location.lon_degrees = longD;
   GPS_Location.lat_direction = latN;
   GPS_Location.lon_direction = longE;
   GPS_Location.lat_minutes = 42.66947;
   GPS_Location.lon_minutes = 17.76415;
   //occom waypoint
   GPS_Way[0].lat_degrees = latD;
   GPS_Way[0].lon_degrees = longD;
   GPS_Way[0].lat_direction = latN;
   GPS_Way[0].lon_direction = longE;
   GPS_Way[0].lat_minutes = 42.72882;
   GPS_Way[0].lon_minutes = 17.17637;

   GPS_Way[1].lat_degrees = latD;
   GPS_Way[1].lon_degrees = longD;
   GPS_Way[1].lat_direction = latN;
   GPS_Way[1].lon_direction = longE;
   GPS_Way[1].lat_minutes = 42.73626;
   GPS_Way[1].lon_minutes = 17.1867;
   reachedGoal = 0; // set the goal flag to 0


   /*
   // initialize unchanging struct values of waypoints
   for(i = 0; i<numWayPoints; i++)
   {
      GPS_Way[i].lat_degrees = latD;
      GPS_Way[i].lon_degrees = longD;
      GPS_Way[i].lat_direction = latN;
      GPS_Way[i].lon_direction = longE;
      GPS_Way[i].sog = SOG;
      GPS_Way[i].tog = TOG;
   } // end wayload for

   // initialize thayer waypoint  g
   GPS_Way[0].lat_minutes = 740732;
   GPS_Way[0].lon_minutes = 294146;
   */

   // initialize program state
   state.rAngle = 0;                           // degrees
	state.sAngle = 0;                           // degrees
   state.gpsState = GPS_BROADCAST_STATE;        // send raw gps data on xbee
   state.boatState = BROADCAST_STATE;				// set boat status on xbee
   state.controlState = USER_CONTROL_MODE;     // initially in user control
   state.initialize_Wind = 0;                  // initially not initializing
   state.windSet = 0;                          // flag for xBee ack initialy 0
   state.Goal = 0;								// initially look at waypoint 0 - THAYER
   state.Abort = 0;                            // unset abort flag
   GPSConnectionStatus = GPS_INVALID_MESSAGE;  // initially no GPS contact
   state.controlState = USER_CONTROL_MODE;      // initially in user Control
   state.desiredHeading=0;                     // Placeholder
   state.windDir=0;
   state.windVel=0;
   state.tackFlag=0;
   state.SAIL_GRAD_STEP = 0.1; // gradient step amount for sail control
   state.sailDeadband = 0.05; //
   state.HEAD_GRAD_STEP = 0.1; // gradient step amount for heading w/rudders
   state.MIN_RUDDER = -45;
   state.MAX_RUDDER = 45;
   sail_Flag = 0;
   newGPS_FLAG = 0;
   AVE_DONE = 0;
   windDSum = 0; //initial sum for wind direction is 0
   windSSum = 0; //initial sum for wind speed is 0
   rollingPointer = 0; //initial pointer of location is 0
   // zero out history
   for(i =0; i< WIND_HISTORY; i++){
    	histWindD[i] = 0;
      histWindS[i] = 0;

   }

   state.Kri = 0;
   state.Krp = -.6;


   state.NO_SAIL=30.0;
   state.TACK_LENGTH=0.005;
   state.ANG_OFF_WIND=45.0;
   //state.trueDir = 0;
   //state.trueVel = 0;

   state.trueDir = 120;
   state.trueVel = 4;

   brdInit(); /// initialize the board

   // setup Xbee
   serXbeeOpen(BAUD_XBEE);
   serXbeerdFlush();
   serXbeewrFlush();
   serXbeeMode(XBEE_MODE);

   // setup GPS
   serGPSOpen(BAUD_GPS);
   serGPSrdFlush();
   serGPSwrFlush();
   serGPSMode(GPS_MODE);

   //initialize serial data check flags
   usedXbeeIn = -1;
   usedGPSIn = -1;
   memset(&xBeeString,0x00, sizeof(xBeeString));
   // initialize the GPS
   initGPS();

   // initialize the servos
   serServoOpen(19200);
	serServoMode(0);
   initServo();
   uhead = 0;
   uheadm1 = 0;

   //BEGIN Enconder initialization
   N2 = 70;
   dt = ((float)N2)/1024;
 	offset=0;
   encInit();
   offset=getCount(3);
   old_anem_pos=getCount(2);
   // END Encoder

     //Sailing startegy stuff
   tack_possible=0;
   strategy = TACKING;
   loop=1;
   bearing=0;
   goal_reached=0;

  tackOrigin.lat_degrees = 0;
  tackOrigin.lon_degrees = 0;
  tackOrigin.lat_direction = latN ;
  tackOrigin.lon_direction = longE;
  tackOrigin.sog = 0;
  tackOrigin.tog = 0;

  GPS_Location.lat_degrees =  latD;
   GPS_Location.lon_degrees = longD;
   GPS_Location.lat_direction = latN;
   GPS_Location.lon_direction = longE;
   GPS_Location.lat_minutes = 42.66947;
   GPS_Location.lon_minutes = 17.76415;
   GPS_Location.sog = 0;
   GPS_Location.tog = 0;
   //occom waypoint
   GPS_Way[0].lat_degrees = latD;
   GPS_Way[0].lon_degrees = longD;
   GPS_Way[0].lat_direction = latN;
   GPS_Way[0].lon_direction = longE;
   GPS_Way[0].lat_minutes = 42.72882;
   GPS_Way[0].lon_minutes = 17.17637;

   GPS_Way[1].lat_degrees = latD;
   GPS_Way[1].lon_degrees = longD;
   GPS_Way[1].lat_direction = latN;
   GPS_Way[1].lon_direction = longE;
   GPS_Way[1].lat_minutes = 42.73626;
   GPS_Way[1].lon_minutes = 17.1867;

   currentToGoal = gps_ground_distance(&GPS_Way[state.Goal] ,&GPS_Location);
   printGPSPosition(&GPS_Location);
// OUTERMOST WHILE LOOP. THIS WILL ONLY LOOP FORWARD FOR A RESET
while(1){

   /*** START LOOP. WILL WAIT FOR GO COMMAND */
   while(1){
   	costate initcheck always_on
      {
       	waitfor( serXbeerdUsed() > 0);
         DelayMs(20);
         serXbeeRead(xBeeString,2,5);
         //xBeeString[3] = '\0';
          // recieved a 1. This means start the main control loop

#ifdef _debug_

         printf("Xbee Values: %s\n",xBeeString);
#endif
     	 if(strncmp(xBeeString,"1",1) == 0){

				break;
         } // ENDIF
         // loading waypoints
      //else if(&xBeeString[0] == '$' && &xBeeString[1]== 'F' )
      	 else if( strncmp(xBeeString,"$F", 2) == 0)
         {
                	waitfor(DelayMs(100));
                  // wait a long time for points to come in
            		usedXbeeIn = serXbeerdUsed();
            		serXbeeRead(xBeeString,usedXbeeIn, 0);
         			//usedXBeeIn++;
         			xBeeString[usedXbeeIn] = '\0'; // add terminating string
                  parseAddPoints(xBeeString);
         }
         // initialize wind encoder
         else if(strncmp(xBeeString,"$O",2) == 0)
         {

           	offset = getCount(3);   //generates offset
         	state.initialize_Wind = 0;
           #ifdef _printState_
           		printf("offset= %ld",offset);
           #endif
         	writeXBeeString("$S,1");    // send acknowledgements
#ifdef _debug_
         	printf("Wind initialization complete");
#endif
         }
         else{

           serXbeerdFlush();
         }

         }// end costate
         }// end while(1)



   usedXbeeIn = -1;
   usedGPSIn = -1;
     serGPSrdFlush();
   serGPSwrFlush();
#ifdef _debug_
   printf("Begining Control while loop\n");
#endif

   while(1)
   {
		T0 = TICK_TIMER;
      costate stateUpdate init_on
      {
      #ifdef _debug_
         printf("update state\n");
		#endif
      	// update costates
         setCostates(&state);
      }
   	costate checkSerial always_on
      {
         #ifdef _debug_
         printf("check serial\n");
		#endif
      	usedXbeeIn = serXbeerdUsed();
         usedGPSIn  = serGPSrdUsed();
#ifdef _debug_
         if( usedXbeeIn > 0 || usedGPSIn > 0 )
         {
          	printf("usedXbee: %d, usedGPS: %d \n",usedXbeeIn, usedGPSIn);
         }

#endif
      } // end costate


#ifdef _send_xBee_
      costate xBeeWr always_on
      {
          #ifdef _debug_
         printf("xBeeWr \n");
		#endif
      	// wait for a set amount of time between transmissions
         waitfor(DelayMs(TELEMETRY_INTERVAL));
         #ifdef _debug_
         printf("in xbeewr\n");
		#endif
         // GPS state 1 means send GPS data
         if(state.gpsState == GPS_BROADCAST_STATE && GPSConnectionStatus == GPS_VALID){
         	// string
            // $GPS, timestamp, lat minutes, long minutes, sog, tog
         	sprintf(xBee_write_buffer,"$GPS,%s,%f,%f,%f,%f",
                                     GPS_Location.timestamp,
                                     GPS_Location.lat_minutes,
                                     GPS_Location.lon_minutes,
                                     GPS_Location.sog,
                                     GPS_Location.tog);
         	writeXBeeString(xBee_write_buffer);
#ifdef _debugXbee_
      		printf("wrote: %s\n",xBee_write_buffer);
#endif
         }
         // send error message instead of the gps coordinates
         else if(state.gpsState == GPS_BROADCAST_STATE){
         	sprintf(xBee_write_buffer,"$E,%d",GPSConnectionStatus);
            writeXBeeString(xBee_write_buffer);
#ifdef _debugXbee_
      		printf("wrote: %s\n",xBee_write_buffer);
#endif

         }// ENDIF GPS error if
         //waitfor(DelayMs(10));
         waitfor(DelayMs(TELEMETRY_INTERVAL));
         if( state.boatState == BROADCAST_STATE){
          	sprintf(xBee_write_buffer,"$ST,%d,%d,%f,%f,%f,%f,%f",state.rAngle,
                                                     state.sAngle,
                                                     state.desiredHeading,
                                                     state.windDir,
                                                     state.windVel,
                                                     state.trueDir,
                                                     state.trueVel);
            writeXBeeString(xBee_write_buffer);
#ifdef _debugXbee_
      		printf("wrote: %s\n",xBee_write_buffer);
#endif
         }

         if( state.windSet == 1 ){
          	writeXBeeString("$S,1");
            state.windSet = 0;
            CoPause(&generate_offset);    // pause the costate
#ifdef _debugXbee_
      		printf("wrote: $S,1\n");
#endif
         }

         // reached waypoint
         if( reachedGoal == 1){
            sprintf(xBee_write_buffer,"$B,%d",state.Goal-1);
            writeXBeeString(xBee_write_buffer);
            reachedGoal = 0;
         }

      }// END costate xBeeWr
#endif
      costate xBeeRead always_on
      {
          #ifdef _debug_
         printf("xbeeRead\n");
		#endif
      waitfor(usedXbeeIn > 0);// wait for there to be a message in the buffer
      //while(usedXbeeIn<=0) {
      //     #ifdef _debug_
      //   printf("usedXbeeIn = %d\n",usedXbeeIn);
		//#endif
      //yield;
      //}

          #ifdef _debug_
         printf("in xbeerd \n");
		#endif
         // give the message a chance to finish sending
         waitfor(DelayMs(20));
         // read in the entire string
         usedXbeeIn = serXbeerdUsed();
         serXbeeRead(xBeeString,usedXbeeIn, 0);
         //usedXBeeIn++;
         xBeeString[usedXbeeIn] = '\0'; // add terminating string

#ifdef _xBeeDebug_
         printf("Xbee String read in: %s\n",xBeeString);
#endif
         // update the state
        update_Sail_State(&state, xBeeString);
        if (state.Abort == 1)
        {
        		state.Abort = 0; // reset flag
#ifdef _statusChange_
      		printf("Abort executed\n");
#endif
         	break; //exit the loop
        }

        else if (state.initialize_Wind==1)
        {
#ifdef _statusChange_
        	printf("initialize wind\n");
#endif
         CoResume(&generate_offset); //start the initialization costate
        }// ENDIF check if wind is to be initialized
      }// END costate xBeeRead

      costate GPSRead always_on
      {
          #ifdef _debug_
         printf("GPS read\n");
		#endif
         waitfor(usedGPSIn > 0); // wait for msg in buffer
       //    while(usedGPSIn<=0) {
       //    #ifdef _debug_
       //  printf("usefdGPSIn = %d\n",usedXbeeIn);
		//#endif
     // yield;
      //}
        #ifdef _debug_
         printf("in gps read \n");
		#endif
         c = 0;
         while(1)
         {
         	 c = serGPSgetc();
             if( c == -1)
             {
             	serGPSrdFlush();
               abort;
             } // END if
             else if ( c == '$')
             {
             	waitfor(DelayMs(5));  // wait for message to come
               break;
             } //END else if
         }// end while(1)

         // now that some time has passed read in the gps string
         getgps(gpsString);
#ifdef _GPS_Debug_
			printf("gps: %s\n",gpsString);
#endif
			//update our gpsLocation
      	GPSConnectionStatus = gps_get_position(&GPS_Location,gpsString);
         //printf("gps timestamp: %s\n",GPS_Location.timestamp);

         if( GPSConnectionStatus == GPS_VALID)
         {
#ifdef _printState_
         	printGPSPosition(&GPS_Location);
#endif
            //printf("flag high\n");
            newGPS_FLAG = 1;		// set flag denoting new GPS came in valid
         }// END if


      } // END costate GPSRead

      costate get_wind always_on
      {
       #ifdef _debug_
         printf("get wind\n");
		#endif
      //T0=TICK_TIMER;
      state.windDir=getWindPos(offset);

      output=getWindVel(dt,old_anem_pos);
      old_anem_pos=output.old_anem_pos_st;
		state.windVel=output.velocity;
#ifdef _debugWindReadings_
      printf("Measured WindVel: %f, WindDir: %f\n",state.windVel,state.windDir);
#endif


     }  // END get_wind costate

      costate generate_offset always_on
      {
          #ifdef _debug_
         printf("gen offset\n");
		#endif
         waitfor(state.initialize_Wind==1);
         offset = getCount(3);   //generates offset
         state.initialize_Wind = 0;
         state.windSet = 1; // set flag for xBee ack
#ifdef _debug_
         printf("Wind initialization complete");
#endif

      } // END generate_offset costate

      costate averaging always_on
      {
          #ifdef _debug_
         printf("averaging\n");
		#endif
         for (q=0; q<aveNum; q++)
         {
         waitfor(newGPS_FLAG == 1);
         //printf("q = %d",q);
         sum_vel += GPS_Location.sog;	// sum aveNum speeds then average
         wayBear = gps_bearing2(&GPS_Way[state.Goal], &GPS_Location);	// bearing to waypoint
         sum_vmg += GPS_Location.sog*cos(rad(wayBear));  // vmg toward waypoint
         newGPS_FLAG = 0;
         yield;
         }
         AVE_DONE = 1;
      }	// end averaging costate


      costate maxHeading always_on
      {
       #ifdef _debug_
         printf("maxHeading\n");
		#endif
       waitfor(AVE_DONE == 1);
		 ave_vmg = sum_vmg/aveNum;
		 slope = (ave_vmg - pvmg)*1024/N2;    // improvement on vmg over loop time
         // take a step in appropriate heading change
         //state.desiredHeading = (1 + HEAD_GRAD_STEP*slope)*state.desiredHeading;
         state.desiredHeading = state.desiredHeading + state.HEAD_GRAD_STEP*slope;
         pvmg = ave_vmg;
#ifdef _bearingPrint_
         printf("bearing: %f, vmg: %f, pvmg: %f, slope: %f, desired Heading: %f\n",wayBear,ave_vmg,pvmg,slope,state.desiredHeading);
#endif
         AVE_DONE = 0;

      }// END costate maxHeading



       costate maxVelocity always_on
      {
         waitfor(AVE_DONE == 1);
         ave_vel = sum_vel/aveNum;
			sailSlope = ave_vel - velLast;
        if (sailSlope > -state.sailDeadband && sailSlope < state.sailDeadband)
             {}  // if within band of zero, do nothing
      	else
         	{
            state.sAngle = (int) (state.sAngle + sailSlope*state.SAIL_GRAD_STEP);
            sail_stat = setServoPosition(SAIL,state.sAngle,&state);
            }
         velLast = ave_vel;
			AVE_DONE = 0;
#ifdef _sailPrint_
		printf("ave_vel: %f, velLast %f, sailSlope %f\n",ave_vel,velLast,sailSlope);
#endif
      }// END costate maxVelocity

      costate headingControl always_on
      {
          #ifdef _debug_
         printf("heading control\n");
		#endif
		ehead = state.desiredHeading - GPS_Location.tog;
        //ehead=state.desiredHeading-state.windDir;
        if(ehead<-180.0)
        {
        ehead=(360+ehead);
        }
        else if (ehead>180.0)  {
        ehead=-(360-ehead);
        }
         // u/e = k1/(z-1)
         // uk = ukm1*ki - ek*kp
         uhead = (int)(state.Kri*uheadm1 - ehead*state.Krp);
         uheadm1 = uhead;
         state.rAngle = uhead; // keep track of rudder angle
         rud_stat = setServoPosition(RUDDER, uhead, &state);
#ifdef _debugHeadingControl_
         //printf("des: %f , tog %f, ehead: %f, uheadm1: %d, rud_stat: %d\n",state.desiredHeading,state.windDir,ehead,uhead,rud_stat);
         printf("des: %f , tog %f, ehead: %f, KRP: %f ,uhead: %d, rud_stat: %d\n",state.desiredHeading,GPS_Location.tog,ehead,state.Krp,uhead,rud_stat);

#endif

         //printf("headingcontrol\n");

      }// END costate headingControl

      costate WaypointCheck always_on
      {
         #ifdef _debug_
         printf("waypoint check\n");
		#endif
        	waitfor(DelayMs(1000)); // only run once a second
         //printf("waypointCheck\n");
         if( currentToGoal < WAYPOINT_RADIUS ){
         	reachedGoal = 1; // set notification flag
          	state.Goal ++;   // iterate to next waypoint
            //check to see if we have reached the end
            if( state.Goal > numWayPoints){
             	state.Goal = 0; //return to begining
            }
         }
         // we have not reached our goal find our new distance
         else
         {
          	currentToGoal = gps_ground_distance(&GPS_Way[state.Goal] ,&GPS_Location);
         }

      }// END WaypointCheck

      costate UserControl always_on
      {
          #ifdef _debug_
         printf("userControl\n");
		#endif
        //	waitfor(DelayMs(100));
       rud_stat = setServoPosition(RUDDER,state.rAngle, &state);
       sail_stat = setServoPosition(SAIL,state.sAngle, &state);
#ifdef _printState_
      printSailState(&state);
      //printf("user status \tRUDDER: %d\tSAIL: %d\n",rud_stat,sail_stat);
#endif

      }// END UserControl

  /*
      costate check_speed always_on
      {
          #ifdef _debug_
         printf("check_speed\n");
		#endif
         waitfor(newGPS_FLAG==1 && GPSConnectionStatus == GPS_VALID); //Wait for a new message, then re-evaluate

         //If the boat is moving faster than TACK_SPEED, set the tack_possible flag to true
         if (GPS_Location.sog>TACK_SPEED){
         	tack_possible=1;
         }
         else
         {
        	 tack_possible=0;
         }

      } // end check_speed costate
      /*-----------------------------------------------------------*/


     costate setTack always_on
     {
      #ifdef _debug_
         printf("set tack\n");
		#endif
     #ifdef _debugWind_
      printf("end tack, waiting for tack flag \n",bearing);
      #endif
       waitfor(state.tackFlag==1);
       state.tackFlag=0;
		  bearing=gps_bearing2(&GPS_Location,&GPS_Way[state.Goal]);	// set the bearing to waypoint
         #ifdef _debugWind_
      printf("bearing is %f\n",bearing);
      #endif
         if (bearing>state.trueDir || bearing<(state.trueDir-180))
         {//head right of wind
				state.desiredHeading=state.trueDir+state.ANG_OFF_WIND;

			}
			else
			{ //head left of wind
				state.desiredHeading=state.trueDir-state.ANG_OFF_WIND;
			}
         if (state.desiredHeading>360)
         {
            state.desiredHeading=state.desiredHeading-360;
         }
     #ifdef _debugWind_
      printf("begin tack to %f\n",state.desiredHeading);
      #endif
      waitfor(ehead<HEADING_ERROR);




     }
      costate windCalc always_on
      {
          #ifdef _debug_
         printf("wind calc\n");
		#endif
        //state.trueDir=0;
        //state.trueVel=0;
        //printGPSPosition(&GPS_Location);
        windDSum -= histWindD[rollingPointer];
        //calculate true wind


   	  windSSum -=  histWindS[rollingPointer];
        //calculate true wind speed
        //tempFloat = pow(state.windVel,2.0);

        //windSSum += sqrt(pow(state.windVel,2.0)+ pow(GPS_Location.sog,2.0) + 2.0*state.windVel*GPS_Location.sog);
        histWindS[rollingPointer] = sqrt(pow(state.windVel,2.0)+ pow(GPS_Location.sog,2.0) + 2.0*state.windVel*GPS_Location.sog*cos(rad(state.windDir)));//insert true wind calc

        windSSum += histWindS[rollingPointer];
        state.trueVel = windSSum/WIND_HISTORY;


        tempFloat = (state.windVel*cos(rad(state.windDir))-GPS_Location.sog)/(state.trueVel);
        if( tempFloat > 1 || tempFloat < 1){
#ifdef _debugWind_
 				printf("Bad wind calculation\n");
            printGPSPosition(&GPS_Location);
#endif
				histWindD[rollingPointer] = state.windDir;
            windDSum += histWindD[rollingPointer]; // just to not have everything blow up
        }
        else
        {
        		histWindD[rollingPointer] = GPS_Location.tog + deg(acos(tempFloat));
        		windDSum += histWindD[rollingPointer];
        }
        state.trueDir = windDSum/WIND_HISTORY;


#ifdef _debugWind_
        printf("trueVel: %f, trueDir: %f\n",state.trueDir,state.trueVel);
#endif
		  rollingPointer++;
   	  if( rollingPointer == WIND_HISTORY ){
         	rollingPointer = 0;
         }

      }


     	//set loop length
#ifdef _debug_
      if( (TICK_TIMER - T0) > N2)
		{
      		printf("overrun sampling time\n");
     	}
#endif

		while((TICK_TIMER-T0)<=N2){}
   }// END costate while(1)
   }// END far outside while(1) loop
   return;
}// END main loop