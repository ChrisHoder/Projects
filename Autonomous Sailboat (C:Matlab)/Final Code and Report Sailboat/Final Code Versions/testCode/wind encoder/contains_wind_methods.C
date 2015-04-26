

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



int EncRead(int channel, int reg);
void EncWrite(int channel, int data, int reg);
int encInit(void);
float getWindPos(long offset);
float getWindVel(float dt);
long getCount(int channel);

long old_anem_pos;
/* START FUNCTION DESCRIPTION ********************************************
main

SYNTAX:      void main();
KEYWORDS:      encoder,test
DESCRIPTION:   Main method for the encoder board test
RETURN VALUE:  none

END DESCRIPTION**********************************************************/
void main()
{

   float windpos;
   float windvel;
   long offset;
   int N;
   float dt;
   float T0;
 	offset=0;
   brdInit();

   N = 50;
   dt = ((float)N)/1024;


   encInit();

   offset=getCount(3);
   old_anem_pos=getCount(2);
   while (1)
   {
   		T0=TICK_TIMER;

         windpos=getWindPos(offset);
         windvel=getWindVel(dt);

      printf("Position (degrees): %f\n Velocity (m/s): %f\n\n",windpos,windvel);
        // printf("vel: %f\n",windvel);

         if( (TICK_TIMER - T0) > N) {
      		printf("overrun sampling time\n");
         }

         while ((TICK_TIMER - T0) < N)  {  }//Wait for next timestep
   }
}
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
      printf("written = %d, read = %d\n",0x12,EncRead(i,DAT));
      printf("written = %d, read = %d\n",0x34,EncRead(i,DAT));
      printf("written = %d, read = %d\n",0x56,EncRead(i,DAT));

    // Reset the counter now so that starting position is 0
       EncWrite(i,0x5A0,DAT);
       EncWrite(i,CNTR_RESET,CNT);
       EncWrite(i,CNTR_RESETB,CNT);

   }
   return fail;
}



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
   // printf("%d, %d, %d, \n",csb, bsb, asb);
 	position  = (long)asb;			// least significant byte
 	position += (long)(bsb << 8);
 	position += (long)(csb <<16);
   position=position-offset;
 	position= (position % 1440);
	floatPos=(position * 360.0)/1440.0;

   if (floatPos < 0 ){ return 360 + floatPos;}

   return floatPos;
}
/* START FUNCTION DESCRIPTION ********************************************
getWindVel

SYNTAX:        float getWindVel(float dt);
KEYWORDS:      encoder,read,anemometer
DESCRIPTION:   Returns the wind velocity using the anemometer position
PARAMETER 1:   dt - the timestep, used in the derivitive calculation
RETURN VALUE:  the wind velocity

END DESCRIPTION**********************************************************/
float getWindVel(float dt){
  int asb, bsb, csb;
  float vel;
  long position;
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
             vel= ((float)position-(float)old_anem_pos)/(dt);
             vel=0.001*vel-0.0369;
              if (vel<0){ vel=-vel;}
              old_amem_pos=position;
              return vel;

}
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
   EncWrite(2, TRSFRCNTR_OL, CNT);
  	EncWrite(2,BP_RESETB,CNT);
   asb = EncRead(2,DAT);
   bsb = EncRead(2,DAT);
   csb = EncRead(2,DAT);
   // printf("%d, %d, %d, \n",csb, bsb, asb);
 	position  = (long)asb;			// least significant byte
 	position += (long)(bsb << 8);
 	position += (long)(csb <<16);
   return position;
}