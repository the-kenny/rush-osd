


float sAltitude = 0;
float sVario = 0;
float sVBat = 0;
int mode_armed = 0;
int mode_stable = 0;
int mode_baro = 0;
int mode_mag = 0;
int mode_gpshome = 0;
int mode_gpshold = 0;
int mode_llights = 0;
int mode_osd_switch = 0;

boolean[] keys = new boolean[526];


Group SG,SGModes,SGAtitude,SGRadio,SGSensors1,SGGPS; 

// Checkboxs
CheckBox checkboxSimItem[] = new CheckBox[SIMITEMS] ;
CheckBox SimulateMultiWii,ShowSimBackground, UnlockControls, SGPS_FIX; 

// Slider2d ---
Slider2D Pitch_Roll, Throttle_Yaw,MW_Pitch_Roll;
//Sliders ---
Slider s_Altitude,s_Vario,s_VBat,s_RSSI;

// Knobs----
Knob HeadingKnob,SGPSHeadHome;

Numberbox SGPS_numSat, SGPS_altitude, SGPS_speed, SGPS_ground_course,SGPS_distanceToHome,SGPS_directionToHome,SGPS_update;
//GPS_distanceToHome=read16();
    //GPS_directionToHome=read16();
    //GPS_update=read8();

    
//ControlWindow  Throttle_YawWindow;    

