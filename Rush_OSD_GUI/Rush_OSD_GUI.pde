/***
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
//import javax.swing.JOptionPane; // for message dialogue





PImage img,OSDBackground,RadioPot;
//PGraphics pg;
int x = 0;
int y = 0;
int sx = 0;
int sy = 0;

// charmap rows & cols --------------------------------------------------
int[] col = {0,13,26,39,52,65,78,91,104,117,130,143,156,169,182,195};
int[] row = {0,19,38,57,76,95,114,133,152,171,190,209,228,247,266,285};
// charmap rows & cols --------------------------------------------------


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



String Rush_KV_Version = "2.01";


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
static int CHECKBOXITEMS=0;
static int CONFIGITEMS=10;
static int SIMITEMS=10;

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
int xGPS        = 853;        int yGPS        = 438; //693,438
int xx=0;

int Roll = 0;
int Pitch = 0;

int OnTimer = 0;
int FlyTimer = 0;
float SimItem0= 0;
int Armed = 0;
//int ReadMultiWii = 0;
// int variables

// For Heading
String[] headGraph={
  "0x1a","0x1d","0x1c","0x1d","0x19","0x1d","0x1c","0x1d","0x1b","0x1d","0x1c","0x1d","0x18","0x1d","0x1c","0x1d","0x1a","0x1d","0x1c","0x1d","0x19","0x1d","0x1c","0x1d","0x1b"};
static int MwHeading=0;
String MwHeadingUnitAdd="0xbd";
//int MwHeading = 0;


 // EEPROM LOCATION IN ARDUINO EEPROM MAP
//  EEPROM_RSSIMIN             1
//  EEPROM_RSSIMAX             2
//  EEPROM_DISPLAYRSSI         3
//  EEPROM_DISPLAYVOLTAGE      4
//  EEPROM_VOLTAGEMIN          5
//  EEPROM_DISPLAYTEMPERATURE  6
//  EEPROM_TEMPERATUREMAX      7
//  EEPROM_DISPLAYGPS          8
//  EEPROM_SCREENTYPE         9
//  EEPROM_UNITSYSTEM         10



String[] ConfigNames = {
  "",
  "RSSI Min:",
  "RSSI Max:",
  "Display RSSI:",
  "Display Voltage:",
  "Voltage Min:",
  "Display Temperature:",
  "Temperature Max:",
  "Display GPS:",
  "Screen Type:",
  "Unit System:"
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
  
int[] ConfigRanges = {
  0,
  255,
  255,
  1,
  1,
  255,
  1,
  255,
  1,
  1,
  1};
  
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
CheckBox ReadMultiWii; 
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
OSDBackground = loadImage("Background1.jpg");
RadioPot = loadImage("Radio_Pot.png");
//image(OSDBackground,DisplayWindowX+WindowAdjX, DisplayWindowY+WindowAdjY, DisplayWindowX+360-WindowShrinkX, DisplayWindowY+288-WindowShrinkY);
img = loadImage("MW_OSD_Team_Clear.png");
img.format = ARGB;


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
  buttonREAD = controlP5.addButton("READ",1,xParam+5,yParam+260,50,16);buttonREAD.setColorBackground(red_);
  buttonRESET = controlP5.addButton("RESET",1,xParam+60,yParam+260,60,16);buttonRESET.setColorBackground(red_);
  buttonWRITE = controlP5.addButton("WRITE",1,xParam+130,yParam+260,60,16);buttonWRITE.setColorBackground(red_);
  //buttonREQUEST = controlP5.addButton("REQUEST",1,xParam+150,yParam+260,60,16);buttonREQUEST.setColorBackground(red_);
 // buttonSETTING = controlP5.addButton("SETTING",1,xParam+405,yParam+260,110,16); buttonSETTING.setLabel("SELECT SETTING"); buttonSETTING.setColorBackground(red_);
 

// test labels------------------------------------------------------------------
for(int i=0;i<CONFIGITEMS;i++) {
txtlblconfItem[i] = controlP5.addTextlabel("txtlblconfItem"+i,ConfigNames[i],xParam+40,yParam+20+i*17);
}
for(int i=0;i<SIMITEMS;i++) {
txtlblSimItem[i] = controlP5.addTextlabel("txtlblSimItem"+i,SimNames[i],xParam+290,yParam+20+i*17);
}

// test labels------------------------------------------------------------------

//  number boxes----------------------------------------------------------------

 for(int i=0;i<CONFIGITEMS;i++) {
    confItem[i] = (controlP5.Numberbox) hideLabel(controlP5.addNumberbox("configItem"+i,0,xParam,yParam+20+i*17,35,14));
    confItem[i].setColorBackground(red_);confItem[i].setMin(0);confItem[i].setDirection(Controller.HORIZONTAL);confItem[i].setMax(ConfigRanges[i]);confItem[i].setDecimalPrecision(0); //confItem[i].setMultiplier(1);confItem[i].setDecimalPrecision(1);
 }
 for(int i=0;i<SIMITEMS;i++) {
    SimItem[i] = (controlP5.Numberbox) hideLabel(controlP5.addNumberbox("SimItem"+i,0,xParam+250,yParam+20+i*17,35,14));
    SimItem[i].setColorBackground(red_);confItem[i].setMin(0);confItem[i].setDirection(Controller.HORIZONTAL);confItem[i].setMax(ConfigRanges[i]);confItem[i].setDecimalPrecision(0); //confItem[i].setMultiplier(1);confItem[i].setDecimalPrecision(1);
 }
 
//  number boxes----------------------------------------------------------------

// checkboxes -----------------------------------------------------------------------

  for(int i=0;i<CONFIGITEMS;i++) {
    //buttonCheckbox[i] = controlP5.addButton("bcb"+i,1,xBox-30,yBox+20+13*i,68,12);
   // buttonCheckbox[i].setColorBackground(red_);buttonCheckbox[i].setLabel(name);
    checkboxConfItem[i] =  controlP5.addCheckBox("checkboxConfItem"+i,xParam+25,yParam+20+i*17);
       checkboxConfItem[i].setColorActive(color(255));checkboxConfItem[i].setColorBackground(color(120));
        checkboxConfItem[i].setItemsPerRow(1);checkboxConfItem[i].setSpacingColumn(10);
        checkboxConfItem[i].setLabel(ConfigNames[i]);
        //if (ConfigRanges[i] == 1){
        checkboxConfItem[i].addItem("cbox"+i,1);
        //}
        checkboxConfItem[i].hideLabels();
   
  }
  
  for(int i=0;i<SIMITEMS;i++) {
    //buttonCheckbox[i] = controlP5.addButton("bcb"+i,1,xBox-30,yBox+20+13*i,68,12);
   // buttonCheckbox[i].setColorBackground(red_);buttonCheckbox[i].setLabel(name);
    checkboxSimItem[i] =  controlP5.addCheckBox("checkboxSimItem"+i,xParam+275,yParam+20+i*17);
       checkboxSimItem[i].setColorActive(color(255));checkboxSimItem[i].setColorBackground(color(120));
        checkboxSimItem[i].setItemsPerRow(1);checkboxSimItem[i].setSpacingColumn(10);
        checkboxSimItem[i].setLabel(SimNames[i]);
        //if (ConfigRanges[i] == 1){
        checkboxSimItem[i].addItem("scbox"+i,1);
        //}
        checkboxSimItem[i].hideLabels();
   
  }
  
  ReadMultiWii = controlP5.addCheckBox("ReadMultiWii",xParam+200,yParam+260);
      ReadMultiWii.setColorActive(color(255));ReadMultiWii.setColorBackground(color(120));
        ReadMultiWii.setItemsPerRow(1);ReadMultiWii.setSpacingColumn(10);
       ReadMultiWii.setLabel("Read MultiWii");
        //if (ConfigRanges[i] == 1){
       ReadMultiWii.addItem("Read MultiWii",1);
        //}
        //ReadMultiWii.hideLabels();
  // End Checkboxes----------------------------------------------------------------------------
  
  // Timers --------------------------------------------------------------------------------
  
  //OnTimer = new ControlTimer();
  //t = new Textlabel(cp5,"--",100,100);
  //OnTimer.setSpeedOfTime(1);
  
  
  
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
  
//Slider -----------------------------
//
/*sPitch =  controlP5.addSlider("Pitch")
     .setPosition(DisplayWindowX+WindowAdjX - 50,DisplayWindowY+WindowAdjY)
     .setWidth(360-WindowShrinkX/2)
     .setSize(10,180)
     .setRange(-45,45) // values can range from big to small as well
     .setValue(0)
     .setScrollSensitivity(1) 

     //.setNumberOfTickMarks(180)
     .setSliderMode(Slider.FLEXIBLE)
     ;
     
     
  // add a vertical slider
sRoll =  controlP5.addSlider("Roll")
     .setPosition(DisplayWindowX+WindowAdjX,DisplayWindowY+WindowAdjY+288-WindowShrinkY +10)
     .setWidth(360-WindowShrinkX/2)
     .setSize(180,10)
     .setRange(-45,45) // values can range from big to small as well
     .setValue(0)
     .setScrollSensitivity(1) 

     //.setNumberOfTickMarks(180)
     .setSliderMode(Slider.FLEXIBLE)
     ;
  // use Slider.FIX or Slider.FLEXIBLE to change the slider handle
  // by default it is Slider.FIX
 */ 
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

