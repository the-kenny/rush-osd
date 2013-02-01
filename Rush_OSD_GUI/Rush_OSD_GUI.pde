/**
 * Rush_KV Configuration
 * by Ross Power. 
 * 
 * 
 * 
 * 
 * 
 */
 



import processing.serial.Serial; // serial library
import controlP5.*; // controlP5 library
//import processing.opengl.*; 
import java.lang.StringBuffer; // for efficient String concatemation
import javax.swing.SwingUtilities; // required for swing and EDT
import javax.swing.JFileChooser; // Saving dialogue
import javax.swing.filechooser.FileFilter; // for our configuration file filter "*.mwi"
import javax.swing.JOptionPane; // for message dialogue


String Rush_OSD_GUI_Version = "2.01a";


PImage img_Clear,OSDBackground,RadioPot;

// ScreenType---------- NTSC = 0, PAL = 1 ---------------------------------
int ScreenType = 0;

int TIMEBASE_X1 =  50;
int TIMEBASE = TIMEBASE_X1;
int LINE  =    30;
int LINE01 =   0;
int LINE02  =  30;
int LINE03  =  60;
int LINE04  =  90;
int LINE05  =  120;
int LINE06  =  150;
int LINE07  =  180;
int LINE08  =  210;
int LINE09  =  240;
int LINE10  =  270;
int LINE11  =  300;
int LINE12  =  330;
int LINE13  =  360;
int LINE14  =  390;
int LINE15  =  420;
int LINE16  =  450;
int TestLine = 300;

// TOP OF THE SCREEN
int[] GPS_numSatPosition = {
 LINE02+2,LINE02+2};
int[] GPS_directionToHomePosition=    {
  LINE03+14 ,LINE03+14};

int[] GPS_distanceToHomePosition=  {
  LINE02+22  ,LINE02+24 };
int[] speedPosition = {     
  LINE03+22 ,LINE03+24};  // [0] En Km/h   [1] En Mph
int[] GPS_angleToHomePosition=  {
  LINE04+14 ,LINE04+14};
int[] MwGPSAltPosition =        {
  LINE04+22,LINE04+24};
int[] sensorPosition=           {
  LINE03+2 ,LINE03+2};
int[] MwHeadingPosition =       {
  LINE02+19 ,LINE02+19};
int[] MwHeadingGraphPosition =  {
  LINE02+10 ,LINE02+10};

// MIDDLE OF THE SCREEN
int[] MwAltitudePosition=  {
  LINE07+2,LINE07+2 };
int[] MwClimbRatePosition=  {
  LINE07+24 ,LINE07+25 };
int[] CurrentThrottlePosition = {
  LINE11+22,LINE11+23+60};
int[] flyTimePosition=                {
  LINE12+22,LINE12+23+60};
int[] onTimePosition=                 {
  LINE13+22,LINE13+23+60};
int[] motorArmedPosition=            {
  LINE12+11,LINE11+11+60};
int[] MwGPSLatPosition =              {
  LINE10+2,LINE10+2+60};
int[] MwGPSLonPosition =              {
  LINE10+13+2,LINE10+2+13+60};
int[]  rssiPosition = {
  LINE12+3 ,LINE12+3+60};
int[] temperaturePosition= {
  LINE11+2   ,LINE11+2};
int[] voltagePosition =                {
  LINE13+3  ,LINE13+3+60 };
int[] vidvoltagePosition =   {
  LINE11+3  ,LINE11+3+60};
int[] amperagePosition =     {
  LINE13+10,LINE13+10+60};
int[] pMeterSumPosition =       {
  LINE13+16,LINE13+16+60};
  
int DisplayWindowX = 635; //380;//380;
int DisplayWindowY = 10; //10;
int WindowAdjX = 15;
int WindowAdjY = 0;
int WindowShrinkX = 20;
int WindowShrinkY = 50;

int currentCol = 0;
int currentRow = 0;  
int ReadMW = 0;






Serial g_serial;      // The serial port
ControlP5 controlP5;
Textlabel txtlblWhichcom; 
ListBox commListbox;

char serialBuffer[] = new char[128]; // this hold the imcoming string from serial O string
String TestString = "";
String SendCommand = "";


boolean firstContact = false;   
boolean disableSerial = false;
// Int variables


int init_com;
int commListMax;
int whichKey = -1;  // Variable to hold keystoke values
int inByte = -1;    // Incoming serial data
int[] serialInArray = new int[3];    // Where we'll put what we receive
int serialCount = 0;                 // A count of how many bytes we receive
int ConfigEEPROM = -1;
int ConfigVALUE = -1;

int windowsX    = 1000;       int windowsY    = 540;
int xGraph      = 10;         int yGraph      = 325;
int xObj        = 520;        int yObj        = 293; //900,450
int xCompass    = 920;        int yCompass    = 341; //760,336
int xLevelObj   = 920;        int yLevelObj   = 80; //760,80
int xParam      = 120;        int yParam      = 5;
int xRC         = 690;        int yRC         = 10; //850,10
int xMot        = 690;        int yMot        = 155; //850,155
int xButton     = 845;        int yButton     = 231; //685,222
int xBox        = 415;        int yBox        = 10;
//int xGPS        = 853;        int yGPS        = 438; //693,438
int XSim        = DisplayWindowX+WindowAdjX;        int YSim        = 288-WindowShrinkY + 20;

//DisplayWindowX+WindowAdjX, DisplayWindowY+WindowAdjY, 360-WindowShrinkX, 288-WindowShrinkY);
// Box locations -------------------------------------------------------------------------
int XEEPROM    = 120;        int YEEPROM    = 5;
int XModeBox   = 120;        int YModeBox    = 50;
int XRSSI      = 120;        int YRSSI    = 180;
int XVolts      = 120;        int YVolts    = 260;
int XTemp      = 120;        int YTemp    = 430;
int XGPS       = 310;        int YGPS    = 50;
int XBoard     = 310;        int YBoard   = 150;
int XOther     = 310;        int YOther   = 200;
int XControlBox     = 120;        int YControlBox   = 500;



int activeTab = 1;
int xx=0;
int YLocation = 0;
int Roll = 0;
int Pitch = 0;

int OnTimer = 0;
int FlyTimer = 0;
float SimItem0= 0;
int Armed = 0;
int Showback = 1;
//int ReadMultiWii = 0;
// int variables

// For Heading
//char[] headGraph={
  //"0x1a","0x1d","0x1c","0x1d","0x19","0x1d","0x1c","0x1d","0x1b","0x1d","0x1c","0x1d","0x18","0x1d","0x1c","0x1d","0x1a","0x1d","0x1c","0x1d","0x19","0x1d","0x1c","0x1d","0x1b"};
char[] headGraph={
  0x1a,0x1d,0x1c,0x1d,0x19,0x1d,0x1c,0x1d,0x1b,0x1d,0x1c,0x1d,0x18,0x1d,0x1c,0x1d,0x1a,0x1d,0x1c,0x1d,0x19,0x1d,0x1c,0x1d,0x1b};

static int MwHeading=0;
char MwHeadingUnitAdd=0xbd;
//int MwHeading = 0;

