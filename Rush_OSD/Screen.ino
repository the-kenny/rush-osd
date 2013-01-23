
char *ItoaPadded(int val, char *str, uint8_t bytes, uint8_t decimalpos)  {
  uint8_t neg = 0;
  if(val < 0) {
    neg = 1;
    val = -val;
  }

  str[bytes] = 0;
  for(;;) {
    if(bytes == decimalpos) {
      str[--bytes] = DECIMAL;
      decimalpos = 0;
    }
    str[--bytes] = '0' + (val % 10);
    val = val / 10;
    if(bytes == 0 || (decimalpos == 0 && val == 0))
      break;
  }

  if(neg && bytes > 0)
    str[--bytes] = '-';

  while(bytes != 0)
    str[--bytes] = ' ';
  return str;
}

char *FormatGPSCoord(int32_t val, char *str, uint8_t p, char pos, char neg) {
  if(val < 0) {
    pos = neg;
    val = -val;
  }

  uint8_t bytes = p+8;

  str[bytes] = 0;
  str[--bytes] = pos;
  for(;;) {
    if(bytes == p) {
      str[--bytes] = DECIMAL;
      continue;
    }
    str[--bytes] = '0' + (val % 10);
    val = val / 10;
    if(bytes < 3 && val == 0)
       break;
   }

   while(bytes != 0)
     str[--bytes] = ' ';

   return str;
}

// Take time in Seconds and format it as 'MM:SS'
// Alternately Take time in Minutes and format it as 'HH:MM'
// If hhmmss is 1, display as HH:MM:SS
char *formatTime(uint16_t val, char *str, uint8_t hhmmss) {
  int8_t bytes = 5;
  if(hhmmss)
    bytes = 8;
  str[bytes] = 0;
  do {
    str[--bytes] = '0' + (val % 10);
    val = val / 10;
    str[--bytes] = '0' + (val % 6);
    val = val / 6;
    str[--bytes] = ':';
  } while(hhmmss-- != 0);
  do {
    str[--bytes] = '0' + (val % 10);
    val = val / 10;
  } while(val != 0 && bytes != 0);

  while(bytes != 0)
     str[--bytes] = ' ';

  return str;
}

uint8_t FindNull(void)
{
  uint8_t xx;
  for(xx=0;screenBuffer[xx]!=0;xx++)
    ;
  return xx;
}

void displayTemperature(void)        // WILL WORK ONLY WITH V1.2
{
  int xxx;
  if (Settings[S_UNITSYSTEM])
    xxx = temperature*1.8+32;       //Fahrenheit conversion for imperial system.
  else
    xxx = temperature;

  if(xxx > temperMAX)
    temperMAX = xxx;

  itoa(xxx,screenBuffer,10);
  uint8_t xx = FindNull();   // find the NULL
  screenBuffer[xx++]=temperatureUnitAdd[Settings[S_UNITSYSTEM]];
  screenBuffer[xx]=0;                                   // Restore the NULL
  MAX7456_WriteString(screenBuffer,getPosition(temperaturePosition));
}

void displayMode(void)
{
  // Put sensor symbold (was displaySensors)
  screenBuffer[0] = (MwSensorPresent&ACCELEROMETER) ? 0xa0 : ' ';
  screenBuffer[1] = (MwSensorPresent&BAROMETER) ? 0xa2 : ' ';
  screenBuffer[2] = (MwSensorPresent&MAGNETOMETER) ? 0xa1 : ' ';
  screenBuffer[3] = (MwSensorPresent&GPSSENSOR) ? 0xa3 : ' ';

  if(MwSensorActive&Settings[S_STABLEMODE])
  {
    screenBuffer[4]=0xac;
    screenBuffer[5]=0xad;
  }
  else
  {
    screenBuffer[4]=0xae;
    screenBuffer[5]=0xaf;
  }
  screenBuffer[6]=' ';
  if(MwSensorActive&Settings[S_GPSHOMEMODE])
    screenBuffer[7]=0xff;
  else if(MwSensorActive&Settings[S_GPSHOLDMODE])
    screenBuffer[7]=0xef;
  else if(GPS_fix)
    screenBuffer[7]=0xdf;
  else
    screenBuffer[7]=' ';
  screenBuffer[8]=0;
  MAX7456_WriteString(screenBuffer,getPosition(sensorPosition));

  // Put ON indicator under sensor symbol
  screenBuffer[0] = (MwSensorActive&Settings[S_STABLEMODE]) ? 0xBE : ' ';
  screenBuffer[1] = (MwSensorActive&Settings[S_BAROMODE]) ? 0xBE : ' ';
  screenBuffer[2] = (MwSensorActive&Settings[S_MAGMODE]) ? 0xBE : ' ';
  screenBuffer[3] = (MwSensorActive&(Settings[S_GPSHOMEMODE]|Settings[S_GPSHOLDMODE])) ? 0xBE : ' ';
  screenBuffer[4] = 0;
  MAX7456_WriteString(screenBuffer,getPosition(sensorPosition)+LINE);
}

