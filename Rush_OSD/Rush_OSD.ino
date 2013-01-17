// This software is a copy of the original Rushduino-OSD project was written by Jean-Gabriel Maurice.
// http://code.google.com/p/rushduino-osd/
// For more information about this software <  Multiwii forum > http://www.multiwii.com/forum/viewtopic.php?f=8&t=922
// For new code releases http://code.google.com/p/rush-osd-development/
// Thanks to all developers that contributed before us, and all users that help us to improve.
// This team wish you great flights.



              /***********************************************************************************************************************************************/
              /*                                                           RUSH_KV_2.2                                                                       */
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
              /*                                                      Created for Multiwii r1240 or higher                                                    */
              /************************************************************************************************************************************************/


              // This software communicates using MSP via the serial port. Therefore Multiwii develop-dependent.
              // Changes the values of pid and rc-tuning, writes in eeprom of Multiwii FC.
              // In config mode, can do acc and mag calibration.
              // In addition, it works by collecting information analogue inputs. Such as voltage, amperage, rssi, temperature on the original hardware (RUSHDUINO).
              // At the end of the flight may be useful to look at the statistics.


              /***********************************************************************************************************************************************/
              /*                                                                 RUSH_KV_2.2                                                                 */
              /*                                                                                                                                             */
              /*                                                                                                                                             */
              /***********************************************************************************************************************************************/


#include <avr/pgmspace.h>
#include <EEPROM.h> //Needed to access eeprom read/write functions
#include <Metro.h>
#include "Config.h"
#include "GlobalVariables.h"

// Screen is the Screen buffer between program an MAX7456 that will be writen to the screen at 10hz
char screen[480];
// ScreenBuffer is an intermietary buffer to created Strings to send to Screen buffer
char screenBuffer[20];
char nextMSPrequest=0;
char MSPcmdsend=0;

void setup()
{
  Serial.begin(SERIAL_SPEED);
  Serial.flush();
  pinMode(BST,OUTPUT);
  MAX7456Setup();
  readEEPROM();
  analogReference(INTERNAL);
}