void draw() {
  hint(ENABLE_DEPTH_TEST);
  pushMatrix();
  GetMWData();
 background(80);
  
   // ------------------------------------------------------------------------
  // Draw background control boxes
  // ------------------------------------------------------------------------
  fill(0, 0, 0);
  strokeWeight(3);stroke(0);
  rectMode(CORNERS);
  rect(xParam,yParam, xParam+400, yParam+280);
  fill(40, 40, 40);
  strokeWeight(3);stroke(0);
  rectMode(CORNERS);
  rect(5,5,113,40);
  textFont(font15);
  // version
  fill(255, 255, 255);
  text("Rush OSD",18,19);
  text("  GUI    V",10,35);
  text(Rush_KV_Version, 74, 35);
  fill(0, 0, 0);
  strokeWeight(3);stroke(0);
  rectMode(CORNERS);
  image(OSDBackground,DisplayWindowX+WindowAdjX, DisplayWindowY+WindowAdjY, 360-WindowShrinkX, 288-WindowShrinkY);

    //pushMatrix();
  //rect(DisplayWindowX+WindowAdjX, DisplayWindowY+WindowAdjY, DisplayWindowX+360-WindowShrinkX, DisplayWindowY+288-WindowShrinkY);

 // makeText("Rush_KV OSD DEMO!", LINE02+6);
  //MakeRectangle();
//image(DisplayScreen,DisplayWindowX, DisplayWindowY, DisplayWindowX+360, DisplayWindowY+288);

ReadMW = int(ReadMultiWii.arrayValue()[0]);
  MatchConfigs();
  if (int(confItem[4].value()) > 0){
  ShowVolts(12.8);
  }
  displaySensors();
  displayMode();
  if (ReadMW >0){
    s.arrayValue()[0] =MwAngle[0];
    s.arrayValue()[1] =MwAngle[1];
    displayHorizon(int(s.arrayValue()[0]),int(s.arrayValue()[1])*-1);
  }
  else
  {
    displayHorizon(int(s.arrayValue()[0])*10,int(s.arrayValue()[1])*10*-1);
  }
  //int(Roll)*-1
  SimulateTimer();
  //ShowOnTime();
  //ShowFlyTime();
  ShowCurrentThrottlePosition();
  if (int(confItem[3].value()) > 0){
   ShowRSSI(); 
  }
   ShowAmperage();
  displayArmed();
  displayHeadingGraph();
  displayHeading();
   popMatrix();
  hint(DISABLE_DEPTH_TEST);


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
    String portPos = Serial.list()[int(portValue)];
    txtlblWhichcom.setValue("COM = " + shortifyPortName(portPos, 8));
    g_serial = new Serial(this, portPos, 115200);
    init_com=1;
    buttonREAD.setColorBackground(green_);
    buttonRESET.setColorBackground(green_);commListbox.setColorBackground(green_);
    g_serial.buffer(256);
    System.out.println(int(checkboxConfItem[0].getArrayValue()[0]));
    System.out.println("Port Turned On " );//+((int)(cmd&0xFF))+": "+(checksum&0xFF)+" expected, got "+(int)(c&0xFF));
    
  } else {
    txtlblWhichcom.setValue("Comm Closed");
    init_com=0;
    commListbox.setColorBackground(red_);buttonREAD.setColorBackground(red_);buttonRESET.setColorBackground(red_); 
    init_com=0;
    g_serial.stop();
   

    
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


//public void REQUEST() {
  //g_serial.write("*-");
  //g_serial.write(10);
//}
public void READ() {
  disableSerial = false;
  for(int i=0;i<CONFIGITEMS;i++) {
    confItem[i].setValue(0); 
  }
  g_serial.write("*-");
  g_serial.write(10);
  buttonWRITE.setColorBackground(green_);
}
public void WRITE() {
  disableSerial = true;
  for(int i=0;i<CONFIGITEMS;i++) {
   println(checkboxConfItem[i].arrayValue()[0]);
    //checkbox[i].arrayValue()[aa]
  SendCommand = "*+";
  SendCommand += str(i);
  SendCommand += ",";
  SendCommand += str(int(confItem[i].value()));
   g_serial.write(SendCommand);
   //println(SendCommand);
  //g_serial.write(i);
  //g_serial.write(",");
  //g_serial.write("1");
  g_serial.write("\n");
  // println(i);
  }
  g_serial.clear();   
}

//void keyPressed() {
  // Send the keystroke out:
 // g_serial.write(key);
  //whichKey = key;
//}


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



void mapchar(String address, int screenAddress){
  int placeX = (screenAddress % 30) * 12;
  int placeY = (screenAddress / 30) * 18;
  //currentCol = placeX;
  //currentRow = placeY;
  String ss2 = address.substring(2,3);     // Returns "bit"
  String ss3 = address.substring(3, 4);  // Returns "CC"
  int charCol = unhex(ss3);
  int charRow = unhex(ss2);
 
  //s.copy(img,col[charCol], row[charRow], 12, 18, DisplayWindowX + placeX, DisplayWindowY + placeY, 12, 18);
 //s.background(0, 0, 0);
copy(img,col[charCol], row[charRow], 12, 18, placeX+DisplayWindowX, placeY+DisplayWindowY, 12, 18);
 
  //s.copy(img,col[charCol], row[charRow], 12, 18, placeX+WindowAdjX, placeY+WindowAdjY, 12, 18);
  //backgroundImage.updatePixels();
}

void makeText(String inString, int inStartAddress ){
  for (int i = 0; i < inString.length(); i++){
    mapchar(hex(inString.charAt(i)), inStartAddress +i); 
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
  mapchar("0x03", 219-30);
  mapchar("0x1D",224-30-1);
  mapchar("0x1D",224-30+1);
  mapchar("0x01",224-30);
  mapchar("0x02",229-30);
  
  //if (WITHDECORATION){
     mapchar("0xC7",128);
     mapchar("0xC7",128+30);
     mapchar("0xC7",128+60);
     mapchar("0xC7",128+90);
     mapchar("0xC7",128+120);
     mapchar("0xC6",128+12);
     mapchar("0xC6",128+12+30);
     mapchar("0xC6",128+12+60);
     mapchar("0xC6",128+12+90);
     mapchar("0xC6",128+12+120);
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
  String charString = "0x1";
  switch (xx)
   {
    
  case 0:
   charString+=X;
   mapchar(charString,(roll*30)+100 + int(Y));
   
    //screen[(roll*30)+100+Y]=0x10+(X);
    break;
  case 1:
  charString+=X-8;
   mapchar(charString,(roll*30)+130+int(Y));
    //screen[(roll*30)+130+Y]=0x10+(X-8);
    break;
  case 2:
  charString+=X-16;
   mapchar(charString,(roll*30)+160+int(Y));
   // screen[(roll*30)+160+Y]=0x10+(X-16);
    break;
  case 3:
  charString+=X-24;
   mapchar(charString,(roll*30)+190+int(Y));
   // screen[(roll*30)+190+Y]=0x10+(X-24);
    break;
  case 4:
   charString+=X-32;
   mapchar(charString,(roll*30)+220+int(Y));
   // screen[(roll*30)+220+Y]=0x10+(X-32);
    break;
  case 5:
   charString+=X-40;
   mapchar(charString,(roll*30)+250+int(Y));
   // screen[(roll*30)+250+Y]=0x10+(X-40);
    break;
  case 6:
 charString+=X-48;
   mapchar(charString,(roll*30)+280+int(Y));
    //screen[(roll*30)+280+Y]=0x10+(X-48);
    break;
  }
}

void displayHeadingGraph()
{
  int xx;
  String headString = "";
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
   mapchar("0xa0",sensorPosition[0]);
   mapchar("0xa2",sensorPosition[0]+1);
   mapchar("0xa1",sensorPosition[0]+2);
   mapchar("0xa3",sensorPosition[0]+3);
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
    mapchar("0xac",sensorPosition[0]+4);
    mapchar("0xad",sensorPosition[0]+5);
  }
  else
  {
    mapchar("0xae",sensorPosition[0]+4);
    mapchar("0xaf",sensorPosition[0]+5);
  }
   if (int(SimItem[1].value()) > 0){
    mapchar("0xbe",sensorPosition[0]+LINE);
    //mapchar("0xad",sensorPosition[0]+5);
  }
  }
  else 
  {
    if((MwSensorActive&ARMEDMODE) >0) checkboxSimItem[0].activate(0); else checkboxSimItem[0].deactivate(0);
      
      
  if((MwSensorActive&STABLEMODE) >0)   mapchar("0xbe",sensorPosition[0]+LINE);
  else ;
  if((MwSensorActive&BAROMODE) >0)     mapchar("0xbe",sensorPosition[0]+1+LINE);
  else ;
  if((MwSensorActive&MAGMODE) >0)      mapchar("0xbe",sensorPosition[0]+2+LINE);
  else ;
  if((MwSensorActive&GPSHOMEMODE) >0)  mapchar("0xbe",sensorPosition[0]+3+LINE);
  if((MwSensorActive&GPSHOLDMODE) >0)  mapchar("0xbe",sensorPosition[0]+3+LINE);
   //println(MwSensorActive);
  }
  /*
  if ((present&1) >0) {buttonAcc.setColorBackground(green_);} else {buttonAcc.setColorBackground(red_);tACC_ROLL.setState(false); tACC_PITCH.setState(false); tACC_Z.setState(false);}
        if ((present&2) >0) {buttonBaro.setColorBackground(green_);} else {buttonBaro.setColorBackground(red_); tBARO.setState(false); }
        if ((present&4) >0) {buttonMag.setColorBackground(green_);} else {buttonMag.setColorBackground(red_); tMAGX.setState(false); tMAGY.setState(false); tMAGZ.setState(false); }
        if ((present&8) >0) {buttonGPS.setColorBackground(green_);} else {buttonGPS.setColorBackground(red_); tHEAD.setState(false);}
        if ((present&16)>0) {buttonSonar.setColorBackground(green_);} else {buttonSonar.setColorBackground(red_);}
  
  MAX7456_WriteString(screenBuffer,sensorPosition[videoSignalType][screenType]+LINE);
  if(MwSensorActive&STABLEMODE)
  {
    screenBuffer[0]=0xac;
    screenBuffer[1]=0xad;
  }
  else
  {
    screenBuffer[0]=0xae;
    screenBuffer[1]=0xaf;
  }
  screenBuffer[2]=' ';
  screenBuffer[3]=' ';
  if(GPS_fix)                    screenBuffer[3]=0xdf;
  if(MwSensorActive&GPSHOMEMODE) screenBuffer[3]=0xff;
  if(MwSensorActive&GPSHOLDMODE) screenBuffer[3]=0xef;
  screenBuffer[4]=0;
  MAX7456_WriteString(screenBuffer,sensorPosition[videoSignalType][screenType]+4);
  */
 
}

