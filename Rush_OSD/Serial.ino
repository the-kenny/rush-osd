
static uint8_t dataSize;
static uint8_t cmdMSP;
static uint8_t checksum;

int p=0;
int i=0;

uint32_t read32() {
  uint32_t t = read16();
  t+= (uint32_t)read16()<<16;
  return t;
}
uint16_t read16() {
  uint16_t t = read8();
  t+= (uint16_t)read8()<<8;
  return t;
}
uint8_t read8()  {
  return serialBuffer[p++]&0xff;
}

// --------------------------------------------------------------------------------------
// Here are decoded received commands from MultiWii
void serialMSPCheck()
{
  p=0;
  
  if (cmdMSP == MSP_OSD_READ){                           // for GUI communication
    serialWait = 1;
    for(int en=0;en<EEPROM_SETTINGS;en++){
      Serial.write("*");  
      Serial.write(en);
      Serial.write(',');
      Serial.write(EEPROM.read(en));
    }
    serialWait = 0;
  }
  if (cmdMSP == MSP_OSD_WRITE){                          // for GUI communication
    serialWait = 1; 
    for(int en=0;en<EEPROM_SETTINGS;en++){
      EEPROM.write(en,read8());
    }
  readEEPROM();
  serialWait = 0;
  }

  if (cmdMSP==MSP_IDENT)
  {
    MwVersion= read8();                             // MultiWii Firmware version

  }

  if (cmdMSP==MSP_STATUS)
  {
    cycleTime=read16();
    I2CError=read16();
    MwSensorPresent = read16();
    MwSensorActive = read32();
    read8(); //
  }

  if (cmdMSP==MSP_RAW_IMU)
  {
    for(i=0;i<3;i++) MwAccSmooth[i] = read16();    // for(i=0;i<3;i++) serialize16(accSmooth[i]);
  }

  if (cmdMSP==MSP_RC)
  {
    for(i=0;i<8;i++) MwRcData[i] = read16();
  }

  if (cmdMSP==MSP_RAW_GPS)
  {
    GPS_fix=read8();
    GPS_numSat=read8();
    GPS_latitude = read32();
    GPS_longitude = read32();
    GPS_altitude = read16();
    GPS_speed = read16();
    GPS_ground_course = read16();
  }

  if (cmdMSP==MSP_COMP_GPS)
  {
    GPS_distanceToHome=read16();
    GPS_directionToHome=read16();
    GPS_update=read8();
  }

  if (cmdMSP==MSP_ATTITUDE)
  {
    for(i=0;i<2;i++) MwAngle[i] = read16();
    MwHeading = read16();
    read16();
  }

  if (cmdMSP==MSP_ALTITUDE)
  {
    MwAltitude =read32();
    MwVario = read16();
  }

  if (cmdMSP==MSP_BAT)
   {
   MwVBat=read8();
   pMeterSum=read16();
   }


  if (cmdMSP==MSP_RC_TUNING)
  {

    rcRate8 = read8();
    rcExpo8 = read8();
    rollPitchRate = read8();
    yawRate = read8();
    dynThrPID = read8();
    thrMid8 = read8();
    thrExpo8 = read8();
  }

  if (cmdMSP==MSP_PID)
  {
    for(i=0; i<PIDITEMS; i++){
      P8[i] = read8();
      I8[i] = read8();
      D8[i] = read8();
    }


  }

  serialMSPStringOK=0;


  if((MwRcData[PITCHSTICK]>MAXSTICK)&&(MwRcData[YAWSTICK]>MAXSTICK)&&(MwRcData[THROTTLESTICK]>MINSTICK)&&!configMode&&!waitStick&&(allSec>5)&&!armed)
  {
    waitStick =1;
    configMode = 1;
    askPID=2;
  }

  //******************** EXIT from SHOW STATISTICS (menu page 6) AFTER DISARM (push throttle up) (Carlonb) NEB
  if(configMode&&!waitStick&&(MwRcData[THROTTLESTICK]>MINSTICK)&&previousarmedstatus) // EXIT
  {
    configExit();
  }

//if(configMode&&!waitStick&&(MwRcData[THROTTLESTICK]<MINSTICK)) // EXIT
  if(configMode&&!waitStick&&(MwRcData[THROTTLESTICK]<MINSTICK)&& !previousarmedstatus) // EXIT NEB mod for autostatistics
  {
    configExit();
  }

  if(configMode&&!waitStick&&(MwRcData[ROLLSTICK]>MAXSTICK)) // MOVE RIGHT
  {
    waitStick =1;
    COL++;
  }

  if(configMode&&!waitStick&&(MwRcData[ROLLSTICK]<MINSTICK)) // MOVE LEFT
  {
    waitStick =1;
    COL--;
  }

  if(configMode&&!waitStick&&(MwRcData[PITCHSTICK]>MAXSTICK)) // MOVE UP
  {
    waitStick =1;
    ROW--;
  }

  if(configMode&&!waitStick&&(MwRcData[PITCHSTICK]<MINSTICK)) // MOVE DOWN
  {
    waitStick =1;
    ROW++;
  }

  if(configMode&&!waitStick&&(MwRcData[YAWSTICK]<MINSTICK)&&!previousarmedstatus) // DECREASE
  {
    waitStick =1;
    if((ROW==1)&&(COL==1)&&(configPage==1)) P8[0]--;
    if((ROW==1)&&(COL==2)&&(configPage==1)) I8[0]--;
    if((ROW==1)&&(COL==3)&&(configPage==1)) D8[0]--;

    if((ROW==2)&&(COL==1)&&(configPage==1)) P8[1]--;
    if((ROW==2)&&(COL==2)&&(configPage==1)) I8[1]--;
    if((ROW==2)&&(COL==3)&&(configPage==1)) D8[1]--;

    if((ROW==3)&&(COL==1)&&(configPage==1)) P8[2]--;
    if((ROW==3)&&(COL==2)&&(configPage==1)) I8[2]--;
    if((ROW==3)&&(COL==3)&&(configPage==1)) D8[2]--;

    if((ROW==4)&&(COL==1)&&(configPage==1)) P8[3]--;
    if((ROW==4)&&(COL==2)&&(configPage==1)) I8[3]--;
    if((ROW==4)&&(COL==3)&&(configPage==1)) D8[3]--;

    if((ROW==5)&&(COL==1)&&(configPage==1)) P8[4]--;
    if((ROW==5)&&(COL==2)&&(configPage==1)) I8[4]--;
    if((ROW==5)&&(COL==3)&&(configPage==1)) D8[4]--;

    if((ROW==6)&&(COL==1)&&(configPage==1)) P8[7]--;
    if((ROW==6)&&(COL==2)&&(configPage==1)) I8[7]--;
    if((ROW==6)&&(COL==3)&&(configPage==1)) D8[7]--;

    if((ROW==7)&&(COL==1)&&(configPage==1)) P8[8]--;

    if((ROW==1)&&(COL==3)&&(configPage==2)) rcRate8--;
    if((ROW==2)&&(COL==3)&&(configPage==2)) rcExpo8--;
    if((ROW==3)&&(COL==3)&&(configPage==2)) rollPitchRate--;
    if((ROW==4)&&(COL==3)&&(configPage==2)) yawRate--;
    if((ROW==5)&&(COL==3)&&(configPage==2)) dynThrPID--;

    if((ROW==2)&&(COL==3)&&(configPage==3)) enableVoltage=!enableVoltage;
    if((ROW==3)&&(COL==3)&&(configPage==3)) lowVoltage--;
    if((ROW==4)&&(COL==3)&&(configPage==3)) enableTemperature=!enableTemperature;
    if((ROW==5)&&(COL==3)&&(configPage==3)) highTemperature--;
    if((ROW==6)&&(COL==3)&&(configPage==3)) displayGPS=!displayGPS;

    if((ROW==3)&&(COL==3)&&(configPage==4)) rssiTimer=15;
    if((ROW==4)&&(COL==3)&&(configPage==4)) rssiMax=rssiADC;
    if((ROW==5)&&(COL==3)&&(configPage==4)) enableRSSI=!enableRSSI;
    if((ROW==6)&&(COL==3)&&(configPage==4)) unitSystem=!unitSystem;
    if((ROW==7)&&(COL==3)&&(configPage==4)) screenType=!screenType;

    if((ROW==1)&&(COL==3)&&(configPage==5)) accCalibrationTimer=0;
    if((ROW==5)&&(COL==3)&&(configPage==5)) magCalibrationTimer=0;
    if((ROW==7)&&(COL==3)&&(configPage==5)) eepromWriteTimer=0;

    if((ROW==10)&&(COL==3)) configPage--;
    if(configPage<MINPAGE) configPage = MAXPAGE;
    if((ROW==10)&&(COL==1)) configExit();
    if((ROW==10)&&(COL==2)) saveExit();
  }

  if(configMode&&!waitStick&&(MwRcData[YAWSTICK]>MAXSTICK)) // INCREASE
  {
    waitStick =1;
    if((ROW==1)&&(COL==1)&&(configPage==1)) P8[0]++;
    if((ROW==1)&&(COL==2)&&(configPage==1)) I8[0]++;
    if((ROW==1)&&(COL==3)&&(configPage==1)) D8[0]++;

    if((ROW==2)&&(COL==1)&&(configPage==1)) P8[1]++;
    if((ROW==2)&&(COL==2)&&(configPage==1)) I8[1]++;
    if((ROW==2)&&(COL==3)&&(configPage==1)) D8[1]++;

    if((ROW==3)&&(COL==1)&&(configPage==1)) P8[2]++;
    if((ROW==3)&&(COL==2)&&(configPage==1)) I8[2]++;
    if((ROW==3)&&(COL==3)&&(configPage==1)) D8[2]++;

    if((ROW==4)&&(COL==1)&&(configPage==1)) P8[3]++;
    if((ROW==4)&&(COL==2)&&(configPage==1)) I8[3]++;
    if((ROW==4)&&(COL==3)&&(configPage==1)) D8[3]++;

    if((ROW==5)&&(COL==1)&&(configPage==1)) P8[4]++;
    if((ROW==5)&&(COL==2)&&(configPage==1)) I8[4]++;
    if((ROW==5)&&(COL==3)&&(configPage==1)) D8[4]++;

    if((ROW==6)&&(COL==1)&&(configPage==1)) P8[7]++;
    if((ROW==6)&&(COL==2)&&(configPage==1)) I8[7]++;
    if((ROW==6)&&(COL==3)&&(configPage==1)) D8[7]++;

    if((ROW==7)&&(COL==1)&&(configPage==1)) P8[8]++;

    if((ROW==1)&&(COL==3)&&(configPage==2)) rcRate8++;
    if((ROW==2)&&(COL==3)&&(configPage==2)) rcExpo8++;
    if((ROW==3)&&(COL==3)&&(configPage==2)) rollPitchRate++;
    if((ROW==4)&&(COL==3)&&(configPage==2)) yawRate++;
    if((ROW==5)&&(COL==3)&&(configPage==2)) dynThrPID++;


    if((ROW==2)&&(COL==3)&&(configPage==3)) enableVoltage=!enableVoltage;
    if((ROW==3)&&(COL==3)&&(configPage==3)) lowVoltage++;
    if((ROW==4)&&(COL==3)&&(configPage==3)) enableTemperature=!enableTemperature;
    if((ROW==5)&&(COL==3)&&(configPage==3)) highTemperature++;
    if((ROW==6)&&(COL==3)&&(configPage==3)) displayGPS=!displayGPS;



    if((ROW==3)&&(COL==3)&&(configPage==4)) rssiTimer=15;
    if((ROW==4)&&(COL==3)&&(configPage==4)) rssiMax=rssiADC;
    if((ROW==5)&&(COL==3)&&(configPage==4)) enableRSSI=!enableRSSI;
    if((ROW==6)&&(COL==3)&&(configPage==4)) unitSystem=!unitSystem;
    if((ROW==7)&&(COL==3)&&(configPage==4)) screenType=!screenType;

    if((ROW==1)&&(COL==3)&&(configPage==5)) accCalibrationTimer=CALIBRATION_DELAY;
    if((ROW==5)&&(COL==3)&&(configPage==5)) magCalibrationTimer=CALIBRATION_DELAY;
    if((ROW==7)&&(COL==3)&&(configPage==5)) eepromWriteTimer=EEPROM_WRITE_DELAY;

    if((ROW==10)&&(COL==3)) configPage++;
    if(configPage>MAXPAGE) configPage = MINPAGE;
    if((ROW==10)&&(COL==1)) configExit();
    if((ROW==10)&&(COL==2)) saveExit();
  }
}
// End of decoded received commands from MultiWii
// --------------------------------------------------------------------------------------