int[] EEPROM_DEFAULT = {
1,   // used for check                0
1,   // EEPROM_STABLEMODE             1           
4,   // EEPROM_BAROMODE               2            
8,   // EEPROM_MAGMODE                3            
32,  // EEPROM_ARMEDMODE              4           
64,  // EEPROM_GPSHOMEMODE            5           
128, // EEPROM_GPSHOLDMODE            6     
0,   // EEPROM_RSSIMIN                7
255, // EEPROM_RSSIMAX                8
1,   // EEPROM_DISPLAYRSSI            9
1,   // EEPROM_DISPLAYVOLTAGE         10
0,   // EEPROM_VOLTAGEMIN             11
3,   // EEPROM_BATCELLS               12
25,  // EEPROM_DIVIDERRATIO           13
0,   // EEPROM_MAINVOLTAGE_VBAT       14
0,   // EEPROM_VIDVOLTAGE             15
25,  // EEPROM_VIDDIVIDERRATIO        16    
0,   // EEPROM_VIDVOLTAGE_VBAT        17
0,   // EEPROM_DISPLAYTEMPERATURE     18
255, // EEPROM_TEMPERATUREMAX         19
1,   // EEPROM_BOARDTYPE              20
1,   // EEPROM_DISPLAYGPS             21
0,   // EEPROM_COORDINATES            22
1,   // EEPROM_SHOWHEADING            23 
1,   // EEPROM_HEADING360             24      
0,   // EEPROM_UNITSYSTEM             25
0,   // EEPROM_SCREENTYPE             26
1,   // EEPROM_THROTTLEPOSITION       27
1,   // EEPROM_DISPLAY_HORIZON_BR     28
1,   // EEPROM_WITHDECORATION         29
0,   // EEPROM_SHOWBATLEVELEVOLUTION  30 
1    // EEPROM_RESETSTATISTICS        31

};
String[] ConfigNames = {
  "EEPROM Loaded:",
  "Stable Mode:",
  "Baro Mode:",
  "Mag Mode:",
  "Armed Mode:",
  "GPS Home Mode:",
  "GPS Hold Mode:",
  "RSSI Min:",
  "RSSI Max:",
  "Display RSSI:",
  "Display Voltage:",
  "Voltage Min:",
  "Battery Cells",
  "Main Voltage Devider:",
  "Main Voltage MW:",
  "Display Video Voltage:",
  "Video Voltage Devider:",
  "Video Voltage MW:",
  "Display Temperature:",
  "Temperature Max:",
  "Board Type:",
  "Display GPS:",
  "Display GPS Coords:",
  "Display Heading:",
  "Display Heading 360:",
  "Unit System:",
  "Screen Type NTSC / PAL:",
  "Display Thottle Position",
  "Display Hoizon Bar:",
  "Display Horizon Side Bars:",
  
  "Display Battery Evo:",
  "Reset Stats After Arm:",
  "Enable OSD Read ADC:"
  

};
String[] ConfigHelp = {
  "Shows if EEPROM is Loaded, uncheck to reset to defaults",
  "Stable Mode:",
  "Baro Mode:",
  "Mag Mode:",
  "16,32, or 64 check MW configuration",
  "GPS Home Mode:",
  "GPS Hold Mode:",
  "RSSI Min:",
  "RSSI Max:",
  "checked ON, unchecked OFF",
  "checked ON, unchecked OFF",
  "Voltage Min:",
  "# of Battery Cells",
  "Main Voltage Devider:",
  "Main Voltage MW:",
  "checked ON, unchecked OFF",
  "Video Voltage Devider:",
  "Video Voltage MW:",
  "checked ON, unchecked OFF",
  "Temperature Max:",
  "checked MinimOSD, unchecked RUSHDUINO --reboot OSD Required after change, close comm, open comm, read--",
  "checked ON, unchecked OFF",
  "checked ON, unchecked OFF",
  "checked metric, unchecked Imperial",
  "checked narrow, unchecked wide",
  "checked ON, unchecked OFF",
  "checked ON, unchecked OFF",
  "checked ON, unchecked OFF",
  "checked ON, unchecked OFF",
  "checked ON, unchecked OFF",
  "checked ON, unchecked OFF",
  "checked Reset, unchecked Don't reset",
  "checked ON, unchecked OFF"
  };




static int CHECKBOXITEMS=0;
int CONFIGITEMS=ConfigNames.length;
static int SIMITEMS=10;
  
int[] ConfigRanges = {
1,   // used for check             0
255,   // S_STABLEMODE             1           
255,   // S_BAROMODE               2            
255,   // S_MAGMODE                3            
255,   // S_ARMEDMODE              4           
255,   // S_GPSHOMEMODE            5           
255,   // S_GPSHOLDMODE            6     
255,   // S_RSSIMIN                7
255,   // S_RSSIMAX                8
1,     // S_DISPLAYRSSI            9
1,     // S_DISPLAYVOLTAGE         10
255,   // S_VOLTAGEMIN             11
6,     // S_BATCELLS               12
255,   // S_DIVIDERRATIO           13
1,     // S_MAINVOLTAGE_VBAT       14
1,     // S_VIDVOLTAGE             15
255,   // S_VIDDIVIDERRATIO        16    
1,     // S_VIDVOLTAGE_VBAT        17
1,     // S_DISPLAYTEMPERATURE     18
255,   // S_TEMPERATUREMAX         19
1,     // S_BOARDTYPE              20
1,     // S_DISPLAYGPS             21
1,     // S_COORDINATES            22
1,     // S_UNITSYSTEM             23
1,     // S_SCREENTYPE             24
1,     // S_THROTTLEPOSITION       25
1,     // S_DISPLAY_HORIZON_BR     26
1,     // S_WITHDECORATION         27
1,     // S_SHOWHEADING            28 
1,     // S_HEADING360             29             
1,     // S_SHOWBATLEVELEVOLUTION  30 
1,     // S_RESETSTATISTICS        31
1,     // S_ENABLEADC              32
};
String[] SimNames= {
  "Armed:",
  "Acro/Stable:",
  "Sim 2:",
  "Sim 3:",
  "Sim 4:",
  "Sim 5:",
  "Sim 6:",
  "Sim 7:",
  "Sim 8:",
  "Sim 9:",
  "Sim 10:"
};
  
  
  int[] SimRanges = {
  1,
  1,
  1,
  1,
  1,
  255,
  1,
  255,
  1,
  1,
  1};


PFont font8,font9,font12,font15;

//Colors--------------------------------------------------------------------------------------------------------------------
color yellow_ = color(200, 200, 20), green_ = color(30, 120, 30), red_ = color(120, 30, 30), blue_ = color(50, 50, 100),
grey_ = color(30, 30, 30);
//Colors--------------------------------------------------------------------------------------------------------------------

// textlabels -------------------------------------------------------------------------------------------------------------
Textlabel txtlblconfItem[] = new Textlabel[CONFIGITEMS] ;
Textlabel txtlblSimItem[] = new Textlabel[SIMITEMS] ;
// textlabels -------------------------------------------------------------------------------------------------------------

// Buttons------------------------------------------------------------------------------------------------------------------
Button buttonIMPORT,buttonSAVE,buttonREAD,buttonRESET,buttonWRITE,buttonSETTING,buttonREQUEST;
// Buttons------------------------------------------------------------------------------------------------------------------

// Toggles------------------------------------------------------------------------------------------------------------------
Toggle toggleConfItem[] = new Toggle[CONFIGITEMS] ;
// Toggles------------------------------------------------------------------------------------------------------------------    

// checkboxes------------------------------------------------------------------------------------------------------------------
CheckBox checkboxConfItem[] = new CheckBox[CONFIGITEMS] ;
CheckBox checkboxSimItem[] = new CheckBox[SIMITEMS] ;
CheckBox ReadMultiWii,ShowSimBackground; 

// Toggles------------------------------------------------------------------------------------------------------------------    

//  number boxes--------------------------------------------------------------------------------------------------------------

Numberbox confItem[] = new Numberbox[CONFIGITEMS] ;
Numberbox SimItem[] = new Numberbox[SIMITEMS] ;
//  number boxes--------------------------------------------------------------------------------------------------------------

// Slider2d ------------------------------------------------------------------------------------------------------------------

Slider2D s;

Slider sRoll,sPitch;
// Slider2d ------------------------------------------------------------------------------------------------------------------

// Knobs----------------------------------------------------------------------------------------------------------------------
Knob HeadingKnob;
//----------------------------------------------------------------------------------------------------------------------------

// Timers --------------------------------------------------------------------------------------------------------------------
//ControlTimer OnTimer,FlyTimer;





controlP5.Controller hideLabel(controlP5.Controller c) {
  c.setLabel("");
  c.setLabelVisible(false);
  return c;
}




