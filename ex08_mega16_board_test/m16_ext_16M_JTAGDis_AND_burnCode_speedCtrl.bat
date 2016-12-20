@REM ######################################################################################
@REM Settings : External Crystal, no rail to rail swing, Slow rising power, JTAG Disabled
@REM
@REM CKOPT = 1 (unprog)
@REM CKSEL321 = 111	
@REM CKSEL0   = 1
@REM SUT10    = 11
@REM ######################################################################################

avrdude -c usbasp -p m16 -B 50 -u -U hfuse:w:0b11011001:m -U lfuse:w:0b11111111:m
Pause
avrdude -c usbasp -p m16 -B 2 -u -U flash:w:.\exe\m16brdtest.hex
Pause