PImage FullFont;


public boolean mouseDown = false;
public boolean mouseUp = true;
PImage PreviewChar;
PImage[] CharImages = new PImage[256];
int row = 0;
int gap = 5;
int gapE = 1;
int curPixel = -1;
int curChar = -1;
boolean mouseSet = false;
color gray = color(120);
color white = color(255);
color black = color(0);


// screen locations
int XFullFont = 25;    int YFullFont = 25;
int XcharEdit = 5;    int YcharEdit = 5;
int PreviewX = 60;     int PreviewY = 275;



Bang CharBang[] = new Bang[256] ;
Bang CharPixelsBang[] = new Bang[216] ;
Bang PreviewCharBang;
Textlabel CharTopLabel[] = new Textlabel[16] ;
Textlabel CharSideLabel[] = new Textlabel[16] ;
Textlabel LabelCurChar;
Group FG,FGFull,FGCharEdit, FGPreview;
Button buttonFClose;


void Font_Editor_setup() {
  for (int i=0; i<256; i++) {
    CharImages[i] = createImage(12, 18, ARGB);
  }
  
 
  
  FG = FontGroupcontrolP5.addGroup("FG")
    .setPosition(150,50)
    .setWidth(680)
    .setBarHeight(12)
    .activateEvent(true)
    .setBackgroundColor(color(200,255))
    .setBackgroundHeight(450)
    .setLabel("Font Editor")
    .setMoveable(true)
    .disableCollapse()
    .hide();
    
    ;
    FGFull = FontGroupcontrolP5.addGroup("FGFull")
    .setPosition(20,20)
    .setWidth( 16*(12+gap)+ 25)
    .setBarHeight(12)
    .activateEvent(true)
    .hideBar() 
    .setBackgroundColor(color(0,255))
    .setBackgroundHeight(16*(18+gap)+35)
    .setLabel("Character List")
    .setMoveable(true)
    .setGroup(FG);
    ;
    FGCharEdit = FontGroupcontrolP5.addGroup("FGCharEdit")
    .setPosition(350,20)
    .setWidth( 12*(10+gapE)+ 33)
    .setBarHeight(12)
    .activateEvent(true)
    .hideBar() 
    .setBackgroundColor(color(180,255))
    .setBackgroundHeight(18*(10+gapE)+120)
    .setMoveable(true)
    .setGroup(FG);
    ;
    
    
    
// RawFont = LoadFont("MW_OSD_Team.mcm");
for (int i=0; i<256; i++) {
    int boxX = XFullFont+(i % 16) * (12+gap);
    int boxY = YFullFont + (i / 16) * (18+gap);
    CharBang[i] = FontGroupcontrolP5.addBang("CharMap"+i)
      .setPosition(boxX, boxY)
      .setSize(12, 18)
      .setLabel("")
      .setId(i)
      .setImages(CharImages[i], CharImages[i], CharImages[i], CharImages[i]) 
      .setGroup(FGFull);
    ;
   
  } 
String[] CharRows = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"};
  
  for (int i=0; i<16; i++) {
    int boxX = XFullFont-15;
    int boxY = YFullFont + i * (18+gap);
    CharSideLabel[i] = FontGroupcontrolP5.addTextlabel("charlabside" +i,CharRows[i],boxX ,boxY )
    .setGroup(FGFull)
    .setColor(white);
    ;
  } 
  for (int i=0; i<16; i++) {
    int boxX = XFullFont + i * (12+gap);
    int boxY = YFullFont-15;
    CharTopLabel[i] =FontGroupcontrolP5.addTextlabel("charlabtop" +i,CharRows[i],boxX ,boxY )
    .setGroup(FGFull)
    .setColor(white);
    ;
  } 
  

 
 for (int i=0; i<216; i++) {
    int boxX = XcharEdit+(i % 12) * (12+gapE);
    int boxY = YcharEdit + (i / 12) * (12+gapE);
    CharPixelsBang[i] = FontGroupcontrolP5.addBang("CharPix"+i)
      .setPosition(boxX, boxY)
      .setSize(12, 12)
      .setLabel("")
      .setId(i)
      .setColorBackground(gray)
      .setColorForeground(gray)
      .setValue(0)
      .setGroup(FGCharEdit)
      ;
    
  }

  LabelCurChar = FontGroupcontrolP5.addTextlabel("LabelCurChar","No Index Set" ,XcharEdit+ 10,YcharEdit + 18*(12+gapE)+5)
  .setColor(white)
  .setGroup(FGCharEdit);
 
 PreviewCharBang = FontGroupcontrolP5.addBang("PreviewCharBang")
      .setPosition(FGCharEdit.getWidth() / 2 -6, PreviewY)
      .setSize(12, 18)
      .setLabel("")
      //.setId(i)
      .setImages(PreviewChar, PreviewChar, PreviewChar, PreviewChar) 
      .setGroup(FGCharEdit);
    ;
 
 
 
 
  buttonFClose = FontGroupcontrolP5.addButton("FCLOSE",1,680- 55 ,10,45,18);buttonFClose.setColorBackground(red_);
  buttonFClose.getCaptionLabel()
    .setFont(font12)
    .toUpperCase(false)
    .setText("CLOSE");

  buttonFClose.setGroup(FG);
 
  MGUploadF = controlP5.addGroup("MGUploadF")
                .setPosition(5,200)
                .setWidth(110)
                .setBarHeight(15)
                .activateEvent(true)
                .setBackgroundColor(color(30,255))
                .setBackgroundHeight(100)
                .setLabel("Font Tools")
                .disableCollapse();
                //.close() 
               ; 

FileUploadText = controlP5.addTextlabel("FileUploadText",LoadPercent,10,5)
.setGroup(MGUploadF);
;

buttonEditFont = controlP5.addButton("EditFont",1,20,25,60,16)
.setGroup(MGUploadF);
 buttonEditFont.getCaptionLabel()
.toUpperCase(false)
.setText("Edit Font")
;

buttonBrowseFile = controlP5.addButton("Browse",1,20,50,60,16)
.setGroup(MGUploadF);
;
buttonSendFile = controlP5.addButton("Send",1,20,75,60,16)
.setGroup(MGUploadF);
;
 
}

