#define MPH 1
#define KMH 0

#define METRIC 0
#define IMPERIAL 1

//General use variables
int thisSec=0;
int tenthSec=0;
int halfSec=0;
int Blink2hz=0;                               // This is turing on and off at 2hz
int Blink10hz=0;                              // This is turing on and off at 10hz
uint8_t rssiTimer=0;
uint8_t accCalibrationTimer=0;
uint8_t magCalibrationTimer=0;
uint8_t eepromWriteTimer=0;

unsigned int allSec=0;

uint8_t ROW=10;
uint8_t COL=3;
uint8_t configPage=MINPAGE;
uint8_t configMode=0;


//Current # of setting available
#define EEPROM_SETTINGS            34

uint8_t Settings[EEPROM_SETTINGS]; 

// Settings Locations
// used for check               0
#define S_STABLEMODE            1           
#define S_BAROMODE              2            
#define S_MAGMODE               3            
#define S_ARMEDMODE             4           
#define S_GPSHOMEMODE           5           
#define S_GPSHOLDMODE           6     
#define S_RSSIMIN               7
#define S_RSSIMAX               8
#define S_DISPLAYRSSI           9
#define S_DISPLAYVOLTAGE        10
#define S_VOLTAGEMIN            11
#define S_BATCELLS              12     
#define S_DIVIDERRATIO          13
#define S_MAINVOLTAGE_VBAT      14
#define S_VIDVOLTAGE            15
#define S_VIDDIVIDERRATIO       16    
#define S_VIDVOLTAGE_VBAT       17
#define S_DISPLAYTEMPERATURE    18
#define S_TEMPERATUREMAX        19
#define S_BOARDTYPE             20
#define S_DISPLAYGPS            21
#define S_COORDINATES           22
#define S_SHOWHEADING           23
#define S_HEADING360            24     
#define S_UNITSYSTEM            25
#define S_VIDEOSIGNALTYPE       26 
#define S_THROTTLEPOSITION      27
#define S_DISPLAY_HORIZON_BR    28
#define S_WITHDECORATION        29
#define S_SHOWBATLEVELEVOLUTION 30 
#define S_RESETSTATISTICS       31
#define S_ENABLEADC             32
#define S_MWRSSI                33


// For Settings Defaults
uint8_t EEPROM_DEFAULT[EEPROM_SETTINGS] = {
1,   // used for check             0
1,   // S_STABLEMODE             1           
4,   // S_BAROMODE               2            
8,   // S_MAGMODE                3            
32,  // S_ARMEDMODE              4           
64,  // S_GPSHOMEMODE            5           
128, // S_GPSHOLDMODE            6     
0,   // S_RSSIMIN                7
255, // S_RSSIMAX                8
1,   // S_DISPLAYRSSI            9
1,   // S_DISPLAYVOLTAGE         10
105, // S_VOLTAGEMIN             11
3,   // S_BATCELLS               12
25,  // S_DIVIDERRATIO           13
0,   // S_MAINVOLTAGE_VBAT       14
0,   // S_VIDVOLTAGE             15
25,  // S_VIDDIVIDERRATIO        16    
0,   // S_VIDVOLTAGE_VBAT        17
0,   // S_DISPLAYTEMPERATURE     18
255, // S_TEMPERATUREMAX         19
0,   // S_BOARDTYPE              20
1,   // S_DISPLAYGPS             21
0,   // S_COORDINATES            22
1,   // S_SHOWHEADING            23 
1,   // S_HEADING360             24      
0,   // S_UNITSYSTEM             25
1,   // S_VIDEOSIGNALTYPE        26
1,   // S_THROTTLEPOSITION       27
1,   // S_DISPLAY_HORIZON_BR     28
1,   // S_WITHDECORATION         29
0,   // S_SHOWBATLEVELEVOLUTION  30 
1,   // S_RESETSTATISTICS        31
0,   // S_ENABLEADC              32
1,   // S_MWRSSI                 33
};








