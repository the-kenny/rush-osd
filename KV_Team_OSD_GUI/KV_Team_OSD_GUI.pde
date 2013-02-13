
//   KV Team OSD GUI
//   By Ros Power
//   http://code.google.com/p/rush-osd-development/
//   February  2013  V2.01b
//   This program is free software: you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation, either version 3 of the License, or
//   any later version. see http://www.gnu.org/licenses/

              /***********************************************************************************************************************************************/
              /*                                                            KV_OSD_Team_GUI                                                                  */
              /*                                                                                                                                             */
              /*                                                                                                                                             */
              /*                                             This software is the result of a team work                                                      */
              /*                                                                                                                                             */
              /*                           POWER67             KATAVENTOS               ITAIN                    CARLONB                                     */
              /*                                                                                                                                             */
              /*                                                                                                                                             */
              /*                                                                                                                                             */
              /*                                                                                                                                             */
              /*                                                                                                                                             */
              /***********************************************************************************************************************************************/


 



import processing.serial.Serial; // serial library
import controlP5.*; // controlP5 library
import java.io.File;
import java.lang.StringBuffer; // for efficient String concatemation
import javax.swing.SwingUtilities; // required for swing and EDT
import javax.swing.JFileChooser; // Saving dialogue
import javax.swing.filechooser.FileFilter; // for our configuration file filter "*.mwi"
import javax.swing.JOptionPane; // for message dialogue
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream; 
import java.io.FileOutputStream;
import java.io.FileInputStream;
import java.util.*;
import java.io.FileNotFoundException;
import java.text.DecimalFormat; 

//added new imports to support proccessing 2.0b7



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
//Boolean SimulateMW = true;


ControlP5 controlP5;
ControlP5 SmallcontrolP5;
ControlP5 ScontrolP5;
ControlP5 FontGroupcontrolP5;
ControlP5 GroupcontrolP5;
Textlabel txtlblWhichcom; 
ListBox commListbox;

char serialBuffer[] = new char[128]; // this hold the imcoming string from serial O string
String TestString = "";
String SendCommand = "";


boolean firstContact = false;   
boolean disableSerial = false;

boolean PortRead = true;
boolean PortWrite = false;


ControlGroup messageBox;
Textlabel MessageText;
int messageBoxResult = -1;



// Int variables

String LoadPercent = "";
int init_com;
int commListMax;
int whichKey = -1;  // Variable to hold keystoke values
int inByte = -1;    // Incoming serial data
int[] serialInArray = new int[3];    // Where we'll put what we receive

String test;
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
int Col1Width = 180;        int Col2Width = 200;

int XEEPROM    = 120;        int YEEPROM    = 5;  //hidden do not remove
int XBoard     = 120;        int YBoard   = 5;
int XRSSI      = 120;        int YRSSI    = 48;
int XVolts      = 120;       int YVolts    = 126;
int XAmps       = 120;       int YAmps    = 238;
int XVVolts    = 120;        int YVVolts  = 300;
int XTemp      = 120;        int YTemp    = 378;
int XGPS       = 120;        int YGPS    = 442;

int XOther     = 310;        int YOther   = 5; //48;
int XPortStat  = 5;            int YPortStat = 350;
int XControlBox     = 5;        int YControlBox   = 415;
int XRCSim    =   XSim;      int YRCSim = 430;


//File FontFile;
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