void setup() {
  size(windowsX,windowsY);
//size(windowsX,windowsY,OPENGL);

OnTimer = millis();
  frameRate(20); 
OSDBackground = loadImage("Background.jpg");
RadioPot = loadImage("Radio_Pot.png");
//image(OSDBackground,DisplayWindowX+WindowAdjX, DisplayWindowY+WindowAdjY, DisplayWindowX+360-WindowShrinkX, DisplayWindowY+288-WindowShrinkY);
img_Clear = LoadFont("MW_OSD_Team.mcm");

  font8 = createFont("Arial bold",8,false);
  font9 = createFont("Arial bold",9,false);
  font12 = createFont("Arial bold",12,false);
  font15 = createFont("Arial bold",15,false);

  controlP5 = new ControlP5(this); // initialize the GUI controls
  controlP5.setControlFont(font12);


 
 
 
 
 
  commListbox = controlP5.addListBox("portComList",5,100,110,260); // make a listbox and populate it with the available comm ports
  commListbox.setItemHeight(15);
  commListbox.setBarHeight(15);

  commListbox.captionLabel().set("PORT COM");
  commListbox.setColorBackground(red_);
  for(int i=0;i<Serial.list().length;i++) {
    String pn = shortifyPortName(Serial.list()[i], 13);
    if (pn.length() >0 ) commListbox.addItem(pn,i); // addItem(name,value)
    commListMax = i;
  }
  commListbox.addItem("Close Comm",++commListMax); // addItem(name,value)
  // text label for which comm port selected
  txtlblWhichcom = controlP5.addTextlabel("txtlblWhichcom","No Port Selected",5,65); // textlabel(name,text,x,y)
  
  buttonSAVE = controlP5.addButton("bSAVE",1,5,45,40,19); buttonSAVE.setLabel("SAVE"); buttonSAVE.setColorBackground(red_);
  buttonIMPORT = controlP5.addButton("bIMPORT",1,50,45,40,19); buttonIMPORT.setLabel("LOAD"); buttonIMPORT.setColorBackground(red_); 
  
  buttonREAD = controlP5.addButton("READ",1,XControlBox+5,YControlBox+7,45,16);buttonREAD.setColorBackground(red_);
  buttonRESET = controlP5.addButton("RESET",1,XControlBox+67,YControlBox+7,45,16);buttonRESET.setColorBackground(red_);
  buttonWRITE = controlP5.addButton("WRITE",1,XControlBox+130,YControlBox+7,45,16);buttonWRITE.setColorBackground(red_);
  //buttonREQUEST = controlP5.addButton("REQUEST",1,xParam+150,yParam+260,60,16);buttonREQUEST.setColorBackground(red_);
 // buttonSETTING = controlP5.addButton("SETTING",1,xParam+405,yParam+260,110,16); buttonSETTING.setLabel("SELECT SETTING"); buttonSETTING.setColorBackground(red_);
 

// test labels------------------------------------------------------------------




// EEPROM----------------------------------------------------------------
BuildTextLabels(0, 1, XEEPROM+5, YEEPROM);
BuildNumberBoxes(0, 1, XEEPROM+5, YEEPROM);
BuildCheckBoxes(0, 1, XEEPROM+5, YEEPROM+3);

// mode  ---------------------------------------------------------------------------
BuildTextLabels(1, 7, XModeBox+5, YModeBox);
BuildNumberBoxes(1, 7,XModeBox+5, YModeBox);
BuildCheckBoxes(1, 7, XModeBox+5, YModeBox+3);

// RSSI  ---------------------------------------------------------------------------
BuildTextLabels(7, 10, XRSSI+5, YRSSI);
BuildNumberBoxes(7, 10, XRSSI+5, YRSSI);
BuildCheckBoxes(7, 10, XRSSI+5, YRSSI+3);

// Voltage  ------------------------------------------------------------------------
BuildTextLabels(10, 18, XVolts+5, YVolts);
BuildNumberBoxes(10, 18, XVolts+5, YVolts);
BuildCheckBoxes(10, 18, XVolts+5, YVolts+3);

//  Temperature  --------------------------------------------------------------------
BuildTextLabels(18, 20, XTemp+5, YTemp);
BuildNumberBoxes(18, 20, XTemp+5, YTemp);
BuildCheckBoxes(18, 20, XTemp+5, YTemp+3);

//  Board ---------------------------------------------------------------------------
BuildTextLabels(20, 21, XBoard+5, YBoard);
BuildNumberBoxes(20, 21, XBoard+5, YBoard);
BuildCheckBoxes(20, 21, XBoard+5, YBoard+3);

//  GPS  ----------------------------------------------------------------------------
BuildTextLabels(21, 25, XGPS+5, YGPS);
BuildNumberBoxes(21, 25, XGPS+5, YGPS);
BuildCheckBoxes(21, 25, XGPS+5, YGPS+3);

//  Other ---------------------------------------------------------------------------
BuildTextLabels(25, 33, XOther+5, YOther);
BuildNumberBoxes(25, 33, XOther+5, YOther);
BuildCheckBoxes(25, 33, XOther+5, YOther+3);






for(int i=0;i<SIMITEMS;i++) {
txtlblSimItem[i] = controlP5.addTextlabel("txtlblSimItem"+i,SimNames[i],XSim+40,YSim+i*17);
} 
 
  for(int i=0;i<SIMITEMS;i++) {
    SimItem[i] = (controlP5.Numberbox) hideLabel(controlP5.addNumberbox("SimItem"+i,0,XSim,YSim+i*17,35,14));
    SimItem[i].setColorBackground(red_);confItem[i].setMin(0);confItem[i].setDirection(Controller.HORIZONTAL);confItem[i].setMax(ConfigRanges[i]);confItem[i].setDecimalPrecision(0); //confItem[i].setMultiplier(1);confItem[i].setDecimalPrecision(1);
 }
 
  
  for(int i=0;i<SIMITEMS;i++) {
    //buttonCheckbox[i] = controlP5.addButton("bcb"+i,1,xBox-30,yBox+20+13*i,68,12);
   // buttonCheckbox[i].setColorBackground(red_);buttonCheckbox[i].setLabel(name);
    checkboxSimItem[i] =  controlP5.addCheckBox("checkboxSimItem"+i,XSim+25,YSim+3+i*17);
       checkboxSimItem[i].setColorActive(color(255));checkboxSimItem[i].setColorBackground(color(120));
        checkboxSimItem[i].setItemsPerRow(1);checkboxSimItem[i].setSpacingColumn(10);
        checkboxSimItem[i].setLabel(SimNames[i]);
        //if (ConfigRanges[i] == 1){
        checkboxSimItem[i].addItem("scbox"+i,1);
        //}
        checkboxSimItem[i].hideLabels();
   
  }
  
  ReadMultiWii = controlP5.addCheckBox("ReadMultiWii",XSim+200,YSim+3);
      ReadMultiWii.setColorActive(color(255));ReadMultiWii.setColorBackground(color(120));
        ReadMultiWii.setItemsPerRow(1);ReadMultiWii.setSpacingColumn(10);
       ReadMultiWii.setLabel("Read MultiWii");
        //if (ConfigRanges[i] == 1){
       ReadMultiWii.addItem("Read MultiWii",1);
       
 ShowSimBackground = controlP5.addCheckBox("ShowSimBackground",XSim+200,YSim+40);
      ShowSimBackground.setColorActive(color(255));ShowSimBackground.setColorBackground(color(120));
        ShowSimBackground.setItemsPerRow(1);ShowSimBackground.setSpacingColumn(10);
       ShowSimBackground.setLabel("Hide Background");
        //if (ConfigRanges[i] == 1){
       ShowSimBackground.addItem("Hide Background",1);
  
  
  
  for(int i=0;i<CONFIGITEMS;i++) {
    if (ConfigRanges[i] == 0) {
      checkboxConfItem[i].hide();
      confItem[i].hide();
      }
    if (ConfigRanges[i] > 1) {
      checkboxConfItem[i].hide();
      }
      
    if (ConfigRanges[i] == 1){
      confItem[i].hide();  
    }
  }
  
   for(int i=0;i<SIMITEMS;i++) {
    if (SimRanges[i] == 0) {
      checkboxSimItem[i].hide();
      SimItem[i].hide();
      }
    if (SimRanges[i] > 1) {
      checkboxSimItem[i].hide();
      }
      
    if (SimRanges[i] == 1){
      SimItem[i].hide();  
    }
   }
  

  s = controlP5.addSlider2D("Pitch/Roll")
         .setPosition(DisplayWindowX+WindowAdjX-90,DisplayWindowY+WindowAdjY+288-WindowShrinkY-90)
         .setSize(70,70)
         .setArrayValue(new float[] {50, 50})
         .setMaxX(45) 
         .setMaxY(25) 
         .setMinX(-45) 
         .setMinY(-25)
         .setValueLabel("") 
         .setLabel("Roll/Pitch")
        //.setImage(RadioPot) 
        //.updateDisplayMode(1)
         //.disableCrosshair()
         ;
 controlP5.getController("Pitch/Roll").getValueLabel().hide();

HeadingKnob = controlP5.addKnob("MwHeading")
               .setRange(-180,+180)
               .setValue(0)
               .setPosition(DisplayWindowX+WindowAdjX-90,DisplayWindowY+WindowAdjY+288-WindowShrinkY-220)
               .setRadius(35)
               .setLabel("Heading")
               
               //.setNumberOfTickMarks(36)
               //.setTickMarkLength(4)
               //.snapToTickMarks(true)
               //.setColorForeground(color(255))
               .setColorBackground(color(0, 160, 100))
               .setColorActive(color(255,255,0))
               .setDragDirection(Knob.HORIZONTAL)
               ;

BuildToolHelp();

}