void serialMSPreceive()
{
  uint8_t c;

  static enum _serial_state {
    IDLE,
    HEADER_START,
    HEADER_M,
    HEADER_ARROW,
    HEADER_SIZE,
    HEADER_CMD,
  }
  c_state = IDLE;

  if(Serial.available())
  {
    c = Serial.read();

    if (c_state == IDLE)
    {
      c_state = (c=='$') ? HEADER_START : IDLE;
    }
    else if (c_state == HEADER_START)
    {
      c_state = (c=='M') ? HEADER_M : IDLE;
    }
    else if (c_state == HEADER_M)
    {
      c_state = (c=='>') ? HEADER_ARROW : IDLE;
    }
    else if (c_state == HEADER_ARROW)
    {
      if (c > SERIALBUFFERSIZE)
      {  // now we are expecting the payload size
        c_state = IDLE;
      }
      else
      {
        dataSize = c;
        c_state = HEADER_SIZE;
      }
    }
    else if (c_state == HEADER_SIZE)
    {
      c_state = HEADER_CMD;
      cmdMSP = c;
    }
    else if (c_state == HEADER_CMD)
    {
      serialBuffer[receiverIndex++]=c;
      if(receiverIndex>=dataSize)
      {
        receiverIndex=0;
        serialMSPStringOK=1;
        c_state = IDLE;
      }
      if(serialMSPStringOK) serialMSPCheck();
    }
  }
}