void displayArmed(void)
{
  armed = (MwSensorActive&Settings[S_ARMEDMODE]);
  if(armedTimer==0)
    MAX7456_WriteString_P(disarmed_text, getPosition(motorArmedPosition));
  else if((armedTimer>1) && (armedTimer<9) && (Blink10hz))
    MAX7456_WriteString_P(armed_text, getPosition(motorArmedPosition));
}

void displayHorizonPart(int X,int Y,int roll)
{
  // Roll Angle will be between -45 and 45 this is converted to 0-56 to fit with DisplayHorizonPart function
  X=X*(0.6)+28;
  if(X>56) X=56;
  if(X<0) X=0;
  // 7 row, 8 lines per row, mean 56 different case per segment, 2 segment now
  int xx=X/8;
  switch (xx)
  {
  case 0:
    screen[(roll*30)+100+Y]=0x10+(X);
    break;
  case 1:
    screen[(roll*30)+130+Y]=0x10+(X-8);
    break;
  case 2:
    screen[(roll*30)+160+Y]=0x10+(X-16);
    break;
  case 3:
    screen[(roll*30)+190+Y]=0x10+(X-24);
    break;
  case 4:
    screen[(roll*30)+220+Y]=0x10+(X-32);
    break;
  case 5:
    screen[(roll*30)+250+Y]=0x10+(X-40);
    break;
  case 6:
    screen[(roll*30)+280+Y]=0x10+(X-48);
    break;
  }
}

void displayHorizon(short rollAngle, short pitchAngle)
{
  rollAngle = rollAngle / 10;
  pitchAngle = pitchAngle /10;
  if(pitchAngle>25) pitchAngle=25;
  if(pitchAngle<-20) pitchAngle=-20;
  if(rollAngle>40) rollAngle=40;
  if(rollAngle<-40) rollAngle=-40;
  pitchAngle = pitchAngle /5;

  displayHorizonPart(rollAngle,0,pitchAngle );
  displayHorizonPart(rollAngle*0.75,1,pitchAngle );
  displayHorizonPart(rollAngle*0.5,2,pitchAngle );
  displayHorizonPart(rollAngle*0.25,3,pitchAngle );
  displayHorizonPart(0,4,pitchAngle );
  displayHorizonPart(-1*rollAngle*0.25,5,pitchAngle );
  displayHorizonPart(-1*rollAngle*0.5,6,pitchAngle );
  displayHorizonPart(-1*rollAngle*0.75,7,pitchAngle );
  displayHorizonPart(-1*rollAngle,8,pitchAngle );

  if(Settings[S_DISPLAY_HORIZON_BR]){
  //Draw center screen
  screen[219-30]=0x03;
  screen[224-30-1]=0x1D;
  screen[224-30+1]=0x1D;
  screen[224-30]=0x01;
  screen[229-30]=0x02;
    if (Settings[S_WITHDECORATION]){
  screen[128]=0xC7;
  screen[128+30]=0xC7;
  screen[128+60]=0xC7;
  screen[128+90]=0xC7;
  screen[128+120]=0xC7;
  screen[128+12]=0xC6;
  screen[128+12+30]=0xC6;
  screen[128+12+60]=0xC6;
  screen[128+12+90]=0xC6;
  screen[128+12+120]=0xC6;
    }
  }
}

