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

void FindNull(void)
{
  for(xx=0;screenBuffer[xx]!=0;xx++);
}

void displaySensors(void)
{
  if(MwSensorPresent&ACCELEROMETER) screenBuffer[0]=0xa0;
  else screenBuffer[0]=' ';
  if(MwSensorPresent&BAROMETER)     screenBuffer[1]=0xa2;
  else screenBuffer[1]=' ';
  if(MwSensorPresent&MAGNETOMETER)  screenBuffer[2]=0xa1;
  else screenBuffer[2]=' ';
  if(MwSensorPresent&GPSSENSOR)     screenBuffer[3]=0xa3;
  else screenBuffer[3]=' ';
  screenBuffer[4]=0;
  MAX7456_WriteString(screenBuffer,getPosition(sensorPosition));
}

void displayTemperature(void)                           // WILL WORK ONLY WITH V1.2
{
  if (unitSystem) temperature=temperature*1.8+32;       //Fahrenheit conversion for imperial system.
  if(temperature > temperMAX) temperMAX = temperature;
  itoa(temperature,screenBuffer,10);
  FindNull();   // find the NULL
  screenBuffer[xx++]=temperatureUnitAdd[unitSystem];
  screenBuffer[xx]=0;                                   // Restore the NULL
  MAX7456_WriteString(screenBuffer,getPosition(temperaturePosition));
}

void displayMode(void)
{
  if(MwSensorActive&STABLEMODE)   screenBuffer[0]=0xBE;
  else screenBuffer[0]=' ';
  if(MwSensorActive&BAROMODE)     screenBuffer[1]=0xBE;
  else screenBuffer[1]=' ';
  if(MwSensorActive&MAGMODE)      screenBuffer[2]=0xBE;
  else screenBuffer[2]=' ';
  if(MwSensorActive&GPSHOMEMODE)  screenBuffer[3]=0xBE;
  else {
    if(MwSensorActive&GPSHOLDMODE)  screenBuffer[3]=0xBE;
    else screenBuffer[3]=' ';
  }
  MAX7456_WriteString(screenBuffer,getPosition(sensorPosition)+LINE);
  if(MwSensorActive&STABLEMODE)
  {
    screenBuffer[0]=0xac;
    screenBuffer[1]=0xad;
  }
  else
  {
    screenBuffer[0]=0xae;
    screenBuffer[1]=0xaf;
  }
  screenBuffer[2]=' ';
  screenBuffer[3]=' ';
  if(GPS_fix)                    screenBuffer[3]=0xdf;
  if(MwSensorActive&GPSHOMEMODE) screenBuffer[3]=0xff;
  if(MwSensorActive&GPSHOLDMODE) screenBuffer[3]=0xef;
  screenBuffer[4]=0;
  MAX7456_WriteString(screenBuffer,getPosition(sensorPosition)+4);
}

void displayArmed(void)
{
  static const char _disarmed[] PROGMEM = "DISARMED";
  static const char _armed[] PROGMEM = " ARMED";

  armed = (MwSensorActive&ARMEDMODE);
  if(armedTimer==0)
    MAX7456_WriteString_P(_disarmed, getPosition(motorArmedPosition));
  else if((armedTimer>1) && (armedTimer<9) && (Blink10hz))
    MAX7456_WriteString_P(_armed, getPosition(motorArmedPosition));
}

void displayHorizonPart(int X,int Y,int roll)
{
  // Roll Angle will be between -45 and 45 this is converted to 0-56 to fit with DisplayHorizonPart function
  X=X*(0.6)+28;
  if(X>56) X=56;
  if(X<0) X=0;
  // 7 row, 8 lines per row, mean 56 different case per segment, 2 segment now
  xx=X/8;
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

#if defined(DISPLAY_HORIZON_BR)
  //Draw center screen
  screen[219-30]=0x03;
  screen[224-30-1]=0x1D;
  screen[224-30+1]=0x1D;
  screen[224-30]=0x01;
  screen[229-30]=0x02;
#if defined WITHDECORATION
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
#endif
#endif
}

