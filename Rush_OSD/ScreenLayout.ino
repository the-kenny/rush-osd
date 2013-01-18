
//      NTSC          NTSC             PAL              PAL       
//      WIDE          NARROW           WIDE             NARROW 

const unsigned screenPosition[][2][2] PROGMEM = {
  { { LINE02+2,    LINE02+4,    }, { LINE02+2,       LINE02+4       } },   // GPS_numSatPosition
  { { LINE03+14,   LINE03+14,   }, { LINE03+14,      LINE03+14      } },   // GPS_directionToHomePosition
  { { LINE02+24,   LINE02+20,   }, { LINE02+24,      LINE02+21      } },   // GPS_distanceToHomePosition
  { { LINE03+24,   LINE03+20,   }, { LINE03+24,      LINE03+21      } },   // speedPosition
  { { LINE04+14,   LINE04+14,   }, { LINE04+14,      LINE04+14      } },   // GPS_angleToHomePosition
  { { LINE04+24,   LINE04+20,   }, { LINE04+24,      LINE04+21      } },   // MwGPSAltPosition
  { { LINE03+2,    LINE03+4,    }, { LINE03+2,       LINE03+4       } },   // sensorPosition
  { { LINE02+19,   LINE02+17,   }, { LINE02+19,      LINE02+17      } },   // MwHeadingPosition
  { { LINE02+10,   LINE02+10,   }, { LINE02+10,      LINE02+10      } },   // MwHeadingGraphPosition
  { { LINE07+2,    LINE07+4,    }, { LINE07+2,       LINE07+4       } },   // MwAltitudePosition
  { { LINE07+26,   LINE07+26,   }, { LINE07+25,      LINE07+26      } },   // MwClimbRatePosition
  { { LINE11+23,   LINE11+21,   }, { LINE11+23+60,   LINE11+21+60   } },   // CurrentThrottlePosition
  { { LINE12+23,   LINE12+21,   }, { LINE12+23+60,   LINE12+21+60   } },   // flyTimePosition
  { { LINE13+23,   LINE13+21,   }, { LINE13+23+60,   LINE13+21+60   } },   // onTimePosition
  { { LINE12+11,   LINE12+11,   }, { LINE11+11+60,   LINE11+11+60   } },   // motorArmedPosition
  { { LINE10+2,    LINE10+4,    }, { LINE10+2+60,    LINE10+4+60    } },   // MwGPSLatPosition
  { { LINE10+13+2, LINE10+13+4, }, { LINE10+2+13+60, LINE10+13+4+60 } },   // MwGPSLonPosition
  { { LINE12+3,    LINE12+5,    }, { LINE12+3+60,    LINE12+5+60    } },   // rssiPosition
  { { LINE11+2,    LINE11+4,    }, { LINE11+2,       LINE11+4       } },   // temperaturePosition
  { { LINE13+3,    LINE13+5,    }, { LINE13+3+60,    LINE13+5+60    } },   // voltagePosition
  { { LINE11+3,    LINE11+5,    }, { LINE11+3+60,    LINE11+5+60    } },   // vidvoltagePosition
  { { LINE13+10,   LINE13+12,   }, { LINE13+10+60,   LINE13+12+60   } },   // amperagePosition
  { { LINE13+16,   LINE13+18,   }, { LINE13+16+60,   LINE13+18+60   } },   // pMeterSumPosition
};

unsigned int getPosition(uint8_t pos) {
  return (unsigned int)pgm_read_word(&screenPosition[pos][videoSignalType][screenType]);
}