controlP5.Controller hideCheckbox(controlP5.Controller c) {
  c.hide();
  //c.setLabelVisible(false);
  return c;
}

controlP5.Controller CheckboxVisable(controlP5.Controller c) {
  c.isVisible(); 

  //c.setLabelVisible(false);
  return c;
}

void BuildCheckBoxes(int starter, int ender, int StartXLoction, int StartYLocation){
  YLocation = StartYLocation;
  for(int i=starter;i<ender;i++) {
     YLocation+=17;
     checkboxConfItem[i] =  controlP5.addCheckBox("checkboxConfItem"+i,StartXLoction+25,YLocation);
     checkboxConfItem[i].setColorActive(color(255));checkboxConfItem[i].setColorBackground(color(120));
     checkboxConfItem[i].setItemsPerRow(1);checkboxConfItem[i].setSpacingColumn(10);
     checkboxConfItem[i].setLabel(ConfigNames[i]);
     checkboxConfItem[i].addItem("cbox"+i,1);
     checkboxConfItem[i].hideLabels();
     
  
  }
}

void BuildNumberBoxes(int starter, int ender, int StartXLoction, int StartYLocation){
 YLocation = StartYLocation; 
 for(int i=starter;i<ender;i++) {
    YLocation+=17;
    confItem[i] = (controlP5.Numberbox) hideLabel(controlP5.addNumberbox("configItem"+i,0,StartXLoction,YLocation,35,14));
    confItem[i].setColorBackground(red_);confItem[i].setMin(0);confItem[i].setDirection(Controller.HORIZONTAL);confItem[i].setMax(ConfigRanges[i]);confItem[i].setDecimalPrecision(0); //confItem[i].setMultiplier(4); //confItem[i].setDecimalPrecision(1);
 } 
}

void BuildTextLabels(int starter, int ender, int StartXLoction, int StartYLocation){
  YLocation = StartYLocation; 
  for(int i=starter;i<ender;i++) {
    YLocation+=17;
    txtlblconfItem[i] = controlP5.addTextlabel("txtlblconfItem"+i,ConfigNames[i],StartXLoction+40,YLocation);
    controlP5.getTooltip().register("txtlblconfItem"+i,ConfigHelp[i]);
  }
}
void BuildToolHelp(){
  controlP5.getTooltip().setDelay(200);
  //confItem[1].setMultiplier(confItem[1].value);
  //controlP5.getTooltip().register("txtlblconfItem"+0,"Changes the size of the ellipse.");
  //controlP5.getTooltip().register("s2","Changes the Background");


  
}

void draw() {
  hint(ENABLE_DEPTH_TEST);
  pushMatrix();
  GetMWData();
 background(80);
  
   // ------------------------------------------------------------------------
  // Draw background control boxes
  // ------------------------------------------------------------------------
     // Coltrol Box
  fill(100); strokeWeight(3);stroke(200); rectMode(CORNERS); rect(XControlBox,YControlBox, XControlBox+180 , YControlBox+30);
  //textFont(font12); fill(0, 110, 220); text("Other",XControlBox + 75,YControlBox + 10);
  if (activeTab == 1) {
  // EEPROM Box
  fill(30, 30,30); strokeWeight(3);stroke(1); rectMode(CORNERS); rect(XEEPROM,YEEPROM, XEEPROM+180, YEEPROM+35);
  textFont(font12); fill(0, 110, 220); text("EEPROM STATUS", XEEPROM + 45,YEEPROM + 10);
  // Modes Box
  fill(30, 30,30); strokeWeight(3);stroke(1); rectMode(CORNERS); rect(XModeBox,YModeBox, XModeBox+180, YModeBox+120);
  textFont(font12); fill(0, 110, 220); text("Flight Modes",XModeBox + 45,YModeBox + 10);
  // RSSI Box
  fill(30, 30,30); strokeWeight(3);stroke(1); rectMode(CORNERS); rect(XRSSI,YRSSI, XRSSI+180 , YRSSI+70);
  textFont(font12); fill(0, 110, 220); text("RSSI",XRSSI + 70,YRSSI + 10);
   // Volts Box
  fill(30, 30,30); strokeWeight(3);stroke(1); rectMode(CORNERS); rect(XVolts,YVolts, XVolts+180 , YVolts+160);
  textFont(font12); fill(0, 110, 220); text("Voltage",XVolts + 65,YVolts + 10);
   // Temp Box
  fill(30, 30,30); strokeWeight(3);stroke(1); rectMode(CORNERS); rect(XTemp,YTemp, XTemp+180 , YTemp+55);
  textFont(font12); fill(0, 110, 220); text("Temperature",XTemp + 50,YTemp + 10);
   // GPS Box
  fill(30, 30,30); strokeWeight(3);stroke(1); rectMode(CORNERS); rect(XGPS,YGPS, XGPS+200 , YGPS+90);
  textFont(font12); fill(0, 110, 220); text("GPS / Nav",XGPS + 60,YGPS + 10);
       // Board Box
  fill(30, 30,30); strokeWeight(3);stroke(1); rectMode(CORNERS); rect(XBoard,YBoard, XBoard+200 , YBoard+40);
  textFont(font12); fill(0, 110, 220); text("Board Type",XBoard + 65,YBoard + 10);
      // Other Box
  fill(30, 30,30); strokeWeight(3);stroke(1); rectMode(CORNERS); rect(XOther,YOther, XOther+200 , YOther+165);
  textFont(font12); fill(0, 110, 220); text("Other",XOther + 75,YOther + 10);
  }
  
  fill(40, 40, 40);
  strokeWeight(3);stroke(0);
  rectMode(CORNERS);
  rect(5,5,113,40);
  textFont(font15);
  // version
  fill(255, 255, 255);
  text("Rush OSD",18,19);
  text("  GUI    V",10,35);
  text(Rush_OSD_GUI_Version, 74, 35);
  fill(0, 0, 0);
  strokeWeight(3);stroke(0);
  rectMode(CORNERS);
   if (int(ShowSimBackground.arrayValue()[0]) < 1){
    image(OSDBackground,DisplayWindowX+WindowAdjX, DisplayWindowY+WindowAdjY, 360-WindowShrinkX, 288-WindowShrinkY);
   }
   else{
     fill(80, 80,80); strokeWeight(3);stroke(1); rectMode(CORNER); rect(DisplayWindowX+WindowAdjX, DisplayWindowY+WindowAdjY, 360-WindowShrinkX, 288-WindowShrinkY);
   }

    //pushMatrix();
  //rect(DisplayWindowX+WindowAdjX, DisplayWindowY+WindowAdjY, DisplayWindowX+360-WindowShrinkX, DisplayWindowY+288-WindowShrinkY);

 // makeText("Rush_KV OSD DEMO!", LINE02+6);
  //MakeRectangle();
//image(DisplayScreen,DisplayWindowX, DisplayWindowY, DisplayWindowX+360, DisplayWindowY+288);

//ReadMW = int(ReadMultiWii.arrayValue()[0]);
  MatchConfigs();
  
 
  if (ReadMW >0){
    s.arrayValue()[0] =MwAngle[0];
    s.arrayValue()[1] =MwAngle[1];
    displayHorizon(int(s.arrayValue()[0]),int(s.arrayValue()[1])*-1);
  }
  else
  {
    displayHorizon(int(s.arrayValue()[0])*10,int(s.arrayValue()[1])*10*-1);
  }
  SimulateTimer();
  ShowCurrentThrottlePosition();
  if (int(confItem[9].value()) > 0) ShowRSSI(); 
  if (int(confItem[10].value()) > 0) {
      if (int(confItem[13].value()) > 0){
         float voltage=MwVBat / 10.0;
         ShowVolts(voltage);
      }
      else{
        ShowVolts(12.8);    
      }
  }
   
  displaySensors();
  displayMode();
  ShowAmperage();
  displayArmed();
  displayHeadingGraph();
  displayHeading();
   popMatrix();
  hint(DISABLE_DEPTH_TEST);


}