// For Menu
int cursorPostion;

// For Serial communicatin
int8_t waitStick=0;

uint8_t askPID=0;
uint8_t serialWait=0;



static uint8_t P8[PIDITEMS], I8[PIDITEMS], D8[PIDITEMS];

static uint8_t rcRate8,rcExpo8;
static uint8_t rollPitchRate;
static uint8_t yawRate;
static uint8_t dynThrPID;
static uint8_t thrMid8;
static uint8_t thrExpo8;


#define SERIALBUFFERSIZE 128
static uint8_t serialBuffer[SERIALBUFFERSIZE]; // this hold the imcoming string from serial O string
uint8_t serialMSPStringOK=0;
uint8_t receiverIndex=0;
static uint16_t  MwAccSmooth[3]={0,0,0};       // Those will hold Accelerator data
int32_t  MwAltitude=0;                         // This hold barometric value


int MwAngle[2]={0,0};           // Those will hold Accelerator Angle
static uint16_t MwRcData[8]={   // This hold receiver pulse signal
  1500,1500,1500,1500,1500,1500,1500,1500} ;

uint16_t  MwSensorPresent=0;
uint32_t  MwSensorActive=0;
uint8_t MwVersion=0;
uint8_t MwVBat=0;
int16_t MwVario=0;
uint8_t armed=0;
uint8_t previousarmedstatus=0;  // NEB for statistics after disarming
int16_t armedTimer=0;
int16_t GPS_distanceToHome=0;
uint8_t GPSPresent=0;
uint8_t GPS_fix=0;
int32_t GPS_latitude;
int32_t GPS_longitude;
int16_t GPS_altitude;
int16_t GPS_speed=0;
int16_t GPS_ground_course;
uint8_t GPS_update=0;
int16_t GPS_directionToHome=0;
uint8_t GPS_numSat=0;
int16_t I2CError=0;
int16_t cycleTime=0;
uint16_t pMeterSum=0;
uint8_t MwRssi=0;

//For Current Throttle
int LowT = 1100;
int HighT = 1900;

// For Time
uint16_t onTime=0;
uint16_t flyTime=0;

// For Heading
const char headGraph[]={
  0x1a,0x1d,0x1c,0x1d,0x19,0x1d,0x1c,0x1d,0x1b,0x1d,0x1c,0x1d,0x18,0x1d,0x1c,0x1d,0x1a,0x1d,0x1c,0x1d,0x19,0x1d,0x1c,0x1d,0x1b};
static int16_t MwHeading=0;

// For Amperage
   float amperage =0.0;                // its the real value x10
#if defined (HARDSENSOR)
   float amperagesum =0;
#endif

// Rssi
int rssi =0;
int rssiADC=0;
int rssiMin;
int rssiMax;
int rssi_Int=0;


// For Voltage
float voltage=0;                      // its the real value x10
float vidvoltage=0;                   // its the real value x10

// For temprature
float temperature=0;                  // its the real value x10



// For Statistics
int16_t speedMAX=0;
int8_t temperMAX=0;
int16_t altitudeMAX=0;
int16_t distanceMAX=0;
float trip=0;
uint16_t flyingTime=0;

// ---------------------------------------------------------------------------------------
// Defines imported from Multiwii Serial Protocol 0 MultiWii_release_candidate_2_1_r949
#define MSP_VERSION        	 0

