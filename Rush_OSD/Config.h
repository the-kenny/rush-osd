/**********************************************************************************/
/*  Those variable hold position to be diplayed on the screen for each features   */
/**********************************************************************************/

// General configuration
#define VideoSignalType_PAL
const char videoSignalType=1;
//#define VideoSignalType_NTSC
//const char videoSignalType=0;



// Serial configuration
#define SERIAL_SPEED 115200


//Here you can define time before start Calibration (usefull for mag calib) and EEProm write.
#define CALIBRATION_DELAY 10
#define EEPROM_WRITE_DELAY 5

// Voltage match multimeter (you can change this value to match real voltage)
#define DIVIDERRATIO 25           // R1/R2 of voltagePin.

// Current mode
//#define VBAT                      // uncomment to read MWvoltage (must define it on MWcode)
//#define HARDSENSOR                // uncomment if you use current sensor on OSD analogue pin (MW_POWERMETER is DEFAULT and must be defined on MWCode)
//#define AMPERAGE                  // uncomment to display amperage (need current sensor on OSD analogue pin, DONT WORK WITH MW_POWERMETER)

//#define COORDINATES               // if commented only GPS altitude will be displayed on screen by default (use with display GPS ON, on OSD page 3)

// For Sensors presence
#define ACCELEROMETER  1//0b00000001
#define BAROMETER      2//0b00000010  
#define MAGNETOMETER   4//0b00000100  
#define GPSSENSOR      8//0b00001000
//#define SONAR         16//0b00010000

// For Mode Active (you can define according MWC options)
#define STABLEMODE     1    // OK
#define BAROMODE       4    // OK
#define MAGMODE        8    // OK
//#define BOXCAMSTAB     16   // not used
//#define BOXCAMTRIG     256  // not used
#define ARMEDMODE      32   // OK
#define GPSHOMEMODE    64   // OK
#define GPSHOLDMODE    128  // OK

// Display Option
#define DISPLAY_HORIZON_BR
#define DISPLAY_GPSPOSITION

// Display option
#define WITHDECORATION
#define SHOWHEADING
#define SHOWGPSSPEED
#define SHOWTHROTTLE
#define SHOWBATLEVELEVOLUTION

// Led output
#define BST 7 // pin 7 for original Rushduino Board
#define BST_OFF digitalWrite(BST,LOW);
#define BST_ON digitalWrite(BST,HIGH);

// Buzer output
//#define BUZZER                   // Buzzer not defined for original Rushduino Board
#define BUZZERPIN_PINMODE          pinMode (8, OUTPUT);
#define BUZZERPIN_ON               PORTB |= 1;
#define BUZZERPIN_OFF              PORTB &= ~1;

// Analog input defines
const uint8_t voltagePin=0;
const uint8_t amperagePin=1;
const uint8_t temperaturePin=6;   // Temperature pin 6 for original Rushduino Board
const uint8_t rssiPin=3;
const uint8_t rssiSample=30;
const uint8_t lowrssiAlarm=75;    // This will make blink the Rssi if lower then this value

// FOR DEBUG ONLY
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
#define EEPROM_ENABLEBUZZER        9
#define EEPROM_SCREENTYPE         10
#define EEPROM_UNITSYSTEM         11
#define EEPROM_ARMEDTIMEWARNING   12

// POSITION OF EACH CHARACTER OR LOGO IN THE MAX7456
unsigned char speedUnitAdd[2] ={
  0xa5,0xa6} 
; // [0][0] and [0][1] = Km/h   [1][0] and [1][1] = Mph
unsigned char AHUnitAdd[8] = {
  0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17};
unsigned char voltageUnitAdd = 0xa9;
unsigned char temperatureUnitAdd[2] = {
  0x0e,0x0d};   
unsigned char flyTimeUnitAdd=0x9c;
unsigned char onTimeUnitAdd=0x9b;
unsigned char amperageUnitAdd = 0x9a;
unsigned char pMeterSumUnitAdd = 0xa4;
unsigned char rssiUnitAdd = 0xba;
unsigned char sensorAdd[4] = {
  0xa0,0xa1,0xa2,0xa4}; //acc,mag,bar
unsigned char relativeAltitudeUnitAdd[2] ={
  0xa7,0xb8};
unsigned char rcValueAdd[7] = {
  0x00,0xc5,0xc4,0xc3,0xc2,0xc1,0Xc0};
  /***********************************
  char MultiWiiLogoL1Add[17]={
  0xd0,0xd1,0xd2,0xd3,0xd4,0xd5,0xd6,0xd7,0xd8,0xd9,0xda,0xdb,0xdc,0xdd,0xde,0};
char MultiWiiLogoL2Add[17]={
  0xe0,0xe1,0xe2,0xe3,0xe4,0xe5,0xe6,0xe7,0xe8,0xe9,0xea,0xeb,0xec,0xed,0xee,0};
char MultiWiiLogoL3Add[17]={
  0xf0,0xf1,0xf2,0xf3,0xf4,0xf5,0xf6,0xf7,0xf8,0xf9,0xfa,0xfb,0xfc,0xfd,0xfe,0};
  ***********************************/