String[] ConfigNames = {
  "EEPROM Loaded",
  
  "RSSI Min",
  "RSSI Max",
  "Display RSSI",
  
  "Display Voltage",
  "Voltage Min",
  "Battery Cells",
  "Main Voltage Devider",
  "Main Voltage MW",
  
  "Display Amperage",
  "Diplay Amperage Used",
  
  "Display Video Voltage",
  "Video Voltage Devider",
  "Video Voltage MW",
  
  "Display Temperature",
  "Temperature Max",
  
  "",
  
  "Display GPS",
  "Display GPS Coords",
  "Display Heading",
  "Display Heading 360",
  
  "Units",
  "Video Signal",
  "Display Thottle Position",
  "Display Hoizon Bar",
  "Display Horizon Side Bars",
  "Display Battery Evo",
  "Reset Stats After Arm",
  "Enable OSD Read ADC",
  "RSSI Over MW"
  

};
String[] ConfigHelp = {
  "EEPROM Loaded:",
  
  "RSSI Min:",
  "RSSI Max:",
  "Display RSSI:",
  
  "Display Voltage:",
  "Voltage Min:",
  "Battery Cells",
  "Main Voltage Devider:",
  "Main Voltage MW:",
  
  "Display Amperage:",
  "Diplay Amperage Used:",
  
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

1,     // S_AMPERAGE,
1,     // S_AMPER_HOUR,

1,     // S_VIDVOLTAGE             15
255,   // S_VIDDIVIDERRATIO        16    
1,     // S_VIDVOLTAGE_VBAT        17

1,     // S_DISPLAYTEMPERATURE     18
255,   // S_TEMPERATUREMAX         19

1,     // S_BOARDTYPE              20

1,     // S_DISPLAYGPS             21
1,     // S_COORDINATES            22
1,     // S_SHOWHEADING            28 
1,     // S_HEADING360             29

1,     // S_UNITSYSTEM             23
1,     // S_SCREENTYPE             24
1,     // S_THROTTLEPOSITION       25
1,     // S_DISPLAY_HORIZON_BR     26
1,     // S_WITHDECORATION         27
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
Button buttonIMPORT,buttonSAVE,buttonREAD,buttonRESET,buttonWRITE,buttonRESTART;
// Buttons------------------------------------------------------------------------------------------------------------------

// Toggles------------------------------------------------------------------------------------------------------------------
Toggle toggleConfItem[] = new Toggle[CONFIGITEMS] ;
// Toggles------------------------------------------------------------------------------------------------------------------    

// checkboxes------------------------------------------------------------------------------------------------------------------
CheckBox checkboxConfItem[] = new CheckBox[CONFIGITEMS] ;


// Toggles------------------------------------------------------------------------------------------------------------------    
RadioButton RadioButtonConfItem[] = new RadioButton[CONFIGITEMS] ;
RadioButton R_PortStat;

//  number boxes--------------------------------------------------------------------------------------------------------------

Numberbox confItem[] = new Numberbox[CONFIGITEMS] ;
//Numberbox SimItem[] = new Numberbox[SIMITEMS] ;
//  number boxes--------------------------------------------------------------------------------------------------------------

Group MGUploadF,
  G_EEPROM,
  G_RSSI,
  G_Voltage,
  G_Amperage,
  G_VVoltage,
  G_Temperature,
  G_Board,
  G_GPS,
  G_Other,
  G_PortStatus
  ;

// Timers --------------------------------------------------------------------------------------------------------------------
//ControlTimer OnTimer,FlyTimer;

controlP5.Controller hideLabel(controlP5.Controller c) {
  c.setLabel("");
  c.setLabelVisible(false);
  return c;
}



void setup() {
  size(windowsX,windowsY);
 
//Map<Settings, String> table = new EnumMap<Settings>(Settings.class);
OnTimer = millis();
  frameRate(10); 
OSDBackground = loadImage("Background.jpg");
RadioPot = loadImage("Radio_Pot.png");

  font8 = createFont("Arial bold",8,false);
  font9 = createFont("Arial bold",10,false);
  font10 = createFont("Arial bold",11,false);
  font11 = createFont("Arial bold",11,false);
  font12 = createFont("Arial bold",12,false);
  font15 = createFont("Arial bold",15,false);

  controlP5 = new ControlP5(this); // initialize the GUI controls
  controlP5.setControlFont(font10);
  controlP5.setAutoDraw(false);
  

  SmallcontrolP5 = new ControlP5(this); // initialize the GUI controls
  SmallcontrolP5.setControlFont(font9); 
  SmallcontrolP5.setAutoDraw(false); 
 
  ScontrolP5 = new ControlP5(this); // initialize the GUI controls
  ScontrolP5.setControlFont(font10);  
  ScontrolP5.setAutoDraw(false);  
 
 
 FontGroupcontrolP5 = new ControlP5(this); // initialize the GUI controls
 FontGroupcontrolP5.setControlFont(font10);
 FontGroupcontrolP5.setAutoDraw(false); 
 
 
  GroupcontrolP5 = new ControlP5(this); // initialize the GUI controls
  GroupcontrolP5.setControlFont(font10);
  GroupcontrolP5.setColorForeground(color(30,255));
  GroupcontrolP5.setColorBackground(color(30,255));
  GroupcontrolP5.setColorLabel(color(0, 110, 220));
  GroupcontrolP5.setColorValue(0xffff88ff);
  GroupcontrolP5.setColorActive(color(30,255));
  GroupcontrolP5.setAutoDraw(false);
  

  SetupGroups();




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
  buttonRESTART = controlP5.addButton("RESTART",1,XControlBox+25,YControlBox+100,55,16);buttonWRITE.setColorBackground(red_);



// EEPROM----------------------------------------------------------------

CreateItem(GetSetting("S_CHECK_"), 5, 0, G_EEPROM);

// RSSI  ---------------------------------------------------------------------------

CreateItem(GetSetting("S_RSSIMIN"), 5, 0, G_RSSI);
CreateItem(GetSetting("S_RSSIMAX"), 5,1*17, G_RSSI);
CreateItem(GetSetting("S_DISPLAYRSSI"), 5, 2*17, G_RSSI);

// Voltage  ------------------------------------------------------------------------

CreateItem(GetSetting("S_DISPLAYVOLTAGE"), 5,0, G_Voltage);
CreateItem(GetSetting("S_VOLTAGEMIN"), 5,1*17, G_Voltage);
CreateItem(GetSetting("S_BATCELLS"), 5,2*17, G_Voltage);
CreateItem(GetSetting("S_DIVIDERRATIO"), 5,3*17, G_Voltage);
CreateItem(GetSetting("S_MAINVOLTAGE_VBAT"), 5,4*17, G_Voltage);

// Amperage  ------------------------------------------------------------------------
CreateItem(GetSetting("S_AMPERAGE"),  5,0, G_Amperage);
CreateItem(GetSetting("S_AMPER_HOUR"),  5,1*17, G_Amperage);

// Video Voltage  ------------------------------------------------------------------------
CreateItem(GetSetting("S_VIDVOLTAGE"),  5,0, G_VVoltage);
CreateItem(GetSetting("S_VIDDIVIDERRATIO"),  5,1*17, G_VVoltage);
CreateItem(GetSetting("S_VIDVOLTAGE_VBAT"),  5,2*17, G_VVoltage);

//  Temperature  --------------------------------------------------------------------
CreateItem(GetSetting("S_DISPLAYTEMPERATURE"),  5,0, G_Temperature);
CreateItem(GetSetting("S_TEMPERATUREMAX"),  5,1*17, G_Temperature);

//  Board ---------------------------------------------------------------------------
CreateItem(GetSetting("S_BOARDTYPE"),  5,0, G_Board);
BuildRadioButton(GetSetting("S_BOARDTYPE"),  5,0, G_Board, "Rush","Minim");


//  GPS  ----------------------------------------------------------------------------
CreateItem(GetSetting("S_DISPLAYGPS"), 5,0, G_GPS);
CreateItem(GetSetting("S_COORDINATES"),  5,1*17, G_GPS);
CreateItem(GetSetting("S_SHOWHEADING"),  5,2*17, G_GPS);
CreateItem(GetSetting("S_HEADING360"),  5,3*17, G_GPS);

//  Other ---------------------------------------------------------------------------
CreateItem(GetSetting("S_UNITSYSTEM"),  5,0, G_Other);
BuildRadioButton(GetSetting("S_UNITSYSTEM"),  5,0, G_Other, "Metric","Imperial");
CreateItem(GetSetting("S_VIDEOSIGNALTYPE"),  5,1*17, G_Other);
BuildRadioButton(GetSetting("S_VIDEOSIGNALTYPE"),  5,1*17, G_Other, "NTSC","PAL");
CreateItem(GetSetting("S_THROTTLEPOSITION"),  5,2*17, G_Other);
CreateItem(GetSetting("S_DISPLAY_HORIZON_BR"),  5,3*17, G_Other);
CreateItem(GetSetting("S_WITHDECORATION"),  5,4*17, G_Other);
CreateItem(GetSetting("S_SHOWBATLEVELEVOLUTION"),  5,5*17, G_Other);
CreateItem(GetSetting("S_RESETSTATISTICS"),  5,6*17, G_Other);
CreateItem(GetSetting("S_ENABLEADC"),  5,7*17, G_Other);
CreateItem(GetSetting("S_MWRSSI"),  5,8*17, G_Other);






       
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
      toggleConfItem[i].hide();
      confItem[i].hide();
    }
    if (ConfigRanges[i] > 1) {
      toggleConfItem[i].hide();
    }
      
    if (ConfigRanges[i] == 1){
      confItem[i].hide();  
    }
  }
  
  
  

  
  

  BuildToolHelp();
  Font_Editor_setup();
   SimSetup();
  img_Clear = LoadFont("MW_OSD_Team.mcm");
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