void displayVoltage(void)
{
  if (Settings[S_VIDVOLTAGE_VBAT]){
  vidvoltage=MwVBat;
}
  if (Settings[S_MAINVOLTAGE_VBAT]){
    voltage=MwVBat;
  }
  ItoaPadded(voltage, screenBuffer, 4, 3);
  screenBuffer[4] = voltageUnitAdd;
  screenBuffer[5] = 0;
  MAX7456_WriteString(screenBuffer,getPosition(voltagePosition));

if (Settings[S_SHOWBATLEVELEVOLUTION]){
  // For battery evolution display
int BATTEV1 =Settings[S_BATCELLS] * 35;
int BATTEV2 =Settings[S_BATCELLS] * 36;
int BATTEV3 =Settings[S_BATCELLS] * 37;
int BATTEV4 =Settings[S_BATCELLS] * 38;
int BATTEV5 =Settings[S_BATCELLS] * 40;
int BATTEV6 = Settings[S_BATCELLS] * 41;
  
  
  
  
  if (voltage < BATTEV1) screenBuffer[0]=0x96;
  else if (voltage < BATTEV2) screenBuffer[0]=0x95;
  else if (voltage < BATTEV3) screenBuffer[0]=0x94;
  else if (voltage < BATTEV4) screenBuffer[0]=0x93;
  else if (voltage < BATTEV5) screenBuffer[0]=0x92;
  else if (voltage < BATTEV6) screenBuffer[0]=0x91;
  else screenBuffer[0]=0x90;                              // Max charge icon
}
else {
  screenBuffer[0]=0x97;
  }
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(voltagePosition)-1);

  if (Settings[S_VIDVOLTAGE]){
  ItoaPadded(vidvoltage, screenBuffer, 4, 3);
  screenBuffer[4]=voltageUnitAdd;
  screenBuffer[5]=0;
  MAX7456_WriteString(screenBuffer,getPosition(vidvoltagePosition));
  screenBuffer[0]=0xbf;
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(vidvoltagePosition)-1);
}
}

void displayCurrentThrottle(void)
{                                                                           // CurentThrottlePosition is set in Config.h to line 11 above flyTimePosition

  if (MwRcData[THROTTLESTICK] > HighT) HighT = MwRcData[THROTTLESTICK] -5;
  if (MwRcData[THROTTLESTICK] < LowT) LowT = MwRcData[THROTTLESTICK];      // Calibrate high and low throttle settings  --defaults set in GlobalVariables.h 1100-1900
  screenBuffer[0]=0xC8;
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(CurrentThrottlePosition));
  if(!armed) {
    screenBuffer[0]=' ';
    screenBuffer[1]=' ';
    screenBuffer[2]='-';
    screenBuffer[3]='-';
    screenBuffer[4]=0;
    MAX7456_WriteString(screenBuffer,getPosition(CurrentThrottlePosition)+2);
  }
  else
  {
    int CurThrottle = map(MwRcData[THROTTLESTICK],LowT,HighT,0,100);
    ItoaPadded(CurThrottle,screenBuffer,3,0);
    screenBuffer[3]='%';
    screenBuffer[4]=0;
    MAX7456_WriteString(screenBuffer,getPosition(CurrentThrottlePosition)+2);
  }
}

void displayTime(void)
{
  if(flyTime < 3600) {
    screenBuffer[0] = SYM_FLY_M;
    formatTime(flyTime, screenBuffer+1, 0);
  }
  else {
    screenBuffer[0] = SYM_FLY_H;
    formatTime(flyTime/60, screenBuffer+1, 0);
  }
  MAX7456_WriteString(screenBuffer,getPosition(flyTimePosition));

  if(onTime < 3600) {
    screenBuffer[0] = SYM_ON_M;
    formatTime(onTime, screenBuffer+1, 0);
  }
  else {
    screenBuffer[0] = SYM_ON_H;
    formatTime(onTime/60, screenBuffer+1, 0);
  }
  MAX7456_WriteString(screenBuffer,getPosition(onTimePosition));
}

