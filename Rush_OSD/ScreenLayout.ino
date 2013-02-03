
#define POS_MASK        0x01FF
#define PAL_OFF         0x0200
#define DISPLAY_ALWAYS  0x0C00
#define DISPLAY_NEVER   0x0000
#define DISPLAY_COND    0x0400
#define DISPLAY_CONDR   0x0800

#define POS(pos, pal_off, disp)  (((pos)&POS_MASK)|((pal_off)?PAL_OFF:0)|disp)

const uint16_t screenPosition[] PROGMEM = {
  POS(LINE02+2,  0, DISPLAY_ALWAYS), // GPS_numSatPosition
  POS(LINE03+14, 0, DISPLAY_ALWAYS), // GPS_directionToHomePosition
  POS(LINE02+24, 0, DISPLAY_ALWAYS), // GPS_distanceToHomePosition
  POS(LINE03+24, 0, DISPLAY_ALWAYS), // speedPosition
  POS(LINE04+14, 0, DISPLAY_ALWAYS), // GPS_angleToHomePosition
  POS(LINE04+24, 0, DISPLAY_ALWAYS), // MwGPSAltPosition
  POS(LINE03+2,  0, DISPLAY_ALWAYS), // sensorPosition
  POS(LINE02+19, 0, DISPLAY_ALWAYS), // MwHeadingPosition
  POS(LINE02+10, 0, DISPLAY_ALWAYS), // MwHeadingGraphPosition
  POS(LINE07+2,  0, DISPLAY_ALWAYS), // MwAltitudePosition
  POS(LINE07+24, 0, DISPLAY_ALWAYS), // MwClimbRatePosition
  POS(LINE11+22, 1, DISPLAY_ALWAYS), // CurrentThrottlePosition
  POS(LINE12+22, 1, DISPLAY_ALWAYS), // flyTimePosition
  POS(LINE13+22, 1, DISPLAY_ALWAYS), // onTimePosition
  POS(LINE12+11, 1, DISPLAY_ALWAYS), // motorArmedPosition
  POS(LINE10+2,  1, DISPLAY_ALWAYS), // MwGPSLatPosition
  POS(LINE10+15, 1, DISPLAY_ALWAYS), // MwGPSLonPosition
  POS(LINE12+2,  1, DISPLAY_ALWAYS), // rssiPosition
  POS(LINE11+2,  0, DISPLAY_ALWAYS), // temperaturePosition
  POS(LINE13+3,  1, DISPLAY_ALWAYS), // voltagePosition
  POS(LINE11+3,  1, DISPLAY_ALWAYS), // vidvoltagePosition
  POS(LINE13+10, 1, DISPLAY_ALWAYS), // amperagePosition
  POS(LINE13+16, 1, DISPLAY_ALWAYS), // pMeterSumPosition
  POS(LINE05+8,  0, DISPLAY_ALWAYS), // horizonPosition
};

uint16_t getPosition(uint8_t pos) {
  uint16_t val =  (uint16_t)pgm_read_word(&screenPosition[pos]);
  uint16_t ret = val & POS_MASK;

  if(Settings[S_VIDEOSIGNALTYPE] && (val & PAL_OFF)) {
    ret += 2*LINE;
  }
  return ret;
}