void BuildRadioButton(int ItemIndex, int XLoction, int YLocation,Group inGroup, String Cap1, String Cap2){
    
  RadioButtonConfItem[ItemIndex] = controlP5.addRadioButton("RadioButton"+ItemIndex)
         .setPosition(XLoction,YLocation+3)
         .setSize(10,10)
         .setNoneSelectedAllowed(false) 
         //.setColorBackground(color(120))
         //.setColorActive(color(255))
        // .setColorLabel(color(255))
         .setItemsPerRow(2)
         .setSpacingColumn(int(textWidth(Cap1))+10)
         .addItem("First"+ItemIndex,0)
         .addItem("Second"+ItemIndex,1)
         .toUpperCase(false)
        //.hideLabels() 
         ;
    RadioButtonConfItem[ItemIndex].setGroup(inGroup);
    RadioButtonConfItem[ItemIndex].getItem(0).setCaptionLabel(Cap1);
    RadioButtonConfItem[ItemIndex].getItem(1).setCaptionLabel(Cap2 + "    " + ConfigNames[ItemIndex]);
    
    toggleConfItem[ItemIndex].hide();
    txtlblconfItem[ItemIndex].hide();
    
  
}


void CreateItem(int ItemIndex, int XLoction, int YLocation, Group inGroup){
  //numberbox
  confItem[ItemIndex] = (controlP5.Numberbox) hideLabel(controlP5.addNumberbox("configItem"+ItemIndex,0,XLoction,YLocation,35,14));
  confItem[ItemIndex].setColorBackground(red_);
  confItem[ItemIndex].setMin(0);
  confItem[ItemIndex].setDirection(Controller.VERTICAL);
  confItem[ItemIndex].setMax(ConfigRanges[ItemIndex]);
  confItem[ItemIndex].setDecimalPrecision(0);
  confItem[ItemIndex].setGroup(inGroup);
  //Toggle
  toggleConfItem[ItemIndex] = (controlP5.Toggle) hideLabel(controlP5.addToggle("toggleValue"+ItemIndex));
  toggleConfItem[ItemIndex].setPosition(XLoction,YLocation+3);
  toggleConfItem[ItemIndex].setSize(35,10);
  toggleConfItem[ItemIndex].setMode(ControlP5.SWITCH);
  toggleConfItem[ItemIndex].setGroup(inGroup);
  //TextLabel
  txtlblconfItem[ItemIndex] = controlP5.addTextlabel("txtlblconfItem"+ItemIndex,ConfigNames[ItemIndex],XLoction+40,YLocation);
  txtlblconfItem[ItemIndex].setGroup(inGroup);
  //controlP5.getTooltip().register("txtlblconfItem"+ItemIndex,ConfigHelp[ItemIndex]);

} 