#define MSP_IDENT                100   //out message         multitype + multiwii version + protocol version + capability variable
#define MSP_STATUS               101   //out message         cycletime & errors_count & sensor present & box activation
#define MSP_RAW_IMU              102   //out message         9 DOF
#define MSP_SERVO                103   //out message         8 servos
#define MSP_MOTOR                104   //out message         8 motors
#define MSP_RC                   105   //out message         8 rc chan
#define MSP_RAW_GPS              106   //out message         fix, numsat, lat, lon, alt, speed
#define MSP_COMP_GPS             107   //out message         distance home, direction home
#define MSP_ATTITUDE             108   //out message         2 angles 1 heading
#define MSP_ALTITUDE             109   //out message         1 altitude
#define MSP_BAT                  110   //out message         vbat, pmetersum
#define MSP_RC_TUNING            111   //out message         rc rate, rc expo, rollpitch rate, yaw rate, dyn throttle PID
#define MSP_PID                  112   //out message         up to 16 P I D (8 are used)
#define MSP_BOX                  113   //out message         up to 16 checkbox (11 are used)
#define MSP_MISC                 114   //out message         powermeter trig + 8 free for future use
#define MSP_MOTOR_PINS           115   //out message         which pins are in use for motors & servos, for GUI
#define MSP_BOXNAMES             116   //out message         the aux switch names
#define MSP_PIDNAMES             117   //out message         the PID names
#define MSP_WP                   118   //out message         get a WP, WP# is in the payload, returns (WP#, lat, lon, alt, flags) WP#0-home, WP#16-poshold
#define MSP_MWRSSI               119   //out message         RSSI from Multiwii FC

#define MSP_SET_RAW_RC           200   //in message          8 rc chan
#define MSP_SET_RAW_GPS          201   //in message          fix, numsat, lat, lon, alt, speed
#define MSP_SET_PID              202   //in message          up to 16 P I D (8 are used)
#define MSP_SET_BOX              203   //in message          up to 16 checkbox (11 are used)
#define MSP_SET_RC_TUNING        204   //in message          rc rate, rc expo, rollpitch rate, yaw rate, dyn throttle PID
#define MSP_ACC_CALIBRATION      205   //in message          no param
#define MSP_MAG_CALIBRATION      206   //in message          no param
#define MSP_SET_MISC             207   //in message          powermeter trig + 8 free for future use
#define MSP_RESET_CONF           208   //in message          no param
#define MSP_WP_SET               209   //in message          sets a given WP (WP#,lat, lon, alt, flags)
#define MSP_SELECT_SETTING       210   //in message          Select Setting Number (0-2)

#define MSP_OSD_READ             220   //in message          starts epprom send to OSD GUI
#define MSP_OSD_WRITE            221   //in message          write OSD GUI setting to eeprom 

#define MSP_SPEK_BIND            240   //in message          no param
#define MSP_EEPROM_WRITE         250   //in message          no param
#define MSP_DEBUGMSG             253   //out message         debug string buffer
#define MSP_DEBUG                254   //out message         debug1,debug2,debug3,debug4

// End of imported defines from Multiwii Serial Protocol 0 MultiWii_release_candidate_2_1_r949
// ---------------------------------------------------------------------------------------

// For Intro
const char message0[] PROGMEM = "KV_OSD_TEAM_2.2";
const char message1[] PROGMEM = "VIDEO SIGNAL: NTSC";
const char message2[] PROGMEM = "VIDEO SIGNAL: PAL ";
const char message5[] PROGMEM = "MW VERSION:";
const char message6[] PROGMEM = "MENU:THRT MIDDLE";
const char message7[] PROGMEM = "YAW RIGHT";
const char message8[] PROGMEM = "PITCH FULL";

