
	.DEF _iH=R4
	.DEF _iL=R5
	.DEF _my_i2c_rv=R6
	.DEF _t=R7
	.DEF _i1=R9
	.DEF _i2=R11
	.DEF _i=R13
_237:
	.DB  0x80,0xC0
_0:
	.DB  0x30,0x30,0x30,0x30,0x30,0x30,0x0,0x57
	.DB  0x72,0x69,0x74,0x65,0x3A,0x0,0xD,0xA
	.DB  0x57,0x72,0x69,0x74,0x65,0x3A,0x0,0x52
	.DB  0x65,0x61,0x64,0x20,0x3A,0x0,0xD,0xA
	.DB  0x52,0x65,0x61,0x64,0x3A,0x0,0xD,0xA
	.DB  0x4C,0x32,0x39,0x33,0x44,0x5F,0x31,0x20
	.DB  0x54,0x65,0x73,0x74,0x20,0x2E,0x2E,0x2E
	.DB  0x20,0x0,0x20,0x64,0x6F,0x6E,0x65,0x0
	.DB  0xD,0xA,0x4C,0x32,0x39,0x33,0x44,0x5F
	.DB  0x32,0x20,0x54,0x65,0x73,0x74,0x20,0x2E
	.DB  0x2E,0x2E,0x20,0x0,0xD,0xA,0x4C,0x43
	.DB  0x44,0x5F,0x74,0x65,0x73,0x74,0x0,0x4D
	.DB  0x45,0x47,0x41,0x31,0x36,0x0,0x44,0x45
	.DB  0x56,0x45,0x4C,0x4F,0x50,0x4D,0x45,0x4E
	.DB  0x54,0x20,0x42,0x52,0x44,0x0,0xD,0xA
	.DB  0x4C,0x45,0x44,0x20,0x54,0x65,0x73,0x74
	.DB  0x20,0x2E,0x2E,0x2E,0x20,0x0,0xD,0xA
	.DB  0x41,0x44,0x43,0x20,0x54,0x65,0x73,0x74
	.DB  0x20,0x2E,0x2E,0x2E,0x0,0xD,0xA,0x43
	.DB  0x48,0x20,0x25,0x64,0x3A,0x20,0x25,0x30
	.DB  0x33,0x64,0x20,0x3D,0x3E,0x20,0x25,0x30
	.DB  0x34,0x64,0x20,0x6D,0x56,0x0,0xD,0xA
	.DB  0x0,0xD,0xA,0xA,0x23,0x20,0x44,0x4F
	.DB  0x4E,0x45,0x2E,0x0,0xD,0xA,0xA,0x20
	.DB  0x4E,0x6F,0x77,0x20,0x70,0x72,0x65,0x73
	.DB  0x73,0x20,0x6B,0x65,0x79,0x73,0x20,0x6F
	.DB  0x6E,0x20,0x72,0x65,0x6D,0x6F,0x74,0x65
	.DB  0xD,0xA,0x0,0x50,0x72,0x65,0x73,0x73
	.DB  0x20,0x72,0x65,0x6D,0x6F,0x74,0x65,0x20
	.DB  0x6B,0x65,0x79,0x73,0x0,0xD,0xA,0xA
	.DB  0x4B,0x65,0x79,0x20,0x3A,0x20,0x25,0x64
	.DB  0x20,0x0,0xD,0xA,0xA,0xA,0x4D,0x65
	.DB  0x67,0x61,0x31,0x36,0x20,0x64,0x65,0x76
	.DB  0x65,0x6C,0x6F,0x70,0x6D,0x65,0x6E,0x74
	.DB  0x20,0x62,0x6F,0x61,0x72,0x64,0x20,0x66
	.DB  0x6F,0x72,0x20,0x70,0x72,0x6F,0x6A,0x65
	.DB  0x63,0x74,0x2F,0x70,0x72,0x6F,0x64,0x75
	.DB  0x63,0x74,0x2F,0x72,0x6F,0x62,0x6F,0x74
	.DB  0x69,0x63,0x73,0x20,0x64,0x65,0x76,0x65
	.DB  0x6C,0x6F,0x70,0x6D,0x65,0x6E,0x74,0x0
	.DB  0xA,0xD,0x4C,0x43,0x44,0x20,0x69,0x73
	.DB  0x20,0x61,0x73,0x73,0x75,0x6D,0x65,0x64
	.DB  0x20,0x74,0x6F,0x20,0x62,0x65,0x20,0x70
	.DB  0x72,0x65,0x73,0x65,0x6E,0x74,0x2E,0x0
	.DB  0xA,0xD,0x4C,0x43,0x44,0x20,0x69,0x73
	.DB  0x20,0x61,0x73,0x73,0x75,0x6D,0x65,0x64
	.DB  0x20,0x74,0x6F,0x20,0x62,0x65,0x20,0x61
	.DB  0x62,0x73,0x65,0x6E,0x74,0x2E,0x0

__GLOBAL_INI_TBL:
	.DW  0x07
	.DW  _76
	.DW  _0*2

	.DW  0x02
	.DW  __base_y_G4
	.DW  _237*2

	.DW  0
_0x100:
