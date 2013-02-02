





// This software is a copy of the original Rushduino-OSD project was written by Jean-Gabriel Maurice. http://code.google.com/p/rushduino-osd/
// For more information if you have a original Rushduino OSD <Multiwii forum>  http://www.multiwii.com/forum/viewtopic.php?f=8&t=922
// For more information if you have a Minim OSD <Multiwii forum>  http://www.multiwii.com/forum/viewtopic.php?f=8&t=2918
// For new code releases http://code.google.com/p/rush-osd-development/
// Thanks to all developers that coded this software before us, and all users that also help us to improve.
// This team wish you great flights.



              /***********************************************************************************************************************************************/
              /*                                                            KV_OSD_Team                                                                      */
              /*                                                                                                                                             */
              /*                                                                                                                                             */
              /*                                             This software is the result of a team work                                                      */
              /*                                                                                                                                             */
              /*                                     KATAVENTOS               ITAIN                    CARLONB                                               */
              /*                         POWER67                                                                                                             */
              /*                                                                                                                                             */
              /*                                                                                                                                             */
              /*                                                                                                                                             */
              /*                                                                                                                                             */
              /***********************************************************************************************************************************************/




              /************************************************************************************************************************************************/
              /*                         Created for Multiwii r1240 or higher and using the KV_OSD_Team_1.0.mcm Chararter map file.                            */
              /************************************************************************************************************************************************/


              // This software communicates using MSP via the serial port. Therefore Multiwii develop-dependent.
              // Changes the values of pid and rc-tuning, writes in eeprom of Multiwii FC.
              // In config mode, can do acc and mag calibration.
              // In addition, it works by collecting information analogue inputs. Such as voltage, amperage, rssi, temperature on the original hardware (RUSHDUINO).
              // At the end of the flight may be useful to look at the statistics.


              /***********************************************************************************************************************************************/
              /*                                                            KV_OSD_Team_2.2                                                                  */
              /*                                                                                                                                             */
              /*                                                                                                                                             */
              /***********************************************************************************************************************************************/


#include <avr/pgmspace.h>
#include <EEPROM.h> //Needed to access eeprom read/write functions
#include "symbols.h"
#include "Config.h"
#include "GlobalVariables.h"

// Screen is the Screen buffer between program an MAX7456 that will be writen to the screen at 10hz
char screen[480];
// ScreenBuffer is an intermietary buffer to created Strings to send to Screen buffer
char screenBuffer[20];
char nextMSPrequest=0;
char MSPcmdsend=0;

//-------------- Timed Service Routine vars (No more needed Metro.h library)

// May be moved in GlobalVariables.h
unsigned long previous_millis_low=0;
unsigned long previous_millis_high =0;
int hi_speed_cycle = 50;
int lo_speed_cycle = 100;
//----------------


void setup()
{
  Serial.begin(SERIAL_SPEED);
  Serial.flush();
  pinMode(BST,OUTPUT);
  checkEEPROM();
  readEEPROM();
  MAX7456Setup();
  
  analogReference(INTERNAL);
  
  MSPcmdsend=MSP_IDENT;            // Moved here from main loop as called once
  blankserialRequest(MSPcmdsend);
}

