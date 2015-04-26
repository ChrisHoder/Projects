// Modified + Working code 5/26/2011
// Modified again on 5/17/2011
// Modifying Working code on 5/12/2011
// Kevin Olds Spring 2008
// Eric Trautmann Edits, Fall 2008
//    added: Encoder Board interface code
// Suk Joon Lee Edits, Spring 2011
//    disabled Encoder Board interface code
//    edited bearing control equation (desired w eqn) to PI control
//    prevent opposite rotation of motors in setVel
//    added instrument package communication code
//J.Lever edits, fall 2011 for SPole GPR survey
//		begin with YETI_MCMURDO_V1_15
//		implement short stop at each waypoint to delineate GPR tracks
//J.Lever edits winter 2012 for GrIT GPR survey
//		re-zero error_integral at each waypoint (was commented out)
//		print to logfile the gps waypoint list received via radio
//		add extra delay for radio input (2 s) if receiving long waypoint list

// Code to run Yeti autonomous robot with rabbit BL2600 microprocesser.

//comment out to disable debugging
//#define _debug_
//#define _debug_GPS_
//#define _debug_GPS_fine_
#define _debug_bearing_
#define _send_telemetry_

//#use GPS3.lib        //Luke's GPS library
#use GPS4.lib
#use ENCODER.lib     //Kevin's Encoder library
#use ROBOMATH.lib    //Kevin's Math helper functions

// serial baud rate for XTend 900MHz modems
/*#define BAUDR1 115200 //RS232 for 1st radio modem (connection b/w robot and user)
#define BAUDGPS 115200 //RS232 for GPS
#define BAUDR2 115200 //RS232 for 2nd radio modem (connection b/w robot and instrument package)*/
//#define BAUDLOG 115200 // RS232 for datalogger (disabled in this version)

// serial baud rate for XSTream 2.4GHz modems
#define BAUDR1 19200
#define BAUDGPS 115200
#define BAUDR2 19200

// serial buffer configuration
#define CINBUFSIZE  4095         //radio comms
#define COUTBUFSIZE 511
#define FINBUFSIZE  511
#define FOUTBUFSIZE 511
#define EINBUFSIZE  4095
#define EOUTBUFSIZE 511

#define USER_CONTROL_MODE 0
#define GPS_CONTROL_MODE 1
#define ESCAPE_CONTROL_MODE 2
#define ESCAPE_CONFIRM_MODE 3
#define INSTRUMENT_MODE 4//temporary stopping mode for instrument

#define MOBILE 0
#define ALMOST_IMMOBILIZED 1
#define IMMOBILIZED 2

#define CLASSIFICATION_OFF 0
#define CLASSIFICATION_ON 1
, 
#define OBSTACLE_0 0
#define OBSTACLE_1 1
#define OBSTACLE_2 2

#define AUTONOMOUS_SPEED 1200 //changed from 1500 to 1200
#define AUTONOMOUS_SPEED_SLOW 700
#define WAYPOINT_RADIUS .005
//#define MAXW 500 //MAXW = 2048 - AUTONOMOUS_SPEED

// function prototypes
void setVel(int v,int w);

//robot control mode (user control, autonomous gps control, escape sequence control)
char controlMode;
char robotMobility;
char classificationMode;
char obstacleType;
// stopping mode: 0=no stopping, 1=stop at each waypoint, 2=stop
char stoppingMode;

// current linear speed and differential (turning) speed
int currentV;
int currentW;

// desired linear speed and differential (turning) speed
int desiredV;
int desiredW;

//Maximum diffrential speed
int MAXW;

// holds the GPS way points that get sent to the robot
// make pointer and assign pointer to array later when array size is determined
GPSPosition WayPoints[250];

// satellite info
gps_sat Satellite;
// number of available satellite
int num_sat;
// latest GPS position robot has
GPSPosition CurrentGPS;
// previous GPS position robot was in
GPSPosition LastGPS;
// the goal GPS position (the next waypoint)
GPSPosition Goal;
// Goal in polar coordinates from current position
Polar GoalPos;
// Current position in polar coordinates from lat position
Polar CurPol;
// Current position in cartesian coordinates from last position
Cart CurCart;

// the error in the bearing of the robot from the bearing to the next way point
float error, error2;
float last_error;
// intergral of error to perform PI control
float error_integral;
// time stamp for error integration
unsigned long int last_time;
// time interval for error integration
float deltat;
// coefficient for PI control
float P_coeff, I_coeff, loop_gain;
// time stamp for telmetry
float telemetry_time;
unsigned long int loop_time;
// whehter coordinates are received or not
int coords_received;