void displayAmperage(void)
{
  // Real Ampere is ampere / 10
  ItoaPadded(amperage, screenBuffer, 4, 3);     // 99.9 ampere max!
  screenBuffer[4] = SYM_AMP;
  screenBuffer[5] = 0;
  MAX7456_WriteString(screenBuffer,getPosition(amperagePosition));
}

void displaypMeterSum(void)
{
#if defined (HARDSENSOR)
  pMeterSum = amperagesum;
#endif
  screenBuffer[0]=0xa4;
  int xx = pMeterSum / EST_PMSum;
  itoa(xx,screenBuffer+1,10);
  MAX7456_WriteString(screenBuffer,getPosition(pMeterSumPosition));
}

void displayRSSI(void)
{
  screenBuffer[0]=rssiUnitAdd;
  // Calcul et affichage du Rssi
  itoa(rssi,screenBuffer+1,10);
  uint8_t xx = FindNull();
  screenBuffer[xx++]='%';
  screenBuffer[xx]=0;
  MAX7456_WriteString(screenBuffer,getPosition(rssiPosition));
}

void displayHeading(void)
{
  int16_t heading = MwHeading;
  if (Settings[S_HEADING360]){
  if(heading < 0)
    heading += 360;
  ItoaPadded(heading,screenBuffer,3,0);
  screenBuffer[3]=MwHeadingUnitAdd;                 // Restore the NULL by the unit Symbols
  screenBuffer[4]=0;
  }
  else{
  ItoaPadded(heading,screenBuffer,4,0);
  screenBuffer[4]=MwHeadingUnitAdd;                 // Restore the NULL by the unit Symbols
  screenBuffer[5]=0;
  }
  MAX7456_WriteString(screenBuffer,getPosition(MwHeadingPosition));
}

void displayHeadingGraph(void)
{
  int xx;
  xx = MwHeading * 4;
  xx = xx + 720 + 45;
  xx = xx / 90;

  screenBuffer[0] = headGraph[xx++];
  screenBuffer[1] = headGraph[xx++];
  screenBuffer[2] = headGraph[xx++];
  screenBuffer[3] = headGraph[xx++];
  screenBuffer[4] = headGraph[xx++];
  screenBuffer[5] = headGraph[xx++];
  screenBuffer[6] = headGraph[xx++];
  screenBuffer[7] = headGraph[xx++];
  screenBuffer[8] = headGraph[xx];
  screenBuffer[9] = 0;
  MAX7456_WriteString(screenBuffer,getPosition(MwHeadingGraphPosition));
}

void displayIntro(void)
{

  MAX7456_WriteString_P(message0, RushduinoVersionPosition);

if (Settings[S_VIDEOSIGNALTYPE == 0]) MAX7456_WriteString_P(message1, RushduinoVersionPosition+30);


if (Settings[S_VIDEOSIGNALTYPE] == 1)  MAX7456_WriteString_P(message2, RushduinoVersionPosition+30);


  MAX7456_WriteString_P(MultiWiiLogoL1Add, RushduinoVersionPosition+120);
  MAX7456_WriteString_P(MultiWiiLogoL2Add, RushduinoVersionPosition+120+LINE);
  MAX7456_WriteString_P(MultiWiiLogoL3Add, RushduinoVersionPosition+120+LINE+LINE);

  MAX7456_WriteString_P(message5, RushduinoVersionPosition+120+LINE+LINE+LINE);
  MAX7456_WriteString(itoa(MwVersion,screenBuffer,10),RushduinoVersionPosition+131+LINE+LINE+LINE);

  MAX7456_WriteString_P(message6, RushduinoVersionPosition+120+LINE+LINE+LINE+LINE+LINE);
  MAX7456_WriteString_P(message7, RushduinoVersionPosition+125+LINE+LINE+LINE+LINE+LINE+LINE);
  MAX7456_WriteString_P(message8, RushduinoVersionPosition+125+LINE+LINE+LINE+LINE+LINE+LINE+LINE);
}

