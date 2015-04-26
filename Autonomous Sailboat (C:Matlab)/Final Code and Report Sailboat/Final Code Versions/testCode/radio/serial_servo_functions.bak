/*
Serial communication to servo controller
written by darren reis, 5/2013
hardware found here: https://www.sparkfun.com/datasheets/Robotics/ssc03a_guide.pdf
*/

void writeServo(char cmd, int serv, char data);
void initServo();
void setServoSpeed(int serv, int spd);
int setServoPosition(int serv, int ang);


void writeServo(char cmd, int serv, char data)
{
   char buf[5];
	serFputc(0x80);	// start com with servo contorller
	serFputc(0x01);	// servo type id
	serFputc(cmd);		// cmd

	serFputc(sprintf(buf,"%d",serv));	// servo number
	serFputc(data);		// put in data
}

void initServo()
{
	int i;
   serFwrFlush();
	serFrdFlush();
	for (i =0 ; i<8; i++)
   {writeServo(0, i, 0x2F);	// setup servo one
   }
}

void setServoSpeed(int serv, int spd)
{
   writeServo(0x01, serv, spd);
}


int setServoPosition(int serv, int ang)
{
	int temp, retu;
	char buf;

   serFputc((char)0x80); // start byte
   serFputc((char)0x01); // device id
   serFputc((char)0x02); // set position command (7 bit)
   serFputc((char)serv);	// set servo


	if (ang < -90)
		{
      serFputc((char)0x0E); // high byte
      serFputc((char)0x6C); // low byte
      retu = -1;	// angle set too low
		}
	else if (ang > 90)
		{
      serFputc((char)0x21); // high byte
      serFputc((char)0x4C); // low byte
      retu = 1;	// angle set too high
		}
	else
		{
      temp = 63.5*ang/90+63.5;       //
		printf("index = %d\n",temp);
  	   serFputc((char)temp);
		printf("serial put value: %c\n",(char)temp);
      retu = 0;	// all is well
		}
	return retu;
}

// Function to set the STDIO cursor location and display a string
void DispStr(int x, int y, char *s)
{
   x += 0x20;
   y += 0x20;
   printf ("\x1B=%c%c%s", x, y, s);
}

void main()
{

	int angle;
   int stat;
   auto char tmpbuf[128];

brdInit();
serFopen(19200);
serMode(0);

DispStr(2, 16, "Type a desired angle (-90 to 90 deg) =  ");
// get user voltage value for the DAC thats being monitored
angle = atof(gets(tmpbuf));

initServo();
setServoSpeed(6, 0);
stat = 0x0;

while (1)
{
costate stuff always_on

{    waitfor(kbhit());

 stat = setServoPosition(6, angle);
 DispStr(2, 16, "Type a desired angle (-90 to 90 deg) =  ");
 // get user voltage value for the DAC thats being monitored
 angle = atof(gets(tmpbuf));
}
}

}


