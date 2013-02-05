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


String KV_OSD_GUI_Version = "2.01b";


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
Boolean SimulateMW = false;


ControlP5 controlP5;
Textlabel txtlblWhichcom; 
ListBox commListbox;

char serialBuffer[] = new char[128]; // this hold the imcoming string from serial O string
String TestString = "";
String SendCommand = "";


boolean firstContact = false;   
boolean disableSerial = false;


// Int variables

String LoadPercent = "Not Loaded";
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
int XRSSI      = 120;        int YRSSI    = 50;
int XVolts      = 120;        int YVolts    = 130;
int XTemp      = 120;        int YTemp    = 300;
int XGPS       = 120;        int YGPS    = 365;
int XBoard     = 120;        int YBoard   = 465;
int XOther     = 310;        int YOther   = 5;
int XControlBox     = 5;        int YControlBox   = 435;
int XRCSim    =   XSim;      int YRCSim = 430;


File FontFile;
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
// int variables

// For Heading
char[] headGraph={
  0x1a,0x1d,0x1c,0x1d,0x19,0x1d,0x1c,0x1d,0x1b,0x1d,0x1c,0x1d,0x18,0x1d,0x1c,0x1d,0x1a,0x1d,0x1c,0x1d,0x19,0x1d,0x1c,0x1d,0x1b};

static int MwHeading=0;
char MwHeadingUnitAdd=0xbd;

int[] EEPROM_DEFAULT = {
1,   // used for check                0
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
  "Enable OSD Read ADC:",
  "RSSI Over MW:"
  

};
String[] ConfigHelp = {
  "Shows if EEPROM is Loaded, uncheck to reset to defaults",
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
  "checked ON, unchecked OFF",
  "checked RSSI from MW, unchecked Onboard RSSI"
  };




static int CHECKBOXITEMS=0;
int CONFIGITEMS=ConfigNames.length;
static int SIMITEMS=6;
  
int[] ConfigRanges = {
1,   // used for check             0
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
1      // S_MWRSSI                 33
};
String[] SimNames= {
  "Armed:",
  "Acro/Stable:",
  "Bar Mode:",
  "Mag Mode:",
  "GPS Home:",
  "GPS Hold:",
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
  1,
  1,
  255,
  1,
  1,
  1};


PFont font8,font9,font10,font11,font12,font15;

//Colors--------------------------------------------------------------------------------------------------------------------
color yellow_ = color(200, 200, 20), green_ = color(30, 120, 30), red_ = color(120, 30, 30), blue_ = color(50, 50, 100),
grey_ = color(30, 30, 30);
//Colors--------------------------------------------------------------------------------------------------------------------

// textlabels -------------------------------------------------------------------------------------------------------------
Textlabel txtlblconfItem[] = new Textlabel[CONFIGITEMS] ;
Textlabel txtlblSimItem[] = new Textlabel[SIMITEMS] ;
Textlabel FileUploadText;
// textlabels -------------------------------------------------------------------------------------------------------------

// Buttons------------------------------------------------------------------------------------------------------------------
Button buttonIMPORT,buttonSAVE,buttonREAD,buttonRESET,buttonWRITE,buttonSendFile,buttonBrowseFile;
// Buttons------------------------------------------------------------------------------------------------------------------

// Toggles------------------------------------------------------------------------------------------------------------------
Toggle toggleConfItem[] = new Toggle[CONFIGITEMS] ;
// Toggles------------------------------------------------------------------------------------------------------------------    

// checkboxes------------------------------------------------------------------------------------------------------------------
CheckBox checkboxConfItem[] = new CheckBox[CONFIGITEMS] ;


// Toggles------------------------------------------------------------------------------------------------------------------    

//  number boxes--------------------------------------------------------------------------------------------------------------

Numberbox confItem[] = new Numberbox[CONFIGITEMS] ;
//Numberbox SimItem[] = new Numberbox[SIMITEMS] ;
//  number boxes--------------------------------------------------------------------------------------------------------------

Group MGUploadF;

// Timers --------------------------------------------------------------------------------------------------------------------
//ControlTimer OnTimer,FlyTimer;





controlP5.Controller hideLabel(controlP5.Controller c) {
  c.setLabel("");
  c.setLabelVisible(false);
  return c;
}