CheckBox checkboxModeItems[] = new CheckBox[boxnames.length] ;
DecimalFormat OnePlaceDecimal = new DecimalFormat("0.0");



 
void SimSetup(){

  
 

  SG = ScontrolP5.addGroup("SG")
    .setPosition(310,YSim + 30)
    .setWidth(680)
    .setBarHeight(12)
    .activateEvent(true)
    .setBackgroundColor(color(0,255))
    .setBackgroundHeight(265)
   .setLabel("Simulator Controls")
   .setMoveable(true);
    ;
                
 
  SGModes = ScontrolP5.addGroup("SGModes")
                .setPosition(575,20)
                .setWidth(100)
                .setBarHeight(15)
                .activateEvent(true)
                .setBackgroundColor(color(30,255))
                .setBackgroundHeight((boxnames.length*17) + 8)
                .setLabel("Modes")
                .setGroup(SG)
                .disableCollapse() 
                //.close() 
               ; 
               
  SGAtitude = ScontrolP5.addGroup("SGAtitude")
                .setPosition(465,20)
                .setWidth(100)
                .setBarHeight(15)
                .activateEvent(true)
                .setBackgroundColor(color(30,255))
                .setBackgroundHeight(150)
                .setLabel("Angle/Heading")
                .setGroup(SG)
                //.close() 
               ;
               
 SGRadio = ScontrolP5.addGroup("SGRadio")
                .setPosition(290,185)
                .setWidth(130)
                .setBarHeight(15)
                .activateEvent(true)
                .setBackgroundColor(color(30,255))
                .setBackgroundHeight(65)
                .setLabel("Radio")
                .setGroup(SG)
                //.close() 
               ; 

SGSensors1 = ScontrolP5.addGroup("SGSensors1")
                .setPosition(5,20)
                .setWidth(130)
                .setBarHeight(15)
                .activateEvent(true)
                .setBackgroundColor(color(30,255))
                .setBackgroundHeight(110)
                .setLabel("Sensors 1")
                .setGroup(SG)
                //.close() 
               ;                                  
SGGPS = ScontrolP5.addGroup("SGGPS")
                .setPosition(255,20)
                .setWidth(200)
                .setBarHeight(15)
                .activateEvent(true)
                .setBackgroundColor(color(30,255))
                .setBackgroundHeight(130)
                .setLabel("GPS")
                .setGroup(SG)
                //.close() 
               ;

SGPS_FIX =  ScontrolP5.addCheckBox("GPS_FIX",5,5);
    SGPS_FIX.setColorBackground(color(120));
    SGPS_FIX.setColorActive(color(255));
    SGPS_FIX.addItem("GPS Fix",1);
    //GPSLock.hideLabels();
    SGPS_FIX.setGroup(SGGPS);
    
SGPS_numSat = ScontrolP5.addNumberbox("SGPS_numSat",0,5,20,40,14);
    SGPS_numSat.setLabel("Sats");
    //SGPS_numSat.setColorBackground(red_);
    SGPS_numSat.setMin(0);
    SGPS_numSat.setDirection(Controller.HORIZONTAL);
    SGPS_numSat.setMax(15);
    SGPS_numSat.setDecimalPrecision(0);
    SGPS_numSat.setGroup(SGGPS); 
 ScontrolP5.getController("SGPS_numSat").getCaptionLabel()
   .align(ControlP5.LEFT, ControlP5.RIGHT_OUTSIDE).setPaddingX(45);

SGPS_altitude = ScontrolP5.addNumberbox("SGPS_altitude",0,5,40,40,14);
    SGPS_altitude.setLabel("Alt-cm");
    //SGPS_numSat.setColorBackground(red_);
    SGPS_altitude.setMin(0);
    SGPS_altitude.setDirection(Controller.HORIZONTAL);
    SGPS_altitude.setMax(10000);
    SGPS_altitude.setDecimalPrecision(0);
    SGPS_altitude.setGroup(SGGPS); 
 ScontrolP5.getController("SGPS_altitude").getCaptionLabel()
   .align(ControlP5.LEFT, ControlP5.RIGHT_OUTSIDE).setPaddingX(45);     
 
 SGPS_speed = ScontrolP5.addNumberbox("SGPS_speed",0,5,60,40,14);
    SGPS_speed.setLabel("Speed-cm/s");
    //SGPS_numSat.setColorBackground(red_);
    SGPS_speed.setMin(0);
    SGPS_speed.setDirection(Controller.HORIZONTAL);
    SGPS_speed.setMax(10000);
    SGPS_speed.setDecimalPrecision(0);
    SGPS_speed.setGroup(SGGPS); 
 ScontrolP5.getController("SGPS_speed").getCaptionLabel()
   .align(ControlP5.LEFT, ControlP5.RIGHT_OUTSIDE).setPaddingX(45);   
 
 SGPS_distanceToHome = ScontrolP5.addNumberbox("SGPS_distanceToHome",0,5,80,40,14);
    SGPS_distanceToHome.setLabel("Dist Home-M");
    //SGPS_numSat.setColorBackground(red_);
    SGPS_distanceToHome.setMin(0);
    SGPS_distanceToHome.setDirection(Controller.HORIZONTAL);
    SGPS_distanceToHome.setMax(1000);
    SGPS_distanceToHome.setDecimalPrecision(0);
    SGPS_distanceToHome.setGroup(SGGPS); 
 ScontrolP5.getController("SGPS_distanceToHome").getCaptionLabel()
   .align(ControlP5.LEFT, ControlP5.RIGHT_OUTSIDE).setPaddingX(45);   
                 
  SGPSHeadHome = ScontrolP5.addKnob("SGPSHeadHome")
   .setRange(-180,+180)
   .setValue(0)
   .setPosition(140,5)
   .setRadius(25)
   .setLabel("Head Home")
   .setColorBackground(color(0, 160, 100))
   .setColorActive(color(255,255,0))
   .setDragDirection(Knob.HORIZONTAL)
   .setGroup(SGGPS)
   ; 
                 
               
               
  MW_Pitch_Roll = ScontrolP5.addSlider2D("MWPitch/Roll")
    .setPosition(25,5)
    .setSize(50,50)
    .setArrayValue(new float[] {50, 50})
    .setMaxX(45) 
    .setMaxY(25) 
    .setMinX(-45) 
    .setMinY(-25)
    .setValueLabel("") 
    .setLabel("Roll/Pitch")
    .setGroup(SGAtitude)
    ;
 ScontrolP5.getController("MWPitch/Roll").getCaptionLabel()
   .align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);   
 ScontrolP5.getController("MWPitch/Roll").getValueLabel().hide();
 
 HeadingKnob = ScontrolP5.addKnob("MwHeading")
   .setRange(-180,+180)
   .setValue(0)
   .setPosition(25,80)
   .setRadius(25)
   .setLabel("Heading")
   .setColorBackground(color(0, 160, 100))
   .setColorActive(color(255,255,0))
   .setDragDirection(Knob.HORIZONTAL)
   .setGroup(SGAtitude)
   ;
   


 Throttle_Yaw = ScontrolP5.addSlider2D("Throttle/Yaw")
         .setPosition(5,5)
         .setSize(50,50)
         .setArrayValue(new float[] {50, 100})
         .setMaxX(2000) 
         .setMaxY(1000) 
         .setMinX(1000) 
         .setMinY(2000)
         .setValueLabel("") 
        .setLabel("")
         .setGroup(SGRadio)
        ;
 ScontrolP5.getController("Throttle/Yaw").getValueLabel().hide();
 ScontrolP5.getTooltip().register("Throttle/Yaw","Ctrl Key to hold position");


