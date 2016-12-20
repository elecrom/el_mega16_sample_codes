VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MsComCtl.ocx"
Begin VB.Form Form2 
   Caption         =   "Updating data ..."
   ClientHeight    =   675
   ClientLeft      =   60
   ClientTop       =   360
   ClientWidth     =   8700
   LinkTopic       =   "Form2"
   ScaleHeight     =   675
   ScaleWidth      =   8700
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ProgressBar PB1 
      Height          =   690
      Left            =   -45
      TabIndex        =   1
      Top             =   0
      Width           =   8790
      _ExtentX        =   15505
      _ExtentY        =   1217
      _Version        =   393216
      Appearance      =   0
      Scrolling       =   1
   End
   Begin MSCommLib.MSComm MSC 
      Left            =   8640
      Top             =   945
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   -1  'True
      InputLen        =   1
      RThreshold      =   1
      BaudRate        =   38400
      SThreshold      =   1
   End
   Begin VB.TextBox Text3 
      Height          =   690
      Left            =   135
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   0
      Text            =   "Form2.frx":0000
      Top             =   180
      Width           =   8385
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'#AUTHOR  : Omkar C Kulkarni                ##################################
'#                                          ##################################
'#NOTICE  : NO PART OF CODE IN  THIS  FILE  ##################################
'#¯¯¯¯¯¯¯¯  SHOULD  BE  COPIED     WITHOUT  ##################################
'#          PERMISSION OF AUTHOR.           ##################################
'#############################################################################

Public Sub mnu_progEEPROM_Click()
On Error Resume Next

Dim ZEROsdetected As Boolean

Dim eeData(0 To 32767) As String
Dim tmpByte As Byte
Dim newLH, newLL As Byte
Dim i  As Long
Dim retVal As Integer
Dim dtstr As String
Dim try As Integer

FILENUM = 7
Text3.Text = ""
try = 0
ZEROsdetected = False

'Read data from file to EEdata array
Reset
Open App.Path & "\eeprom.bin" For Binary Access Read As #FILENUM
    For i = 0 To 32767
        Get #FILENUM, , tmpByte
        eeData(i) = tmpByte
    Next

Close #FILENUM

'Now send 10 bytes at a time to µC
MSC.PortOpen = False
MSC.PortOpen = True

Text3.Text = Text3.Text & vbCrLf & "Waiting for system to get READY"
Do
    retVal = uart_get_sig(MSC)
    
Loop Until (retVal = uREADY)
Text3.Text = Text3.Text & vbCrLf & "got READY. Sending data ..." & vbCrLf



For i = 0 To 32767 Step 10
      
    '#DECORATION
    PB1.Value = (i * 100 / (eeData(2) * &H100 + eeData(3) + 20))

    'Skip sending ZEROs. If 10 consecutive ZEROs are detected, directly start sending
    'data from new non-zero data location.Tell system this using data packet
    ' '###<newlocation>'.
    If ((eeData(i) = 0) And (eeData(i + 1) = 0) And (eeData(i + 2) = 0) And (eeData(i + 3) = 0) And (eeData(i + 4) = 0)) Then
    If ((eeData(i + 5) = 0) And (eeData(i + 6) = 0) And (eeData(i + 7) = 0) And (eeData(i + 8) = 0) And (eeData(i + 9) = 0)) Then
        If (ZEROsdetected = False) Then Text3.Text = Text3.Text & vbCrLf & i & vbTab & "Skipping..."
        ZEROsdetected = True
        GoTo NEXT_i
    End If
    End If
    
    'if skipping is done...Tell system this using data packet '####<newlocation>'.
    If (ZEROsdetected = True) Then
        'Split higer and lower bytes of new location (in hex format)
        newLL = i And &HFF
        newLH = (i And &HFF00) / 256
        Do
            Call uart_send_pack(MSC, "####" & Chr$(newLH) & Chr$(newLL) & Chr$(0) & Chr$(0) & Chr$(0) & Chr$(0), 10)
        Loop Until (uart_get_sig(MSC) = uNEXT)
        
        ZEROsdetected = False
    End If
       
    'Compose 10 byte string
    dtstr = Chr$(eeData(i)) & Chr$(eeData(i + 1)) & Chr$(eeData(i + 2)) & Chr$(eeData(i + 3)) & Chr$(eeData(i + 4)) & Chr$(eeData(i + 5)) & Chr$(eeData(i + 6)) & Chr$(eeData(i + 7)) & Chr$(eeData(i + 8)) & Chr$(eeData(i + 9))
    Text3.Text = Text3.Text & vbCrLf & i & vbTab & "Sent :" & Chr$(eeData(i)) & Chr$(eeData(i + 1)) & Chr$(eeData(i + 2)) & Chr$(eeData(i + 3)) & Chr$(eeData(i + 4)) & Chr$(eeData(i + 5)) & Chr$(eeData(i + 6)) & Chr$(eeData(i + 7)) & Chr$(eeData(i + 8)) & Chr$(eeData(i + 9))
    Text3.SelStart = Len(Text3.Text) - 1
   
    
