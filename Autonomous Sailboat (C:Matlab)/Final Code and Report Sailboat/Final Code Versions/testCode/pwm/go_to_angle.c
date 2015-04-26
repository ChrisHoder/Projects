#define PWM0_OPTION 0
#define PWM1_OPTION 0

/*  hitec servo specs
  min     center     max
  .9        1.5       2.1  ms

  pulse update at 50 Hz
*/

nodebug
void msDelay(unsigned int delay)
{
	auto unsigned long done_time;

	done_time = MS_TIMER + delay;
   while( (long) (MS_TIMER - done_time) < 0 );
}

// set the STDIO cursor location and display a string
void DispStr(int x, int y, char *s)
{
   x += 0x20;
   y += 0x20;
   printf ("\x1B=%c%c%s", x, y, s);
}

void  blankScreen(int start, int end)
{
	auto char buffer[256];
   auto int i;

   memset(buffer, 0x00, sizeof(buffer));
 	memset(buffer, ' ', sizeof(buffer));
   buffer[sizeof(buffer)-1] = '\0';
   for(i=start; i < end; i++)
   {
   	DispStr(start, i, buffer);
   }
}


/* 	FUNCTION  set angle
 	takes:  int  pwm channel   -  the channel the servo is on
           int  angle 			 -  + or - 90 degress
*/
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

void main()
{
   auto int pwm;
   auto long freq;
   auto int chan, ang;
   auto char tmpbuf[128], c;

   brdInit();
	freq = pwm_init(80ul);

   while (1)
   {
      while(1==kbhit())
      {
    	printf("\nType PWM Channel: ");
		chan = atoi(gets(tmpbuf));
		printf("\nType desired angle (+- 90 deg): ");
   	ang = atoi(gets(tmpbuf));
   	pwm = set_angle(chan, ang);
 	   printf("\nduty set = %d  and angle = %d",pwm,ang);
      }
	}
}