void setup() {
  size(windowsX,windowsY);
 

OnTimer = millis();
  frameRate(10); 
OSDBackground = loadImage("Background.jpg");
RadioPot = loadImage("Radio_Pot.png");
//image(OSDBackground,DisplayWindowX+WindowAdjX, DisplayWindowY+WindowAdjY, DisplayWindowX+360-WindowShrinkX, DisplayWindowY+288-WindowShrinkY);
img_Clear = LoadFont("MW_OSD_Team.mcm");

  font8 = createFont("Arial bold",8,false);
  font9 = createFont("Arial bold",10,false);
  font10 = createFont("Arial bold",11,false);
  font11 = createFont("Arial bold",11,false);
  font12 = createFont("Arial bold",12,false);
  font15 = createFont("Arial bold",15,false);

  controlP5 = new ControlP5(this); // initialize the GUI controls
  controlP5.setControlFont(font10);


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
  
  buttonREAD = controlP5.addButton("READ",1,XControlBox+30,YControlBox+25,45,16);buttonREAD.setColorBackground(red_);
  buttonRESET = controlP5.addButton("RESET",1,XControlBox+30,YControlBox+50,45,16);buttonRESET.setColorBackground(red_);
  buttonWRITE = controlP5.addButton("WRITE",1,XControlBox+30,YControlBox+75,45,16);buttonWRITE.setColorBackground(red_);

//buttonSendFile = controlP5.addButton("Send Font",1,5,17,15,16)




// EEPROM----------------------------------------------------------------
MakeGroup(0, 1, XEEPROM, YEEPROM);

// RSSI  ---------------------------------------------------------------------------
MakeGroup(1, 4, XRSSI, YRSSI);

// Voltage  ------------------------------------------------------------------------
MakeGroup(4, 12, XVolts, YVolts);

//  Temperature  --------------------------------------------------------------------
MakeGroup(12, 14, XTemp, YTemp);


//  Board ---------------------------------------------------------------------------
MakeGroup(14, 15, XBoard, YBoard);
//BuildTextLabels(20, 21, XBoard+5, YBoard);
//BuildNumberBoxes(20, 21, XBoard+5, YBoard);
//BuildCheckBoxes(20, 21, XBoard+5, YBoard+3);

//  GPS  ----------------------------------------------------------------------------
MakeGroup(15, 19, XGPS, YGPS);
//BuildTextLabels(21, 25, XGPS+5, YGPS);
//BuildNumberBoxes(21, 25, XGPS+5, YGPS);
//BuildCheckBoxes(21, 25, XGPS+5, YGPS+3);

//  Other ---------------------------------------------------------------------------
MakeGroup(19, 28, XOther, YOther);
//BuildTextLabels(25, 34, XOther+5, YOther);
//BuildNumberBoxes(25, 34, XOther+5, YOther);
//BuildCheckBoxes(25, 34, XOther+5, YOther+3);


 MGUploadF = controlP5.addGroup("MGUploadF")
                .setPosition(5,200)
                .setWidth(110)
                .setBarHeight(15)
                .activateEvent(true)
                .setBackgroundColor(color(30,255))
                .setBackgroundHeight(70)
                .setLabel("Upload Font")
                //.setGroup(SG)
                //.close() 
               ; 

FileUploadText = controlP5.addTextlabel("FileUploadText",LoadPercent,10,5)
.setGroup(MGUploadF);
;

buttonSendFile = controlP5.addButton("Send",1,5,25,60,16)
.setGroup(MGUploadF);
;
buttonBrowseFile = controlP5.addButton("Browse",1,5,45,60,16)
.setGroup(MGUploadF);
;



  
  // CheckBox "Simulate MultiWii"
  SimulateMultiWii = controlP5.addCheckBox("SimulateMultiWii",XSim+200,YSim);
  SimulateMultiWii.setColorActive(color(255));
  SimulateMultiWii.setColorBackground(color(120));
  SimulateMultiWii.setItemsPerRow(1);
  SimulateMultiWii.setSpacingColumn(10);
  SimulateMultiWii.setLabel("Simulate MultiWii");
  SimulateMultiWii.addItem("Simulate MultiWii",1);
       
  // CheckBox "Hide Background"
  ShowSimBackground = controlP5.addCheckBox("ShowSimBackground",XSim+50,YSim);
  ShowSimBackground.setColorActive(color(255));
  ShowSimBackground.setColorBackground(color(120));
  ShowSimBackground.setItemsPerRow(1);
  ShowSimBackground.setSpacingColumn(10);
  ShowSimBackground.setLabel("Hide Background");
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
  
  
  

  
  

  BuildToolHelp();
  
   SimSetup();
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

void MakeGroup(int starter, int ender, int StartXLoction, int StartYLocation){
  BuildTextLabels(starter, ender, StartXLoction+5, StartYLocation);
  BuildNumberBoxes(starter, ender, StartXLoction+5, StartYLocation);
  BuildCheckBoxes(starter, ender, StartXLoction+5, StartYLocation+3);
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

void BuildNumberBoxes(int starter, int ender, int StartXLoction, int StartYLocation) {
  YLocation = StartYLocation; 
  for(int i=starter;i<ender;i++) {
    YLocation+=17;
    confItem[i] = (controlP5.Numberbox) hideLabel(controlP5.addNumberbox("configItem"+i,0,StartXLoction,YLocation,35,14));
    confItem[i].setColorBackground(red_);
    confItem[i].setMin(0);
    confItem[i].setDirection(Controller.HORIZONTAL);
    confItem[i].setMax(ConfigRanges[i]);
    confItem[i].setDecimalPrecision(0);
  //confItem[i].setMultiplier(4);
  //confItem[i].setDecimalPrecision(1);
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
  controlP5.getTooltip().setDelay(100);
  //confItem[1].setMultiplier(confItem[1].value);
  //controlP5.getTooltip().register("txtlblconfItem"+0,"Changes the size of the ellipse.");
  //controlP5.getTooltip().register("s2","Changes the Background");
}

public void Send(){
  sendFontFile();
}





void draw() {
  time=millis();
  hint(ENABLE_DEPTH_TEST);
  pushMatrix();
  GetMWData();
  background(80);
  
  // ------------------------------------------------------------------------
  // Draw background control boxes
  // ------------------------------------------------------------------------

  // Coltrol Box
  fill(100); strokeWeight(3);stroke(200); rectMode(CORNERS); rect(XControlBox,YControlBox, XControlBox+105 , YControlBox+100);
  textFont(font12); fill(255, 255, 255); text("OSD Controls",XControlBox + 15,YControlBox + 15);
  if (activeTab == 1) {
    // EEPROM Box
    fill(30, 30,30); strokeWeight(3);stroke(1); rectMode(CORNERS); rect(XEEPROM,YEEPROM, XEEPROM+180, YEEPROM+35);
    textFont(font12); fill(0, 110, 220); text("EEPROM STATUS", XEEPROM + 45,YEEPROM + 10);
    // Modes Box
    //fill(30, 30,30); strokeWeight(3);stroke(1); rectMode(CORNERS); rect(XModeBox,YModeBox, XModeBox+180, YModeBox+120);
    //textFont(font12); fill(0, 110, 220); text("Flight Modes",XModeBox + 45,YModeBox + 10);
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
    fill(30, 30,30); strokeWeight(3);stroke(1); rectMode(CORNERS); rect(XGPS,YGPS, XGPS+180 , YGPS+90);
    textFont(font12); fill(0, 110, 220); text("GPS / Nav",XGPS + 60,YGPS + 10);
    // Board Box
    fill(30, 30,30); strokeWeight(3);stroke(1); rectMode(CORNERS); rect(XBoard,YBoard, XBoard+180 , YBoard+40);
    textFont(font12); fill(0, 110, 220); text("Board Type",XBoard + 65,YBoard + 10);
    // Other Box
  fill(30, 30,30); strokeWeight(3);stroke(1); rectMode(CORNERS); rect(XOther,YOther, XOther+200 , YOther+175);
    textFont(font12); fill(0, 110, 220); text("Other",XOther + 75,YOther + 10);
  }
  
  fill(40, 40, 40);
  strokeWeight(3);stroke(0);
  rectMode(CORNERS);
  rect(5,5,113,40);
  textFont(font15);
  // version
  fill(255, 255, 255);
  text("KV Team OSD",10,19);
  text("  GUI    V",10,35);
  text(KV_OSD_GUI_Version, 74, 35);
  fill(0, 0, 0);
  strokeWeight(3);stroke(0);
  rectMode(CORNERS);
  if (int(ShowSimBackground.arrayValue()[0]) < 1){
    image(OSDBackground,DisplayWindowX+WindowAdjX, DisplayWindowY+WindowAdjY, 360-WindowShrinkX, 288-WindowShrinkY);
  }
  else{
    fill(80, 80,80); strokeWeight(3);stroke(1); rectMode(CORNER); rect(DisplayWindowX+WindowAdjX, DisplayWindowY+WindowAdjY, 360-WindowShrinkX, 288-WindowShrinkY);
  }

  MatchConfigs();

  displayHorizon(int(MW_Pitch_Roll.arrayValue()[0])*10,int(MW_Pitch_Roll.arrayValue()[1])*10*-1);
  SimulateTimer();
  ShowCurrentThrottlePosition();
  if (int(confItem[9].value()) > 0)
    ShowRSSI(); 
  if (int(confItem[10].value()) > 0) {
     ShowVolts(sVBat);
  }
    
 
  CalcAlt_Vario(); 
  displaySensors();
  displayMode();
  ShowAmperage();
  displayHeadingGraph();
  displayHeading();
  popMatrix();
  hint(DISABLE_DEPTH_TEST);
}



void ShowSimBackground(float[] a) {
  Showback = int(a[0]);
}

void SimulateMultiWii(float[] a) {
  if (a[0] > 0){
    SimulateMW = true;
  }
  else{
     SimulateMW = false;
     ResetVersion();
     //s.arrayValue()[0] =0;
     //s.arrayValue()[1] =0;
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
  if ((checkboxModeItems[0].arrayValue()[0] == 1) && (SimItem0 < 1)){
    Armed = 1;
    FlyTimer = millis();
  }
  // turn off FlyTimer----
  if ((checkboxModeItems[0].arrayValue()[0] == 0) && (SimItem0 == 1)){
    FlyTimer = 0;
  }


}

// controls comport list click
public void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup())
    if (theEvent.name()=="portComList")
      InitSerial(theEvent.group().value()); // initialize the serial port selected
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





void ShowVolts(float voltage){
  
String output = OnePlaceDecimal.format(voltage);
  mapchar(0x97, voltagePosition[ScreenType]);
  makeText(output, voltagePosition[ScreenType]+2);
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

  if (FlyTimer >0) {
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

public void Browse(){
  SwingUtilities.invokeLater(new Runnable(){
    public void run(){
      final JFileChooser fc = new JFileChooser();
      fc.setDialogType(JFileChooser.SAVE_DIALOG);
      fc.setFileFilter(new FontFileFilter());
      int returnVal = fc.showOpenDialog(null);
      if (returnVal == JFileChooser.APPROVE_OPTION) {
        FontFile = fc.getSelectedFile();
        FileInputStream in = null;
        boolean completed = false;
        String error = null;
        try{
          in = new FileInputStream(FontFile) ;
          //MWI.conf.loadFromXML(in); 
          JOptionPane.showMessageDialog(null,new StringBuffer().append("Font File loaded : ").append(FontFile.toURI()) );
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
                 //updateModel();
          }
          //updateView();
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
  for(int j=0; j<ConfigNames.length; j++) {
    confItem[j].setValue(int(MWI.getProperty(ConfigNames[j])));
    if(confItem[j].value() >0) {
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
      }
    }
    return false;
  }


  public String getExtension(File f) {
    if(f != null) {
      String filename = f.getName();
      int i = filename.lastIndexOf('.');
      if(i>0 && i<filename.length()-1) {
        return filename.substring(i+1).toLowerCase();
      }
    }
    return null;
  } 

  public String getDescription() {
    return "*.osd Rush_OSD configuration file";
  }   
}

public class FontFileFilter extends FileFilter {
  public boolean accept(File f) {
    if(f != null) {
      if(f.isDirectory()) {
        return true;
      }
      String extension = getExtension(f);
      if("mcm".equals(extension)) {
        return true;
      }
    }
    return false;
  }

  public String getExtension(File f) {
    if(f != null) {
      String filename = f.getName();
      int i = filename.lastIndexOf('.');
      if(i>0 && i<filename.length()-1) {
        return filename.substring(i+1).toLowerCase();
      }
    }
    return null;
  } 

  public String getDescription() {
    return "*.mcm Font File";
  }   
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
static class MWI {
  private static Properties conf = new Properties();

  public static void setProperty(String key ,String value ){
    conf.setProperty( key,value );
  }

  public static String getProperty(String key ){
    return conf.getProperty( key,"0");
  }

  public static void clear( ){
    conf= null; // help gc
    conf = new Properties();
  }
}

//********************************************************
//********************************************************
//********************************************************










////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// BEGIN MW SERIAL////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

int STABLEMODE =  1;           // OK
int BAROMODE=     4;           // OK
int MAGMODE=      8;           // OK
int ARMEDMODE=    16;          // OK
int GPSHOLDMODE=  64;          // OK
int GPSHOMEMODE=  128;         // OK

void SetMode(){
  STABLEMODE =  int(confItem[1].value());          
  BAROMODE=     int(confItem[2].value());         // OK
  MAGMODE=      int(confItem[3].value());
  ARMEDMODE=    int(confItem[4].value());
  GPSHOMEMODE=  int(confItem[5].value());
  GPSHOLDMODE=  int(confItem[6].value());
}

int time,time2,time3,time4;

int version,versionMisMatch;
int multiType;

int[] MwAngle={ 0, 0 };           // Those will hold Accelerator Angle
int[] MwRcData={   // This hold receiver pulse signal
  1500,1500,1500,1500,1500,1500,1500,1500} ;

int MwSensorPresent=0;
int MwSensorActive=0;
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


boolean toggleRead = false,
        toggleReset = false,
        toggleCalibAcc = false,
        toggleCalibMag = false,
        toggleWrite = false,
        toggleSpekBind = false,
        toggleSetSetting = false;
        
        
void stop(){
  if(init_com == 1){
   SimulateMW = false; 
  init_com = 0; 
  InitSerial(0);
  }
}         