void displayVoltage(void)
{
#if defined VIDVOLTAGE_VBAT
  vidvoltage=MwVBat;
#endif
#if defined MAINVOLTAGE_VBAT
  voltage=MwVBat;
#endif

  ItoaPadded(voltage, screenBuffer, 4, 3);
  screenBuffer[4] = voltageUnitAdd;
  screenBuffer[5] = 0;
  MAX7456_WriteString(screenBuffer,getPosition(voltagePosition));

#if defined SHOWBATLEVELEVOLUTION
  if (voltage < 105) screenBuffer[0]=0x96;
  else if (voltage < 108) screenBuffer[0]=0x95;
  else if (voltage < 110) screenBuffer[0]=0x94;
  else if (voltage < 115) screenBuffer[0]=0x93;
  else if (voltage < 120) screenBuffer[0]=0x92;
  else if (voltage < 122) screenBuffer[0]=0x91;
  else screenBuffer[0]=0x90;                              // Max charge icon
#else
  screenBuffer[0]=0x97;
#endif
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(voltagePosition)-1);

#if defined VIDVOLTAGE
  ItoaPadded(vidvoltage, screenBuffer, 4, 3);
  screenBuffer[4]=voltageUnitAdd;
  screenBuffer[5]=0;
  MAX7456_WriteString(screenBuffer,getPosition(vidvoltagePosition));

  screenBuffer[0]=0x97;
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(vidvoltagePosition)-1);
#endif
}

void displayCurrentThrottle(void)
{                                                                                  // CurentThrottlePosition is set in Config.h to line 11 above flyTimePosition
  
  if (MwRcData[THROTTLESTICK] > HighT) HighT = MwRcData[THROTTLESTICK] -5;         
  if (MwRcData[THROTTLESTICK] < LowT) LowT = MwRcData[THROTTLESTICK];              // Calibrate high and low throttle settings  --defaults set in GlobalVariables.h 1100-1900
  screenBuffer[0]=0xC8;
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(CurrentThrottlePosition));
  if(!armed) {
    screenBuffer[0]=' ';
    screenBuffer[1]=' ';
    screenBuffer[2]='-';
    screenBuffer[3]='-';
    screenBuffer[4]=0;
    MAX7456_WriteString(screenBuffer,getPosition(CurrentThrottlePosition)+1);
  }
  else
  {
    int CurThrottle = map(MwRcData[THROTTLESTICK],LowT,HighT,0,100);
    ItoaPadded(CurThrottle,screenBuffer,3,0);
    screenBuffer[3]='%';
    screenBuffer[4]=0;
    MAX7456_WriteString(screenBuffer,getPosition(CurrentThrottlePosition)+1);
  }
}

void displayTime(void)
{
  if(flyMinute>0) flyingMinute=flyMinute;
  if(flySecond>0) flyingSecond=flySecond;
  screenBuffer[0]=flyTimeUnitAdd;
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(flyTimePosition));
  itoa(flyMinute,screenBuffer,10);
  FindNull();
  screenBuffer[xx++]=0x3a;
  screenBuffer[xx]=0;    // find the NULL
  if(flyMinute<10) xx=2;
  if(flyMinute>=10) xx=3;
  if(flyMinute>=100) xx=4;
  MAX7456_WriteString(screenBuffer,getPosition(flyTimePosition)+1);


  itoa(flySecond,screenBuffer,10);
  if(flySecond<10)
  {
    screenBuffer[1]=screenBuffer[0];
    screenBuffer[0]='0';
  }

  MAX7456_WriteString(screenBuffer,getPosition(flyTimePosition)+1+xx);
  screenBuffer[0]=onTimeUnitAdd;
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(onTimePosition));
  itoa(onMinute,screenBuffer,10);
  FindNull();
  screenBuffer[xx++]=0x3a;
  screenBuffer[xx]=0;                          // Find the NULL
  if(onMinute<10) xx=2;
  if(onMinute>=10) xx=3;
  if(onMinute>=100) xx=4;
  MAX7456_WriteString(screenBuffer,getPosition(onTimePosition)+1);
  itoa(onSecond,screenBuffer,10);
  if(onSecond<10)
  {
    screenBuffer[1]=screenBuffer[0];
    screenBuffer[0]='0';
    screenBuffer[2]=0;
  }
  MAX7456_WriteString(screenBuffer,getPosition(onTimePosition)+1+xx);
}

void displayAmperage(void)
{
  // Real Ampere is ampere / 10
  ItoaPadded(amperage, screenBuffer, 4, 3);     // 99.9 ampere max!
  screenBuffer[4]=amperageUnitAdd;
  screenBuffer[5]=0;
  MAX7456_WriteString(screenBuffer,getPosition(amperagePosition));
}