void loop()
{
  // Process AI
  #if defined RUSHDUINO
  temperature=(analogRead(temperaturePin)*1.1)/10.23;
  voltage=(analogRead(voltagePin)*1.1*DIVIDERRATIO)/102.3;
  vidvoltage=(analogRead(vidvoltagePin)*1.1*VIDDIVIDERRATIO)/102.3;
  rssiADC = (analogRead(rssiPin)*1.1)/1023;
  amperage = (AMPRERAGE_OFFSET - (analogRead(amperagePin)*AMPERAGE_CAL))/10.23;
  #endif

  // Blink Basic Sanity Test Led at 1hz
  if(tenthSec>10) BST_ON else BST_OFF

  if(MetroTimer.check()==1)  // this execute 20 times per second
  {
    tenthSec++;
    halfSec++;
    Blink10hz=!Blink10hz;
    calculateTrip();
    calculateRssi();

    MetroTimer.interval(TIMEBASE);
    if(!serialWait)
    {
                                //******************** Every second request faster AH Contribution of TrailBlazer ****************************//
      nextMSPrequest++;
      switch (nextMSPrequest) {
      case 1:
        MSPcmdsend=MSP_IDENT;
        break;
      case 2:
        MSPcmdsend=MSP_ATTITUDE;
        break;
      case 3:
        MSPcmdsend=MSP_STATUS;
        break;
      case 4:
        MSPcmdsend=MSP_ATTITUDE;
        break;
      case 5:
        MSPcmdsend=MSP_RAW_IMU;
        break;
      case 6:
        MSPcmdsend=MSP_ATTITUDE;
        break;
      case 7:
        MSPcmdsend=MSP_RAW_GPS;
        break;
      case 8:
        MSPcmdsend=MSP_ATTITUDE;
        break;
      case 9:
        MSPcmdsend=MSP_COMP_GPS;
        break;
      case 10:
        MSPcmdsend=MSP_ATTITUDE;
        break;
      case 11:
        MSPcmdsend=MSP_ALTITUDE;
        break;
      case 12:
        MSPcmdsend=MSP_ATTITUDE;
        break;
      case 13:
        MSPcmdsend=MSP_RC_TUNING;
        break;
      case 14:
        MSPcmdsend=MSP_ATTITUDE;
        break;
      case 15:
        MSPcmdsend=MSP_PID;
        break;
      case 16:
        MSPcmdsend=MSP_ATTITUDE;
        break;
      case 17:
        MSPcmdsend=MSP_BAT;
        break;
      case 201:
        MSPcmdsend=MSP_STATUS;
        break;
      case 202:
        MSPcmdsend=MSP_RAW_IMU;
        break;
      case 203:
        MSPcmdsend=MSP_ATTITUDE;
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
      }

      blankserialRequest(MSPcmdsend);
    }

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
        if(enableVoltage&&((voltage>lowVoltage)||(Blink2hz))) displayVoltage();
        if(enableRSSI&&((rssi>lowrssiAlarm)||(Blink2hz))) displayRSSI();

        displayTime();
        displaySensors();
        displayMode();

        if(enableTemperature&&((temperature<highTemperature)||(Blink2hz))) displayTemperature();

#if defined HARDSENSOR
        displayAmperage();
#endif
        displaypMeterSum();
        displayArmed();
#if defined THROTTLEPOSITION
        displayCurrentThrottle();
#endif

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

          if (displayGPS)
            displayGPSPosition();
        }
      }
    }
  }

  if(halfSec>=10){
    halfSec=0;
    Blink2hz=!Blink2hz;
    if(waitStick) waitStick=waitStick-1;
  }

  if(tenthSec>=20)     // this execute 1 time a second
  {
    onSecond++;

#if defined HARDSENSOR
    amperagesum += amperage / AMPDIVISION; //(mAh)
#endif

    tenthSec=0;
    armedTimer++;

    if(!armed) {
      armedTimer=0;
      flyMinute=0;
      flySecond=0;
    }
    else {
      flySecond++;
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
      rssiMin=rssiADC;
      rssiTimer=0;
    }
    if(rssiTimer>0) rssiTimer--;
  }

  if(onSecond>=60)    // this execute each minute
  {
    onMinute++;
    onSecond=0;
  }
  if(flySecond>=60)    // this execute each minute
  {
    flyMinute++;
    flySecond=0;
  }
  serialMSPreceive();
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
  aa = ((aa-rssiMin) *101)/(rssiMax-rssiMin) ;
  rssi_Int += ( ( (signed int)((aa*rssiSample) - rssi_Int )) / rssiSample );
  rssi = rssi_Int / rssiSample ;
  if(rssi<0) rssi=0;
  if(rssi>100) rssi=100;
}

void writeEEPROM(void)
{
  EEPROM.write(EEPROM_RSSIMIN,rssiMin);
  EEPROM.write(EEPROM_RSSIMAX,rssiMax);
  EEPROM.write(EEPROM_DISPLAYRSSI,enableRSSI);
  EEPROM.write(EEPROM_DISPLAYVOLTAGE,enableVoltage);
  EEPROM.write(EEPROM_VOLTAGEMIN,lowVoltage);
  EEPROM.write(EEPROM_DISPLAYTEMPERATURE,enableTemperature);
  EEPROM.write(EEPROM_TEMPERATUREMAX,highTemperature);
  EEPROM.write(EEPROM_DISPLAYGPS,displayGPS);
  EEPROM.write(EEPROM_SCREENTYPE,screenType);
  EEPROM.write(EEPROM_UNITSYSTEM,unitSystem);
  EEPROM.write(EEPROM_MAINVOLTAGE_VBAT,MAINVOLTAGE_VBAT);
}

void readEEPROM(void)
{
  rssiMin= EEPROM.read(EEPROM_RSSIMIN);
  rssiMax= EEPROM.read(EEPROM_RSSIMAX);
  enableRSSI= EEPROM.read(EEPROM_DISPLAYRSSI);
  enableVoltage= EEPROM.read(EEPROM_DISPLAYVOLTAGE);
  lowVoltage= EEPROM.read(EEPROM_VOLTAGEMIN);
  enableTemperature= EEPROM.read(EEPROM_DISPLAYTEMPERATURE);
  highTemperature= EEPROM.read(EEPROM_TEMPERATUREMAX);
  displayGPS= EEPROM.read(EEPROM_DISPLAYGPS);
  screenType= !!EEPROM.read(EEPROM_SCREENTYPE);
  unitSystem= !!EEPROM.read(EEPROM_UNITSYSTEM);
  MAINVOLTAGE_VBAT = EEPROM.read(EEPROM_MAINVOLTAGE_VBAT);
  
}