void displayGPSPosition(void)
{
  if(!GPS_fix)
    return;

  if(Settings[S_COORDINATES]){
  screenBuffer[0] = 0xCA;
  FormatGPSCoord(GPS_latitude,screenBuffer+1,3,'N','S');
  MAX7456_WriteString(screenBuffer,getPosition(MwGPSLatPosition));

  screenBuffer[0] = 0xCB;
  FormatGPSCoord(GPS_longitude,screenBuffer+1,4,'E','W');
  MAX7456_WriteString(screenBuffer,getPosition(MwGPSLonPosition));
  }

  screenBuffer[0] = MwGPSAltPositionAdd[Settings[S_UNITSYSTEM]];
  itoa(GPS_altitude,screenBuffer+1,10);
  MAX7456_WriteString(screenBuffer,getPosition(MwGPSAltPosition));
}

void displayNumberOfSat(void)
{
  screenBuffer[0] = 0x1e;
  screenBuffer[1] = 0x1f;
  itoa(GPS_numSat,screenBuffer+2,10);
  MAX7456_WriteString(screenBuffer,getPosition(GPS_numSatPosition));
}

void displayGPS_speed(void)
{
  if(!GPS_fix)
    return;

  int xx;
  if(!Settings[S_UNITSYSTEM])
    xx = GPS_speed * 0.036;           // From MWii cm/sec to Km/h
  else
    xx = GPS_speed * 0.02236932;       // (0.036*0.62137)  From MWii cm/sec to mph

  if(xx > speedMAX)
    speedMAX = xx;

  screenBuffer[0]=speedUnitAdd[Settings[S_UNITSYSTEM]];
  itoa(xx,screenBuffer+1,10);
  MAX7456_WriteString(screenBuffer,getPosition(speedPosition));
}

void displayAltitude(void)
{
  int altitude;

  if(armed && allSec>5 && altitude > altitudeMAX)
    altitudeMAX = altitude;

  if(Settings[S_UNITSYSTEM])
    altitude = MwAltitude/100*3.2808;  // cm to feet
  else
    altitude = MwAltitude/100;         // cm to mt

  screenBuffer[0]=MwAltitudeAdd[Settings[S_UNITSYSTEM]];
  itoa(altitude,screenBuffer+1,10);
  MAX7456_WriteString(screenBuffer,getPosition(MwAltitudePosition));
}

void displayClimbRate(void)
{
  screenBuffer[0] = MwClimbRateAdd[Settings[S_UNITSYSTEM]];
  int xx;
  if(Settings[S_UNITSYSTEM])
    xx = MwVario * 0.032808;       // cm/sec ----> ft/sec
  else
    xx = MwVario / 100;            // cm/sec ----> mt/sec
  itoa(xx,screenBuffer+1,10);
  MAX7456_WriteString(screenBuffer,getPosition(MwClimbRatePosition));

  if(MwVario > 70)       screenBuffer[0]=0xB3;
  else if(MwVario > 50)  screenBuffer[0]=0xB2;
  else if(MwVario > 30)  screenBuffer[0]=0xB1;
  else if(MwVario > 20)  screenBuffer[0]=0xB0;
  else if(MwVario < -70) screenBuffer[0]=0xB4;
  else if(MwVario < -50) screenBuffer[0]=0xB5;
  else if(MwVario < -30) screenBuffer[0]=0xB6;
  else if(MwVario < -20) screenBuffer[0]=0xB7;
  else                   screenBuffer[0]=0xBC;
  screenBuffer[1]=0;

  int pos = getPosition(MwClimbRatePosition)-2;
  if(MwVario < -20)
    pos += LINE;
  MAX7456_WriteString(screenBuffer,pos);
}

void displayDistanceToHome(void)
{
  if(!GPS_fix)
    return;

  screenBuffer[0]=GPS_distanceToHomeAdd[Settings[S_UNITSYSTEM]];
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(GPS_distanceToHomePosition));

  if(!Settings[S_UNITSYSTEM]) GPS_distanceToHome = GPS_distanceToHome;                    // Mt
  if(Settings[S_UNITSYSTEM]) GPS_distanceToHome = GPS_distanceToHome * 3.2808;            // mt to feet

  if(GPS_distanceToHome > distanceMAX) distanceMAX = GPS_distanceToHome;
  itoa(GPS_distanceToHome,screenBuffer,10);
  MAX7456_WriteString(screenBuffer,getPosition(GPS_distanceToHomePosition)+1);
}