void displaypMeterSum(void)
{
#if defined (HARDSENSOR)
  pMeterSum = amperagesum;
#endif
  int xx=0;
  int pos;
  screenBuffer[0]=0xa4;
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(pMeterSumPosition));
  if(!unitSystem) xx= pMeterSum / EST_PMSum;
  itoa(xx,screenBuffer,10);
  MAX7456_WriteString(screenBuffer,getPosition(pMeterSumPosition)+1);
}

void displayRSSI(void)
{
  // Calcul et affichage du Rssi
  itoa(rssi,screenBuffer,10);
  FindNull();   // Trouve le NULL
  screenBuffer[xx++]='%';
  screenBuffer[xx++]=0;
  MAX7456_WriteString(screenBuffer,getPosition(rssiPosition));
  screenBuffer[0]=rssiUnitAdd;
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(rssiPosition)-1);
}

void displayHeading(void)
{
  int16_t heading = MwHeading;
#if defined HEADING360
  if(heading < 0)
    heading += 360;
  ItoaPadded(heading,screenBuffer,3,0);
  screenBuffer[3]=MwHeadingUnitAdd;                 // Restore the NULL by the unit Symbols
  screenBuffer[4]=0;
#else
  ItoaPadded(heading,screenBuffer,4,0);
  screenBuffer[4]=MwHeadingUnitAdd;                 // Restore the NULL by the unit Symbols
  screenBuffer[5]=0;
#endif
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

  MAX7456_WriteString_P((char*)pgm_read_word(&(introMessages[0])), RushduinoVersionPosition);

#if defined VideoSignalType_NTSC
  MAX7456_WriteString_P((char*)pgm_read_word(&(introMessages[1])), RushduinoVersionPosition+30);
#endif

#if defined VideoSignalType_PAL
  MAX7456_WriteString_P((char*)pgm_read_word(&(introMessages[2])), RushduinoVersionPosition+30);
#endif

  if(screenType==WIDE){
    MAX7456_WriteString_P((char*)pgm_read_word(&(introMessages[3])), RushduinoVersionPosition+60);
  }
  else{
    MAX7456_WriteString_P((char*)pgm_read_word(&(introMessages[4])), RushduinoVersionPosition+60);
  }
#if defined MULTIWIILOGO
  MAX7456_WriteString_P(MultiWiiLogoL1Add, RushduinoVersionPosition+120);
  MAX7456_WriteString_P(MultiWiiLogoL2Add, RushduinoVersionPosition+120+LINE);
  MAX7456_WriteString_P(MultiWiiLogoL3Add, RushduinoVersionPosition+120+LINE+LINE);
#endif

  MAX7456_WriteString_P((char*)pgm_read_word(&(introMessages[5])), RushduinoVersionPosition+120+LINE+LINE+LINE);
  MAX7456_WriteString(itoa(MwVersion,screenBuffer,10),RushduinoVersionPosition+128+LINE+LINE+LINE);

  MAX7456_WriteString_P((char*)pgm_read_word(&(introMessages[6])), RushduinoVersionPosition+120+LINE+LINE+LINE+LINE+LINE);
  MAX7456_WriteString_P((char*)pgm_read_word(&(introMessages[7])), RushduinoVersionPosition+125+LINE+LINE+LINE+LINE+LINE+LINE);
  MAX7456_WriteString_P((char*)pgm_read_word(&(introMessages[8])), RushduinoVersionPosition+125+LINE+LINE+LINE+LINE+LINE+LINE+LINE);
}

void displayGPSPosition(void)
{
  if(!GPS_fix)
    return;
    
#if defined COORDINATES
  screenBuffer[0]=0xCA;
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(MwGPSLatPosition));
  FormatGPSCoord(GPS_latitude,screenBuffer,3,'N','S');
  MAX7456_WriteString(screenBuffer,getPosition(MwGPSLatPosition)+1);

  screenBuffer[0]=0xCB;
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(MwGPSLonPosition));
  FormatGPSCoord(GPS_longitude,screenBuffer,4,'E','W');
  MAX7456_WriteString(screenBuffer,getPosition(MwGPSLonPosition)+1);
#endif

  screenBuffer[0]=0xCC;
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(MwGPSAltPosition));
  itoa(GPS_altitude,screenBuffer,10);
  FindNull();
  MAX7456_WriteString(screenBuffer,getPosition(MwGPSAltPosition)+1);
}

