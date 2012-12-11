// This software is a copy of the original Rushduino-OSD project was written by Jean-Gabriel Maurice.
// http://code.google.com/p/rushduino-osd/
// It's open source, simple and seems easy editable.
// I have the original Hrdware since released.
// Rushduino_V9 beta 0.7 software was the last one that the autor coded and big problems of compatibility with MWC where found at the time.
// Rushduino project has been forgotten for a long time. 
// Modelci started to make some arrangements without having the original hardware, it is a bit dificult to know the compatibility of the code.
// After all this I decided to keep it working for future releases of MWC with or without help.
// For more information about this hardware Multiwii forum http://www.multiwii.com/forum/viewtopic.php?f=8&t=922
// For new code releases http://code.google.com/p/rush-osd-development/
// In near future I pretend to have my one site dedicated to Aerial Drones/Photography and FPV stuff related. I will share it. 
// As I am not a coder professionaly, developments are going to be slower but I intend to keep them going with the new needs to come. 
// All the things that I possibly do with this software are intended to be my needs I just hope they can meet yours.
// Along the code are mencioned credits to people who helped me debugging and implementing new features. 
// I wish you great flights with Rushduino OSD. 


              /************************************************************************************************************************************************/
              /*                                                      Created for Multiwii r1240 or higher                                                    */
              /************************************************************************************************************************************************/


              // This software communicates using MSP via the serial port. Therefore Multiwii develop-dependent.
              // Changes the values of pid and rc-tuning, writes in eeprom of Multiwii FC.
              // In config mode, can do acc and mag calibration. 
              // In addition, it works by collecting information analogue inputs. Such as voltage, amperage, rssi, temperature.
              // In addition displayed information provides status information using an LED.
              // At the end of the flight may be useful to look at the statistics.




              /***********************************************************************************************************************************************/
              /*                                                           RUSH_KV_2.0 Kataventos                                                            */
              /*                                                                                                                                             */
              /*                  1-Division adjustment for PowerMeter;                                                                                      */
              /*                  2-Analogue video voltage working;                                                                                          */
              /*                  3-Option between Vbat and analogue read for MAIN and VIDEO voltages;                                                       */
              /*                  4-MaxSpeed debugged on statistics;                                                                                         */
              /*                  5-AltitudeMax debugged on statistics;                                                                                      */
              /*                  6-Amperage offset and amperage calibration djustment on config.h;                                                          */
              /*                  7-Multiwii logo lives again, can be supressed on config.h                                                                  */
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
  //readEEPROM();
  analogReference(INTERNAL);
}

void loop()
{
  // Process AI
  temperature=(analogRead(temperaturePin)*1.1)/10.23;  
  voltage=(analogRead(voltagePin)*1.1*DIVIDERRATIO)/102.3;
  vidvoltage=(analogRead(vidvoltagePin)*1.1*VIDDIVIDERRATIO)/102.3;
  rssiADC = (analogRead(rssiPin)*1.1)/1023;
  amperage = (AMPRERAGE_OFFSET - (analogRead(amperagePin)*AMPERAGE_CAL))/10.23;

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
  
    MAX7456_DrawScreen(screen,0);
    if( allSec < 9 ) displayIntro();
    else
    { 

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
          
          if (displayGPS) displayGPSPosition();

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
 if(GPS_fix && (GPS_speed>0)) trip = ((GPS_speed * 1000)/3600)*0.1; 
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
  screenType= EEPROM.read(EEPROM_SCREENTYPE);
  unitSystem= EEPROM.read(EEPROM_UNITSYSTEM);
 
}