void displayAngleToHome(void)
{
  if(!GPS_fix)
    return;
  if(GPS_distanceToHome <= 2 && Blink2hz)
    return;

  itoa(GPS_directionToHome,screenBuffer,10);
  uint8_t xx = FindNull();
  screenBuffer[xx++]=0xBD;
  screenBuffer[xx]=0;
  MAX7456_WriteString(screenBuffer,getPosition(GPS_angleToHomePosition));
}

void displayDirectionToHome(void)
{
  if(!GPS_fix)
    return;
  if(GPS_distanceToHome <= 2 && Blink2hz)
    return;

  int16_t d = MwHeading + 180 + 360 - GPS_directionToHome;
  d *= 4;
  d += 45;
  d = (d/90)%16;

  screenBuffer[0] = 0x60 + d;
  //screenBuffer[1] = 0x81 + d;
  screenBuffer[1]=0;                //2
  MAX7456_WriteString(screenBuffer,getPosition(GPS_directionToHomePosition));
}

void displayCursor(void)
{
int cursorpos;
static const char CURSOR[] PROGMEM = "*";

if(ROW==10){
  if(COL==3) cursorpos=SAVEP+16-1;    // page
  if(COL==1) cursorpos=SAVEP-1;       // exit
  if(COL==2) cursorpos=SAVEP+6-1;     // save/exit
  }
  if(ROW<10){  
    if(configPage==1){
      if (ROW==9) ROW=7;
      if (ROW==8) ROW=10;
      if(COL==1) cursorpos=(ROW+2)*30+10;
      if(COL==2) cursorpos=(ROW+2)*30+10+6;  
      if(COL==3) cursorpos=(ROW+2)*30+10+6+6;
      }  
    if(configPage==2){
      COL=3;
      if (ROW==7) ROW=5;
      if (ROW==6) ROW=10;
      if (ROW==9) ROW=5;
      cursorpos=(ROW+2)*30+10+6+6;
      }      
    if(configPage==3){
      COL=3;
      if (ROW==1) ROW=2;
      if (ROW==9) ROW=6;
      if (ROW==7) ROW=10;
      cursorpos=(ROW+2)*30+10+6+6;
      }  
    if(configPage==4){
      COL=3;
      if (ROW==2) ROW=3;
      if (ROW==9) ROW=7;
      if (ROW==8) ROW=10;
      if ((ROW==6)||(ROW==7)) cursorpos=(ROW+2)*30+10+6+6-2;  // Narrow/Imperial strings longer
      else cursorpos=(ROW+2)*30+10+6+6;
      }  
    if(configPage==5){
      COL=3;
      if (ROW==9) ROW=7;
      if (ROW==8) ROW=10;   
      cursorpos=(ROW+2)*30+10+6+6;
      }
    if(configPage==6){
      ROW=10;
      }
  } 
  if(Blink10hz) MAX7456_WriteString_P(CURSOR,cursorpos);
}