void displayArmed()
{
  //static const char _disarmed[] PROGMEM = "DISARMED";
  //static const char _armed[] PROGMEM = " ARMED";

  //armed = (MwSensorActive&ARMEDMODE);
  //if(armedTimer==0)
  if (int(SimItem[0].value()) > 0){
    makeText("ARMED", motorArmedPosition[0]);
  }
  else
  {
  makeText("DISARMED", motorArmedPosition[0]);
  }
   // MAX7456_WriteString_P(_disarmed, motorArmedPosition[videoSignalType][screenType]);
  //else if((armedTimer>1) && (armedTimer<9) && (Blink10hz))
    //MAX7456_WriteString_P(_armed, motorArmedPosition[videoSignalType][screenType]);
}



void ShowVolts(float voltage){
mapchar("0x97", voltagePosition[ScreenType]);
makeText(str(voltage), voltagePosition[ScreenType]+2);
}
void ShowFlyTime(String FMinutes_Seconds){
mapchar("0x9c", flyTimePosition[ScreenType]);
makeText(FMinutes_Seconds, flyTimePosition[ScreenType]+1);
}
void ShowOnTime(String Minutes_Seconds){
mapchar("0x9b", onTimePosition[ScreenType]);
makeText(Minutes_Seconds, onTimePosition[ScreenType]+1);
}

void ShowCurrentThrottlePosition(){
mapchar("0xc8", CurrentThrottlePosition[ScreenType]);
makeText(" 40%", CurrentThrottlePosition[ScreenType]+1);
}

void ShowRSSI(){
mapchar("0xba", rssiPosition[ScreenType]);
makeText("93%", rssiPosition[ScreenType]+1);
}

void ShowAmperage(){
mapchar("0xa4", amperagePosition[ScreenType]);
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


