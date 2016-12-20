
@ECHO REM###############################################################
@ECHO REM      Batch file for burning the .HEX file using AVRDude
@ECHO REM      and USBASP. You can modify the  .hex filename  and 
@ECHO REM      use it for burning your own programmes. 
@ECHO REM###############################################################

avrdude -c usbasp -p m32 -u -U flash:w:.\exe\iotest.hex
Pause
