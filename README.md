# MultifunctionalDigitalWatch

The multifunctional digital watch is a digital circuit programmed in VHDL. The design is optimized for
implementation on the Digilent Nexys3-developmentboard. The whole system is a synchronized design and
has the following functionality:
 - Time display
 - Date display
 - Alarm
 - Timer
 - Chronometer

# Structure / Modules

- Debouncer
- Klokdeler
  - Deler
- DigitaalUurwerkHoofdsturing
  - ModeSelector5Toestanden
  - InstelmodeSturing
  - PulsToSelectedModule
- Uurwerk
  - Teller4x2DigitsCijfers
    - Teller4x2DigitsCijfersSturing
    - BCDUpDownTeller2DigitsVariableMax
  - UuwerkSturing
    - ZetModule
      - ZetSelector
      - Pulsmodule
      - DelayedPulsGenerator
- Datum
  - Teller4x2DigitsCijfers
    - Teller4x2DigitsCijfersSturing
    - BCDUpDownTeller2DigitsVariableMax
  - DatumSturing
    - ZetModule
      - ZetSelector
      - Pulsmodule
      - DelayedPulsGenerator
  - DatumController
- Alarm
  - Teller4x2DigitsCijfers
    - Teller4x2DigitsCijfersSturing
    - BCDUpDownTeller2DigitsVariableMax
  - AlarmSturing
    - ZetModule
      - ZetSelector
      - Pulsmodule
      - DelayedPulsGenerator
  - AlarmModule
  - Pulsmodule
  - SignalPulsModule
- Timer
  - Teller4x2DigitsCijfers
    - Teller4x2DigitsCijfersSturing
    - BCDUpDownTeller2DigitsVariableMax
  - TimerSturing
    - ZetModule
      - ZetSelector
      - Pulsmodule
      - DelayedPulsGenerator
  - TimerModule
- Chronometer
  - Teller4x2DigitsCijfers
    - Teller4x2DigitsCijfersSturing
    - BCDUpDownTeller2DigitsVariableMax
  - ChronometerSturing
  - FreezeChronoModule
  - Pulsmodule
- Display
  - DisplaySturing
    - DisplaySelector
    - BCDToDis
  - DisplayModule
    - BCD7SegmentDecoder
    - DisplayController
    - DisplayBlinkModule

# Developed by

Huybrechts Thomas

University of Antwerp - 2014