void ShowSimBackground(float[] a){

  Showback = int(a[0]);
}

void ReadMultiWii(float[] a) {
  if (a[0] > 0){
    ReadMW = 1;
  }
  else{
     ReadMW = 0;
     s.arrayValue()[0] =0;
     s.arrayValue()[1] =0;
  }
}


void MatchConfigs(){
 for(int i=0;i<CONFIGITEMS;i++) {
   if  (checkboxConfItem[i].isVisible()){
     confItem[i].setValue(int(checkboxConfItem[i].arrayValue()[0]));
   }
   if (ConfigRanges[i] == 0) {
      checkboxConfItem[i].hide();
      confItem[i].hide();
      }
    if (ConfigRanges[i] > 1) {
      checkboxConfItem[i].hide();
      }
      
    if (ConfigRanges[i] == 1){
      confItem[i].hide();  
    }
  }
  // turn on FlyTimer----
   if ((checkboxSimItem[0].arrayValue()[0] == 1) && (SimItem0 < 1)){
    Armed = 1;
     FlyTimer = millis();
  }
  // turn off FlyTimer----
  if ((checkboxSimItem[0].arrayValue()[0] == 0) && (SimItem0 == 1)){
    FlyTimer = 0;
  }

   for(int i=0;i<SIMITEMS;i++) {
   if  (checkboxSimItem[i].isVisible()){
     SimItem[i].setValue(int(checkboxSimItem[i].arrayValue()[0]));
   }
   if (SimRanges[i] == 0) {
      checkboxSimItem[i].hide();
      SimItem[i].hide();
      }
    if (SimRanges[i] > 1) {
      checkboxSimItem[i].hide();
      }
      
    if (ConfigRanges[i] == 1){
      SimItem[i].hide();  
    }
  }
  
}


// controls comport list click
public void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup()) if (theEvent.name()=="portComList") InitSerial(theEvent.group().value()); // initialize the serial port selected
  

    

}

// initialize the serial port selected in the listBox
void InitSerial(float portValue) {
  if (portValue < commListMax) {
    if(init_com == 0){ 
      String portPos = Serial.list()[int(portValue)];
      txtlblWhichcom.setValue("COM = " + shortifyPortName(portPos, 8));
      g_serial = new Serial(this, portPos, 115200);
      init_com=1;
      buttonREAD.setColorBackground(green_);
      buttonRESET.setColorBackground(green_);commListbox.setColorBackground(green_);
      g_serial.buffer(256);
      System.out.println(int(checkboxConfItem[0].getArrayValue()[0]));
      System.out.println("Port Turned On " );//+((int)(cmd&0xFF))+": "+(checksum&0xFF)+" expected, got "+(int)(c&0xFF));
    }
  } else {
    if(init_com == 1){ 
      txtlblWhichcom.setValue("Comm Closed");
      init_com=0;
      commListbox.setColorBackground(red_);buttonREAD.setColorBackground(red_);buttonRESET.setColorBackground(red_); buttonWRITE.setColorBackground(red_);
      init_com=0;
      g_serial.stop();
      ReadMultiWii.deactivateAll();
    }
   

    
  }
}

void serialEvent(Serial g_serial) {
   inByte = g_serial.read();
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller. 
  // Otherwise, add the incoming byte to the array:
 if (disableSerial != true){
  if (firstContact == false) {
    if (inByte == '*') { 
      //g_serial.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      //myPort.write('A');       // ask for more
    } 
  } 
  else {
    // Add the latest byte from the serial port to array:
   
    serialInArray[serialCount] = inByte;
    serialCount++;
    // If we have 3 bytes:
    if (serialCount > 2 ) {
      ConfigEEPROM = serialInArray[0];
      //skip the ","
      ConfigVALUE = serialInArray[2];
      //byteCi[ConfigEEPROM] = ConfigVALUE;
      
      confItem[ConfigEEPROM].setValue(ConfigVALUE);
      if (ConfigEEPROM == CONFIGITEMS-1)  buttonWRITE.setColorBackground(green_);
      if (ConfigVALUE>0) checkboxConfItem[ConfigEEPROM].activate(0); else checkboxConfItem[ConfigEEPROM].deactivate(0);
     // print the values (for debugging purposes only):
      //println(ConfigEEPROM + "\t" + ConfigVALUE );
      firstContact = false;
      // Reset serialCount:
      serialCount = 0;
      }
      
  }
 }
}


public void READ(){
  if(init_com ==1){
   for(int i=0;i<CONFIGITEMS;i++) {
     confItem[i].setValue(0);
     checkboxConfItem[i].deactivateAll();
   }
   g_serial.write('$');
   g_serial.write('M');
   g_serial.write('>');
   g_serial.write((byte)0x00);
   g_serial.write(MSP_OSD_READ);
   g_serial.write(MSP_OSD_READ);
   SetMode();
  }
}

public void WRITE(){
  if(init_com == 1){ 
   for(int j=0;j<2;j++) {
    g_serial.write('$');
    g_serial.write('M');
    g_serial.write('>');
    checksum=0;
    dataSize=CONFIGITEMS;
    g_serial.write((byte)dataSize);
    checksum ^= dataSize;
    g_serial.write(MSP_OSD_WRITE);
    checksum ^= MSP_OSD_WRITE;
    for(int i=0; i<CONFIGITEMS; i++){
      g_serial.write(int(confItem[i].value()));
      checksum ^= int(confItem[i].value());
    }
    g_serial.write((byte)checksum);
   }
  }
    
}

// coded by Eberhard Rensch
// Truncates a long port name for better (readable) display in the GUI
String shortifyPortName(String portName, int maxlen)  {
  String shortName = portName;
  if(shortName.startsWith("/dev/")) shortName = shortName.substring(5);  
  if(shortName.startsWith("tty.")) shortName = shortName.substring(4); // get rid of leading tty. part of device name
  if(portName.length()>maxlen) shortName = shortName.substring(0,(maxlen-1)/2) + "~" +shortName.substring(shortName.length()-(maxlen-(maxlen-1)/2));
  if(shortName.startsWith("cu.")) shortName = "";// only collect the corresponding tty. devices
  return shortName;
}





void mapchar(int address, int screenAddress){
  int placeX = (screenAddress % 30) * 12;
  int placeY = (screenAddress / 30) * 18;

  blend(img_Clear, 0,address*18, 12, 18, placeX+DisplayWindowX, placeY+DisplayWindowY, 12, 18, BLEND);
}

void makeText(String inString, int inStartAddress ){
  for (int i = 0; i < inString.length(); i++){
    mapchar(int(inString.charAt(i)), inStartAddress +i); 
  }   
}