void BuildToolHelp(){
  controlP5.getTooltip().setDelay(100);
  //confItem[1].setMultiplier(confItem[1].value);
  //controlP5.getTooltip().register("txtlblconfItem"+0,"Changes the size of the ellipse.");
  //controlP5.getTooltip().register("s2","Changes the Background");
}



void BounceSerial(){
  toggleMSP_Data = false;
  InitSerial(200.00);
  InitSerial(LastPort);
  toggleMSP_Data = true;
  delay(1000);
  
}  

void RESTART(){
  BounceSerial();
}  


public void RESET(){
  MessageText.setValue("Reset OSD to Default Settings?");
  //messageBox.bringToFront(); 
  messageBox.show();
  
}

void MakePorts(){
  
  //time=millis();
  strokeWeight(3);stroke(100);
  fill(100); strokeWeight(3);stroke(200); rectMode(CORNERS); rect(XPortStat,YPortStat, XPortStat+105 , YPortStat+30);
  if ((PortRead) && (time - time2 >200)){
    time2 = time;
    fill(255, 10, 0);
  }
  else
  {
    fill(100, 10, 0);
  }
  ellipse(XPortStat+35, YPortStat+15, 10, 10);
  if ((PortWrite) && (time - time3 > 200)){
   time3 = time;
    fill(0,240, 0);
  }
   else
  {
   fill(0,100, 0);
  }
   
  ellipse(XPortStat+ 65, YPortStat+15, 10, 10);
  
}

