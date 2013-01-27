PImage LoadFont(String filename) {
  colorMode(ARGB, 255);
  PImage img = createImage(12, 18*256, ARGB);
  InputStream in = null;
  byte[] header = { 'M','A','X','7','4','5','6' };
  boolean inHeader = true;
  int hIndex = 0;
  int bitNo = 0;
  int byteNo = 0;
  int charNo = 0;
  int curByte = 0;
  
  int white = 0xFFFFFFFF;
  int black = 0xFF000000;
  int transparent = 0x00000000;
  
  System.out.println("LoadFont "+filename);
  
  img.loadPixels();

  //for(int i = 0; i < 12*18*256; i++)
  //  img.pixels[i] = #000000;
    
  try {
    in = createInput(filename);
    
    while(in.available() > 0) {
      int inB = in.read();
      //System.out.println("read "+inB);
      if(inHeader) {
        if(hIndex < header.length && header[hIndex] == inB) {
          hIndex++;
          continue;
        }
        if(hIndex == header.length && (inB == '\r' || inB == '\n')) {
          inHeader = false;
          //System.out.println("done header");
          continue;
        }
        hIndex = 0;
        continue;
      }
      else {
        //System.out.println("data "+hex(inB));
        switch(inB) {
        case '\r':
        case '\n':
          if (bitNo == 0)
            continue; 
          if (bitNo == 8) {
            if (byteNo < 54) {
              for(int i = 0; i < 4; i++) {
                int index = (charNo*12*18) + (byteNo*4) + (3-i);
                switch((curByte >> (2*i)) & 0x03) {
                case 0x00:
                   img.pixels[index] = black;
                   break; 
                case 0x01:
                   img.pixels[index] = transparent;
                   break; 
                case 0x02:
                   img.pixels[index] = white;
                   break; 
                case 0x03:
                   img.pixels[index] = transparent;
                   break; 
                }
              }
            }
            bitNo = 0;
            //System.out.println("Loaded byte "+byteNo+" "+hex(curByte));
            curByte = 0;
            ++byteNo;
            if(byteNo == 64) {
              //System.out.println("Loaded char "+charNo);
              byteNo = 0;
              ++charNo;
            }
          }
          break;
        case '0':
        case '1':
          if(bitNo >= 8) {
            throw new Exception("File format error");
          }
          curByte = (curByte << 1) | (inB & 1);
          ++bitNo;
          break;
        }
      }
    }
  }
  catch (FileNotFoundException e) {
      System.out.println("File Not Found "+filename);
  }
  catch (IOException e) {
  }
  catch(Exception e) {
  }
  finally {
    if(in != null)
      try {
        in.close();
      }
      catch (IOException ioe) {
      }
  }
  
  img.updatePixels();
  return img;
}