re_send_it:

    'send packet & get response
    Call uart_send_pack(MSC, dtstr, 10)
    retVal = uart_get_sig(MSC)
    
    
    If (retVal = uRESEND) Then                  'if error occurs, RESEND 5 times
        try = try + 1
        If (try > 5) Then                       'if 5 tries over, EXIT
            Text3.Text = Text3.Text & vbCrLf & " STOP : PERMANET ERROR": Text3.SelStart = Len(Text3.Text) - 1
            Exit Sub
        End If
        
        Text3.Text = Text3.Text & " ERROR, Retry " & CStr(try)
        GoTo re_send_it
    
    ElseIf (retVal = uEND) Then                 'If system sends END signla terminate transfer
        Text3.Text = Text3.Text & vbCrLf & "DATA WRITTEN"
        Exit Sub
    
    ElseIf (retVal = uNEXT) Then                'if NEXT signal received...
        Text3.Text = Text3.Text & " Next"
    Else                                        'if any other Invalid signal is received
        try = try + 1
        If (try > 5) Then                       'if 5 tries over, EXIT
            Text3.Text = Text3.Text & vbCrLf & " STOP : PERMANET ERROR": Text3.SelStart = Len(Text3.Text) - 1
            Exit Sub
        End If
        
        Text3.Text = Text3.Text & " ERROR, Retry " & CStr(try)
        GoTo re_send_it
    End If
    
    If ((i Mod 190) = 0) Then Text3.Text = ""
    
      
NEXT_i:
Next i
'send one END packet at the end
Call uart_send_pack(MSC, "####END" & Chr$(0) & Chr$(0) & Chr$(0), 10)
Text3.Text = Text3.Text & vbCrLf & "DATA WRITTEN"



End Sub
Public Sub readEEPROM()
On Error Resume Next


Dim eeData(0 To 65536) As String
Dim tmpByte As Byte
Dim dCnt  As Long
Dim retVal As Integer
Dim strR As String
Dim errCnt As Integer

FILENUM = 7
Text3.Text = ""
try = 0


'OPEN PORT
MSC.PortOpen = False
MSC.PortOpen = True

uart_send_sig MSC, uREADY

Do
   'Get packet
   Do
      retVal = uart_get_pack(MSC, strR, 10)
      
      If (retVal = uERROR) Then
         uart_send_sig MSC, uRESEND
         Text3.Text = Text3.Text & " RESEND"
      End If
      
   Loop Until (retVal = uERROR)
''''''''''''''''''''''
''''''''''''''''''''''''
''''''''''''''''''''''''
Loop
   





End Sub


Private Sub Form_Load()
PB1.Value = 0
End Sub

Private Sub Form_Unload(Cancel As Integer)
On Error Resume Next
MSC.PortOpen = False
End

End Sub