void displayPIDConfigScreen(void)
{

  MAX7456_WriteString_P(configMsg0, SAVEP);		//EXIT
  MAX7456_WriteString_P(configMsg1, SAVEP+6);	//SaveExit
  MAX7456_WriteString_P(configMsg2, SAVEP+16);	//<Page>

  if(configPage==1)
  {
    MAX7456_WriteString_P(configMsg3, 38);
    MAX7456_WriteString_P(configMsg4, ROLLT);
    MAX7456_WriteString(itoa(P8[0],screenBuffer,10),ROLLP);
    MAX7456_WriteString(itoa(I8[0],screenBuffer,10),ROLLI);
    MAX7456_WriteString(itoa(D8[0],screenBuffer,10),ROLLD);

    MAX7456_WriteString_P(configMsg5, PITCHT);
    MAX7456_WriteString(itoa(P8[1],screenBuffer,10), PITCHP);
    MAX7456_WriteString(itoa(I8[1],screenBuffer,10), PITCHI);
    MAX7456_WriteString(itoa(D8[1],screenBuffer,10), PITCHD);

    MAX7456_WriteString_P(configMsg6, YAWT);
    MAX7456_WriteString(itoa(P8[2],screenBuffer,10),YAWP);
    MAX7456_WriteString(itoa(I8[2],screenBuffer,10),YAWI);
    MAX7456_WriteString(itoa(D8[2],screenBuffer,10),YAWD);

    MAX7456_WriteString_P(configMsg7, ALTT);
    MAX7456_WriteString(itoa(P8[3],screenBuffer,10),ALTP);
    MAX7456_WriteString(itoa(I8[3],screenBuffer,10),ALTI);
    MAX7456_WriteString(itoa(D8[3],screenBuffer,10),ALTD);

    MAX7456_WriteString_P(configMsg8, VELT);
    MAX7456_WriteString(itoa(P8[4],screenBuffer,10),VELP);
    MAX7456_WriteString(itoa(I8[4],screenBuffer,10),VELI);
    MAX7456_WriteString(itoa(D8[4],screenBuffer,10),VELD);

    MAX7456_WriteString_P(configMsg9, LEVT);
    MAX7456_WriteString(itoa(P8[7],screenBuffer,10),LEVP);
    MAX7456_WriteString(itoa(I8[7],screenBuffer,10),LEVI);
    MAX7456_WriteString(itoa(D8[7],screenBuffer,10),LEVD);

    MAX7456_WriteString_P(configMsg10, MAGT);
    MAX7456_WriteString(itoa(P8[8],screenBuffer,10),MAGP);

    MAX7456_WriteString("P",71);
    MAX7456_WriteString("I",77);
    MAX7456_WriteString("D",83);
  }

  if(configPage==2)
  {
    MAX7456_WriteString_P(configMsg11, 38);
    MAX7456_WriteString_P(configMsg12, ROLLT);
    MAX7456_WriteString(itoa(rcRate8,screenBuffer,10),ROLLD);
    MAX7456_WriteString_P(configMsg13, PITCHT);
    MAX7456_WriteString(itoa(rcExpo8,screenBuffer,10),PITCHD);
    MAX7456_WriteString_P(configMsg14, YAWT);
    MAX7456_WriteString(itoa(rollPitchRate,screenBuffer,10),YAWD);
    MAX7456_WriteString_P(configMsg15, ALTT);
    MAX7456_WriteString(itoa(yawRate,screenBuffer,10),ALTD);
    MAX7456_WriteString_P(configMsg16, VELT);
    MAX7456_WriteString(itoa(dynThrPID,screenBuffer,10),VELD);
    MAX7456_WriteString_P(configMsg17, LEVT);
    MAX7456_WriteString(itoa(cycleTime,screenBuffer,10),LEVD);
    MAX7456_WriteString_P(configMsg18, MAGT);
    MAX7456_WriteString(itoa(I2CError,screenBuffer,10),MAGD);
  }

  if(configPage==3)
  {
    MAX7456_WriteString_P(configMsg19, 35);
    MAX7456_WriteString_P(configMsg23, PITCHT);
    if(Settings[S_DISPLAYVOLTAGE]){
      MAX7456_WriteString_P(configMsg21, PITCHD);
    }
    else {
      MAX7456_WriteString_P(configMsg22, PITCHD);
    }
    MAX7456_WriteString_P(configMsg24, YAWT);
    MAX7456_WriteString(itoa(Settings[S_VOLTAGEMIN],screenBuffer,10),YAWD);
    MAX7456_WriteString_P(configMsg25, ALTT);

    if(Settings[S_DISPLAYTEMPERATURE] ){
      MAX7456_WriteString_P(configMsg21, ALTD);
    }
    else {
      MAX7456_WriteString_P(configMsg22, ALTD);
    }
    MAX7456_WriteString_P(configMsg26, VELT);
    MAX7456_WriteString(itoa(Settings[S_TEMPERATUREMAX],screenBuffer,10),VELD);
    MAX7456_WriteString_P(configMsg27, LEVT);

    if(Settings[S_DISPLAYGPS]){
      MAX7456_WriteString_P(configMsg21, LEVD);
     }
     else {
      MAX7456_WriteString_P(configMsg22, LEVD);
    }
  }

  if(configPage==4)
  {
    MAX7456_WriteString_P(configMsg31, 39);

    MAX7456_WriteString_P(configMsg32, ROLLT);
    MAX7456_WriteString(itoa(rssiADC,screenBuffer,10),ROLLD);

    MAX7456_WriteString_P(configMsg33, PITCHT);
    MAX7456_WriteString(itoa(rssi,screenBuffer,10),PITCHD);

    MAX7456_WriteString_P(configMsg34, YAWT);
    if(rssiTimer>0) MAX7456_WriteString(itoa(rssiTimer,screenBuffer,10),YAWD-5);
    MAX7456_WriteString(itoa(Settings[S_RSSIMIN],screenBuffer,10),YAWD);

    MAX7456_WriteString_P(configMsg35, ALTT);
    MAX7456_WriteString(itoa(Settings[S_RSSIMAX],screenBuffer,10),ALTD);

    MAX7456_WriteString_P(configMsg36, VELT);
    if(Settings[S_DISPLAYRSSI]){
      MAX7456_WriteString_P(configMsg21, VELD);
    }
    else{
      MAX7456_WriteString_P(configMsg22, VELD);
    }

    MAX7456_WriteString_P(configMsg37, LEVT);
    if(Settings[S_UNITSYSTEM]==METRIC){
      MAX7456_WriteString_P(configMsg38, LEVD-2);
    }
    else {
      MAX7456_WriteString_P(configMsg39, LEVD-2);
    }
  }

  if(configPage==5)
  {
    MAX7456_WriteString_P(configMsg43, 37);

    MAX7456_WriteString_P(configMsg44, ROLLT);
    if(accCalibrationTimer>0)
      MAX7456_WriteString(itoa(accCalibrationTimer,screenBuffer,10),ROLLD);
    else
      MAX7456_WriteString("-",ROLLD);

    MAX7456_WriteString_P(configMsg45, PITCHT);
    MAX7456_WriteString(itoa(MwAccSmooth[0],screenBuffer,10),PITCHD);

    MAX7456_WriteString_P(configMsg46, YAWT);
    MAX7456_WriteString(itoa(MwAccSmooth[1],screenBuffer,10),YAWD);

    MAX7456_WriteString_P(configMsg47, ALTT);
    MAX7456_WriteString(itoa(MwAccSmooth[2],screenBuffer,10),ALTD);

    MAX7456_WriteString_P(configMsg48, VELT);
    if(magCalibrationTimer>0)
      MAX7456_WriteString(itoa(magCalibrationTimer,screenBuffer,10),VELD);
    else
      MAX7456_WriteString("-",VELD);

    MAX7456_WriteString_P(configMsg49, LEVT);
    MAX7456_WriteString(itoa(MwHeading,screenBuffer,10),LEVD);

    MAX7456_WriteString_P(configMsg50, MAGT);
    if(eepromWriteTimer>0)
      MAX7456_WriteString(itoa(eepromWriteTimer,screenBuffer,10),MAGD);
    else
      MAX7456_WriteString("-",MAGD);
  }

  if(configPage==6)
  {
    MAX7456_WriteString_P(configMsg51, 38);

    MAX7456_WriteString_P(configMsg52, ROLLT);
    MAX7456_WriteString(itoa(trip,screenBuffer,10),ROLLD);

    MAX7456_WriteString_P(configMsg53, PITCHT);
    MAX7456_WriteString(itoa(distanceMAX,screenBuffer,10),PITCHD);

    MAX7456_WriteString_P(configMsg54, YAWT);
    MAX7456_WriteString(itoa(altitudeMAX,screenBuffer,10),YAWD);

    MAX7456_WriteString_P(configMsg55, ALTT);
    MAX7456_WriteString(itoa(speedMAX,screenBuffer,10),ALTD);

    MAX7456_WriteString_P(configMsg56, VELT);

    formatTime(flyingTime, screenBuffer, 1);
    MAX7456_WriteString(screenBuffer,VELD-7);

    MAX7456_WriteString_P(configMsg57, LEVT);
    int xx= pMeterSum / EST_PMSum;
    MAX7456_WriteString(itoa(xx,screenBuffer,10),LEVD);

    MAX7456_WriteString_P(configMsg58, MAGT);
    MAX7456_WriteString(itoa(temperMAX,screenBuffer,10),MAGD);
  }
  displayCursor();  // NEB mod cursor display
}
