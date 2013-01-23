                                      /**********************************************************************************/
                                      /*        KV_OSD_Team 2.2    Configurable parameters       KV_OSD_Team 2.2        */
                                      /**********************************************************************************/

// _______________________________________________________________General configuration________________________________________________________________________//


//*************************************   Define your OSD Board   ****************************************/
// moved MINIMOSD to eeprom, default values are in GlobalVariables
// moved RUSHDUINO to eeprom, default values are in GlobalVariables

/*******************************************  Video System  ***********************************/
//moved VideoSignalType to eeprom, default values are in GlobalVariables

/**********************       Serial speed      ************************/

#define SERIAL_SPEED 115200

//moved active modes to eeprom, default values are in GlobalVariables


/**********    Here you can define time out for Mag calibration and EEProm write (mostly useful for mag calibration)    ***********/

#define CALIBRATION_DELAY 10
#define EEPROM_WRITE_DELAY 5

/***************************************         Amperage        ********************************************/
 /*                                                                                                                     */
  /************** Voltage match multimeter (you can change this options to match your setup/requirements) ****************/
// moved DIVIDERRATIO to eeprom, default values are in GlobalVariables
// moved VIDDIVIDERRATIO to eeprom, default values are in GlobalVariables
// moved  VIDVOLTAGE_VBAT to eeprom, default values are in GlobalVariables
// moved MAINVOLTAGE_VBAT to eeprom, default values are in GlobalVariables

#define EST_PMSum 2.6                 /****  NOTE  **** If you use hardware CURRENT sensor on OSD use (#define EST_PMSum 1) BEFORE ANY ADJUSTMENT OR CALIBRATION
                                                      this value is empirical and you can find "yours" after some flights using the same instructions as for VBAT adjustment
                                                      on Mwc (first you have to MWC fine tune your voltage (VBat))                                                            ****/

//#define HARDSENSOR                // Uncomment to change from MW_POWERMETER to Hard current sensor on analogue Pin (MW_POWERMETER is DEFAULT and must be defined on MWCode)
#define AMPDIVISION 3600            // Hardware current sensor division ratio
#define AMPERAGE_CAL 1.1            // Amperage calibration
#define AMPRERAGE_OFFSET 512        // Amperage = AMPRERAGE_OFFSET - analogRead * AMPERAGE_CAL / 10.23


/**********************************         Display Settings         ************************/

#define DECIMAL '.'                 // Decimal point character, change to what suits you best (.) (,)

// moved THROTTLEPOSITION to eeprom, default values are in GlobalVariables
// moved DISPLAY_HORIZON_BR to eeprom, default values are in GlobalVariables
// moved COORDINATES to eeprom, default values are in GlobalVariables
// moved WITHDECORATION to eeprom, default values are in GlobalVariables
// moved SHOWHEADING to eeprom, default values are in GlobalVariables
// moved HEADING360 to eeprom, default values are in GlobalVariables
// moved HEADING360 to eeprom, default values are in GlobalVariables
// moved VIDVOLTAGE  to eeprom, default values are in GlobalVariables



/********************       For Sensors presence      *********************/

#define ACCELEROMETER  1//0b00000001
#define BAROMETER      2//0b00000010
#define MAGNETOMETER   4//0b00000100
#define GPSSENSOR      8//0b00001000
//#define SONAR         16//0b00010000

//moved BATCELLS to EEPROM
// moved BATEVs to DisplayVoltage

/*********************      Led output      *******************************/
#define BST 7                        // pin 7 for original Rushduino Board
#define BST_OFF digitalWrite(BST,LOW);
#define BST_ON digitalWrite(BST,HIGH);

/*********************      Statistics      *******************************/
// moved RESETSTATISTICS to eeprom, default values are in GlobalVariables

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
#define MINTROTTLE       1000

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






// POSITION OF EACH CHARACTER OR LOGO IN THE MAX7456
const unsigned char speedUnitAdd[2] ={
  0xa5,0xa6} ; // [0][0] and [0][1] = Km/h   [1][0] and [1][1] = Mph
const unsigned char AHUnitAdd[8] = {
  0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17};
const unsigned char voltageUnitAdd = 0xa9;
const unsigned char temperatureUnitAdd[2] = {
  0x0e,0x0d};

const unsigned char rssiUnitAdd = 0xba;

const char MultiWiiLogoL1Add[17] PROGMEM = {
  0xd0,0xd1,0xd2,0xd3,0xd4,0xd5,0xd6,0xd7,0xd8,0xd9,0xda,0xdb,0xdc,0xdd,0xde,0};
const char MultiWiiLogoL2Add[17] PROGMEM = {
  0xe0,0xe1,0xe2,0xe3,0xe4,0xe5,0xe6,0xe7,0xe8,0xe9,0xea,0xeb,0xec,0xed,0xee,0};
const char MultiWiiLogoL3Add[17] PROGMEM = {
  0xf0,0xf1,0xf2,0xf3,0xf4,0xf5,0xf6,0xf7,0xf8,0xf9,0xfa,0xfb,0xfc,0xfd,0xfe,0};

const char disarmed_text[] PROGMEM = "DISARMED";
const char armed_text[] PROGMEM = " ARMED";

const unsigned char MwHeadingUnitAdd=0xbd;
const unsigned char MwAltitudeAdd[2]={
  0xa7,0xa8};
const unsigned char MwClimbRateAdd[2]={
  0x9f,0x99};
const unsigned char GPS_distanceToHomeAdd[2]={
  0xbb,0xb9};
const unsigned char MwGPSAltPositionAdd[2]={
  0xa7,0xa8};
const char RushduinoVersionPosition = 35;