void loop()
{
  // Process AI
  if (Settings[S_ENABLEADC]){
    temperature=(analogRead(temperaturePin)*1.1)/10.23;
    if (!Settings[S_MAINVOLTAGE_VBAT]){
      static uint8_t ind = 0;
      static uint16_t voltageRawArray[8];
      voltageRawArray[(ind++)%8] = analogRead(voltagePin);                  
      uint16_t voltageRaw = 0;
      for (uint8_t i=0;i<8;i++)
        voltageRaw += voltageRawArray[i];
      voltage = ((voltageRaw *1.1*Settings[S_DIVIDERRATIO])/102.3) /8;  
    }
    if (!Settings[S_VIDVOLTAGE_VBAT]){
      vidvoltage=(analogRead(vidvoltagePin)*1.1*Settings[S_VIDDIVIDERRATIO])/102.3;
    }
    if (!Settings[S_MWRSSI]){
      rssiADC = (analogRead(rssiPin)*1.1)/1023;
    } 
    amperage = (AMPRERAGE_OFFSET - (analogRead(amperagePin)*AMPERAGE_CAL))/10.23;
  }

  // Blink Basic Sanity Test Led at 1hz
  if(tenthSec>10) BST_ON else BST_OFF


//---------------  Start Timed Service Routines  ---------------------------------------
unsigned long currentMillis = millis();

  if((currentMillis - previous_millis_low) >= lo_speed_cycle)  // 10 Hz (Executed every 100ms)
  {
    previous_millis_low = currentMillis;    
    if(!serialWait){
      MSPcmdsend=MSP_ATTITUDE;
      blankserialRequest(MSPcmdsend);
    }
  }  // End of slow Timed Service Routine (100ms loop)
 
  
  if((currentMillis - previous_millis_high) >= hi_speed_cycle)  // 20 Hz (Executed every 50ms)
  {
    previous_millis_high = currentMillis;   

    tenthSec++;
    halfSec++;
    Blink10hz=!Blink10hz;
    calculateTrip();
    if(Settings[S_DISPLAYRSSI]) calculateRssi();

    if(!serialWait) {
      nextMSPrequest++;
      switch (nextMSPrequest) {
//      case 1:
//        MSPcmdsend=MSP_IDENT;
//        break;
      case 1:
        MSPcmdsend=MSP_STATUS;    // Single serial data call every 450ms (50ms x 9 serial calls ----> 2.2 Hz)
        break;
      case 2:
        MSPcmdsend=MSP_RAW_IMU;
        break;
      case 3:
        MSPcmdsend=MSP_RAW_GPS;
        break;
      case 4:
        MSPcmdsend=MSP_COMP_GPS;
        break;
      case 5:
        MSPcmdsend=MSP_ALTITUDE;
        break;
      case 6:
        MSPcmdsend=MSP_RC_TUNING;
        break;
      case 7:
        MSPcmdsend=MSP_PID;
        break;
      case 8:
        MSPcmdsend=MSP_BAT;
        break;
        
      case 201:
        MSPcmdsend=MSP_STATUS;
        break;
      case 202:
        MSPcmdsend=MSP_RAW_IMU;
        break;

      default:
        MSPcmdsend=MSP_RC;
        if(askPID==0)
        {
          nextMSPrequest = 0;
        }
        else
        {
          nextMSPrequest = 200;
        }
        break;
      } // end of case
      blankserialRequest(MSPcmdsend);      
    } // End of serial wait
    
    
    MAX7456_DrawScreen();
    if( allSec < 9 ) displayIntro();
    else
    {
      if(armed){
        previousarmedstatus=1;
      }
      if(previousarmedstatus && !armed){
        configPage=6;
        ROW=10;
        COL=1;
        configMode=1;
      }
      if(configMode)
      {
        displayPIDConfigScreen();
      }
      else
      {
        CollectStatistics();
        if(Settings[S_DISPLAYVOLTAGE]&&((voltage>Settings[S_VOLTAGEMIN])||(Blink2hz))) displayVoltage();
        if(Settings[S_DISPLAYRSSI]&&((rssi>lowrssiAlarm)||(Blink2hz))) displayRSSI();

        displayTime();
        displayMode();

        if(Settings[S_DISPLAYTEMPERATURE]&&((temperature<Settings[S_TEMPERATUREMAX])||(Blink2hz))) displayTemperature();

#if defined HARDSENSOR
        displayAmperage();
#endif
        displaypMeterSum();
        displayArmed();
        if (Settings[S_THROTTLEPOSITION]) displayCurrentThrottle();

        if(MwSensorPresent&ACCELEROMETER) displayHorizon(MwAngle[0],MwAngle[1]*-1);
        if(MwSensorPresent&MAGNETOMETER)  {
          displayHeadingGraph();
          displayHeading();
        }
        if(MwSensorPresent&BAROMETER)     {
          displayAltitude();
          displayClimbRate();
        }
        if(MwSensorPresent&GPSSENSOR)     {
          displayNumberOfSat();
          displayDirectionToHome();
          displayDistanceToHome();
          displayAngleToHome();
          displayGPS_speed();

          if (Settings[S_DISPLAYGPS])
            displayGPSPosition();
        }
      }
    }       
  }  // End of fast Timed Service Routine (20ms loop)


  if(halfSec>=10){
    halfSec=0;
    Blink2hz=!Blink2hz;
    if(waitStick) waitStick=waitStick-1;
  }

  if(tenthSec>=20)     // this execute 1 time a second
  {
    onTime++;

#if defined HARDSENSOR
    amperagesum += amperage / AMPDIVISION; //(mAh)
#endif

    tenthSec=0;
    armedTimer++;

    if(!armed) {
      armedTimer=0;
      flyTime=0;
    }
    else {
      flyTime++;
      flyingTime++;
      configMode=0;
    }
    allSec++;

    if((accCalibrationTimer==1)&&(configMode)) {
      MSPcmdsend = MSP_ACC_CALIBRATION;
      blankserialRequest(MSPcmdsend);
      accCalibrationTimer=0;
    }

    if((magCalibrationTimer==1)&&(configMode)) {
      MSPcmdsend = MSP_MAG_CALIBRATION;
      blankserialRequest(MSPcmdsend);
      magCalibrationTimer=0;
    }

    if((eepromWriteTimer==1)&&(configMode)) {
      MSPcmdsend = MSP_EEPROM_WRITE;
      blankserialRequest(MSPcmdsend);
      eepromWriteTimer=0;
    }

    if(accCalibrationTimer>0) accCalibrationTimer--;
    if(magCalibrationTimer>0) magCalibrationTimer--;
    if(eepromWriteTimer>0) eepromWriteTimer--;

    if((rssiTimer==1)&&(configMode)) {
      Settings[S_RSSIMIN]=rssiADC;
      rssiTimer=0;
    }
    if(rssiTimer>0) rssiTimer--;
  }

  serialMSPreceive();

}  // End of main loop
//---------------------  End of Timed Service Routine ---------------------------------------


