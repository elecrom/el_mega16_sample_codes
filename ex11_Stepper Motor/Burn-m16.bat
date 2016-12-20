@echo REM###############################################################
@echo REM      Batch file for burning the .HEX file using AVRDude
@echo REM      and USBASP. You can modify the  .hex filename  and 
@echo REM      use it for burning your own programmes. 
@echo REM###############################################################

avrdude -c usbasp -p m16 -u -U flash:w:.\exe\stepper.hex
Pause