void displayHorizon(int rollAngle, int pitchAngle)
{
  //println(rollAngle);
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

//if (DISPLAY_HORIZON_BR){
  //Draw center screen
  mapchar(0x03, 219-30);
  mapchar(0x1D,224-30-1);
  mapchar(0x1D,224-30+1);
  mapchar(0x01,224-30);
  mapchar(0x02,229-30);
  
  //if (WITHDECORATION){
     mapchar(0xC7,128);
     mapchar(0xC7,128+30);
     mapchar(0xC7,128+60);
     mapchar(0xC7,128+90);
     mapchar(0xC7,128+120);
     mapchar(0xC6,128+12);
     mapchar(0xC6,128+12+30);
     mapchar(0xC6,128+12+60);
     mapchar(0xC6,128+12+90);
     mapchar(0xC6,128+12+120);
    //}
  //}
  //mapchar("0x10"+ 00,(rollAngle*30)+100+0);
}

void displayHorizonPart(float X,float Y,int roll)
{
 
  // Roll Angle will be between -45 and 45 this is converted to 0-56 to fit with DisplayHorizonPart function
  X = X*(0.6)+28;
  if(X>56) X=56;
  if(X<0) X=0;
  // 7 row, 8 lines per row, mean 56 different case per segment, 2 segment now
  xx=int(X/8);
  int charString = 0x1;
  switch (xx)
   {
    
  case 0:
   //charString+=X;
   mapchar(0x10+int(X),(roll*30)+100 + int(Y));
   
    //screen[(roll*30)+100+Y]=0x10+(X);
    break;
  case 1:
  charString+=X-8;
   mapchar(0x10+int(X-8),(roll*30)+130+int(Y));
    //screen[(roll*30)+130+Y]=0x10+(X-8);
    break;
  case 2:
  charString+=X-16;
   mapchar(0x10+int(X-16),(roll*30)+160+int(Y));
   // screen[(roll*30)+160+Y]=0x10+(X-16);
    break;
  case 3:
  charString+=X-24;
   mapchar(0x10+int(X-24),(roll*30)+190+int(Y));
   // screen[(roll*30)+190+Y]=0x10+(X-24);
    break;
  case 4:
   charString+=X-32;
   mapchar(0x10+int(X-32),(roll*30)+220+int(Y));
   // screen[(roll*30)+220+Y]=0x10+(X-32);
    break;
  case 5:
   charString+=X-40;
   mapchar(0x10+int(X-40),(roll*30)+250+int(Y));
   // screen[(roll*30)+250+Y]=0x10+(X-40);
    break;
  case 6:
 charString+=X-48;
   mapchar(0x10+int(X-48),(roll*30)+280+int(Y));
    //screen[(roll*30)+280+Y]=0x10+(X-48);
    break;
  }
}

void displayHeadingGraph()
{
  int xx;
  
  xx = MwHeading * 4;
  xx = xx + 720 + 45;
  xx = xx / 90;
 //for (int i = 0; i < 9; i++){
 
  mapchar(headGraph[xx++],MwHeadingGraphPosition[0]);
  mapchar(headGraph[xx++],MwHeadingGraphPosition[0]+1);
  mapchar(headGraph[xx++],MwHeadingGraphPosition[0]+2);
  mapchar(headGraph[xx++],MwHeadingGraphPosition[0]+3);
  mapchar(headGraph[xx++],MwHeadingGraphPosition[0]+4);
  mapchar(headGraph[xx++],MwHeadingGraphPosition[0]+5);
  mapchar(headGraph[xx++],MwHeadingGraphPosition[0]+6);
  mapchar(headGraph[xx++],MwHeadingGraphPosition[0]+7);
  mapchar(headGraph[xx],MwHeadingGraphPosition[0]+8);  

}

void displayHeading()
{
  int heading = MwHeading;
  if(heading < 0)
    heading += 360;
    
  switch (str(heading).length())
  {
    
  case 1:
   makeText(str(heading), MwHeadingPosition[0]+2);

   
    break;
  case 2:
    makeText(str(heading), MwHeadingPosition[0]+1);
   
    
    break;
  case 3:
    makeText(str(heading), MwHeadingPosition[0]);
   }
    mapchar(MwHeadingUnitAdd,MwHeadingPosition[0]+3);  
}


void displaySensors()
{
   mapchar(0xa0,sensorPosition[0]);
   mapchar(0xa2,sensorPosition[0]+1);
   mapchar(0xa1,sensorPosition[0]+2);
   mapchar(0xa3,sensorPosition[0]+3);
 /* 
  if(MwSensorPresent&ACCELEROMETER) mapchar("0xa0",sensorPosition[0]);
  else ;
  if(MwSensorPresent&BAROMETER)     screenBuffer[1]=0xa2;
  else screenBuffer[1]=' ';
  if(MwSensorPresent&MAGNETOMETER)  screenBuffer[2]=0xa1;
  else screenBuffer[2]=' ';
  if(MwSensorPresent&GPSSENSOR)     screenBuffer[3]=0xa3;
  else screenBuffer[3]=' ';
  screenBuffer[4]=0;
  MAX7456_WriteString(screenBuffer,sensorPosition[videoSignalType][screenType]);
  */
}

void displayMode()
{
  if (ReadMW < 1){  
  if (int(SimItem[1].value()) > 0){
    mapchar(0xac,sensorPosition[0]+4);
    mapchar(0xad,sensorPosition[0]+5);
  }
  else
  {
    mapchar(0xae,sensorPosition[0]+4);
    mapchar(0xaf,sensorPosition[0]+5);
  }
   if (int(SimItem[1].value()) > 0){
    mapchar(0xbe,sensorPosition[0]+LINE);
    //mapchar("0xad",sensorPosition[0]+5);
  }
  }
  else 
  {
    if((MwSensorActive&ARMEDMODE) >0) checkboxSimItem[0].activate(0); else checkboxSimItem[0].deactivate(0);
      
      
  if((MwSensorActive&STABLEMODE) >0)   mapchar(0xbe,sensorPosition[0]+LINE);
  else ;
  if((MwSensorActive&BAROMODE) >0)     mapchar(0xbe,sensorPosition[0]+1+LINE);
  else ;
  if((MwSensorActive&MAGMODE) >0)      mapchar(0xbe,sensorPosition[0]+2+LINE);
  else ;
  if((MwSensorActive&GPSHOMEMODE) >0)  mapchar(0xbe,sensorPosition[0]+3+LINE);
  if((MwSensorActive&GPSHOLDMODE) >0)  mapchar(0xbe,sensorPosition[0]+3+LINE);
   //println(MwSensorActive);
  }
 
 
}

void displayArmed()
{
  if (int(SimItem[0].value()) > 0){
    makeText("ARMED", motorArmedPosition[0]);
  }
  else
  {
  makeText("DISARMED", motorArmedPosition[0]);
  }

}



void ShowVolts(float voltage){
mapchar(0x97, voltagePosition[ScreenType]);
makeText(str(voltage), voltagePosition[ScreenType]+2);
}
void ShowFlyTime(String FMinutes_Seconds){
mapchar(0x9c, flyTimePosition[ScreenType]);
makeText(FMinutes_Seconds, flyTimePosition[ScreenType]+1);
}
void ShowOnTime(String Minutes_Seconds){
mapchar(0x9b, onTimePosition[ScreenType]);
makeText(Minutes_Seconds, onTimePosition[ScreenType]+1);
}

void ShowCurrentThrottlePosition(){
mapchar(0xc8, CurrentThrottlePosition[ScreenType]);
makeText(" 40%", CurrentThrottlePosition[ScreenType]+1);
}

void ShowRSSI(){
mapchar(0xba, rssiPosition[ScreenType]);
makeText("93%", rssiPosition[ScreenType]+1);
}

void ShowAmperage(){
mapchar(0xa4, amperagePosition[ScreenType]);
makeText("2306", amperagePosition[ScreenType]+1);
}

