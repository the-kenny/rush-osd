
//  NTSC         PAL
const unsigned screenPosition[][2] PROGMEM = {
  { LINE02+2,    LINE02+2       },   // GPS_numSatPosition
  { LINE03+14,   LINE03+14      },   // GPS_directionToHomePosition
  { LINE02+23,   LINE02+23      },   // GPS_distanceToHomePosition
  { LINE03+24,   LINE03+24      },   // speedPosition
  { LINE04+14,   LINE04+14      },   // GPS_angleToHomePosition
  { LINE04+24,   LINE04+24      },   // MwGPSAltPosition
  { LINE03+2,    LINE03+2       },   // sensorPosition
  { LINE02+19,   LINE02+19      },   // MwHeadingPosition
  { LINE02+10,   LINE02+10      },   // MwHeadingGraphPosition
  { LINE07+2,    LINE07+2       },   // MwAltitudePosition
  { LINE07+24,   LINE07+24      },   // MwClimbRatePosition
  { LINE11+22,   LINE11+22+60   },   // CurrentThrottlePosition
  { LINE12+22,   LINE12+22+60   },   // flyTimePosition
  { LINE13+22,   LINE13+22+60   },   // onTimePosition
  { LINE12+11,   LINE11+11+60   },   // motorArmedPosition
  { LINE10+2,    LINE10+2+60    },   // MwGPSLatPosition
  { LINE10+13+2, LINE10+2+13+60 },   // MwGPSLonPosition
  { LINE12+2,    LINE12+2+60    },   // rssiPosition
  { LINE11+2,    LINE11+2       },   // temperaturePosition
  { LINE13+3,    LINE13+3+60    },   // voltagePosition
  { LINE11+3,    LINE11+3+60    },   // vidvoltagePosition
  { LINE13+10,   LINE13+10+60   },   // amperagePosition
  { LINE13+16,   LINE13+16+60   },   // pMeterSumPosition
};

unsigned int getPosition(uint8_t pos) {
  return (unsigned int)pgm_read_word(&screenPosition[pos][Settings[S_VIDEOSIGNALTYPE]]);
}