UnlockControls =  ScontrolP5.addCheckBox("UnlockControls",60,25);
    UnlockControls.setColorBackground(color(120));
    UnlockControls.setColorActive(color(255));
    UnlockControls.addItem("UnlockControls1",1);
    UnlockControls.hideLabels();
    UnlockControls.setGroup(SGRadio);


  Pitch_Roll = ScontrolP5.addSlider2D("Pitch/Roll")
         .setPosition(75,5)
         .setSize(50,50)
         .setArrayValue(new float[] {50, 50})
         .setMaxX(2000) 
         .setMaxY(1000) 
         .setMinX(1000) 
         .setMinY(2000)
         .setLabel("")
         .setGroup(SGRadio)
         ;
  ScontrolP5.getController("Pitch/Roll").getValueLabel().hide();


 
 

 

               
s_Altitude = ScontrolP5.addSlider("sAltitude")
  .setPosition(5,10)
  .setSize(8,75)
  .setRange(-500,1000)
  .setValue(0)
  .setLabel("Alt")
  .setDecimalPrecision(1)
  .setGroup(SGSensors1);
  ScontrolP5.getController("sAltitude").getValueLabel()
    .setFont(font9);
  ScontrolP5.getController("sAltitude").getCaptionLabel()
    .setFont(font9)
    .align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

s_Vario = ScontrolP5.addSlider("sVario")
  .setPosition(47,10)
  .setSize(8,75)
  .setRange(-20,20)
  .setNumberOfTickMarks(41)
  .showTickMarks(false)
  .setValue(0)
  .setLabel("Vario")
  .setDecimalPrecision(1)
  .setGroup(SGSensors1);
  ScontrolP5.getController("sVario").getValueLabel()
    .setFont(font9);
  ScontrolP5.getController("sVario").getCaptionLabel()
    .setFont(font9)
    .align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

s_VBat = ScontrolP5.addSlider("sVBat")
  .setPosition(90,10)
  .setSize(8,75)
  .setRange(9,17)
  .setValue(0)
  .setLabel("VBat")
  .setDecimalPrecision(1)
  .setGroup(SGSensors1);
  ScontrolP5.getController("sVBat").getValueLabel()
     .setFont(font9);
  ScontrolP5.getController("sVBat")
    .getCaptionLabel()
    .setFont(font9)
    .align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);               





  //for(int i=0;i<SIMITEMS;i++) {
    //txtlblSimItem[i] = ScontrolP5.addTextlabel("txtlblSimItem"+i,"",20,5+i*17);//SimNames[i],20,5+i*17);
    //if (i < 6){
      //txtlblSimItem[i].setGroup(SGModes);
    //}
  //} 
 
  //for(int i=0;i<SIMITEMS;i++) {
    //SimItem[i] = (controlP5.Numberbox) hideLabel(ScontrolP5.addNumberbox("SimItem"+i,0,5,5+i*17,35,14));
    //SimItem[i].setColorBackground(red_);confItem[i].setMin(0);confItem[i].setDirection(Controller.HORIZONTAL);confItem[i].setMax(ConfigRanges[i]);confItem[i].setDecimalPrecision(0);
    //if (i < 6){
      //SimItem[i].setGroup(SGModes);
    //}
    
 //}

  for(int i=0;i<boxnames.length ;i++) {
    checkboxModeItems[i] =  ScontrolP5.addCheckBox("checkboxSimItem"+i,5,5+3+i*17);
    checkboxModeItems[i].setColorActive(color(255));
    checkboxModeItems[i].setColorBackground(color(120));
    //checkboxModeItems[i].setItemsPerRow(1);
    //checkboxModeItems[i].setSpacingColumn(10);
    //checkboxModeItems[i].setLabel(boxnames[i]);
    checkboxModeItems[i].addItem(boxnames[i],1);
    //checkboxModeItems[i].hideLabels();
    checkboxModeItems[i].setGroup(SGModes);
    
  }
      
GetModes();  
} 