void MakePreviewChar(){
  PImage PreviewChar = createImage(12, 18, ARGB);
   PreviewChar.loadPixels();
  for(int byteNo = 0; byteNo < 216; byteNo++) {
    switch(int(CharPixelsBang[byteNo].value())) {
      case 0:
        PreviewChar.pixels[byteNo] = gray;
        //CharImages[charNo].pixels[CharIndex] = gray;
      break;     
      case 1:
        PreviewChar.pixels[byteNo] = black;
        //CharImages[charNo].pixels[CharIndex] = black;
      break; 
      case 2:
        PreviewChar.pixels[byteNo] = white;
        //CharImages[charNo].pixels[CharIndex] = white;
      break; 
    }
  }
  PreviewChar.updatePixels();
  PreviewCharBang.setImages(PreviewChar, PreviewChar, PreviewChar, PreviewChar); 
}

void FCLOSE(){
  Lock_All_Controls(false);
  FG.hide();
}

void EditFont(){
  Lock_All_Controls(true);
 //setLock(ScontrolP5.getController("MwHeading"),true);
  FG.show();
  Lock_All_Controls(true);
}

void changePixel(int id){
 
  if ((mouseUp) && (id > -1)){
    int curColor = int(CharPixelsBang[id].value());
    switch(curColor) {
    
    case 0: 
     CharPixelsBang[id].setColorForeground(black);
     CharPixelsBang[id].setValue(1);
     //println("0");
    
    break; 
    
    case 1: 
     CharPixelsBang[id].setColorForeground(white);
     CharPixelsBang[id].setValue(2);
     //println("1");
    
    break; 
    
    case 2: 
     CharPixelsBang[id].setColorForeground(gray);
     CharPixelsBang[id].setValue(0);
     //println("2");
    
    break; 
   }
  }
  curPixel = -1;
  MakePreviewChar();
 
}  

void GetChar(int id){
 
  if ((mouseUp) && (id > -1)){
    for(int byteNo = 0; byteNo < 216; byteNo++) {
      CharPixelsBang[byteNo].setColorForeground(gray);
      CharPixelsBang[byteNo].setValue(0);
    }
    for(int byteNo = 0; byteNo < 216; byteNo++) {
      switch(CharImages[id].pixels[byteNo]) {
          case 0xFF000000:
            CharPixelsBang[byteNo].setColorForeground(black);
            CharPixelsBang[byteNo].setValue(1);
          break; 
          case 120:
            CharPixelsBang[byteNo].setColorForeground(gray);
            CharPixelsBang[byteNo].setValue(0);
          break; 
          case 0xFFFFFFFF:
            CharPixelsBang[byteNo].setColorForeground(white);
            CharPixelsBang[byteNo].setValue(2);
          break; 
      }
      
    }
    //LabelCurChar.setValue("          ");
    String HexId = " -- Hex ID 0x" + hex(id).substring(hex(id).length()-2, hex(id).length());  
    LabelCurChar.setValue("INDEX # "+id + HexId);
    LabelCurChar.setColorBackground(0);
    MakePreviewChar();
    //LabelCurChar.update(); 
    curChar = -1;
  }
 
}

void setLock(Controller theController, boolean theValue) {
  theController.setLock(theValue);
}

void Lock_All_Controls(boolean theLock){

 //System.out.println(controlP5.getControllerList());
ControllerInterface[] sctrl = ScontrolP5.getControllerList();
   for(int i=0; i<sctrl.length; ++i)
   {
    try{
      setLock(ScontrolP5.getController(sctrl[i].getName()),theLock);
    }catch (NullPointerException e){}
   }
   
   ControllerInterface[] ctrl5 = controlP5.getControllerList();
   for(int i=0; i<ctrl5.length; ++i)
   {
    try{
      setLock(controlP5.getController(ctrl5[i].getName()),theLock);
    }catch (NullPointerException e){}
   }


}