void draw() {
  time=millis();
  hint(ENABLE_DEPTH_TEST);
  pushMatrix();
 PortRead = false; 
 PortWrite = false; 
  if ((init_com==1)  && (toggleMSP_Data == true)) MWData_Com();
  
  
  background(80);
  
  // ------------------------------------------------------------------------
  // Draw background control boxes
  // ------------------------------------------------------------------------

  // Coltrol Box
  fill(100); strokeWeight(3);stroke(200); rectMode(CORNERS); rect(XControlBox,YControlBox, XControlBox+105 , YControlBox+120);
  textFont(font12); fill(255, 255, 255); text("OSD Controls",XControlBox + 15,YControlBox + 15);
  if (activeTab == 1) {
  
  }
  
  fill(40, 40, 40);
  strokeWeight(3);stroke(0);
  rectMode(CORNERS);
  rect(5,5,113,40);
  textFont(font12);
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


 

  displayHorizon(int(MW_Pitch_Roll.arrayValue()[0])*10,int(MW_Pitch_Roll.arrayValue()[1])*10*-1);
  SimulateTimer();
  ShowCurrentThrottlePosition();
  if (int(confItem[GetSetting("S_DISPLAYRSSI")].value()) > 0)
    ShowRSSI(); 
  if (int(confItem[GetSetting("S_DISPLAYVOLTAGE")].value()) > 0) {
     ShowVolts(sVBat);
  }
    
 
  CalcAlt_Vario(); 
  displaySensors();
  displayMode();
  ShowAmperage();
  displayHeadingGraph();
  displayHeading();
  
  
  MakePorts();
  
  GroupcontrolP5.draw();
  controlP5.draw();
  ScontrolP5.draw();
  SmallcontrolP5.draw();
  FontGroupcontrolP5.draw();
  MatchConfigs();
  popMatrix();
  hint(DISABLE_DEPTH_TEST);
  CheckMessageBox();
}

void CheckMessageBox(){
  
  if (messageBoxResult == 1){
  toggleConfItem[0].setValue(0);
  confItem[0].setValue(0);
  WRITE();
  BounceSerial();
  messageBoxResult = -1;
  }
  
}


int GetSetting(String test){
  int TheSetting = 0;
  for (int i=0; i<Settings.values().length; i++) 
  if (Settings.valueOf(test) == Settings.values()[i]){ 
      TheSetting = Settings.values()[i].ordinal();
  }
  return TheSetting;
}


void ShowSimBackground(float[] a) {
  Showback = int(a[0]);
}

//void SimulateMultiWii(float[] a) {
//}


void MatchConfigs(){
 for(int i=0;i<CONFIGITEMS;i++) {
   try{ 
       if (RadioButtonConfItem[i].isVisible()){
          confItem[i].setValue(int(RadioButtonConfItem[i].getValue()));
       }
        }catch(Exception e) {}finally {}
    
   
   if  (toggleConfItem[i].isVisible()){
     //confItem[i].setValue(int(checkboxConfItem[i].arrayValue()[0]));
     if (int(toggleConfItem[i].getValue())== 1){
       confItem[i].setValue(1);
     }
     else{ 
       confItem[i].setValue(0);
     }
   }
   if (ConfigRanges[i] == 0) {
      toggleConfItem[i].hide();
      //RadioButtonConfItem[i].hide();
      confItem[i].hide();
    }
    if (ConfigRanges[i] > 1) {
      toggleConfItem[i].hide();
      
    }  
    if (ConfigRanges[i] == 1){
      confItem[i].hide();  
    }
    
    
  }
  // turn on FlyTimer----
  if ((toggleModeItems[0].getValue() == 0) && (SimItem0 < 1)){
    Armed = 1;
    FlyTimer = millis();
  }
  // turn off FlyTimer----
  if ((toggleModeItems[0].getValue() == 1 ) && (SimItem0 == 1)){
    FlyTimer = 0;
  }



}

// controls comport list click
public void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup())
    if (theEvent.name()=="portComList")
      InitSerial(theEvent.group().value()); // initialize the serial port selected
      
  try{
  //for (int i=0;i<col.length;i++) {
    if ((theEvent.getController().getName().substring(0, 7).equals("CharPix")) && (theEvent.getController().isMousePressed())) {
      //println("Got a pixel " + theEvent.controller().id());
        int ColorCheck = int(theEvent.getController().value());
        curPixel = theEvent.controller().id();
    }
    if ((theEvent.getController().getName().substring(0, 7).equals("CharMap")) && (theEvent.getController().isMousePressed())) {
      curChar = theEvent.controller().id();    
      //println("Got a Char " + theEvent.controller().id());
    }
   } catch(ClassCastException e){}
     catch(StringIndexOutOfBoundsException se){}
      
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
    
    //confItem[j].setValue(int(MWI.getProperty(ConfigNames[j])));
    if(j >= CONFIGITEMS)
    return;
  int value = int(MWI.getProperty(ConfigNames[j]));
  confItem[j].setValue(value);
  if (j == CONFIGITEMS-1){
    buttonWRITE.setColorBackground(green_);
  }  
  if (value >0){
    toggleConfItem[j].setValue(1);
    }
    else {
    toggleConfItem[j].setValue(0);
  }

  try{
    switch(value) {
    case(0):
      RadioButtonConfItem[j].activate(0);
      break;
    case(1):
      RadioButtonConfItem[j].activate(1);
      break;
    }
  }
  catch(Exception e) {}finally {}
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



        
        
        
        