main()
{
   char radioOutput[511];
   // buffer to read the radio input from user laptop
   char radioInput[CINBUFSIZE];
   char radioOutput2[511];
   // buffer to read the radio input from instrument laptop
   char radioInput2[EINBUFSIZE];
   // buffer to output encoder info
   char enc_data[70];
   // buffer to relay data from the datalogger through to the radio
   char loggerInput[EINBUFSIZE+2];
   char yetiState[10];
   char axis_1[20];
   char axis_2[20];
   char axis_3[20];
   char axis_4[20];
   char temp[3];
   // whether the robot has gotten a ping recently or not
   char ping;
   // the number of waypoints the robot has
   int numWayPoints;
   // the current waypoint the robot is on
   char curWayPoint;
   // interval(sec) b/w telemtry broacastings from the robot to user and to instrument
   char telemetryInterval;
   // whether gps string is valid or not
   int valid_gps;

   // whether gps navigation is engaged or not
   char engageGPSnav;
   // how many bytes in the serial buffer are used
   int used;
   int usedE;
   // int for indexing loops
   int i;
   // requested linear and angular velocites of robot from java
   int v;
   int w;
   // updated linear and angular velocites
   int newV;
   int newW;
   // difference between current and desired linear and angular velocites
   int vDiff;
   int wDiff;
   // how many characters of a gps string have been read in so far
   int charCounter;
   // character read in off the serial port (look at serFgetc() to see why it is
   // an int
   int c;
   // holds a gps string after reading it in
   char gpsString[85];
   // stopping interval for data collection in seconds
   int resting_interval;

   // int to keep track of if this is the first run of the program or not
   int helpLast,helpLast2;

   //Encoder Sending code
   int j;
   int delayvar;
   int asb, bsb, csb;
   long position, asb_l, bsb_l, csb_l;

   float currentToGoal; //distance between current position and goal
   float originToCurrent; //distance between origin to current position
   float bearingToGoal; //bearing from current position to goal in degree
   float bearingToCurrent; //bearing from origin to current position in degree

   float INTEGRALMAX; //maximum that integral can get

   float deltaloop;

   int flag; //flag for restoring yeti to GPS navigation automatically
   int flag2; //flag for changing last gps coordinate

   // initialize hardware
   brdInit();

   LastGPS.lat_degrees = 72;
   LastGPS.lat_minutes = 32.123;
   LastGPS.lon_degrees = 17;
   LastGPS.lon_minutes = 42.232;

   CurrentGPS.lat_degrees = 72;
   CurrentGPS.lat_minutes = 32.200;
   CurrentGPS.lon_degrees = 17;
   CurrentGPS.lon_minutes = 42.232;

   Goal.lat_degrees = 72;
   Goal.lat_minutes = 33.200;
   Goal.lon_degrees = 17;
   Goal.lon_minutes = 43.500;

   GoalPos = getPol(getCart(&CurrentGPS,&Goal));
	bearingToGoal = gps_bearing2(&CurrentGPS, &Goal);
   CurCart = getCart(&LastGPS,&CurrentGPS);
   CurPol = getPol(CurCart);
	bearingToCurrent = gps_bearing2(&LastGPS,&CurrentGPS);
	error = bearRange(CurPol.t-GoalPos.t);
	error2 = bearRange((bearingToCurrent-bearingToGoal)*PI/180.0);

   printf("%f, %f\n",bearingToCurrent,bearingToGoal);
   printf("error:%f,   error2:%f\n",error,error2);

   //digOutConfig(DIGOUTCONFIG);
   digOutConfig(0xff00);
   //digHoutConfig(0x07);        // Set Hout0 Sinking
   digHTriStateConfig(0x06);  // Set Hout1 & Hout2 for Tristate
   //initialize Encoder Board
   initEncoder();

   //initialize state machine flags
   controlMode = USER_CONTROL_MODE;
   robotMobility = MOBILE;
   classificationMode = CLASSIFICATION_OFF;
   obstacleType = OBSTACLE_1;

   // open 2 radio serial ports and gps serial ports
   serCopen(BAUDR1);
   serFopen(BAUDGPS);
   serEopen(BAUDR2);
   //serEopen(BAUDLOG);

   //disable motor controllers
   //digHout(0,0);
   digHoutTriState(1,0);

   // set wheel velocities to 0
   anaOutConfig(1,1);
   anaOutPwr(1);
   anaOutVolts(0,0);
   anaOutVolts(1,0);
   anaOutVolts(2,0);
   anaOutVolts(3,0);
   anaOutStrobe();

   // set serial port mode
   serMode(0);
   // initialize variables
   ping = 1;
   numWayPoints = 0;
   coords_received = 0;
   //engageGPSnav = 0;     //remove
   curWayPoint = 0;
   currentV = 0;
   currentW = 0;
   desiredV = 0;
   desiredW = 0;
   helpLast = 0;
   helpLast2 = 0;

   // intialize WMAX so that Vmin > Vmax / 4 (preventing robot from turning in circle)
   MAXW = min(2000 - AUTONOMOUS_SPEED, AUTONOMOUS_SPEED);
   if((AUTONOMOUS_SPEED+MAXW)/4 > AUTONOMOUS_SPEED-MAXW)
   	MAXW = 3*AUTONOMOUS_SPEED/5;
   printf("MAXW : %d\n",MAXW);

   telemetryInterval = 1; //default telemetry broadcasting interval = 1 sec

   //controller coefficients
   P_coeff = .30;                   //starting point .30
   I_coeff = .002;          //starting point .002
   loop_gain = 714;                 //starting point 714
   INTEGRALMAX = (float)MAXW / loop_gain / I_coeff / 2.0; //integral effort max = 1/2 speed differential

   // clear any junk out of serial ports
   serFrdFlush();
   serCrdFlush();
   serErdFlush();

   sprintf(radioOutput, "Waypoints not received, %s", gpsString);

   // error integration initialization
   last_error = 0;
   error_integral = 0;
   error = 0;
   error2 = 0;
   last_time = TICK_TIMER;
   deltat = 0;

   // stopping at each waypoint as a default setting
   stoppingMode = 1;
   resting_interval = 0;

   // initialize distance and bearing
   originToCurrent = 0;
   currentToGoal = 0;
   bearingToGoal = 0;
   bearingToCurrent =0;

   loop_time = TICK_TIMER;

   flag=0;
   flag2=0;
   valid_gps=-1;

   // main while loop
   while(1)
   {
      deltaloop = (float)(TICK_TIMER-loop_time)/1024;
      loop_time = TICK_TIMER;

      //Test if Serial ports have input
      costate
      {
         used = serCrdUsed();       //bytes being used in serial buffer for radio communication port1
         usedE = serErdUsed();      //bytes being used in serial buffer for radio communication port2 or data logger
      }

      // sending data from robot to user computer
#ifdef _send_telemetry_
      costate sendTelemetry always_on
      {
         waitfor(DelaySec(telemetryInterval));

         sprintf(radioOutput,"valid GPS: %d, ",valid_gps);
         serCputs(radioOutput);
         DelayMs(35);

         /*sprintf(radioOutput,"current GPS: %d,%f,%d,%f,*", CurrentGPS.lat_degrees, CurrentGPS.lat_minutes, CurrentGPS.lon_degrees, CurrentGPS.lon_minutes);
         serCputs(radioOutput);
         DelayMs(35);

         sprintf(radioOutput,"coord GPS: %d,%f,%d,%f,*", WayPoints[0].lat_degrees, WayPoints[0].lat_minutes, WayPoints[0].lon_degrees, WayPoints[0].lon_minutes);
         serCputs(radioOutput);
         DelayMs(35);*/

         sprintf(radioOutput,"errors: %f,%f, deltat: %f, ",error,error2,deltat);
         serCputs(radioOutput);
         DelayMs(35);

         sprintf(radioOutput,"integral term: %f, w:%d, ",I_coeff*error_integral*loop_gain,currentW);
         serCputs(radioOutput);
         DelayMs(35);

         sprintf(radioOutput,"dis: %f,%f,*",currentToGoal,GoalPos.r);
         serCputs(radioOutput);
         DelayMs(35);

         /*DelayMs(35);
         sprintf(radioOutput2,"loop:%f,*",deltaloop);
         serCputs(radioOutput2);*/

         sprintf(radioOutput,"%d,%f,%d,%f,", CurrentGPS.lat_degrees, CurrentGPS.lat_minutes, CurrentGPS.lon_degrees, CurrentGPS.lon_minutes);
         serCputs(radioOutput);
         DelayMs(35);
         sprintf(radioOutput,"%d,%d,%d,",currentV,currentW,controlMode);
         serCputs(radioOutput);
         DelayMs(35);
         sprintf(radioOutput,"%d,%f,%d,%f,*", Goal.lat_degrees, Goal.lat_minutes, Goal.lon_degrees, Goal.lon_minutes);
         serCputs(radioOutput);
      }
      costate sendTelemetry2 always_on
      {
         waitfor(DelaySec(telemetryInterval));

         //send current moving status of robot to instrument package laptop
         sprintf(radioOutput2,"%d,%f,%d,%f,", CurrentGPS.lat_degrees, CurrentGPS.lat_minutes, CurrentGPS.lon_degrees, CurrentGPS.lon_minutes);
         serEputs(radioOutput2);

         DelayMs(35);
         sprintf(radioOutput2,"%d,%d,%d,*",currentV,currentW,controlMode);
         serEputs(radioOutput2);

         DelayMs(35);
         sprintf(radioOutput2,"stopmode: %d, controlmode: %d,*",stoppingMode, controlMode);
         serEputs(radioOutput2);
      }
#endif

      //***********************************************************************************
      // serial message interpretation costate
      costate serialIn always_on
      {
         // wait until a message comes
         waitfor(used > 0);

         // give the message a chance to finish sending
         waitfor(DelayMs(100));
         if(used > 100) waitfor(DelaySec(2)); //increase in case receiving long waypoint list
         used = serCrdUsed();
         serCread(radioInput,used, 2);
         radioInput[used] = '\0';      //terminate string

         // since a message came, we know we are in radio contact
         ping = 1;
         serCrdFlush();

         //remote control mode
         // [zeros] [v byte 1] [v byte 2] [w byte 1] [w byte 2]
         if(radioInput[0] == 0)
         {
            // recieve a remote control driving command
            //engageGPSnav = 0;       //remove
            if (controlMode != ESCAPE_CONTROL_MODE)
            {
               controlMode = USER_CONTROL_MODE;
               error_integral = 0;
               last_time = TICK_TIMER;

               v = (int)radioInput[2]<<8; 
               desiredV = v+radioInput[1];
               w = (int)radioInput[4]<<8;
               desiredW = w+radioInput[3];
#ifdef _debug_
               printf("command\n");
#endif
            }
         }

         else if (radioInput[0] == 1) //receiving gps waypoint list
         {
            // load in gps coordinates
            // convention N = +lat_deg +lat_min, W = +long_deg +long_min
            //				  S = -lat_deg -lat_min, E = -long_deg -long_min
            if(radioInput[1] > 180){
               numWayPoints = 180;
            }
            else if(radioInput[1] >0){
               numWayPoints = (int)(radioInput[1]);
            }
            else{
               numWayPoints = 0;
            }

            for(i = 0;i<numWayPoints;i++)
            {
               WayPoints[i].lat_degrees = CtoI(radioInput[2+i*12],radioInput[2+i*12+1]);
               WayPoints[i].lat_minutes = CtoF(radioInput[2+i*12+2],radioInput[2+i*12+3],radioInput[2+i*12+4],radioInput[2+i*12+5]);
               WayPoints[i].lon_degrees = CtoI(radioInput[2+i*12+6],radioInput[2+i*12+7]);
               WayPoints[i].lon_minutes = CtoF(radioInput[2+i*12+8],radioInput[2+i*12+9],radioInput[2+i*12+10],radioInput[2+i*12+11]);

               DelayMs(35);   //print waypoint list to logfile
               sprintf(radioOutput,"waypoint,%d,%d,%f,%d,%f,*",i,WayPoints[i].lat_degrees,WayPoints[i].lat_minutes,WayPoints[i].lon_degrees,WayPoints[i].lon_minutes);
               serCputs(radioOutput);
            }
            curWayPoint = 0;
            Goal = WayPoints[0];

            if (numWayPoints > 0){
               coords_received  = 1;
            }

            DelayMs(35);
            sprintf(radioOutput,"coords loaded,%d,*",numWayPoints);
            serCputs(radioOutput);
            //DelayMs(35);
            //sprintf(radioOutput,"1st pos: %d,%f,%d,%f,*", Goal.lat_degrees, Goal.lat_minutes, Goal.lon_degrees, Goal.lon_minutes);
            //serCputs(radioOutput);

#ifdef _debug_
            printf("load coord\n");
#endif
         }

         else if (radioInput[0] == 3)
         {
            // engage GPS navigation system
            if (numWayPoints>0){
               controlMode = GPS_CONTROL_MODE;
               error_integral = 0;
               last_time = TICK_TIMER;
               helpLast =0;
               helpLast2 = 0;
               originToCurrent = 0;
               currentToGoal = 999999;

               sprintf(radioOutput,"GPS mode started,*",numWayPoints);
               serCputs(radioOutput);
            }
#ifdef _debug_
            printf("GPS\n");
#endif
         }

         else if (radioInput[0] == 4)
         {
            //set the interval for telemetry broadcasting
            telemetryInterval = radioInput[1];
         }
         // {
            // // set the current waypoint the robot is heading for
            // if ((radioInput[1] <= numWayPoints) && (radioInput[1] > 0))
            // curWayPoint = radioInput[1]-1;
         // }
         // Signal to test escape sequences and re-routing

         // Emergency Stop the robot if Escape Mode is enabled
         else if (radioInput[0] == 6)
         {
            controlMode = USER_CONTROL_MODE;
#ifdef _debug_
            printf("E-stop\n");
#endif
            desiredV = 0;
            desiredW = 0;

            sprintf(radioOutput,"User Control Mode,*");
            serCputs(radioOutput);
         }

         // Toggle Classification mode
         else if (radioInput[0] == 7)
         {
            if (classificationMode == CLASSIFICATION_OFF)
            {
#ifdef _debug_
               printf("Classification on\n");
#endif
               classificationMode = CLASSIFICATION_ON;
            }
            else
            {
#ifdef _debug_
               printf("Classification off\n");
#endif
               classificationMode = CLASSIFICATION_OFF;
            }
         }

         //change controller coefficients
         else if (radioInput[0] == 8)
         {
            P_coeff = CtoF(radioInput[1],radioInput[2],radioInput[3],radioInput[4]);
            I_coeff = CtoF(radioInput[5],radioInput[6],radioInput[7],radioInput[8]);
            loop_gain = CtoF(radioInput[9],radioInput[10],radioInput[11],radioInput[12]);

            INTEGRALMAX = (float)MAXW / loop_gain / I_coeff / 2.0;

            DelayMs(35);
            sprintf(radioOutput,"Coefficients loaded,*");
            serCputs(radioOutput);
         }
      }

      //this costate controls state update for the control mode.  State transitions
      //can also take place within functions, but where it doesn't make sense make
      //those transitions within a function it is taken care of here.

      /*costate controlModeUpdate always_on
      {
         if ((controlMode == GPS_CONTROL_MODE)&&(robotMobility == IMMOBILIZED))
         {
            controlMode = ESCAPE_CONTROL_MODE;
            printf("escape control set\n");
         }
      }
      */

      //***********************************************************************************
      // serial message interpretation costate for instrument package communication
      costate serial2In always_on
      {
         // wait until a message comes
         waitfor(usedE > 0);

         // give the message a chance to finish sending
         waitfor(DelayMs(100));
         usedE = serErdUsed();
         serEread(radioInput2,usedE, 2);
         radioInput2[usedE] = '\0';    //terminate string

         serErdFlush();

         if(radioInput2[0] == 0)
         {
            // recieve a remote control driving command
            //engageGPSnav = 0;       //remove
            if (controlMode != ESCAPE_CONTROL_MODE)
            {
               controlMode = USER_CONTROL_MODE;
               error_integral = 0;
               last_time = TICK_TIMER;

               v = (int)radioInput2[2]<<8;
               desiredV = v+radioInput2[1];
               w = (int)radioInput2[4]<<8;
               desiredW = w+radioInput2[3];
#ifdef _debug_
               printf("command\n");
#endif
            }
         }

         else if (radioInput2[0] == 1) //Set autonomous mode
         {
            // load in gps coordinates
            // [1] [lattitude degrees int byte 1] [longitutde degrees int byte 2]...
            if(radioInput2[1] > 180){
               numWayPoints = 180;
            }
            else if(radioInput2[1] >0){
               numWayPoints = (int)(radioInput2[1]);
            }
            else{
               numWayPoints =0;
            }

            for(i = 0;i<numWayPoints;i++)
            {
               WayPoints[i].lat_degrees = CtoI(radioInput2[2+i*12],radioInput2[2+i*12+1]);
               WayPoints[i].lat_minutes = CtoF(radioInput2[2+i*12+2],radioInput2[2+i*12+3],radioInput2[2+i*12+4],radioInput2[2+i*12+5]);
               WayPoints[i].lon_degrees = CtoI(radioInput2[2+i*12+6],radioInput2[2+i*12+7]);
               WayPoints[i].lon_minutes = CtoF(radioInput2[2+i*12+8],radioInput2[2+i*12+9],radioInput2[2+i*12+10],radioInput2[2+i*12+11]);
            }

            curWayPoint = 0;
            Goal = WayPoints[0];
            if (numWayPoints > 0)
               coords_received=1;

            sprintf(radioOutput2,"numway: %d,*",radioInput2[1]);
            serEputs(radioOutput2);
            sprintf(radioOutput2,"coords loaded,*");
            serEputs(radioOutput2);

#ifdef _debug_
            printf("load coord\n");
#endif
         }

         else if (radioInput2[0] == 3)
         {
            // engage GPS navigation system
            if (numWayPoints>0){
               controlMode = GPS_CONTROL_MODE;
               error_integral = 0;
               last_time = TICK_TIMER;
               helpLast =0;
               helpLast2 = 0;
               originToCurrent = 0;
               currentToGoal = 999999;

               sprintf(radioOutput2,"GPS Mode,*");
               serEputs(radioOutput2);
            }

            //engageGPSnav = 1;    //remove
#ifdef _debug_
            printf("GPS\n");
#endif
         }

         else if (radioInput2[0] == 4)
         {
            //set the interval for telemetry broadcasting
            telemetryInterval = radioInput2[1];
         }

         // Signal to test escape sequences and re-routing
         // Emergency Stop the robot if Escape Mode is enabled

         else if (radioInput2[0] == 6)
         {
            controlMode = USER_CONTROL_MODE;
#ifdef _debug_
            printf("E-stop\n");
#endif
            desiredV = 0;
            desiredW = 0;

            sprintf(radioOutput2,"User Control Mode,*");
            serEputs(radioOutput2);
         }

         else if (radioInput2[0] == 8)
         {
            P_coeff = CtoF(radioInput2[1],radioInput2[2],radioInput2[3],radioInput2[4]);
            I_coeff = CtoF(radioInput2[5],radioInput2[6],radioInput2[7],radioInput2[8]);
            loop_gain = CtoF(radioInput2[9],radioInput2[10],radioInput2[11],radioInput2[12]);

            INTEGRALMAX = (float)MAXW / loop_gain / I_coeff / 2.0;

            sprintf(radioOutput2,"coefficients loaded,*");
            serEputs(radioOutput2);
         }

         // restore control mode to GPS control mode from Instrument mode
         else if(radioInput2[0] == 9 && controlMode == INSTRUMENT_MODE)
         {
            controlMode = GPS_CONTROL_MODE;
            last_time = TICK_TIMER;

            desiredW = 0;
            desiredV = AUTONOMOUS_SPEED;
            //DelaySec(2);
         }

         // stop for each waypoint for X seconds
         else if(radioInput2[0] == 10)
         {
            sprintf(radioOutput2,"command 10,*");
            serEputs(radioOutput2);

            stoppingMode = 1;
            resting_interval = CtoI(radioInput2[1],radioInput2[2]);
         }

         // stop the robot for X seconds right now
         else if(radioInput2[0] == 11)
         {
            stoppingMode = 2;
            resting_interval = CtoI(radioInput2[1],radioInput2[2]);
            controlMode = INSTRUMENT_MODE;
            desiredV = 0;
            desiredW = 0;
         }

         // restore stopping mode to 0 (non-stoppig mode)
         else if(radioInput2[0] == 12)
         {
            stoppingMode = 0;
         }
      }

      //***********************************************************************************
      //if no moving signal from instrument laptop is received for designated resting interval + 2sec
      //assume connection with instrument laptop is broken and go back to autonomous mode
      costate monitorStop always_on
      {
         if(stoppingMode != 0 && controlMode == INSTRUMENT_MODE && currentV==0 && curWayPoint < numWayPoints){
            waitfor(DelaySec(resting_interval+2)); //2 sec delay in addition to resting_interval

            if(controlMode == INSTRUMENT_MODE){
               //stoppingMode = 0;  //9-13-11 retain stop at each waypoint
               controlMode = GPS_CONTROL_MODE;
            	last_time = TICK_TIMER;
            	desiredW = 0;
            	desiredV = AUTONOMOUS_SPEED;
            }
         }
      }

      //***********************************************************************************
#ifdef _debug_
      costate debugHelp always_on
      {
         waitfor(DelayMs(1000));
         {
            switch(controlMode){
               case(USER_CONTROL_MODE):
               printf("user control,   ");
               break;
               case(GPS_CONTROL_MODE):
               printf("gps control,    ");
               break;
               case(ESCAPE_CONTROL_MODE):
               printf("escape ctrl.,   ");
               break;
               case(ESCAPE_CONFIRM_MODE):
               printf("escape confirm, ");
               break;
            }

            switch(classificationMode){
               case(CLASSIFICATION_ON):
               printf("class. on,   ");
               break;
               case(CLASSIFICATION_OFF):
               printf("class. off,  ");
               break;
            }

            switch(obstacleType){
               case(OBSTACLE_0):
               printf("obstacle 0,  ");
               break;
               case(OBSTACLE_1):
               printf("obstacle 1,  ");
               break;
            }

            switch(robotMobility){
               case(MOBILE):
               printf("mobile   ,   ");
               break;
               case(ALMOST_IMMOBILIZED):
               printf("almost immob.,  ");
               break;
               case(IMMOBILIZED):
               printf("immobilized,    ");
               break;
            }
            printf("\n");
         }
      }
#endif
      /* **********************************************************************************
      //this costate interprets the results from the mobility and obstacle detection
      //classifiers
      //this function is disabled in this version of yeti code because we need a serial port
      //for a second radio for the communication with instrument package latop
      costate loggerInterpret always_on
      {
         // wait for a message from datalogger port
         waitfor(usedE > 0);

         // give the message a chance to finish sending
         waitfor(DelayMs(8));

         if  (classificationMode == CLASSIFICATION_ON)
         {

            usedE = serErdUsed();
            serEread(loggerInput,usedE, 2);
            loggerInput[usedE] = '\0';
            serErdFlush();

            switch(loggerInput[1]) {
            case '0':
               robotMobility = MOBILE;
               break;
            case '1':
               robotMobility = ALMOST_IMMOBILIZED;
               break;
            case '2':
               robotMobility = IMMOBILIZED;
               break;
            }

            switch(loggerInput[2]) {
            case '0':
               obstacleType = OBSTACLE_0;
               break;
            case '1':
               obstacleType = OBSTACLE_1;
               break;
            default:
               obstacleType = OBSTACLE_1;
            }
         }
         else
         {
            serErdFlush();
         }
      }
   */

      //***********************************************************************************
      // this costate updates the velocity of the wheels
      // acc rate is such that it takes 1 sec to go from 0 to max V
      // therefore can change v by at most 100 at each 50 ms time step
      costate
      {
         waitfor(DelayMs(50));

         newV = currentV;
         newW = currentW;
         vDiff = desiredV - currentV;
         wDiff = desiredW - currentW;

         if (vDiff > 0)
         {
            newV = currentV + min(50,vDiff); //emt - changed to 50 from 100
         }
         else if (vDiff < 0)
         {
            newV = currentV + max(-50,vDiff);
         }

         if (wDiff > 0)
         {
            newW = currentW + min(50,wDiff);
         }
         else if (wDiff < 0)
         {
            newW = currentW + max(-50,wDiff);
         }
         if ((newV != currentV) || (newW != currentW))
         {
            //disable motor controllers if velocity should be 0
            if (newV == 0 && newW == 0)
            digHoutTriState(1,0);
            else
            digHoutTriState(1,2);

            setVel(newV,newW);
            currentV = newV;
            currentW = newW;
         }
      }

      /* **********************************************************************************
      // Send encoder data through serial to Datalogger needed for mobility detection
      // This function is disabled in this version of C code
      */

      /*costate sendEncoder always_on
      {
         waitfor(DelayMs(45));     //send faster than 20Hz
         for (j = 0; j < 4; j++)
         {
            EncWrite(j, TRSFRCNTR_OL, CNT);
            // EncWrite(j,BP_RESET,CNT);
            EncWrite(j,BP_RESETB,CNT);
            asb = EncRead(j,DAT);
            asb_l = asb;
            bsb = EncRead(j,DAT);
            bsb_l = bsb;
            csb = EncRead(j,DAT);
            csb_l = csb;
            position  = asb_l;       // least significant byte
            position += (bsb_l << 8);
            position += (csb_l <<16);

            switch(j) {
            case 0:
               sprintf(axis_1,"%ld",position);
               break;
            case 1:
               sprintf(axis_2,"%ld",position);
               break;
            case 2:
               sprintf(axis_3,"%ld",position);
               break;
            case 3:
               sprintf(axis_4,"%ld",position);
               break;
            }
         }
         sprintf(enc_data,",%s,%s,%s,%s*",axis_1,axis_2,axis_3,axis_4);
         serEputs(enc_data);
      }*/


      //***********************************************************************************
      // stop robot if get no pings from java for 5 seconds DURING user control mode
      // continue GPS mode even if communication to user has been lost
      /*costate pingCheck always_on
      {
         if(controlMode == USER_CONTROL_MODE){
	      	if (ping == 1)
  	      	{
   	         waitfor(DelayMs(500));
      	      ping = 0;
        	    	abort;
        	 	}
        	 	else
        	 	{
           		waitfor(DelaySec(5));
            	if (ping == 1)
         	   	abort;
            	else
            	{
               	desiredV = 0;
               	desiredW = 0;
            	}
            }
         }
      }*/

      //***********************************************************************************
      // this costate will check if the GPS has sent some data or not and
      // call the appropriate functions to process the data
      costate GPSRead always_on
      {
         //printf("gps read started\n");
         waitfor((serFrdUsed() > 0)); //always read GPS even during user control mode
         //printf("gps string came in\n");

         charCounter = 0;
         // read until finding the beginning of a gps string then wait 2 seconds
         while(1)
         {
            c = serFgetc();
            if (c == -1)
            {
               serFrdFlush();
               abort;
            }
            else if (c == '$')
            {
               waitfor(DelayMs(20));     //wait for full message to send
               break;
            }
         }

         // now that 20 ms have passed, read in the gps string (it must all
         // be there by now, since so much time has passed

         getgps2(gpsString);

#ifdef _debug_GPS_
         //printf("gps: %u \n",strlen(test2));
         printf("gps: %s ",gpsString);
         //puts(gpsString);
         //puts(":   end gps \n");
#endif

         //===================================================================================
#ifdef _debug_GPS_fine_
         printf("gps 2\n");
#endif
         // use Luke's library function to get gps position data from the
         // gps string
         valid_gps = gps_get_position(&CurrentGPS,gpsString);
         //num_sat = gps_get_satellites(&Satellite,gpsString); //<-can be used only during GPGSA mode

         printf("valid gps: %d, CurrentGPS: %d %f, %d %f\n", valid_gps, CurrentGPS.lat_degrees, CurrentGPS.lat_minutes, CurrentGPS.lon_degrees, CurrentGPS.lon_minutes);
         //printf("# of sat: %d\n",num_sat);

#ifdef _debug_GPS_fine_
         printf("valid gps: %d, CurrentGPS: %d %f, %d %f\n", valid_gps, CurrentGPS.lat_degrees, CurrentGPS.lat_minutes, CurrentGPS.lon_degrees, CurrentGPS.lon_minutes);
#endif

#ifdef _debug_GPS_fine_
         printf("gps 3\n");
#endif

#ifdef _debug_GPS_fine_
         printf("gps 4\n");
#endif

			flag2=0;
         //valid gps=0 - success, -1 - parsing error, 1 - sentence marked invalid
         if(valid_gps==0 && controlMode == GPS_CONTROL_MODE){
            // initialize last gps coordinate if program is just starting
            if(helpLast == 0)
            {
               LastGPS = CurrentGPS;
               helpLast = 1;
            }

            // find the x and y distances between the last and current GPS
            // positions of the robot
            CurCart = getCart(&LastGPS,&CurrentGPS);

            originToCurrent = gps_ground_distance(&LastGPS, &CurrentGPS);
        		currentToGoal = gps_ground_distance(&CurrentGPS, &Goal);

            printf("CurrentGPS: %d %f, %d %f\n",CurrentGPS.lat_degrees, CurrentGPS.lat_minutes, CurrentGPS.lon_degrees, CurrentGPS.lon_minutes);
            printf("LastGPS: %d,%f,%d,%f\n", LastGPS.lat_degrees, LastGPS.lat_minutes, LastGPS.lon_degrees, LastGPS.lon_minutes);
            printf("originTocurrent: %f, currentToGoal: %f\n",originToCurrent, currentToGoal);

            if(currentToGoal>=WAYPOINT_RADIUS){
            	// compute bearing if there the robot traveled enough distance 2m
			  		if(originToCurrent >= 0.002 || helpLast2 == 0){

                  if(helpLast2 == 0)
               		helpLast2 = 1;

                  // set the flag so that v,w are updated in the second if statement
						flag2=1;

           			// compute the bearing and distance from current pos to the next waypoint
           			GoalPos = getPol(getCart(&CurrentGPS,&Goal));

	           		bearingToGoal = gps_bearing2(&CurrentGPS, &Goal);

   	      		// compute bearing from origin to current
      	     		// if the robot is not stationary, calculate robot bearing
         	  		// this is necessary because atan2 breaks if it is given 0/0
        	     		if(!(CurCart.x == 0 && CurCart.y == 0))
        	     		{
            			CurPol = getPol(CurCart);
         	  	 	}
         			else
           	 		{
           				CurPol.t = GoalPos.t;
           	 		}

              	 	if(originToCurrent!=0)
               	{
              			bearingToCurrent = gps_bearing2(&LastGPS,&CurrentGPS);
             		}
           			else
               	{
               		bearingToCurrent = bearingToGoal;
            		}

                  LastGPS = CurrentGPS;

               	/*sprintf(radioOutput,"bearing calculation: %f, %f\n", bearRange(CurPol.t-GoalPos.t),bearRange((bearingToCurrent-bearingToGoal)*PI/180.0));
                  serCputs(radioOutput);
                  printf("bearing calculation: %f, %f\n", bearRange(CurPol.t-GoalPos.t),bearRange((bearingToCurrent-bearingToGoal)*PI/180.0));*/
            	}
            }
         }

         // if within 10m of the next way point, switch to the next waypoint
         // in the array, or stop of there are no more waypoints
         if (controlMode == GPS_CONTROL_MODE && currentToGoal >= WAYPOINT_RADIUS)
         {
            if (valid_gps == 0 && flag2==1)   //0 = good GPS, -1 = bad GPS
            {
               // compute bearing error
               error = bearRange(CurPol.t-GoalPos.t);

               // bearing error using double precision calculation
               error2 = bearRange((bearingToCurrent-bearingToGoal)*PI/180.0);

               //only add up integral term when the robot is currently moving at full speed
               //& the robot has actually moved 1m from the last positoin
               if(currentV == AUTONOMOUS_SPEED)
               {
                  deltat = (float)(TICK_TIMER-last_time) / (1024);
                  //TICK_TIMER is shared unsigned long that counts every 1/1024 sec
                  if(deltat<0)
                  {
                     deltat=(float)(TICK_TIMER-last_time+1024)/1024;
                  }
                  if(deltat<0) //invalid deltat -> set deltat=0
                  {
                     deltat=0;
                  }
                  error_integral = error_integral + (error2 + last_error)/2*deltat;
                  error_integral = bound(error_integral,INTEGRALMAX);
               }

               desiredW = (int)(bound(((-P_coeff*error2) - I_coeff*error_integral)*loop_gain, MAXW));
               desiredV = AUTONOMOUS_SPEED;

               last_error = error2;
               last_time = TICK_TIMER; //(1024 times per second)
            }
            /*else if(valid_gps!=0)
            {
               // without valid GPS, go straight but slower (half of autonomous speed)
               // still under autonomous mode
               desiredW = 0;
               desiredV = AUTONOMOUS_SPEED_SLOW;
               abort;
            }*/
         }
      }

      //***********************************************************************************
      // change the current waypoint to the nextway point when the robot reaches
      // near the current waypoint
      costate WaypointCheck always_on
      {
			//default distance = .005 (5 meters)
         if (currentToGoal < WAYPOINT_RADIUS && controlMode == GPS_CONTROL_MODE && valid_gps==0)
         {
         	// go straight for 2sec (travel about 4m straight)
            desiredW = 0;
            desiredV = AUTONOMOUS_SPEED;
            waitfor(DelaySec(2));

            // stop at each waypoint when stoppingMode = 1
            if(stoppingMode == 1){
            	controlMode = INSTRUMENT_MODE;
               desiredV = 0;
               desiredW = 0;
            }

            curWayPoint++;

            // if at the last way point, stop
            if(curWayPoint >= numWayPoints)
            {
	            controlMode = USER_CONTROL_MODE;
               desiredV = 0;
               desiredW = 0;
               curWayPoint = 0;
               Goal = WayPoints[0];
               abort;
            }
            else{
  	         	Goal = WayPoints[curWayPoint];
            	currentToGoal = gps_ground_distance(&CurrentGPS, &Goal);
            	error_integral = 0; //reset error integral for PI control
            	last_time = TICK_TIMER; //(1024 times per second)
         	}
         }
      }
      //***********************************************************************************
      // Change to user control mode when there is no good GPS connection
      /*costate GPSPingCheck always_on
      {
         waitfor(valid_gps != 0);
         waitfor(DelaySec(10) || (valid_gps == 0));
         if (valid_gps != 0)
         {
            controlMode = USER_CONTROL_MODE;
            desiredV = 0;
            desiredW = 0;

            flag=1;
         }

         if(valid_gps == 0 && flag==1){
            controlMode = GPS_CONTROL_MODE;
            flag=0;
         }
      }*/
      //***********************************************************************************
      //Escape mode disabled in this version because datalogger is not being used
      /*costate escapeSequence always_on
      {
         waitfor(controlMode == ESCAPE_CONTROL_MODE);
         desiredV = 0;
         desiredW = 0;
         setVel(0,0);
         //printf("waiting for escape confirm... \n");
         //waitfor(controlMode  == ESCAPE_CONFIRM_MODE);

         printf("escape sequence initiated \n");
         switch(obstacleType){
         case OBSTACLE_0:
            desiredV = 0;
            desiredW = 0;
            waitfor(DelayMs(500));

            desiredV = -300;
            desiredW = 0;
            waitfor(DelayMs(4000));

            desiredV = 0;
            desiredW = -600;
            waitfor(DelayMs(2000));

            desiredV = 800;
            desiredW = 0;
            waitfor(DelayMs(4000));
            break;
         case OBSTACLE_1:
            desiredV = 0;
            desiredW = 0;
            waitfor(DelayMs(500));

            desiredV = -400;
            desiredW = 0;
            waitfor(DelayMs(4000));

            desiredV = 1500;
            desiredW = 0;
            waitfor(DelayMs(3500));

            desiredV = -400;
            desiredW = 0;
            waitfor(DelayMs(4000));

            desiredV = 1500;
            desiredW = 0;
            waitfor(DelayMs(3500));
            break;
         }

         //relinquish control to User
         desiredV = 0;
         desiredW = 0;
         controlMode = USER_CONTROL_MODE;
         robotMobility = MOBILE;
         classificationMode = CLASSIFICATION_OFF;
      }*/
   }
}

// directly sets the outputs to the motor controllers
// v and w are integers between -2048 and 2047 (b/c of 12 bits)
// v is linear velocity, w is angular velocity
void setVel(int v,int w)
{
   //  chan 0 = A
   //  chan 1 = B
   //  chan 2 = C
   //  chan 3 = D
   // linear velocity component
   float voutl;
   // angular velocity component
   float vouta;
   float vA;
   float vB;
   float vC;
   float vD;
   float vr;
   float vl;

   voutl = (float)v/2048*10;
   vouta = (float)w/2048*10;
   vr = -voutl - vouta;
   vl = voutl - vouta;

   vA = bound(vr,10);
   vB = bound(vr,10);
   vC = bound(vl,10);
   vD = bound(vl,10);

   anaOutVolts(0,vA);
   anaOutVolts(1,vB);
   anaOutVolts(2,vC);
   anaOutVolts(3,vD);
   anaOutStrobe();
}