void CollectStatistics() {
  if(GPS_fix && GPS_speed > speedMAX)
    speedMAX = GPS_speed;
}

void calculateTrip(void)
{
  if(GPS_fix && (GPS_speed>0))
    trip += GPS_speed *0.0005;                  // NEB mod : 100/1000*50=0.0005  cm/sec ---> mt/50msec (trip var is float)
}

void calculateRssi(void)
{
  float aa=0;
  aa =  analogRead(rssiPin)/4;
  aa = ((aa-Settings[S_RSSIMIN]) *101)/(Settings[S_RSSIMAX]-Settings[S_RSSIMIN]) ;
  rssi_Int += ( ( (signed int)((aa*rssiSample) - rssi_Int )) / rssiSample );
  rssi = rssi_Int / rssiSample ;
  if(rssi<0) rssi=0;
  if(rssi>100) rssi=100;
}

void writeEEPROM(void)
{
 for(int en=0;en<EEPROM_SETTINGS;en++){
  if (EEPROM.read(en) != Settings[en]) EEPROM.write(en,Settings[en]);
 } 
}

void readEEPROM(void)
{
 for(int en=0;en<EEPROM_SETTINGS;en++){
   Settings[en] = EEPROM.read(en);
 }
}

// for first run to ini
void checkEEPROM(void)
{
  int EEPROM_Loaded = EEPROM.read(0);
  if (!EEPROM_Loaded){
    for(int en=0;en<EEPROM_SETTINGS;en++){
     if (EEPROM.read(en) != EEPROM_DEFAULT[en]) EEPROM.write(en,EEPROM_DEFAULT[en]);
    }
  }
}

