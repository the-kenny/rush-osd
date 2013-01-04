
                                      /**********************************************************************************/
                                      /*    RUSH KV 2.1               Configurable parameters        RUSH KV 2.1        */
                                      /**********************************************************************************/

// ____________________________________________________________________General configuration________________________________________________________________________//


//******************************************   Define your OSD Board   ****************************************/

//#define MINIMOSD
#define RUSHDUINO

/*******************************************  Video System  ***********************************/

#define VideoSignalType_PAL
const char videoSignalType=1;

//#define VideoSignalType_NTSC
//const char videoSignalType=0;

/**********************       Serial speed      ************************/

#define SERIAL_SPEED 115200

/*******************************************      Mode Active (you MUST define according your MWC options)      *****************************/
/*
Only MWii version newer than 2.1 (including dev versions)
How to config correctly the Mode active in order to show sensors and Arm/Disarm indication:
-) Take a look at "MultiWii.ino" file of MWii sketch in "enum box...."
-) Assign a power of 2 for each sensor/device defined in MWii "config.h" skipping sensor/devices not defined.
-) These found numbers are to be defined here....
*/
#define STABLEMODE     1            // OK
#define BAROMODE       4            // OK
#define MAGMODE        8            // OK
//#define BOXCAMSTAB     16         // not used
#define ARMEDMODE      32           // OK
#define GPSHOMEMODE    64           // OK
#define GPSHOLDMODE    128          // OK
//#define BOXCAMTRIG     256        // not used

/*
// MWii version 2.1 and older
#define STABLEMODE     1
#define BAROMODE       2
#define MAGMODE        4
#define ARMEDMODE      32
#define GPSHOMEMODE    64
#define GPSHOLDMODE    128
*/

/**********    Here you can define time out for Mag calibration and EEProm write (mostly useful for mag calibration)    ***********/

#define CALIBRATION_DELAY 10
#define EEPROM_WRITE_DELAY 5

/***************************************        Voltage and Amperage        ********************************************/
 /*                                                                                                                     */
  /************** Voltage match multimeter (you can change this options to match your setup/requirements) ****************/

#define DIVIDERRATIO 25             // Main voltage ratio
#define VIDDIVIDERRATIO 25          // Video voltage ratio
//#define VIDVOLTAGE_VBAT           // Uncomment to change from VIDEO VLOTAGE Analog Pin to MwVbat (must be defined on MWcode)
//#define MAINVOLTAGE_VBAT          // Uncomment to change from MAIN VLOTAGE Analog Pin to MwVbat (must be defined on MWcode)

#define EST_PMSum 2.6                 /****  NOTE  **** If you use hardware CURRENT sensor on OSD use (#define EST_PMSum 1) BEFORE ANY ADJUSTMENT OR CALIBRATION
                                                      this value is empirical and you can find "yours" after some flights using the same instructions as for VBAT adjustment
                                                      on Mwc (first you have to MWC fine tune your voltage (VBat))                                                            ****/

//#define HARDSENSOR                // Uncomment to change from MW_POWERMETER to Hard current sensor on analogue Pin (MW_POWERMETER is DEFAULT and must be defined on MWCode)
#define AMPDIVISION 3600            // Hardware current sensor division ratio
#define AMPERAGE_CAL 1.1            // Amperage calibration
#define AMPRERAGE_OFFSET 512        // Amperage = AMPRERAGE_OFFSET - analogRead * AMPERAGE_CAL / 10.23


/*****************************      Climb rate adjust      **********************************/

#define ESTCLIMB 60                 // Here you can adjust Climb rate (60 is empirical value)

/**********************************         Display Settings         ************************/

#define GPSALT_UNDERSPEED           // GPS altitude is displayed under GPS speed comment to deactivate
#define DISPLAY_HORIZON_BR
#define DISPLAY_GPSPOSITION
#define COORDINATES                 // Uncomment to display coordinates and altitude on the orinal place (use with display GPS ON, on OSD page 3)
#define WITHDECORATION
#define SHOWHEADING
#define HEADING360                  // Heading shows as 0..359; Comment for -179..180
//#define SHOWBATLEVELEVOLUTION     // Uncomment to display battery evolution
#define MULTIWIILOGO                // Comment to supress Multiwii logo at start up, good to use other character maps
//#define VIDVOLTAGE                // Uncomment if you want to display video voltage
#define DECIMAL '.'                 // Decimal point character, change to what suits you best (.) (,)

/********************       For Sensors presence      *********************/

#define ACCELEROMETER  1//0b00000001
#define BAROMETER      2//0b00000010
#define MAGNETOMETER   4//0b00000100
#define GPSSENSOR      8//0b00001000
//#define SONAR         16//0b00010000

/*********************      Led output      *******************************/

