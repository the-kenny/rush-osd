Serial g_serial;      // The serial port

/******************************* Multiwii Serial Protocol **********************/

String boxnames[] = { // names for dynamic generation of config GUI
    "ANGLE;",
    "HORIZON;",
    "BARO;",
    "MAG;",
    "ARM;",
    "LLIGHTS;",
    "GPS HOME;",
    "GPS HOLD;",
    "OSD SW;",
    
  };
String strBoxNames = join(boxnames,""); 
//int modebits = 0;

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
  MSP_DEBUG                =254;

// initialize the serial port selected in the listBox
void InitSerial(float portValue) {
  if (portValue < commListMax) {
    if(init_com == 0){ 
      String portPos = Serial.list()[int(portValue)];
      txtlblWhichcom.setValue("COM = " + shortifyPortName(portPos, 8));
      g_serial = new Serial(this, portPos, 115200);
      init_com=1;
      buttonREAD.setColorBackground(green_);
      buttonRESET.setColorBackground(green_);
      commListbox.setColorBackground(green_);
      g_serial.buffer(256);
      System.out.println("Port Turned On " );
      //+((int)(cmd&0xFF))+": "+(checksum&0xFF)+" expected, got "+(int)(c&0xFF));
    }
  }
  else {
    if(init_com == 1){ 
      txtlblWhichcom.setValue("Comm Closed");
      init_com=0;
      commListbox.setColorBackground(red_);
      buttonREAD.setColorBackground(red_);
      buttonRESET.setColorBackground(red_);
      buttonWRITE.setColorBackground(red_);
      init_com=0;
      g_serial.stop();
      SimulateMultiWii.deactivateAll();
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

public static final int
  IDLE = 0,
  HEADER_START = 1,
  HEADER_M = 2,
  HEADER_ARROW = 3,
  HEADER_SIZE = 4,
  HEADER_CMD = 5,
  HEADER_ERR = 6;

private static final String MSP_SIM_HEADER = "$M>";
int c_state = IDLE;
boolean err_rcvd = false;
List<Character> payload;
byte checksum=0;
byte cmd;
int offset=0, dataSize=0;
byte[] inBuf = new byte[256];
int Send_timer = 1;
int p;
int read32() {return (inBuf[p++]&0xff) + ((inBuf[p++]&0xff)<<8) + ((inBuf[p++]&0xff)<<16) + ((inBuf[p++]&0xff)<<24); }
int read16() {return (inBuf[p++]&0xff) + ((inBuf[p++])<<8); }
int read8()  {return inBuf[p++]&0xff;}

/*
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
  for (byte c : MSP_SIM_HEADER.getBytes()) {
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

//send msp with payload
private List<Byte> SendMSP (int msp, Character[] payload) {
  if(msp < 0) {
   return null;
  }
  List<Byte> bf = new LinkedList<Byte>();
  //for (byte c : MSP_HEADER.getBytes()) {
  for (byte c : MSP_SIM_HEADER.getBytes()) {
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
*/

void serialize8(int val) {
   g_serial.write(val);
}

void serialize16(int a) {
  serialize8((a   ) & 0xFF);
  serialize8((a>>8) & 0xFF);
}

void serialize32(int a) {
  serialize8((a    ) & 0xFF);
  serialize8((a>> 8) & 0xFF);
  serialize8((a>>16) & 0xFF);
  serialize8((a>>24) & 0xFF);
}

void serializeNames(int s) {
  //for (PGM_P c = s; pgm_read_byte(c); c++) {
   // serialize8(pgm_read_byte(c));
  //}
  for (int c = 0; c < strBoxNames.length(); c++) {
    serialize8(strBoxNames.charAt(c));
  }
}

int outChecksum;

void headSerialResponse(int requestMSP, Boolean err, int s) {
  serialize8('$');
  serialize8('M');
  serialize8(err ? '!' : '>');
  outChecksum = 0; // start calculating a new checksum
  serialize8(s);
  serialize8(requestMSP);
}

void headSerialReply(int requestMSP, int s) {
  headSerialResponse(requestMSP, false, s);
}

void headSerialError(int requestMSP, int s) {
  headSerialResponse(requestMSP, true, s);
}

void tailSerialReply() {
  serialize8(outChecksum);
}

public void evaluateCommand(byte cmd, int dataSize) {
  int icmd = (int)(cmd&0xFF);

  switch(icmd) {
  case MSP_IDENT:
    headSerialReply(MSP_IDENT, 7);
    serialize8(101);   // multiwii version
    serialize8(0); // type of multicopter
    serialize8(0);         // MultiWii Serial Protocol Version
    serialize32(0);        // "capability"
    break;

  case MSP_STATUS:
    Send_timer+=1;
    headSerialReply(MSP_STATUS, 11);
    serialize16(Send_timer);
    serialize16(0);
    serialize16(1|1<<1|1<<2|1<<3|0<<4);
    
    int modebits = 0;
    int BitCounter = 1;
    for (int i=0; i<boxnames.length; i++) {
      if(checkboxModeItems[i].arrayValue()[0] > 0) modebits |= BitCounter;
      BitCounter += BitCounter;
    }
    
    serialize32(modebits);
    serialize8(0);   // current setting
    break;
    
  case MSP_BOXNAMES:
     headSerialReply(MSP_BOXNAMES,strBoxNames.length());
     serializeNames(strBoxNames.length());
    break;

  case MSP_ATTITUDE:
    headSerialReply(MSP_ATTITUDE, 8);
    serialize16(int(MW_Pitch_Roll.arrayValue()[0])*10);
    serialize16(int(MW_Pitch_Roll.arrayValue()[1])*10);
    serialize16(MwHeading);
    serialize16(0);
    break;

  case MSP_RC:
     headSerialReply(MSP_RC, 14);
      //Roll 
     serialize16(int(Pitch_Roll.arrayValue()[0]));
      //pitch
     serialize16(int(Pitch_Roll.arrayValue()[1]));
      //Yaw
     serialize16(int(Throttle_Yaw.arrayValue()[0]));
      //Throttle
     serialize16(int(Throttle_Yaw.arrayValue()[1]));
      for (int i=5; i<8; i++) {
       serialize16(1500);
      }
    break;
  
  case MSP_RAW_IMU:
  case MSP_RAW_GPS:
  case MSP_COMP_GPS:
  case MSP_ALTITUDE:
    headSerialReply(MSP_ALTITUDE, 6);
    serialize32(int(sAltitude) *100);
    
    serialize16(int(sVario) *10);     
    break;
  
  case MSP_RC_TUNING:
  case MSP_PID:
  case MSP_BAT:
    headSerialReply(MSP_BAT, 3);
    serialize8(int(sVBat * 10));
    serialize16(0);
    break;

  default:
    System.out.print("Unsupported request = ");
    System.out.println(str(icmd));
    break;
  }
}

void GetMWData() {
  List<Character> payload;
  int i,aa;
  float val,inter,a,b,h;
  int c;
  if ((init_com==1) && SimulateMW) {
/*
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
*/
    while (g_serial.available()>0) {
      c = (g_serial.read());

      //if(c >= ' ' && c <= '~')
      //  System.out.print(char(c));
      //else
      //  System.out.print(hex(c));
      //System.out.print(" ");
      //System.out.println(int(c_state));

      if (c_state == IDLE) {
        c_state = (c=='$') ? HEADER_START : IDLE;
      }
      else if (c_state == HEADER_START) {
        c_state = (c=='M') ? HEADER_M : IDLE;
      }
      else if (c_state == HEADER_M) {
        if (c == '<') {
          c_state = HEADER_ARROW;
        } else if (c == '!') {
          c_state = HEADER_ERR;
        } else {
          c_state = IDLE;
        }
      }
      else if (c_state == HEADER_ARROW || c_state == HEADER_ERR) {
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
      }
      else if (c_state == HEADER_SIZE) {
        cmd = (byte)(c&0xFF);
        checksum ^= (c&0xFF);
        c_state = HEADER_CMD;
      }
      else if (c_state == HEADER_CMD && offset < dataSize) {
          checksum ^= (c&0xFF);
          inBuf[offset++] = (byte)(c&0xFF);
      } 
      else if (c_state == HEADER_CMD && offset >= dataSize) {
        /* compare calculated and transferred checksum */
        if ((checksum&0xFF) == (c&0xFF)) {
          if (err_rcvd) {
            //System.err.println("Copter did not understand request type "+c);
          } else {
            /* we got a valid response packet, evaluate it */
            evaluateCommand(cmd, (int)dataSize);
          }
        }
        else {
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
/*
int GetBit(int Mode){
  
  int GetFromSettings = int(confItem[Mode].value());
  int SendBit = 0;    
  switch(GetFromSettings) {
    case 1:
      SendBit = 0;
    break;
    
    case 2:
     SendBit = 1;
    break;
    case 4:
     SendBit = 2;
    break;
    case 8:
     SendBit = 3;
    break;
    case 16:
     SendBit = 4;
    break;
    case 32:
     SendBit = 5;
    break;
    case 64:
     SendBit = 6;
    break;
    case 128:
     SendBit = 7;
    break;
  }
  return SendBit;
}
*/
void ResetVersion(){
  headSerialReply(MSP_IDENT, 7);
  serialize8(0);   // multiwii version
  serialize8(0); // type of multicopter
  serialize8(0);         // MultiWii Serial Protocol Version
  serialize32(0);        
}
      
