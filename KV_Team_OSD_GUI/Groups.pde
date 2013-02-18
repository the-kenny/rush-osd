void SetupGroups(){
 //G_EEPROM,
  //G_RSSI,
 // G_Voltage,
  //G_Amperage,
 // G_VVoltage,
 // G_Temperature,
 // G_Board,
 // G_GPS,
//  G_Other
 
  //.setColorForeground(color(30,255))
  //.setColorBackground(color(30,255))
  //.setColorLabel(color(0, 110, 220))
  //.setColorValue(0xffff88ff)
  //.setColorActive(color(30,255))
  
 
 
  
  G_EEPROM = GroupcontrolP5.addGroup("G_EEPROM")
                .setPosition(XEEPROM,YEEPROM+15)
                .setWidth(Col1Width)
                .setBarHeight(15)
                .setBackgroundColor(color(30,255))
                .setColorForeground(color(30,255))
                .setColorActive(red_)
                .setBackgroundHeight((1*17) +5)
                .setLabel("EEPROM")
                //.setGroup(SG)
                .disableCollapse() 
                ; 
                G_EEPROM.captionLabel()
                .toUpperCase(false)
                .align(controlP5.CENTER,controlP5.CENTER)
                ;
                G_EEPROM.hide();
G_RSSI = GroupcontrolP5.addGroup("G_RSSI")
                
                .setPosition(XRSSI,YRSSI+15)
                .setWidth(Col1Width)
                .setColorForeground(color(30,255))
                .setColorBackground(color(30,255))
                .setColorLabel(color(0, 110, 220))
                .setBarHeight(15)
                .setBackgroundColor(color(30,255))
                .setColorActive(red_)
                .setBackgroundHeight((3*17) +5)
                .setLabel("RSSI")
                //.setGroup(SG)
                .disableCollapse() 
                ; 
                G_RSSI.captionLabel()
                
                .toUpperCase(false)
                .align(controlP5.CENTER,controlP5.CENTER)
                ; 
              // G_RSSI.setColorBackground(color(30,255));
G_Voltage = GroupcontrolP5.addGroup("G_Voltage")
                .setPosition(XVolts,YVolts+15)
                .setWidth(Col1Width)
                .setColorForeground(color(30,255))
                .setColorBackground(color(30,255))
                .setColorLabel(color(0, 110, 220))
                .setBarHeight(15)
                .setBackgroundColor(color(30,255))
                .setColorActive(red_)
                .setBackgroundHeight((5*17) +5)
                .setLabel("Main Voltage")
                //.setGroup(SG)
                .disableCollapse() 
                ; 
                G_Voltage.captionLabel()
                .toUpperCase(false)
                .align(controlP5.CENTER,controlP5.CENTER)
                ; 
 
 G_Amperage = GroupcontrolP5.addGroup("G_Amperage")
                .setPosition(XAmps,YAmps+15)
                .setWidth(Col1Width)
                .setBarHeight(15)
                .setColorForeground(color(30,255))
                .setColorBackground(color(30,255))
                .setColorLabel(color(0, 110, 220))
                .setBarHeight(15)
                .setBackgroundColor(color(30,255))
                .setColorActive(red_)
                .setBackgroundHeight((2*17) +5)
                .setLabel("Amperage")
                //.setGroup(SG)
                .disableCollapse() 
                ; 
                G_Amperage.captionLabel()
                .toUpperCase(false)
                .align(controlP5.CENTER,controlP5.CENTER)
                ; 
 G_VVoltage = GroupcontrolP5.addGroup("G_VVoltage")
                .setPosition(XVVolts,YVVolts+15)
                .setWidth(Col1Width)
                .setBarHeight(15)
                .setColorForeground(color(30,255))
                .setColorBackground(color(30,255))
                .setColorLabel(color(0, 110, 220))
                .setBarHeight(15)
                .setBackgroundColor(color(30,255))
                .setColorActive(red_)
                .setBackgroundHeight((3*17) +5)
                .setLabel("Video Voltage")
                //.setGroup(SG)
                .disableCollapse() 
                ; 
                G_VVoltage.captionLabel()
                .toUpperCase(false)
                .align(controlP5.CENTER,controlP5.CENTER)
                ; 
 G_Temperature = GroupcontrolP5.addGroup("G_Temperature")
                .setPosition(XTemp,YTemp+15)
                .setWidth(Col1Width)
                .setBarHeight(15)
                .setColorForeground(color(30,255))
                .setColorBackground(color(30,255))
                .setColorLabel(color(0, 110, 220))
                .setBarHeight(15)
                .setBackgroundColor(color(30,255))
                .setColorActive(red_)
                .setBackgroundHeight((2*17) +5)
                .setLabel("Temperature")
                //.setGroup(SG)
                .disableCollapse() 
                ; 
                G_Temperature.captionLabel()
                .toUpperCase(false)
                .align(controlP5.CENTER,controlP5.CENTER)
                ; 
G_GPS = GroupcontrolP5.addGroup("G_GPS")
                .setPosition(XGPS,YGPS+15)
                .setWidth(Col1Width)
                .setBarHeight(15)
                .setColorForeground(color(30,255))
                .setColorBackground(color(30,255))
                .setColorLabel(color(0, 110, 220))
                .setBarHeight(15)
                .setBackgroundColor(color(30,255))
                .setColorActive(red_)
                .setBackgroundHeight((4*17) +5)
                .setLabel("Board Type")
                //.setGroup(SG)
                .disableCollapse() 
                ; 
                G_GPS.captionLabel()
                .toUpperCase(false)
                .align(controlP5.CENTER,controlP5.CENTER)
                ;        
G_Board = GroupcontrolP5.addGroup("G_Board")
                .setPosition(XBoard,YBoard+15)
                .setWidth(Col1Width)
                .setBarHeight(15)
                .setColorForeground(color(30,255))
                .setColorBackground(color(30,255))
                .setColorLabel(color(0, 110, 220))
                .setBarHeight(15)
                .setBackgroundColor(color(30,255))
                .setColorActive(red_)
                .setBackgroundHeight((1*17) +5)
                .setLabel("Board Type")
                //.setGroup(SG)
                .disableCollapse() 
                ; 
                G_Board.captionLabel()
                .toUpperCase(false)
                .align(controlP5.CENTER,controlP5.CENTER)
                ;   

G_Other = GroupcontrolP5.addGroup("G_Other")
                .setPosition(XOther,YOther+15)
                .setWidth(Col2Width)
                .setBarHeight(15)
                .setColorForeground(color(30,255))
                .setColorBackground(color(30,255))
                .setColorLabel(color(0, 110, 220))
                .setBarHeight(15)
                .setBackgroundColor(color(30,255))
                .setColorActive(red_)
                .setBackgroundHeight((9*17) +5)
                .setLabel("Other")
                //.setGroup(SG)
                .disableCollapse() 
                ; 
                G_Other.captionLabel()
                .toUpperCase(false)
                .align(controlP5.CENTER,controlP5.CENTER)
                ;                                          




                 
 
 createMessageBox();
messageBox.hide(); 
  
  
}