unsigned char MwHeadingUnitAdd=0xbd;
unsigned char GPS_numSatAdd[2]={
  0x1e,0x1f};
unsigned char MwAltitudeAdd[2]={
  0xa7,0xa8};
unsigned char MwClimbRateAdd[2]={
  0x9f,0x99};
unsigned char GPS_distanceToHomeAdd[2]={
  0x9d,0x9e};


// POSITION OF EACH INFORMATION IN THE SCREEN BUFFER
//                                         NTSC        NTSC        PAL         PAL       
//                                         WIDE        NARROW      WIDE        NARROW                                       
//
// TOP OF THE SCREEN
int GPS_numSatPosition[2][2]=             {
  LINE02+2   ,LINE02+4   ,LINE02+2   ,LINE02+4   }; 
int GPS_directionToHomePosition[2][2]=    {
  LINE03+14  ,LINE03+14  ,LINE03+14  ,LINE03+14  };

// TOP OF THE SCREEN
int GPS_distanceToHomePosition[2][2]=     {
  LINE02+22  ,LINE02+20  ,LINE02+24  ,LINE02+21  };
int speedPosition[2][2] =                 {
  LINE03+23  ,LINE03+21  ,LINE03+25  ,LINE03+22  };  // [0] En Km/h   [1] En Mph
int GPS_angleToHomePosition[2][2]=        {
  LINE04+14  ,LINE04+14  ,LINE04+14  ,LINE04+14  };
int MwGPSAltPosition[2][2] =              {
  LINE04+52  ,LINE04+50  ,LINE04+24  ,LINE04+51  }; //54          

int sensorPosition[2][2]=                 {
  LINE03+2   ,LINE03+4   ,LINE03+2   ,LINE03+4   };
int MwHeadingPosition[2][2] =             {
  LINE02+19  ,LINE02+17  ,LINE02+19  ,LINE02+17  };
int MwHeadingGraphPosition[2][2] =        {
  LINE02+10  ,LINE02+10  ,LINE02+10  ,LINE02+10  };

// MIDDLE OF THE SCREEN
int MwAltitudePosition[2][2]=             {
  LINE07+2   ,LINE07+4   ,LINE07+2   ,LINE07+4   }; 
int MwClimbRatePosition[2][2]=            {
  LINE07+24  ,LINE07+26  ,LINE07+25  ,LINE07+26  }; 


// BOTTOM OF THE SCREEN
int flyTimePosition[2][2]=                {
  LINE12+22  ,LINE12+21  ,LINE12+23+60  ,LINE12+21+60  };
int onTimePosition[2][2]=                 {
  LINE13+22  ,LINE13+21  ,LINE13+23+60  ,LINE13+21+60  };
int motorArmedPosition[2][2]=            {
  LINE12+11  ,LINE12+11  ,LINE11+11+60  ,LINE11+11+60  }; 
int MwGPSLatPosition[2][2] =              {
  LINE10+2   ,LINE10+4   ,LINE10+2+60   ,LINE10+4+60   };
int MwGPSLonPosition[2][2] =              {
  LINE10+11+2   ,LINE10+11+4   ,LINE10+2+11+60   ,LINE10+11+4+60  };
   
//int MwGPSAltPosition[2][2] =              {
 // LINE10+23   ,LINE10+22   ,LINE10+24+60   ,LINE10+22+60  };                       //Original place
 
int rssiPosition[2][2]=                   {
  LINE12+3   ,LINE12+5   ,LINE12+3+60   ,LINE12+5+60   }; 
int temperaturePosition[2][2]=          {
  LINE11+2   ,LINE11+4   ,LINE11+2   ,LINE11+4   }; 
int voltagePosition[2][2]  =                {
  LINE13+3  ,LINE13+5   ,LINE13+3+60   ,LINE13+5+60   }; 
int amperagePosition[2][2] =               {
  LINE13+10   ,LINE13+12  ,LINE13+10+60   ,LINE13+12+60   }; 
int pMeterSumPosition[2][2] =       {
  LINE13+16   ,LINE13+18   ,LINE13+16+60   ,LINE13+18+60    };

char RushduinoVersionPosition = 35; 
int AHPosition[10]={
  101,131,161,191,221,251,281,311,341,371};
int MultiWiiLogo[10]={
  101,131,161,191,221,251,281,311,341,371};