void displayNumberOfSat(void)
{
  screenBuffer[0]=GPS_numSatAdd[0];    // Remplace le NULL par le/les symboles d'unité
  screenBuffer[1]=GPS_numSatAdd[1];    // Restore le NULL
  screenBuffer[2]=0;
  MAX7456_WriteString(screenBuffer,getPosition(GPS_numSatPosition));

  itoa(GPS_numSat,screenBuffer,10);

  MAX7456_WriteString(screenBuffer,getPosition(GPS_numSatPosition)+2);
}

void displayGPS_speed(void)
{
  if(!GPS_fix)
    return;

  int xx=0;
  int pos;
  screenBuffer[0]=speedUnitAdd[unitSystem];
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(speedPosition));
  if(!unitSystem) xx= GPS_speed * 0.036;
  itoa(xx,screenBuffer,10);
  if (xx > speedMAX) speedMAX = xx;
  MAX7456_WriteString(screenBuffer,getPosition(speedPosition)+1);
}

void displayAltitude(void)
{
  MwAltitude=MwAltitude;
  if(!altitudeOk&&(allSec>5)&&armed)
  {
    altitudeOk=MwAltitude;
    altitudeMAX=MwAltitude;
  }
  if(!armed) {
    altitudeOk=MwAltitude;
  }
  if(unitSystem)  altitude = MwAltitude/100;
  if(!unitSystem) altitude = MwAltitude/100;
  screenBuffer[0]=MwAltitudeAdd[unitSystem];
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(MwAltitudePosition));
  if(altitudeOk && (altitude > altitudeMAX)) altitudeMAX = altitude;
  itoa(altitude,screenBuffer,10);
  MAX7456_WriteString(screenBuffer,getPosition(MwAltitudePosition)+1);
}

void displayClimbRate(void)
{
  climbRate=MwVario;
  int xx=0;
  int pos;
  screenBuffer[0]=MwClimbRateAdd[unitSystem];
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(MwClimbRatePosition));

  if(!unitSystem) xx= climbRate / 100;
  if(unitSystem)  xx= climbRate / 100;
  itoa(xx,screenBuffer,10);
  MAX7456_WriteString(screenBuffer,getPosition(MwClimbRatePosition)+1);

   if (climbRate > 70)   screenBuffer[0]=0xB3;  
  else
    if (climbRate > 50)    screenBuffer[0]=0xB2; 
    else
      if (climbRate > 30)    screenBuffer[0]=0xB1;  
      else
        if (climbRate > 20)  screenBuffer[0]=0xB0; 
        else screenBuffer[0]=0xBC;
 
  if (climbRate < -70)  screenBuffer[0]=0xB4;
  else
    if (climbRate < -50)   screenBuffer[0]=0xB5;
    else
      if (climbRate < -30)   screenBuffer[0]=0xB6;
      else
        if (climbRate < -20) screenBuffer[0]=0xB7;
  screenBuffer[1]=0;
  if (climbRate>= -20) pos = getPosition(MwClimbRatePosition)-2; 
  else pos = getPosition(MwClimbRatePosition)-2+LINE;
  MAX7456_WriteString(screenBuffer,pos);
}

void displayDistanceToHome(void)
{
  if(!GPS_fix)
    return;

  screenBuffer[0]=0xb8;
  screenBuffer[1]=0;
  MAX7456_WriteString(screenBuffer,getPosition(GPS_distanceToHomePosition));
  if(unitSystem) GPS_distanceToHome = GPS_distanceToHome * 3.28;

  if(GPS_distanceToHome > distanceMAX) distanceMAX = GPS_distanceToHome;

  itoa(GPS_distanceToHome,screenBuffer,10);
  FindNull();
  screenBuffer[xx++]=GPS_distanceToHomeAdd[unitSystem];
  screenBuffer[xx]=0;
  MAX7456_WriteString(screenBuffer,getPosition(GPS_distanceToHomePosition)+1);
}

void displayAngleToHome(void)
{
  if(!GPS_fix)
    return;
  if(GPS_distanceToHome <= 2 && Blink2hz)
    return;

  itoa(GPS_directionToHome,screenBuffer,10);
  FindNull();
  screenBuffer[xx++]=0xBD;
  screenBuffer[xx]=0;
  MAX7456_WriteString(screenBuffer,getPosition(GPS_angleToHomePosition));
}

