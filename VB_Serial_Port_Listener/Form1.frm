VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Begin VB.Form Form1 
   Appearance      =   0  'Flat
   BackColor       =   &H80000005&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Comm Port : 1 : Listening OFF"
   ClientHeight    =   10290
   ClientLeft      =   1500
   ClientTop       =   525
   ClientWidth     =   12525
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   10290
   ScaleWidth      =   12525
   Begin VB.TextBox Text4 
      Height          =   4155
      Left            =   135
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   13
      Text            =   "Form1.frx":0000
      Top             =   5535
      Visible         =   0   'False
      Width           =   12255
   End
   Begin VB.CommandButton fSend 
      Caption         =   "SendFile"
      Height          =   465
      Left            =   10935
      TabIndex        =   12
      Top             =   90
      Width           =   1455
   End
   Begin VB.CommandButton NewFl 
      Caption         =   "New File"
      Height          =   465
      Left            =   6705
      TabIndex        =   11
      Top             =   90
      Width           =   1455
   End
   Begin VB.Timer Timer1 
      Interval        =   2000
      Left            =   7920
      Top             =   675
   End
   Begin MSComDlg.CommonDialog CD 
      Left            =   9585
      Top             =   900
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.TextBox Text3 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   1260
      TabIndex        =   7
      Text            =   "56000,n,8,1"
      Top             =   630
      Width           =   1230
   End
   Begin MSCommLib.MSComm MSC 
      Left            =   11610
      Top             =   1530
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   0   'False
      InBufferSize    =   16000
      InputLen        =   10
      OutBufferSize   =   5555
      RThreshold      =   1
      SThreshold      =   1
   End
   Begin VB.CommandButton Command4 
      Caption         =   "Clear Text Box"
      Height          =   465
      Left            =   8370
      TabIndex        =   5
      Top             =   90
      Width           =   1545
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Save To File"
      Height          =   465
      Left            =   5265
      TabIndex        =   4
      Top             =   90
      Width           =   1455
   End
   Begin VB.TextBox Text1 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1305
      TabIndex        =   3
      Text            =   "1"
      Top             =   135
      Width           =   510
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Stop Listening"
      Height          =   465
      Left            =   3825
      TabIndex        =   1
      Top             =   90
      Width           =   1455
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Start Listening"
      Height          =   465
      Left            =   2385
      TabIndex        =   0
      Top             =   90
      Width           =   1455
   End
   Begin RichTextLib.RichTextBox Text2 
      Height          =   8880
      Left            =   135
      TabIndex        =   8
      Top             =   1080
      Width           =   12255
      _ExtentX        =   21616
      _ExtentY        =   15663
      _Version        =   393217
      Enabled         =   -1  'True
      ScrollBars      =   3
      TextRTF         =   $"Form1.frx":0006
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Courier New"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.Label LSpeed 
      Caption         =   "Speed"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   11385
      TabIndex        =   15
      Top             =   585
      Width           =   960
   End
   Begin VB.Label bSent 
      Caption         =   "Bytes Sent"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   510
      Left            =   9855
      TabIndex        =   14
      Top             =   585
      Width           =   1500
   End
   Begin VB.Label fnameLBL 
      Caption         =   "DEFAULT FILE :"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   135
      TabIndex        =   10
      Top             =   9990
      Width           =   11220
   End
   Begin VB.Label Label3 
      Caption         =   "OmkarCK"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   240
      Left            =   11610
      TabIndex        =   9
      Top             =   9945
      Width           =   825
   End
   Begin VB.Label Label2 
      Caption         =   "Settings :                            ( Baud rate,Parity,No of data bits,No of stop bits)"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   180
      TabIndex        =   6
      Top             =   660
      Width           =   7050
   End
   Begin VB.Label Label1 
      Caption         =   "Comm Port : "
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   180
      TabIndex        =   2
      Top             =   135
      Width           =   2130
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Dim def_fname As String
Dim curr_time, cur_date As String

Dim currB As Long    ''for displaying speed
Dim lastB As Long    ''for displaying speed


Private Sub Command1_Click()
On Error Resume Next

    MSC.PortOpen = False
    MSC.CommPort = CInt(Text1.Text)
    MSC.Settings = Text3.Text
    MSC.PortOpen = True
    Command1.Enabled = False
    Command2.Enabled = True
    
    Form1.Caption = "Comm Port : " & Text1.Text & " : Listening ON"

End Sub

Private Sub Command2_Click()
On Error Resume Next
    
    MSC.PortOpen = False
    Form1.Caption = "Comm Port : " & Text1.Text & " : Listening OFF"
    Command1.Enabled = True
    Command2.Enabled = False