void configExit()
{
  configPage=1;
  ROW=10;
  COL=3;
  configMode=0;
  askPID=0;
  waitStick=3;
  previousarmedstatus = 0;
#if defined RESETSTATISTICS  // NEB added for reset statistics if defined
  trip=0;
  distanceMAX=0;
  altitudeMAX=0;
  speedMAX=0;
  flyingSecond=0;
#endif
}

void saveExit()
{
  waitStick=3;
  serialWait=0;

  if (configPage==1){
    Serial.write('$');
    Serial.write('M');
    Serial.write('<');
    checksum=0;
    dataSize=30;
    Serial.write((byte)dataSize);
    checksum ^= dataSize;
    Serial.write(MSP_SET_PID);
    checksum ^= MSP_SET_PID;
    for(i=0; i<PIDITEMS; i++){
      Serial.write(P8[i]);
      checksum ^= P8[i];
      Serial.write(I8[i]);
      checksum ^= I8[i];
      Serial.write(D8[i]);
      checksum ^= D8[i];
    }
    Serial.write((byte)checksum);
  }

  if (configPage==2){
    Serial.write('$');
    Serial.write('M');
    Serial.write('<');
    checksum=0;
    dataSize=7;
    Serial.write((byte)dataSize);
    checksum ^= dataSize;
    Serial.write(MSP_SET_RC_TUNING);
    checksum ^= MSP_SET_RC_TUNING;
    Serial.write(rcRate8);
    checksum ^= rcRate8;
    Serial.write(rcExpo8);
    checksum ^= rcExpo8;
    Serial.write(rollPitchRate);
    checksum ^= rollPitchRate;
    Serial.write(yawRate);
    checksum ^= yawRate;
    Serial.write(dynThrPID);
    checksum ^= dynThrPID;
    Serial.write(thrMid8);
    checksum ^= thrMid8;
    Serial.write(thrExpo8);
    checksum ^= thrExpo8;
    Serial.write((byte)checksum);
  }

  if (configPage==3 || configPage==4){
    writeEEPROM();
  }
  configExit();
}

void blankserialRequest(char requestMSP)
{
  Serial.write('$');
  Serial.write('M');
  Serial.write('<');
  Serial.write((byte)0x00);
  Serial.write(requestMSP);
  Serial.write(requestMSP);
}