void SimulateTimer(){
   String OnTimerString ="";
   String FlyTimerString ="";
   int seconds = (millis() - OnTimer) / 1000;
   int minutes = seconds / 60;
   int hours = minutes / 60;
   seconds -= minutes * 60;
   minutes -= hours * 60;
  if (seconds < 10){
   OnTimerString = str(minutes) + ":0" + str(seconds);
  }
  else
  {
   OnTimerString = str(minutes) + ":" + str(seconds);
  }
  
  ShowOnTime(OnTimerString);
  
  if (FlyTimer >0){
    
    seconds = (millis() - FlyTimer) / 1000;
    minutes = seconds / 60;
    hours = minutes / 60;
    seconds -= minutes * 60;
    minutes -= hours * 60;
    if (seconds < 10){
      FlyTimerString = str(minutes) + ":0" + str(seconds);
    }
    else
    {
      FlyTimerString = str(minutes) + ":" + str(seconds);
    }
  }
  else
  {
   FlyTimerString = "0:00";
  } 
   ShowFlyTime(FlyTimerString);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////// BEGIN FILE OPS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//save the content of the model to a file
public void bSAVE() {
  updateModel();
  SwingUtilities.invokeLater(new Runnable(){
    public void run() {
     final JFileChooser fc = new JFileChooser() {

        private static final long serialVersionUID = 7919427933588163126L;

        public void approveSelection() {
            File f = getSelectedFile();
            if (f.exists() && getDialogType() == SAVE_DIALOG) {
                int result = JOptionPane.showConfirmDialog(this,
                        "The file exists, overwrite?", "Existing file",
                        JOptionPane.YES_NO_CANCEL_OPTION);
                switch (result) {
                case JOptionPane.YES_OPTION:
                    super.approveSelection();
                    return;
                case JOptionPane.CANCEL_OPTION:
                    cancelSelection();
                    return;
                default:
                    return;
                }
            }
            super.approveSelection();
        }
    };

      fc.setDialogType(JFileChooser.SAVE_DIALOG);
      fc.setFileFilter(new MwiFileFilter());
      int returnVal = fc.showSaveDialog(null);
      if (returnVal == JFileChooser.APPROVE_OPTION) {
        File file = fc.getSelectedFile();
        String filePath = file.getPath();
        if(!filePath.toLowerCase().endsWith(".osd")){
          file = new File(filePath + ".osd");
        }

        
        FileOutputStream out =null;
        String error = null;
        try{
          out = new FileOutputStream(file) ;
          MWI.conf.storeToXML(out, "RUSH_OSD Configuration File  " + new  Date().toString());
          JOptionPane.showMessageDialog(null,new StringBuffer().append("configuration saved : ").append(file.toURI()) );
        }catch(FileNotFoundException e){
         
          error = e.getCause().toString();
        }catch( IOException ioe){
                /*failed to write the file*/
                ioe.printStackTrace();
                error = ioe.getCause().toString();
        }finally{
                
          if (out!=null){
            try{
              out.close();
            }catch( IOException ioe){/*failed to close the file*/error = ioe.getCause().toString();}
          }
          if (error !=null){
                  JOptionPane.showMessageDialog(null, new StringBuffer().append("error : ").append(error) );
          }
        }
    }
    }
  }
  );
}


public void updateModel(){
  for(int j=0;j<ConfigNames.length;j++) {
         MWI.setProperty(ConfigNames[j],String.valueOf(confItem[j].value()));
  }
        
}
public void updateView(){
  for(int j=0;j<ConfigNames.length;j++) {
         confItem[j].setValue(int(MWI.getProperty(ConfigNames[j])));
         if  (confItem[j].value() >0){
           checkboxConfItem[j].activateAll();
         }
         else {
           checkboxConfItem[j].deactivateAll();
         }
           
  }
        
}



public class MwiFileFilter extends FileFilter {
 public boolean accept(File f) {
   if(f != null) {
     if(f.isDirectory()) {
       return true;
     }
     String extension = getExtension(f);
     if("osd".equals(extension)) {
       return true;
     };
   }
   return false;
 }
 public String getExtension(File f) {
   if(f != null) {
      String filename = f.getName();
      int i = filename.lastIndexOf('.');
      if(i>0 && i<filename.length()-1) {
        return filename.substring(i+1).toLowerCase();
      };
    }
    return null;
  } 
  public String getDescription() {return "*.osd Rush_OSD configuration file";}   
}


// import the content of a file into the model
public void bIMPORT(){
  SwingUtilities.invokeLater(new Runnable(){
    public void run(){
      final JFileChooser fc = new JFileChooser();
      fc.setDialogType(JFileChooser.SAVE_DIALOG);
      fc.setFileFilter(new MwiFileFilter());
      int returnVal = fc.showOpenDialog(null);
      if (returnVal == JFileChooser.APPROVE_OPTION) {
        File file = fc.getSelectedFile();
        FileInputStream in = null;
        boolean completed = false;
        String error = null;
        try{
          in = new FileInputStream(file) ;
          MWI.conf.loadFromXML(in); 
          JOptionPane.showMessageDialog(null,new StringBuffer().append("configuration loaded : ").append(file.toURI()) );
          completed  = true;
          
        }catch(FileNotFoundException e){
                error = e.getCause().toString();

        }catch( IOException ioe){/*failed to read the file*/
                ioe.printStackTrace();
                error = ioe.getCause().toString();
        }finally{
          if (!completed){
                 // MWI.conf.clear();
                 // or we can set the properties with view values, sort of 'nothing happens'
                 updateModel();
          }
          updateView();
          if (in!=null){
            try{
              in.close();
            }catch( IOException ioe){/*failed to close the file*/}
          }
          
          if (error !=null){
                  JOptionPane.showMessageDialog(null, new StringBuffer().append("error : ").append(error) );
          }
        }
      }
    }
  }
  );
}


//  our model 
static class MWI{
private static Properties conf = new Properties();

public static void setProperty(String key ,String value ){
conf.setProperty( key,value );
}

public static String getProperty(String key ){
 return conf.getProperty( key,"0");
}

public static void clear(){
        conf= null; // help gc
        conf = new Properties();
}

}

//********************************************************
//********************************************************
//********************************************************










////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// BEGIN MW SERIAL////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

int STABLEMODE =  1;            // OK
int BAROMODE=     4;            // OK
int MAGMODE=      8;            // OK
//int BOXCAMSTAB 16;         // not used
int ARMEDMODE=    16;           // OK
int GPSHOMEMODE=  128;          // OK
int GPSHOLDMODE=  64;          // OK
//int BOXCAMTRIG     256;        // not used

void SetMode(){
STABLEMODE =  int(confItem[1].value());          
BAROMODE=     int(confItem[2].value());         // OK
MAGMODE=      int(confItem[3].value());
//int BOXCAMSTAB 16;         // not used
ARMEDMODE=    int(confItem[4].value());
GPSHOMEMODE=  int(confItem[5].value());
GPSHOLDMODE=  int(confItem[6].value());
}
//int BOXCAMTRIG     256;        // not used


int time,time2,time3,time4;

int version,versionMisMatch;
int multiType;

int[] MwAngle={0,0};           // Those will hold Accelerator Angle
int[] MwRcData={   // This hold receiver pulse signal
  1500,1500,1500,1500,1500,1500,1500,1500} ;

int  MwSensorPresent=0;
int  MwSensorActive=0;
int MwVersion=0;
int MwVBat=0;
int MwVario=0;
int armed=0;
int previousarmedstatus=0;  // NEB for statistics after disarming
int armedTimer=0;
int GPS_distanceToHome=0;
int GPSPresent=0;
int GPS_fix=0;
int GPS_latitude;
int GPS_longitude;
int GPS_altitude;
int GPS_speed=0;
int GPS_ground_course;
int GPS_update=0;
int GPS_directionToHome=0;
int GPS_numSat=0;
int I2CError=0;
int cycleTime=0;
int pMeterSum=0;

/******************************* Multiwii Serial Protocol **********************/
private static final String MSP_HEADER = "$M<";

private static final int
  MSP_IDENT                =100,
  MSP_STATUS               =101,
  MSP_RAW_IMU              =102,
  MSP_SERVO                =103,
  MSP_MOTOR                =104,
  MSP_RC                   =105,
  MSP_RAW_GPS              =106,
  MSP_COMP_GPS             =107,
  MSP_ATTITUDE             =108,
  MSP_ALTITUDE             =109,
  MSP_BAT                  =110,
  MSP_RC_TUNING            =111,
  MSP_PID                  =112,
  MSP_BOX                  =113,
  MSP_MISC                 =114,
  MSP_MOTOR_PINS           =115,
  MSP_BOXNAMES             =116,
  MSP_PIDNAMES             =117,

  MSP_SET_RAW_RC           =200,
  MSP_SET_RAW_GPS          =201,
  MSP_SET_PID              =202,
  MSP_SET_BOX              =203,
  MSP_SET_RC_TUNING        =204,
  MSP_ACC_CALIBRATION      =205,
  MSP_MAG_CALIBRATION      =206,
  MSP_SET_MISC             =207,
  MSP_RESET_CONF           =208,
  MSP_SELECT_SETTING       =210,
  MSP_OSD_READ             =220,
  MSP_OSD_WRITE            =221,
  MSP_SPEK_BIND            =240,

  MSP_EEPROM_WRITE         =250,
  
  MSP_DEBUGMSG             =253,
  MSP_DEBUG                =254
;

public static final int
  IDLE = 0,
  HEADER_START = 1,
  HEADER_M = 2,
  HEADER_ARROW = 3,
  HEADER_SIZE = 4,
  HEADER_CMD = 5,
  HEADER_ERR = 6
;

int c_state = IDLE;
boolean err_rcvd = false;

byte checksum=0;
byte cmd;
int offset=0, dataSize=0;
byte[] inBuf = new byte[256];


int p;
int read32() {return (inBuf[p++]&0xff) + ((inBuf[p++]&0xff)<<8) + ((inBuf[p++]&0xff)<<16) + ((inBuf[p++]&0xff)<<24); }
int read16() {return (inBuf[p++]&0xff) + ((inBuf[p++])<<8); }
int read8()  {return inBuf[p++]&0xff;}

int mode;
boolean toggleRead = false,toggleReset = false,toggleCalibAcc = false,toggleCalibMag = false,toggleWrite = false,toggleSpekBind = false,toggleSetSetting = false;

//send msp without payload
private List<Byte> requestMSP(int msp) {
  return  requestMSP( msp, null);
}

//send multiple msp without payload
private List<Byte> requestMSP (int[] msps) {
  List<Byte> s = new LinkedList<Byte>();
  for (int m : msps) {
    s.addAll(requestMSP(m, null));
  }
  return s;
}

//send msp with payload
private List<Byte> requestMSP (int msp, Character[] payload) {
  if(msp < 0) {
   return null;
  }
  List<Byte> bf = new LinkedList<Byte>();
  for (byte c : MSP_HEADER.getBytes()) {
    bf.add( c );
  }
  
  byte checksum=0;
  byte pl_size = (byte)((payload != null ? int(payload.length) : 0)&0xFF);
  bf.add(pl_size);
  checksum ^= (pl_size&0xFF);
  
  bf.add((byte)(msp & 0xFF));
  checksum ^= (msp&0xFF);
  
  if (payload != null) {
    for (char c :payload){
      bf.add((byte)(c&0xFF));
      checksum ^= (c&0xFF);
    }
  }
  bf.add(checksum);
  return (bf);
}

void sendRequestMSP(List<Byte> msp) {
  byte[] arr = new byte[msp.size()];
  int i = 0;
  for (byte b: msp) {
    arr[i++] = b;
  }
  g_serial.write(arr); // send the complete byte sequence in one go
}

public void evaluateCommand(byte cmd, int dataSize) {
  int i;
  int icmd = (int)(cmd&0xFF);
  switch(icmd) {
    case MSP_STATUS:
      cycleTime=read16();
      I2CError=read16();
      MwSensorPresent = read16();
      MwSensorActive = read32();
      read8(); //   
      break;
        
    case MSP_ATTITUDE:
        
    for(i=0;i<2;i++) MwAngle[i] = read16();
    MwHeading = read16();
    read16();
    break;
   
   
   case MSP_BAT:
   
   MwVBat=read8();
   pMeterSum=read16();
   break;
  }
   
}


void GetMWData(){
  List<Character> payload;
  int i,aa;
  float val,inter,a,b,h;
  int c;
  if ((init_com==1) && (ReadMW ==1)) {
    time=millis();
    if ((time-time4)>40 ) {
      time4=time;
      //accROLL.addVal(ax);accPITCH.addVal(ay); //accYAW.addVal(az);gyroROLL.addVal(gx);gyroPITCH.addVal(gy);gyroYAW.addVal(gz);
      
      //magxData.addVal(magx);magyData.addVal(magy);magzData.addVal(magz);
      //altData.addVal(alt);headData.addVal(head);
      //debug1Data.addVal(debug1);debug2Data.addVal(debug2);debug3Data.addVal(debug3);debug4Data.addVal(debug4);
    }
    if ((time-time2)>40 && ! toggleRead && ! toggleWrite && ! toggleSetSetting) {
      time2=time;
      int[] requests = {MSP_STATUS, MSP_RAW_IMU, MSP_SERVO, MSP_MOTOR, MSP_RC, MSP_RAW_GPS, MSP_COMP_GPS, MSP_ALTITUDE, MSP_BAT, MSP_DEBUGMSG, MSP_DEBUG};
      sendRequestMSP(requestMSP(requests));
    }
    if ((time-time3)>20 && ! toggleRead && ! toggleWrite && ! toggleSetSetting) {
      sendRequestMSP(requestMSP(MSP_ATTITUDE));
      time3=time;
    }
     while (g_serial.available()>0) {
      c = (g_serial.read());

      if (c_state == IDLE) {
        c_state = (c=='$') ? HEADER_START : IDLE;
      } else if (c_state == HEADER_START) {
        c_state = (c=='M') ? HEADER_M : IDLE;
      } else if (c_state == HEADER_M) {
        if (c == '>') {
          c_state = HEADER_ARROW;
        } else if (c == '!') {
          c_state = HEADER_ERR;
        } else {
          c_state = IDLE;
        }
      } else if (c_state == HEADER_ARROW || c_state == HEADER_ERR) {
        /* is this an error message? */
        err_rcvd = (c_state == HEADER_ERR);        /* now we are expecting the payload size */
        dataSize = (c&0xFF);
        /* reset index variables */
        p = 0;
        offset = 0;
        checksum = 0;
        checksum ^= (c&0xFF);
        /* the command is to follow */
        c_state = HEADER_SIZE;
      } else if (c_state == HEADER_SIZE) {
        cmd = (byte)(c&0xFF);
        checksum ^= (c&0xFF);
        c_state = HEADER_CMD;
      } else if (c_state == HEADER_CMD && offset < dataSize) {
          checksum ^= (c&0xFF);
          inBuf[offset++] = (byte)(c&0xFF);
      } else if (c_state == HEADER_CMD && offset >= dataSize) {
        /* compare calculated and transferred checksum */
        if ((checksum&0xFF) == (c&0xFF)) {
          if (err_rcvd) {
            //System.err.println("Copter did not understand request type "+c);
          } else {
            /* we got a valid response packet, evaluate it */
            evaluateCommand(cmd, (int)dataSize);
          }
        } else {
          System.out.println("invalid checksum for command "+((int)(cmd&0xFF))+": "+(checksum&0xFF)+" expected, got "+(int)(c&0xFF));
          System.out.print("<"+(cmd&0xFF)+" "+(dataSize&0xFF)+"> {");
          for (i=0; i<dataSize; i++) {
            if (i!=0) { System.err.print(' '); }
            System.out.print((inBuf[i] & 0xFF));
          }
          System.out.println("} ["+c+"]");
          System.out.println(new String(inBuf, 0, dataSize));
        }
        c_state = IDLE;
      }
    }
  }
}