End Sub

Private Sub Command3_Click()
Dim fName As String
    
    CD.ShowSave
    def_fname = CD.FileName

    Text2.SaveFile def_fname
    fnameLBL.Caption = "FILE : " & def_name
    
End Sub

Private Sub Command4_Click()
Text2.Text = ""

End Sub

Private Sub Form_Load()
On Error Resume Next

   currB = 0
   lastB = 0

   Text3.Text = Interaction.GetSetting("SerialPortListener", "commSetting", "commSetting", Text3.Text)
   Text1.Text = Interaction.GetSetting("SerialPortListener", "commSetting", "commSettingP", Text1.Text)
   MSC.CommPort = Text1.Text
   MSC.Settings = Text3.Text
    
   cur_time = Str$(Time)
   cur_date = Str$(Date)
   cur_date = Replace(cur_date, "/", "_")
   cur_time = Replace(cur_time, ":", "_")
   def_fname = App.Path & "\log# " & cur_date & "# " & cur_time & ".rtf"
   fnameLBL.Caption = "FILE : " & def_fname    'Text2.Text = "Listening..." & vbCrLf
    
   Text2.Text = ""
    
   Command1.Enabled = False

   MSC.PortOpen = True

End Sub

Private Sub Form_Unload(Cancel As Integer)
On Error Resume Next
    MSC.PortOpen = False
End

End Sub

Private Sub Label4_Click()

End Sub

Private Sub fSend_Click()
Dim FILENUM As Integer
Dim eeData() As Byte
Dim fLen As Long
Dim fName As String
Dim tmpByte As Byte
Dim i As Long



CD.ShowOpen
If (CD.FileName <> "") Then

   '# Read data from file to EEdata array
   Reset
   fLen = FileLen(CD.FileName)
   
   ReDim eeData(0 To fLen + 8)
   FILENUM = FreeFile()
   fName = CD.FileName
   Open fName For Binary Access Read As #FILENUM
    For i = 8 To fLen + 8
        Get #FILENUM, , tmpByte
        eeData(i) = tmpByte
    Next

   Close #FILENUM

   '# store length of file
   'NOTE THAT : LSB first
   '----------
   eeData(3) = (fLen And CLng(&HFF000000)) / CLng((2 ^ 24))  '>>> MSB LAST !!!!
   eeData(2) = (fLen And CLng(&HFF0000)) / CLng((2 ^ 16))
   eeData(1) = (fLen And CLng(65280)) / CLng((2 ^ 8))
   eeData(0) = (fLen And CLng(255))

   eeData(4) = 0
   eeData(5) = 0
   eeData(6) = 0
   eeData(7) = 0



   'If ((i Mod 512) <> 0) Then                'if available data is not in multiple
                                             ' of 512 bytes
    '  Do
     '    eeData(i) = 0
      '   i = i + 1
      'Loop Until ((i Mod 512) = 0)
   'End If

   '# send data inthe form of packets of 512 Bytes
   Text4.Visible = False
     Text4.Visible = True

   sendData eeData, 512, MSC, currB, Text4, bSent

End If


End Sub

Private Sub MSC_OnComm()
Dim x As String
If sendingData = False Then
    Text2.Text = Text2.Text & MSC.Input
    'If (Len(Text2.Text) > 7000) Then Text2.Text = ""
    Text2.SelStart = Len(Text2.Text)
    Text2.SelLength = 1
End If
End Sub

Private Sub NewFl_Click()
    cur_time = Str$(Time)
    cur_date = Str$(Date)
    cur_date = Replace(cur_date, "/", "_")
    cur_time = Replace(cur_time, ":", "_")
    def_fname = App.Path & "\log# " & cur_date & "# " & cur_time & ".rtf"
    fnameLBL.Caption = "FILE : " & def_fname
    Text2.Text = ""
End Sub

Private Sub Text1_Change()
Interaction.SaveSetting "SerialPortListener", "commSetting", "commSettingP", Text1.Text
End Sub

Private Sub Text3_Change()
Interaction.SaveSetting "SerialPortListener", "commSetting", "commSetting", Text3.Text
End Sub
Private Sub Timer1_Timer()
   
    LSpeed.Caption = Left$(CStr(((currB - lastB) / 1000) / 2), 4) & "KB/s"
    lastB = currB

    Text2.SaveFile def_fname
    ' Text2.SelLength = 0
    ' Text2.SelStart = Len(Text2.Text)

End Sub