void displayDirectionToHome(void)
{
  /*if(!GPS_fix)
    return;*/
  if(GPS_distanceToHome <= 2 && Blink2hz)
    return;

  int16_t d = MwHeading + 22 + 180 + 360 - GPS_directionToHome;
  d = ((d % 360) / 22.5);            //2* (( )/45)

  screenBuffer[0] = 0x60 + d;
  //screenBuffer[1] = 0x81 + d;
  screenBuffer[1]=0;                //2
  MAX7456_WriteString(screenBuffer,getPosition(GPS_directionToHomePosition));
}

void displayPIDConfigScreen(void)
{
  char CURSOR[]="*";

  MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[0])), SAVEP);		//EXIT
  MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[1])), SAVEP+6);	//SaveExit
  MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[2])), SAVEP+16);	//<Page>

  if(configPage==1)
  {
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[3])), 38);
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[4])), ROLLT);
    MAX7456_WriteString(itoa(P8[0],screenBuffer,10),ROLLP);
    MAX7456_WriteString(itoa(I8[0],screenBuffer,10),ROLLI);
    MAX7456_WriteString(itoa(D8[0],screenBuffer,10),ROLLD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[5])), PITCHT);
    MAX7456_WriteString(itoa(P8[1],screenBuffer,10), PITCHP);
    MAX7456_WriteString(itoa(I8[1],screenBuffer,10), PITCHI);
    MAX7456_WriteString(itoa(D8[1],screenBuffer,10), PITCHD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[6])), YAWT);
    MAX7456_WriteString(itoa(P8[2],screenBuffer,10),YAWP);
    MAX7456_WriteString(itoa(I8[2],screenBuffer,10),YAWI);
    MAX7456_WriteString(itoa(D8[2],screenBuffer,10),YAWD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[7])), ALTT);
    MAX7456_WriteString(itoa(P8[3],screenBuffer,10),ALTP);
    MAX7456_WriteString(itoa(I8[3],screenBuffer,10),ALTI);
    MAX7456_WriteString(itoa(D8[3],screenBuffer,10),ALTD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[8])), VELT);
    MAX7456_WriteString(itoa(P8[4],screenBuffer,10),VELP);
    MAX7456_WriteString(itoa(I8[4],screenBuffer,10),VELI);
    MAX7456_WriteString(itoa(D8[4],screenBuffer,10),VELD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[9])), LEVT);
    MAX7456_WriteString(itoa(P8[7],screenBuffer,10),LEVP);
    MAX7456_WriteString(itoa(I8[7],screenBuffer,10),LEVI);
    MAX7456_WriteString(itoa(D8[7],screenBuffer,10),LEVD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[10])), MAGT);
    MAX7456_WriteString(itoa(P8[8],screenBuffer,10),MAGP);

    MAX7456_WriteString("P",71);
    MAX7456_WriteString("I",77);
    MAX7456_WriteString("D",83);
  }

  if(configPage==2)
  {
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[11])), 38);
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[12])), ROLLT);
    MAX7456_WriteString(itoa(rcRate8,screenBuffer,10),ROLLD);
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[13])), PITCHT);
    MAX7456_WriteString(itoa(rcExpo8,screenBuffer,10),PITCHD);
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[14])), YAWT);
    MAX7456_WriteString(itoa(rollPitchRate,screenBuffer,10),YAWD);
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[15])), ALTT);
    MAX7456_WriteString(itoa(yawRate,screenBuffer,10),ALTD);
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[16])), VELT);
    MAX7456_WriteString(itoa(dynThrPID,screenBuffer,10),VELD);
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[17])), LEVT);
    MAX7456_WriteString(itoa(cycleTime,screenBuffer,10),LEVD);
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[18])), MAGT);
    MAX7456_WriteString(itoa(I2CError,screenBuffer,10),MAGD);
  }

  if(configPage==3)
  {
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[19])), 35);
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[23])), PITCHT);
    if(enableVoltage){
      MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[21])), PITCHD);
    }
    else {
      MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[22])), PITCHD);
    }
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[24])), YAWT);
    MAX7456_WriteString(itoa(lowVoltage,screenBuffer,10),YAWD);
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[25])), ALTT);

    if(enableTemperature){
      MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[21])), ALTD);
    }
    else {
      MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[22])), ALTD);
    }
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[26])), VELT);
    MAX7456_WriteString(itoa(highTemperature,screenBuffer,10),VELD);
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[27])), LEVT);

    if(displayGPS){
      MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[21])), LEVD);
     }
     else {
      MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[22])), LEVD);
    }
  }

  if(configPage==4)
  {
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[31])), 39);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[32])), ROLLT);
    MAX7456_WriteString(itoa(rssiADC,screenBuffer,10),ROLLD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[33])), PITCHT);
    MAX7456_WriteString(itoa(rssi,screenBuffer,10),PITCHD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[34])), YAWT);
    if(rssiTimer>0) MAX7456_WriteString(itoa(rssiTimer,screenBuffer,10),YAWD-5);
    MAX7456_WriteString(itoa(rssiMin,screenBuffer,10),YAWD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[35])), ALTT);
    MAX7456_WriteString(itoa(rssiMax,screenBuffer,10),ALTD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[36])), VELT);
    if(enableRSSI){
      MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[21])), VELD);
    }
    else{
      MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[22])), VELD);
    }

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[37])), LEVT);
    if(unitSystem==METRIC){
      MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[38])), LEVD-2);
    }
    else {
      MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[39])), LEVD-2);
    }

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[40])), MAGT);
    if(screenType==NARROW){
      MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[41])), MAGD-2);
    }
    else {
      MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[42])), MAGD-1);
    }
  }

  if(configPage==5)
  {
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[43])), 37);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[44])), ROLLT);
    if(accCalibrationTimer>0)
      MAX7456_WriteString(itoa(accCalibrationTimer,screenBuffer,10),ROLLD);
    else
      MAX7456_WriteString("-",ROLLD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[45])), PITCHT);
    MAX7456_WriteString(itoa(MwAccSmooth[0],screenBuffer,10),PITCHD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[46])), YAWT);
    MAX7456_WriteString(itoa(MwAccSmooth[1],screenBuffer,10),YAWD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[47])), ALTT);
    MAX7456_WriteString(itoa(MwAccSmooth[2],screenBuffer,10),ALTD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[48])), VELT);
    if(magCalibrationTimer>0)
      MAX7456_WriteString(itoa(magCalibrationTimer,screenBuffer,10),VELD);
    else
      MAX7456_WriteString("-",VELD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[49])), LEVT);
    MAX7456_WriteString(itoa(MwHeading,screenBuffer,10),LEVD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[50])), MAGT);
    if(eepromWriteTimer>0)
      MAX7456_WriteString(itoa(eepromWriteTimer,screenBuffer,10),MAGD);
    else
      MAX7456_WriteString("-",MAGD);
  }

  if(configPage==6)
  {
    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[51])), 38);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[52])), ROLLT);
    MAX7456_WriteString(itoa(trip,screenBuffer,10),ROLLD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[53])), PITCHT);
    MAX7456_WriteString(itoa(distanceMAX,screenBuffer,10),PITCHD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[54])), YAWT);
    MAX7456_WriteString(itoa(altitudeMAX,screenBuffer,10),YAWD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[55])), ALTT);
    MAX7456_WriteString(itoa(speedMAX,screenBuffer,10),ALTD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[56])), VELT);

    strcpy_P(screenBuffer, (char*)pgm_read_word(&(configMsgs[30]))); //screenBuffer cleaning.
    itoa(flyingMinute,screenBuffer,10);
    if(flyingMinute<10) {
      screenBuffer[1]=0x3a;
      xx=2;
    }
    else {
      screenBuffer[2]=0x3a;
      xx=3;
    }
    MAX7456_WriteString(screenBuffer,VELD);

    itoa(flyingSecond,screenBuffer,10);
    if(flyingSecond<10)
    {
      screenBuffer[1]=screenBuffer[0];
      screenBuffer[0]='0';
    }
    MAX7456_WriteString(screenBuffer,VELD+xx);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[57])), LEVT);
    if(!unitSystem) xx= pMeterSum / EST_PMSum;
    MAX7456_WriteString(itoa(xx,screenBuffer,10),LEVD);

    MAX7456_WriteString_P((char*)pgm_read_word(&(configMsgs[58])), MAGT);
    MAX7456_WriteString(itoa(temperMAX,screenBuffer,10),MAGD);
  }

  if(ROW>10) ROW=10;
  if(ROW<1) ROW=1;
  if(COL>3) COL=3;
  if(COL<1) COL=1;

  cursorPostion=configPage*100+ROW*10+COL;

  if(Blink10hz) switch(cursorPostion)
  {

  case 111:
    MAX7456_WriteString(CURSOR,ROLLP-1);
    break;
  case 112:
    MAX7456_WriteString(CURSOR,ROLLI-1);
    break;
  case 113:
    MAX7456_WriteString(CURSOR,ROLLD-1);
    break;
  case 121:
    MAX7456_WriteString(CURSOR,PITCHP-1);
    break;
  case 122:
    MAX7456_WriteString(CURSOR,PITCHI-1);
    break;
  case 123:
    MAX7456_WriteString(CURSOR,PITCHD-1);
    break;
  case 131:
    MAX7456_WriteString(CURSOR,YAWP-1);
    break;
  case 132:
    MAX7456_WriteString(CURSOR,YAWI-1);
    break;
  case 133:
    MAX7456_WriteString(CURSOR,YAWD-1);
    break;
  case 141:
    MAX7456_WriteString(CURSOR,ALTP-1);
    break;
  case 142:
    MAX7456_WriteString(CURSOR,ALTI-1);
    break;
  case 143:
    MAX7456_WriteString(CURSOR,ALTD-1);
    break;
  case 151:
    MAX7456_WriteString(CURSOR,VELP-1);
    break;
  case 152:
    MAX7456_WriteString(CURSOR,VELI-1);
    break;
  case 153:
    MAX7456_WriteString(CURSOR,VELD-1);
    break;
  case 161:
    MAX7456_WriteString(CURSOR,LEVP-1);
    break;
  case 162:
    MAX7456_WriteString(CURSOR,LEVI-1);
    break;
  case 163:
    MAX7456_WriteString(CURSOR,LEVD-1);
    break;
  case 171:
    MAX7456_WriteString(CURSOR,MAGP-1);
    break;
  case 172:
    COL=1;
    break;
  case 173:
    COL=1;
    break;
  case 181:
    ROW=10;
    break;
  case 191:
    ROW=7;
    break;
  case 192:
    ROW=7;
    break;
  case 193:
    ROW=7;
    break;
  case 201:
    MAX7456_WriteString(CURSOR,SAVEP-1);
    break;  // exit
  case 202:
    MAX7456_WriteString(CURSOR,SAVEP+6-1);
    break; // saveexit
  case 203:
    MAX7456_WriteString(CURSOR,SAVEP+16-1);
    break; // PAGE

  case 211:
    COL=3;
    break;
  case 212:
    COL=3;
    break;
  case 213:
    MAX7456_WriteString(CURSOR,ROLLD-1);
    break;
  case 221:
    COL=3;
    break;
  case 222:
    COL=3;
    break;
  case 223:
    MAX7456_WriteString(CURSOR,PITCHD-1);
    break;
  case 231:
    COL=3;
    break;
  case 232:
    COL=3;
    break;
  case 233:
    MAX7456_WriteString(CURSOR,YAWD-1);
    break;
  case 241:
    COL=3;
    break;
  case 242:
    COL=3;
    break;
  case 243:
    MAX7456_WriteString(CURSOR,ALTD-1);
    break;
  case 251:
    COL=3;
    break;
  case 252:
    COL=3;
    break;
  case 253:
    MAX7456_WriteString(CURSOR,VELD-1);
    break;
  case 263:
    ROW=9;
    break;
  case 291:
    ROW=5;
    break;
  case 292:
    ROW=5;
    break;
  case 293:
    ROW=5;
    break;
  case 301:
    MAX7456_WriteString(CURSOR,SAVEP-1);
    break;  // exit
  case 302:
    MAX7456_WriteString(CURSOR,SAVEP+6-1);
    break; // saveexit
  case 303:
    MAX7456_WriteString(CURSOR,SAVEP+16-1);
    break; // PAGE



  case 311:
    COL=3;
    break;
  case 312:
    COL=3;
    break;
  case 313:
    MAX7456_WriteString(CURSOR,ROLLD-1);
    break;
  case 321:
    COL=3;
    break;
  case 322:
    COL=3;
    break;
  case 323:
    MAX7456_WriteString(CURSOR,PITCHD-1);
    break;
  case 331:
    COL=3;
    break;
  case 332:
    COL=3;
    break;
  case 333:
    MAX7456_WriteString(CURSOR,YAWD-1);
    break;
  case 341:
    COL=3;
    break;
  case 342:
    COL=3;
    break;
  case 343:
    MAX7456_WriteString(CURSOR,ALTD-1);
    break;
  case 351:
    COL=3;
    break;
  case 352:
    COL=3;
    break;
  case 353:
    MAX7456_WriteString(CURSOR,VELD-1);
    break;
  case 361:
    COL=3;
    break;
  case 362:
    COL=3;
    break;
  case 363:
    MAX7456_WriteString(CURSOR,LEVD-1);
    break;
  case 371:
    COL=3;
    break;
  case 372:
    COL=3;
    break;
  case 373:
    MAX7456_WriteString(CURSOR,MAGD-1);
    break;
  case 383:
    ROW=10;
    break;
 case 391:
    ROW=7;
    break;
  case 392:
    ROW=7;
    break;
  case 393:
    ROW=7;
    break;
  case 401:
    MAX7456_WriteString(CURSOR,SAVEP-1);
    break;  // exit
  case 402:
    MAX7456_WriteString(CURSOR,SAVEP+6-1);
    break; // saveexit
  case 403:
    MAX7456_WriteString(CURSOR,SAVEP+16-1);
    break; // PAGE


  case 421:
    COL=3;
    ROW=3;
    break;
  case 422:
    COL=3;
    ROW=3;
    break;
  case 423:
    COL=3;
    ROW=3;
    break;
  case 431:
    COL=3;
    break;
  case 432:
    COL=3;
    break;
  case 433:
    MAX7456_WriteString(CURSOR,YAWD-1);
    break;
  case 441:
    COL=3;
    break;
  case 442:
    COL=3;
    break;
  case 443:
    MAX7456_WriteString(CURSOR,ALTD-1);
    break;
  case 451:
    COL=3;
    break;
  case 452:
    COL=3;
    break;
  case 453:
    MAX7456_WriteString(CURSOR,VELD-1);
    break;
  case 461:
    COL=3;
    break;
  case 462:
    COL=3;
    break;
  case 463:
    MAX7456_WriteString(CURSOR,LEVD-3);
    break;
  case 471:
    COL=3;
    break;
  case 472:
    COL=3;
    break;
  case 473:
    MAX7456_WriteString(CURSOR,MAGD-3);
    break;
 case 483:
    ROW=10;
    break;
case 491:
    ROW=7;
    break;
  case 492:
    ROW=7;
    break;
  case 493:
    ROW=7;
    break;
  case 501:
    MAX7456_WriteString(CURSOR,SAVEP-1);
    break;  // exit
  case 502:
    MAX7456_WriteString(CURSOR,SAVEP+6-1);
    break; // save
  case 503:
    MAX7456_WriteString(CURSOR,SAVEP+16-1);
    break; // PAGE

  case 511:
    COL=3;
    break;
  case 512:
    COL=3;
    break;
  case 513:
    MAX7456_WriteString(CURSOR,ROLLD-1);
    break;
  case 521:
    COL=3;
    ROW=5;
    break;
  case 522:
    COL=3;
    ROW=5;
    break;
  case 523:
    COL=3;
    ROW=5;
    break;
  case 541:
    COL=3;
    ROW=1;
    break;
  case 542:
    COL=3;
    ROW=1;
    break;
  case 543:
    COL=3;
    ROW=1;
    break;
  case 551:
    COL=3;
    break;
  case 552:
    COL=3;
    break;
  case 553:
    MAX7456_WriteString(CURSOR,VELD-1);
    break;
  case 571:
    COL=3;
    break;
  case 572:
    COL=3;
    break;
  case 573:
    MAX7456_WriteString(CURSOR,MAGD-1);
    break;
  case 583:
    ROW=10;
    break;
  case 591:
    ROW=7;
    break;
  case 592:
    ROW=7;
    break;
  case 593:
    ROW=7;
    break;
  case 601:
    MAX7456_WriteString(CURSOR,SAVEP-1);
    break;  // exit
  case 602:
    MAX7456_WriteString(CURSOR,SAVEP+6-1);
    break; // saveexit
  case 603:
    MAX7456_WriteString(CURSOR,SAVEP+16-1);
    break; // PAGE


  case 691:
    ROW=10;
    break;  // exit
  case 692:
    ROW=10;
    break;  // exit
  case 693:
    ROW=10;
    break;  // exit

  case 701:
    MAX7456_WriteString(CURSOR,SAVEP-1);
    break;  // exit
  case 702:
    MAX7456_WriteString(CURSOR,SAVEP+6-1);
    break; // save
  case 703:
    MAX7456_WriteString(CURSOR,SAVEP+16-1);
    break; // PAGE
  }
}