#define BST 7                        // pin 7 for original Rushduino Board
#define BST_OFF digitalWrite(BST,LOW);
#define BST_ON digitalWrite(BST,HIGH);


/********************      Analog input defines     ***********************/

const uint8_t voltagePin=0;
const uint8_t vidvoltagePin=2;
const uint8_t amperagePin=1;
const uint8_t rssiPin=3;
const uint8_t temperaturePin=6;    // Temperature pin 6 for original Rushduino Board V1.2
const uint8_t rssiSample=30;
const uint8_t lowrssiAlarm=75;     // This will make blink the Rssi if lower then this value


/*----------------------------------------------       End of configurable parameters      ----------------------------------------------------*/



/******************       FOR DEBUG ONLY      ********************/

#define TIMEBASE_X1   50
#define TIMEBASE  TIMEBASE_X1
#define LINE      30
#define LINE01    0
#define LINE02    30
#define LINE03    60
#define LINE04    90
#define LINE05    120
#define LINE06    150
#define LINE07    180
#define LINE08    210
#define LINE09    240
#define LINE10    270
#define LINE11    300
#define LINE12    330
#define LINE13    360
#define LINE14    390
#define LINE15    420
#define LINE16    450

#define PIDITEMS 10

// RX CHANEL IN MwRcData table
#define ROLLSTICK        0
#define PITCHSTICK       1
#define YAWSTICK         2
#define THROTTLESTICK    3

// STICK POSITION
#define MAXSTICK         1900
#define MINSTICK         1100
#define MINTROTTLE       1150

// FOR POSITION OF PID CONFIG VALUE
#define ROLLT 93
#define ROLLP 101
#define ROLLI 107
#define ROLLD 113
#define PITCHT 93+(30*1)
#define PITCHP 101+(30*1)
#define PITCHI 107+(30*1)
#define PITCHD 113+(30*1)
#define YAWT 93+(30*2)
#define YAWP 101+(30*2)
#define YAWI 107+(30*2)
#define YAWD 113+(30*2)
#define ALTT 93+(30*3)
#define ALTP 101+(30*3)
#define ALTI 107+(30*3)
#define ALTD 113+(30*3)
#define VELT 93+(30*4)
#define VELP 101+(30*4)
#define VELI 107+(30*4)
#define VELD 113+(30*4)
#define LEVT 93+(30*5)
#define LEVP 101+(30*5)
#define LEVI 107+(30*5)
#define LEVD 113+(30*5)
#define MAGT 93+(30*6)
#define MAGP 101+(30*6)
#define MAGI 107+(30*6)
#define MAGD 113+(30*6)

#define SAVEP 93+(30*9)


// DEFINE CONFIGURATION MENU PAGES
#define MINPAGE 1
#define MAXPAGE 6

// EEPROM LOCATION IN ARDUINO EEPROM MAP
#define EEPROM_RSSIMIN             1
#define EEPROM_RSSIMAX             2
#define EEPROM_DISPLAYRSSI         3
#define EEPROM_DISPLAYVOLTAGE      4
#define EEPROM_VOLTAGEMIN          5
#define EEPROM_DISPLAYTEMPERATURE  6
#define EEPROM_TEMPERATUREMAX      7
#define EEPROM_DISPLAYGPS          8
#define EEPROM_SCREENTYPE         9
#define EEPROM_UNITSYSTEM         10

// POSITION OF EACH CHARACTER OR LOGO IN THE MAX7456
const unsigned char speedUnitAdd[2] ={
  0xa5,0xa6} ; // [0][0] and [0][1] = Km/h   [1][0] and [1][1] = Mph
const unsigned char AHUnitAdd[8] = {
  0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17};
const unsigned char voltageUnitAdd = 0xa9;
const unsigned char temperatureUnitAdd[2] = {
  0x0e,0x0d};
const unsigned char flyTimeUnitAdd=0x9c;
const unsigned char onTimeUnitAdd=0x9b;
const unsigned char amperageUnitAdd = 0x9a;

const unsigned char rssiUnitAdd = 0xba;
const unsigned char sensorAdd[4] = {
  0xa0,0xa1,0xa2,0xa4}; //acc,mag,bar,GPS

#if defined MULTIWIILOGO
const char MultiWiiLogoL1Add[17] PROGMEM = {
  0xd0,0xd1,0xd2,0xd3,0xd4,0xd5,0xd6,0xd7,0xd8,0xd9,0xda,0xdb,0xdc,0xdd,0xde,0};
const char MultiWiiLogoL2Add[17] PROGMEM = {
  0xe0,0xe1,0xe2,0xe3,0xe4,0xe5,0xe6,0xe7,0xe8,0xe9,0xea,0xeb,0xec,0xed,0xee,0};