void createMessageBox() {
  // create a group to store the messageBox elements
  messageBox = GroupcontrolP5.addGroup("messageBox",width/2 - 450,height/2 -60,300);
  messageBox.setBackgroundHeight(120);
  messageBox.setBackgroundColor(color(120,255));
  messageBox.hideBar();
  
  // add a TextLabel to the messageBox.
  MessageText = GroupcontrolP5.addTextlabel("messageBoxLabel","Some MessageBox text goes here.",20,20);
 MessageText.moveTo(messageBox);
  
  // add a textfield-controller with named-id inputbox
  // this controller will be linked to function inputbox() below.
 
  // add the OK button to the messageBox.
  // the name of the button corresponds to function buttonOK
  // below and will be triggered when pressing the button.
  Button b1 = controlP5.addButton("buttonOK",0,65,80,80,24);
  b1.moveTo(messageBox);
  //b1.setColorBackground(color(80));
  b1.setColorForeground(red_); 
  b1.setColorActive(red_);
  // by default setValue would trigger function buttonOK, 
  // therefore we disable the broadcasting before setting
  // the value and enable broadcasting again afterwards.
  // same applies to the cancel button below.
  b1.setBroadcast(false); 
  b1.setValue(1);
  b1.setBroadcast(true);
  b1.setCaptionLabel("OK");
  // centering of a label needs to be done manually 
  // with marginTop and marginLeft
  //b1.captionLabel().style().marginTop = -2;
  //b1.captionLabel().style().marginLeft = 26;
  
  // add the Cancel button to the messageBox. 
  // the name of the button corresponds to function buttonCancel
  // below and will be triggered when pressing the button.
  Button b2 = GroupcontrolP5.addButton("buttonCancel",0,155,80,80,24);
  b2.moveTo(messageBox);
  b2.setBroadcast(false);
  b2.setValue(0);
  b2.setBroadcast(true);
  b2.setCaptionLabel("Cancel");
  b2.setColorBackground(color(40));
  b2.setColorActive(color(20));
  //b2.captionLabel().toUpperCase(false);
  // centering of a label needs to be done manually 
  // with marginTop and marginLeft
  //b2.captionLabel().style().marginTop = -2;
  //b2.captionLabel().style().marginLeft = 16;
}

// function buttonOK will be triggered when pressing
// the OK button of the messageBox.
void buttonOK(int theValue) {
  println("a button event from button OK.");
  //messageBoxString = ((Textfield)controlP5.controller("inputbox")).getText();
  messageBoxResult = theValue;
  messageBox.hide();
}


// function buttonCancel will be triggered when pressing
// the Cancel button of the messageBox.
void buttonCancel(int theValue) {
  println("a button event from button Cancel.");
  messageBoxResult = theValue;
  messageBox.hide();
}

// inputbox is called whenever RETURN has been pressed 
// in textfield-controller inputbox 
void inputbox(String theString) {
  println("got something from the inputbox : "+theString);
  //messageBoxString = theString;
  messageBox.hide();
}

void mouseReleased() {
   mouseDown = false;
                mouseUp = true;
                if (curPixel>-1)changePixel(curPixel);
                if (curChar>-1)GetChar(curChar);
  ControlLock();
  
} 

        
public void mousePressed() {
                mouseDown = true;
                mouseUp = false;
        }



        public boolean mouseDown() {
                return mouseDown;
        }

        public boolean mouseUp() {
                return mouseUp;
        }
        
        
        


void exit() {
  println("Shut Down Comm & Exiting");
//
  toggleMSP_Data = false;
  delay(1000);
  InitSerial(200.00);
  
  //if (init_com==1){
    //init_com=0;
  //g_serial.stop();
  //}
  
 
  
  super.exit();
}