boolean checkKey(int k)
{
  if (keys.length >= k) {
    return keys[k];  
  }
  return false;
}



void keyPressed()
{ 
  keys[keyCode] = true;
}


void keyReleased()
{ 
  keys[keyCode] = false; 
  ControlLock();
  
}

void mouseReleased() {
  ControlLock();
} 

void CalcAlt_Vario(){
  if (time2 < time - 1000){
    sAltitude += sVario /10;
    time2 = time;
  }
}


void displayMode()
{
  int SimModebits = 0;
  int SimBitCounter = 1;
    for (int i=0; i<boxnames.length; i++) {
      if(checkboxModeItems[i].arrayValue()[0] > 0) SimModebits |= SimBitCounter;
      SimBitCounter += SimBitCounter;
}
    if((SimModebits&mode_armed) >0){
    makeText("ARMED", motorArmedPosition[0]);
  }
    else{
    makeText("DISARMED", motorArmedPosition[0]);
  }
    
    if((SimModebits&mode_stable) >0)
      mapchar(0xbe,sensorPosition[0]+LINE);

    if((SimModebits&mode_baro) >0)
      mapchar(0xbe,sensorPosition[0]+1+LINE);

    if((SimModebits&mode_mag) >0)
      mapchar(0xbe,sensorPosition[0]+2+LINE);

    if((SimModebits&mode_gpshome) >0)
      mapchar(0xbe,sensorPosition[0]+3+LINE);

    if((SimModebits&mode_gpshold) >0)
      mapchar(0xbe,sensorPosition[0]+3+LINE);

}



void displayHorizon(int rollAngle, int pitchAngle)
{
  if(pitchAngle>250) pitchAngle=250;
  if(pitchAngle<-200) pitchAngle=-200;
  if(rollAngle>400) rollAngle=400;
  if(rollAngle<-400) rollAngle=-400;

  for(int X=0; X<=8; X++) {
    int Y = (rollAngle * (4-X)) / 64;
    Y += pitchAngle / 8;
    Y += 41;
    if(Y >= 0 && Y <= 81) {
      int pos = 30*(2+Y/9) + 10 + X;
      if(X < 3 || X >5 || (Y/9) != 4 || confItem[22].value() == 0)
      	mapchar(0x80+(Y%9), pos);
      if(Y>=9 && (Y%9) == 0)
        mapchar(0x89, pos-30);
    }
  }

  if(confItem[GetSetting("S_DISPLAY_HORIZON_BR")].value() > 0) {
    //Draw center screen
    mapchar(0x01, 224-30);
    mapchar(0x00, 224-30-1);
    mapchar(0x00, 224-30+1);
  }
  
  //if (WITHDECORATION){
  if(confItem[GetSetting("S_WITHDECORATION")].value() > 0) {
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
    mapchar(0x02, 229-30);
    mapchar(0x03, 219-30);
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

void ControlLock(){
  Pitch_Roll.setArrayValue(new float[] {500, -500});
  if(checkKey(CONTROL) == false) {
    if(UnlockControls.arrayValue()[0] < 1){
      float A = (2000-Throttle_Yaw.getArrayValue()[1])*-1;
      Throttle_Yaw.setArrayValue(new float[] {500, A});
      s_Vario.setValue(0);
      sVario = 0;
    }
  }    
}

void GetModes(){
  int bit = 1;
  int remaining = strBoxNames.length();
  int len = 0;
 
  mode_armed = 0;
  mode_stable = 0;
  mode_baro = 0;
  mode_mag = 0;
  mode_gpshome = 0;
  mode_gpshold = 0;
  mode_llights = 0;
  mode_osd_switch = 0;
  for (int c = 0; c < boxnames.length; c++) {
    if (boxnames[c] == "ARM;") mode_armed |= bit;
    if (boxnames[c] == "ANGLE;") mode_stable |= bit;
    if (boxnames[c] == "HORIZON;") mode_stable |= bit;
    if (boxnames[c] == "MAG;") mode_mag |= bit;
    if (boxnames[c] == "BARO;") mode_baro |= bit;
    if (boxnames[c] == "LLIGHTS;") mode_llights |= bit;
    if (boxnames[c] == "GPS HOME;") mode_gpshome |= bit;
    if (boxnames[c] == "GPS HOLD;") mode_gpshold |= bit;
    
    bit <<= 1L;
  }
  
   
 
}
