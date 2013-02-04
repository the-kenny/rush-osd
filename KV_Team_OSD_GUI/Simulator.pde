


float sAltitude = 0;
float sVario = 0;
float sVBat = 0;


ControlP5 ScontrolP5;
Group SG,SGModes,SGAtitude,SGRadio,SGSensors1; 

// Slider2d ---
Slider2D Pitch_Roll, Throttle_Yaw,MW_Pitch_Roll;
//Sliders ---
Slider s_Altitude,s_Vario,s_VBat,s_RSSI;

// Knobs----
Knob HeadingKnob;

CheckBox checkboxModeItems[] = new CheckBox[boxnames.length] ;
DecimalFormat OnePlaceDecimal = new DecimalFormat("0.0");



 
void SimSetup(){

  
  ScontrolP5 = new ControlP5(this); // initialize the GUI controls
  ScontrolP5.setControlFont(font10);  

  SG = ScontrolP5.addGroup("SG")
    .setPosition(XSim-130,YSim + 30)
    .setWidth(470)
    .setBarHeight(12)
    .activateEvent(true)
    .setBackgroundColor(color(0,255))
    .setBackgroundHeight(265)
   .setLabel("Simulator Controls")
    ;
                
 
  SGModes = ScontrolP5.addGroup("SGModes")
                .setPosition(365,20)
                .setWidth(100)
                .setBarHeight(15)
                .activateEvent(true)
                .setBackgroundColor(color(30,255))
                .setBackgroundHeight(150)
                .setLabel("Modes")
                .setGroup(SG)
                //.close() 
               ; 
               
  SGAtitude = ScontrolP5.addGroup("SGAtitude")
                .setPosition(260,18)
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
                .setPosition(295,185)
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
                .setPosition(5,18)
                .setWidth(130)
                .setBarHeight(15)
                .activateEvent(true)
                .setBackgroundColor(color(30,255))
                .setBackgroundHeight(110)
                .setLabel("Sensors 1")
                .setGroup(SG)
                //.close() 
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
       //.setImage(RadioPot) 
       //.updateDisplayMode(1)
       //.disableCrosshair()
         ;
  ScontrolP5.getController("Pitch/Roll").getValueLabel().hide();

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
 ScontrolP5.getTooltip().register("Throttle/Yaw","Sift Key to hold position");
 
 

 

               
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
    checkboxModeItems[i].setItemsPerRow(1);
    checkboxModeItems[i].setSpacingColumn(10);
    checkboxModeItems[i].setLabel(boxnames[i]);
    checkboxModeItems[i].addItem(boxnames[i],1);
    //checkboxModeItems[i].hideLabels();
    checkboxModeItems[i].setGroup(SGModes);
    
  }
  //for(int i=0;i<SIMITEMS;i++) {
    //if (SimRanges[i] == 0) {
      //checkboxSimItem[i].hide();
     // SimItem[i].hide();
    //}
    //if (SimRanges[i] > 1) {
      //checkboxSimItem[i].hide();
    //}
      
    //if (SimRanges[i] == 1){
      //SimItem[i].hide();  
    //}
  //}
  
} 

void CalcAlt_Vario(){
  if (time2 < time - 1000){
    sAltitude += sVario /10;
    time2 = time;
  }
}


void displayMode()
{
      
    if((MwSensorActive&STABLEMODE) >0)
      mapchar(0xbe,sensorPosition[0]+LINE);

    if((MwSensorActive&BAROMODE) >0)
      mapchar(0xbe,sensorPosition[0]+1+LINE);

    if((MwSensorActive&MAGMODE) >0)
      mapchar(0xbe,sensorPosition[0]+2+LINE);

    if((MwSensorActive&GPSHOMEMODE) >0)
      mapchar(0xbe,sensorPosition[0]+3+LINE);

    if((MwSensorActive&GPSHOLDMODE) >0)
      mapchar(0xbe,sensorPosition[0]+3+LINE);

}

void displayArmed()
{
  if (int("ARM;") > 0){
    makeText("ARMED", motorArmedPosition[0]);
  }
  else
  {
    makeText("DISARMED", motorArmedPosition[0]);
  }
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
      if(X < 3 || X >5 || (Y/9) != 4)
      	mapchar(0x80+(Y%9), pos);
      if(Y>=9 && (Y%9) == 0)
        mapchar(0x89, pos-30);
    }
  }

//if (DISPLAY_HORIZON_BR){
  //Draw center screen
  mapchar(0x03, 219-30);
  mapchar(0x00, 224-30-1);
  mapchar(0x00, 224-30+1);
  mapchar(0x01, 224-30);
  mapchar(0x02, 229-30);
  
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