// For Config
const char configMsg0[] PROGMEM = "EXIT";
const char configMsg1[] PROGMEM = "SAVE-EXIT";
const char configMsg2[] PROGMEM = "<PAGE>";
//-----------------------------------------------------------Page1
const char configMsg3[] PROGMEM = "1/6 PID CONFIG";
const char configMsg4[] PROGMEM = "ROLL";
const char configMsg5[] PROGMEM = "PITCH";
const char configMsg6[] PROGMEM = "YAW";
const char configMsg7[] PROGMEM = "ALT";
const char configMsg8[] PROGMEM = "GPS";
const char configMsg9[] PROGMEM = "LEVEL";
const char configMsg10[] PROGMEM = "MAG";
//-----------------------------------------------------------Page2
const char configMsg11[] PROGMEM = "2/6 RC TUNING";
const char configMsg12[] PROGMEM = "RC RATE";
const char configMsg13[] PROGMEM = "EXPO";
const char configMsg14[] PROGMEM = "ROLL PITCH RATE";
const char configMsg15[] PROGMEM = "YAW RATE";
const char configMsg16[] PROGMEM = "THROTTLE PID ATT";
const char configMsg17[] PROGMEM = "MWCYCLE TIME";
const char configMsg18[] PROGMEM = "MWI2C ERRORS";
//-----------------------------------------------------------Page3
const char configMsg19[] PROGMEM = "3/6 DISPLAY & ALARM";
const char configMsg20[] PROGMEM = "      ";
const char configMsg21[] PROGMEM = "ON";
const char configMsg22[] PROGMEM = "OFF";
const char configMsg23[] PROGMEM = "DISPLAY VOLTAGE";
const char configMsg24[] PROGMEM = "VOLTAGE ALARM";
const char configMsg25[] PROGMEM = "DISPLAY TEMPERATURE";
const char configMsg26[] PROGMEM = "SET ALARM TEMP";
const char configMsg27[] PROGMEM = "DISPLAY GPS";
const char configMsg28[] PROGMEM = "                  ";
const char configMsg29[] PROGMEM = " ";
const char configMsg30[] PROGMEM = "                   ";
//-----------------------------------------------------------Page4
const char configMsg31[] PROGMEM = "4/6 DISPLAY";
const char configMsg32[] PROGMEM = "ACTUAL RSSIADC(/4)";
const char configMsg33[] PROGMEM = "ACTUAL RSSI";
const char configMsg34[] PROGMEM = "SET RSSI MIN";
const char configMsg35[] PROGMEM = "SET RSSI MAX";
const char configMsg36[] PROGMEM = "DISPLAY RSSI";
const char configMsg37[] PROGMEM = "UNIT SYSTEM";
const char configMsg38[] PROGMEM = "METRIC";
const char configMsg39[] PROGMEM = "IMPERL";
//-----------------------------------------------------------Page5
const char configMsg43[] PROGMEM = "5/6 CALIBRATION";
const char configMsg44[] PROGMEM = "ACC CALIBRATION";
const char configMsg45[] PROGMEM = "ACC ROLL :";
const char configMsg46[] PROGMEM = "ACC PITCH :";
const char configMsg47[] PROGMEM = "ACC Z :";
const char configMsg48[] PROGMEM = "MAG CALIBRATION";
const char configMsg49[] PROGMEM = "HEADING";
const char configMsg50[] PROGMEM = "MW EEPROM WRITE";
//-----------------------------------------------------------Page6
const char configMsg51[] PROGMEM = "6/6 STATISTICS";
const char configMsg52[] PROGMEM = "TRIP:";
const char configMsg53[] PROGMEM = "MAX DISTANCE:";
const char configMsg54[] PROGMEM = "MAX ALTITUDE:";
const char configMsg55[] PROGMEM = "MAX SPEED:";
const char configMsg56[] PROGMEM = "FLYING TIME:";
const char configMsg57[] PROGMEM = "DRAINED AMPS:";
const char configMsg58[] PROGMEM = "MAX TEMP:";

// All screen locations defines in ScreenLayout.ino
enum Positions {
  GPS_numSatPosition,
  GPS_directionToHomePosition,
  GPS_distanceToHomePosition,
  speedPosition,
  GPS_angleToHomePosition,
  MwGPSAltPosition,
  sensorPosition,
  MwHeadingPosition,
  MwHeadingGraphPosition,
  MwAltitudePosition,
  MwClimbRatePosition,
  CurrentThrottlePosition,
  flyTimePosition,
  onTimePosition,
  motorArmedPosition,
  MwGPSLatPosition,
  MwGPSLonPosition,
  rssiPosition,
  temperaturePosition,
  voltagePosition,
  vidvoltagePosition,
  amperagePosition,
  pMeterSumPosition,
};

