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

#define MAX_COUNT          500

int EncRead(int channel, int reg);
void EncWrite(int channel, int data, int reg);
int init(void);

void main()
{
	//File *fp;
   int i,j,N, count;
   float time[MAX_COUNT];
   float vel[MAX_COUNT];
   float wind[MAX_COUNT];
   float data [4][MAX_COUNT];
   float T1,dt;
   unsigned long int T0;
   int delayvar;
   int asb, bsb, csb;
   long position;
   long anposition;
   long anposition2;

   brdInit();
   digOutConfig(0xff00);
   digOut(CS1,1);
   digOut(CS2,1);
   digOut(RD,1);
   digOut(WR,1);
   // printf("init = %d\n",init());
   init();
   //position2 = 0;
   N = 5;
   dt = ((float)N)/1024;
   count = 0;
   T1 = 0;


              EncWrite(1, TRSFRCNTR_OL, CNT);
              EncWrite(1,BP_RESETB,CNT);
              asb = EncRead(1,DAT);
              bsb = EncRead(1,DAT);
              csb = EncRead(1,DAT);

         // printf("%d, %d, %d, ",csb, bsb, asb);
           anposition2  = (long)asb;			// least significant byte
			 anposition2 += (long)(bsb << 8);
			  anposition2 += (long)(csb <<16);
   while (count < MAX_COUNT){
   		T0 = TICK_TIMER;
      for (j=2; j<4;j++){
         EncWrite(j, TRSFRCNTR_OL, CNT);
         EncWrite(j,BP_RESETB,CNT);
         asb = EncRead(j,DAT);
         bsb = EncRead(j,DAT);
         csb = EncRead(j,DAT);
         position  = (long)asb;			// least significant byte
			position += (long)(bsb << 8);
			position += (long)(csb <<16);
          time[count] = T1;
         if (position < -10000000){
         position=0;
         }
         data[j][count] = position;
       }
        /* EncWrite(1, TRSFRCNTR_OL, CNT);
         EncWrite(1,BP_RESETB,CNT);
         asb = EncRead(1,DAT);
         bsb = EncRead(1,DAT);
         csb = EncRead(1,DAT);
         anposition  = (long)asb;			// least significant byte
			anposition += (long)(bsb << 8);
			anposition += (long)(csb <<16);
         vel[count] = -(((float)(anposition-anposition2))/(dt))*0.015707963;
         time[count] = T1;
         anposition2 = anposition;
          */

      // increment iteration count
      count++;
      // increment time
      T1+= dt;
      // check to see if we ran over sampling time
      if( (TICK_TIMER - T0) > N) {
      	printf("overrun sampling time\n");
         }
   	// wait for sampling time
      while ((TICK_TIMER - T0) < N)  {  }

   }
   // print information after running
   //fp = fopen("results.csv", "w");
   for(j = 0; j < MAX_COUNT ; j++){
   	printf("%f,%f,%f,%f,%f\n",time[j],data[0][j],data[1][j],data[2][j],data[3][j]);
     // fprintf(fp, "%f, %f\n", time[i], vel[i]);
   }
   //fclose(fp);


}

int init(void)
{
   int fail;
   int i,j;
   fail = 0;

   for (i = 0; i<4; i++)
   {
//		EncWrite(i, XYIOR_SETUP,CNT);	// Setup I/O control register
//		EncWrite(i, XYIDR_SETUP,CNT);		// Disable Index
      EncWrite(i,EFLAG_RESET,CNT);
      EncWrite(i,BP_RESETB,CNT);
      // EncWrite(i,CNTR_RESETB,CNT);
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
       EncWrite(i,CNTR_RESET,CNT);
   }
   return fail;
}


// channel is an int from 0 to 3 indicating which encoder
// reg is an int which is 1 or 0 indicating whether control or data is desired
int EncRead(int channel, int reg)
{
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