const char MultiWiiLogoL3Add[17] PROGMEM = {
  0xf0,0xf1,0xf2,0xf3,0xf4,0xf5,0xf6,0xf7,0xf8,0xf9,0xfa,0xfb,0xfc,0xfd,0xfe,0};
#endif

const unsigned char MwHeadingUnitAdd=0xbd;
const unsigned char GPS_numSatAdd[2]={
  0x1e,0x1f};
const unsigned char MwAltitudeAdd[2]={
  0xa7,0xa8};
const unsigned char MwClimbRateAdd[2]={
  0x9f,0x99};
const unsigned char GPS_distanceToHomeAdd[2]={
  0x9d,0x9e};


// POSITION OF EACH INFORMATION IN THE SCREEN BUFFER
//                                         NTSC        NTSC        PAL         PAL
//                                         WIDE        NARROW      WIDE        NARROW
//
// TOP OF THE SCREEN
const int GPS_numSatPosition[2][2]=             {
  LINE02+2   ,LINE02+4   ,LINE02+2   ,LINE02+4   };
const int GPS_directionToHomePosition[2][2]=    {
  LINE03+14  ,LINE03+14  ,LINE03+14  ,LINE03+14  };

// TOP OF THE SCREEN
const int GPS_distanceToHomePosition[2][2]=     {
  LINE02+23  ,LINE02+21  ,LINE02+25  ,LINE02+22  };
const int speedPosition[2][2] =                 {
  LINE03+23  ,LINE03+21  ,LINE03+25  ,LINE03+22  };  // [0] En Km/h   [1] En Mph
const int GPS_angleToHomePosition[2][2]=        {
  LINE04+14  ,LINE04+14  ,LINE04+14  ,LINE04+14  };
#if defined GPSALT_UNDERSPEED
const int MwGPSAltPosition[2][2] =              {
  LINE04+23  ,LINE04+21  ,LINE04+25  ,LINE04+22  };
#endif
const int sensorPosition[2][2]=                 {
  LINE03+2   ,LINE03+4   ,LINE03+2   ,LINE03+4   };
const int MwHeadingPosition[2][2] =             {
  LINE02+19  ,LINE02+17  ,LINE02+19  ,LINE02+17  };
const int MwHeadingGraphPosition[2][2] =        {
  LINE02+10  ,LINE02+10  ,LINE02+10  ,LINE02+10  };

// MIDDLE OF THE SCREEN
const int MwAltitudePosition[2][2]=             {
  LINE07+2   ,LINE07+4   ,LINE07+2   ,LINE07+4   };
const int MwClimbRatePosition[2][2]=            {
  LINE07+24  ,LINE07+26  ,LINE07+25  ,LINE07+26  };


// BOTTOM OF THE SCREEN
const int flyTimePosition[2][2]=                {
  LINE12+22  ,LINE12+21  ,LINE12+23+60  ,LINE12+21+60  };
const int onTimePosition[2][2]=                 {
  LINE13+22  ,LINE13+21  ,LINE13+23+60  ,LINE13+21+60  };
const int motorArmedPosition[2][2]=            {
  LINE12+11  ,LINE12+11  ,LINE11+11+60  ,LINE11+11+60  };
#if defined COORDINATES
const int MwGPSLatPosition[2][2] =              {
  LINE10+2   ,LINE10+4   ,LINE10+2+60   ,LINE10+4+60   };
const int MwGPSLonPosition[2][2] =              {
  LINE10+13+2   ,LINE10+13+4   ,LINE10+2+13+60   ,LINE10+13+4+60  };
#endif
//#if defined COORDINATES
//const int MwGPSAltPosition[2][2] =              {
//  LINE10+24   ,LINE10+23   ,LINE10+25+60   ,LINE10+23+60  };
//#endif
const int rssiPosition[2][2]=                   {
  LINE12+3   ,LINE12+5   ,LINE12+3+60   ,LINE12+5+60   };
const int temperaturePosition[2][2]=          {
  LINE11+2   ,LINE11+4   ,LINE11+2   ,LINE11+4   };
const int voltagePosition[2][2]  =                {
  LINE13+3  ,LINE13+5   ,LINE13+3+60   ,LINE13+5+60   };
const int vidvoltagePosition[2][2]  =                {
  LINE11+3  ,LINE11+5   ,LINE11+3+60   ,LINE11+5+60   };
const int amperagePosition[2][2] =               {
  LINE13+10   ,LINE13+12  ,LINE13+10+60   ,LINE13+12+60   };
const int pMeterSumPosition[2][2] =       {
  LINE13+16   ,LINE13+18   ,LINE13+16+60   ,LINE13+18+60    };

const char RushduinoVersionPosition = 35;
