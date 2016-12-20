REM###############################################################
REM      Batch file for burning the .HEX file using AVRDude
REM      and USBASP. You can modify the  .hex filename  and 
REM      use it for burning your own programmes. 
REM###############################################################

avrdude -c usbasp -p m16 -U flash:w:.\exe\motor.hex
Pause
