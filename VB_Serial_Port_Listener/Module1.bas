Attribute VB_Name = "Module1"
'#AUTHOR  : Omkar C Kulkarni                ##################################
'#                                          ##################################
'#NOTICE  : NO PART OF CODE IN  THIS  FILE  ##################################
'#¯¯¯¯¯¯¯¯  SHOULD  BE  COPIED     WITHOUT  ##################################
'#          PERMISSION OF AUTHOR.           ##################################
'#############################################################################


Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Dim toSend(0 To 32767) As Byte
Dim ctr As Integer
Dim qSets As Integer
Dim QsetFound As Boolean                        'To check whether Qset is found or not
Dim isRowEmpty As Boolean                       'To check whether row is empty, as there will be empty line in between Qsets
Dim choices   As Integer                        'Counter for number of choices
Dim QinfoThisSize As Integer                    'Size of current Q
Dim QinfoPrevSize As Integer                    'Size of previous Q
Dim QNumber       As Integer                    'store Q number
Dim Qstart        As Integer                    'Location
Dim strTmp        As String                     'temp variable to store string
Dim iL, iH        As Integer

Dim Ques  As Integer
Dim QsetStart(0 To 9) As Integer

Public Const uREADY As Integer = 7
Public Const uISREADY As Integer = 11
Public Const uRESEND As Integer = 13
Public Const uNEXT As Integer = 17
Public Const uEND As Integer = 23
Public Const uERROR As Integer = 27
Public sendingData As Boolean                    'used to prevent MSCom's event, emptying received
                                                 'data






'*************************************************************************************
'Function to read given file into given array byte wise
'-------------------------------------------------------------------------------------
Public Sub readFile(fN As String, ByRef eData As Variant)
Dim fnum As Integer
Dim tmpByte As Byte

fnum = FreeFile()
Open fN For Binary Access Read As #fnum
    For i = 0 To 32767
        Get #fnum, , tmpByte
        eData(i) = tmpByte
    Next

Close #fnum

End Sub

'#AUTHOR  : Omkar C Kulkarni                ##################################
'#                                          ##################################
'#NOTICE  : NO PART OF CODE IN  THIS  FILE  ##################################
'#¯¯¯¯¯¯¯¯  SHOULD  BE  COPIED     WITHOUT  ##################################
'#          PERMISSION OF AUTHOR.           ##################################
'#############################################################################



'*************************************************************************************
'Function to send given data in the form of given chunks
'-------------------------------------------------------------------------------------
Public Function sendData(ByRef eeData() As Byte, chunkSize As Integer, MSC As MSComm, ByRef CurrentByte As Long, Optional Text3 As TextBox, Optional bytesTxed As Label)
Dim dtstr As String
Dim retVal As Integer
Dim try As Integer
Dim i, m, j As Long
Dim t As Long

MSC.InputLen = 1

'get max size
m = UBound(eeData)
sendingData = True
t = 0

'Wait for ready signal
While (uart_get_sig(MSC) <> uREADY)
Wend


Text3.Text = ""
bytesTxed.Caption = ""

For i = 0 To m - 1
  
   If ((chunkSize - (i Mod chunkSize)) < 10) And ((i Mod chunkSize) > 0) Then
      dtstr = ""
      Do
         dtstr = dtstr & Chr$(eeData(i))
         i = i + 1
      Loop Until ((i Mod chunkSize) = 0)
      i = i - 1
      
      'fill remaining bytes with ZEROS
      For j = 0 To (8 - (chunkSize - (i Mod chunkSize)))
         dtstr = dtstr & Chr$(0)
      Next j


      ''Text3.Text = Text3.Text & vbCrLf & i & vbTab & "Sent :" & dtstr
      Debug.Print i & vbTab & "Sent :" & dtstr & "#" & Len(dtstr)
      ''Text3.SelStart = Len(Text3.Text) - 1
  
   ElseIf (m - i) < 10 Then
      
      dtstr = ""
      'Fill remaining bytes
      Do
         dtstr = dtstr & Chr$(eeData(i))
         i = i + 1
      Loop Until (i = m)
      
      'fill remaining with nulls
      For j = 0 To (9 - Len(dtstr))
         dtstr = dtstr & Chr$(0)
      Next j

      ''Text3.Text = Text3.Text & vbCrLf & i & vbTab & "Sent :" & dtstr
      Debug.Print i & vbTab & "Sent :" & dtstr & "#" & Len(dtstr)
      ''Text3.SelStart = Len(Text3.Text) - 1
   
   Else

      dtstr = Chr$(eeData(i)) & Chr$(eeData(i + 1)) & Chr$(eeData(i + 2)) & Chr$(eeData(i + 3)) & Chr$(eeData(i + 4)) & Chr$(eeData(i + 5)) & Chr$(eeData(i + 6)) & Chr$(eeData(i + 7)) & Chr$(eeData(i + 8)) & Chr$(eeData(i + 9))
      ''Text3.Text = Text3.Text & vbCrLf & i & vbTab & "Sent :" & dtstr
      Debug.Print i & vbTab & "Sent :" & dtstr & "#" & Len(dtstr)
      ''Text3.SelStart = Len(Text3.Text) - 1
      i = i + 9
   End If
   
re_send_it:

   'send packet & get response
   
   Call uart_send_pack(MSC, dtstr, 10)
   retVal = uart_get_sig(MSC)
   'retVal = uNEXT

   If (retVal = uRESEND) Then                  'if error occurs, RESEND 5 times
      Text3.Visible = True
      try = try + 1
      If (try > 21) Then                       'if 5 tries over, EXIT
         Text3.Text = Text3.Text & vbCrLf & " STOP : PERMANET ERROR": Text3.SelStart = Len(Text3.Text) - 1
         Debug.Print " STOP : PERMANET ERROR"
         Exit Function
      End If
        
      Text3.Text = Text3.Text & " ERROR, Retry " & CStr(try)
      Debug.Print " ERROR, Retry " & CStr(try)
      wait (60)
      GoTo re_send_it
    
   ElseIf (retVal = uEND) Then                 'If system sends END signla terminate transfer
      Text3.Text = Text3.Text & vbCrLf & "DATA WRITTEN"
      Exit Function
    
   ElseIf (retVal = uNEXT) Then                'if NEXT signal received...
      ''Text3.Text = Text3.Text & " Next"
      try = 0
   Else                                        'if any other Invalid signal is received
      Text3.Visible = True
      try = try + 1
      If (try > 21) Then                        'if 5 tries over, EXIT
         Text3.Text = Text3.Text & vbCrLf & " STOP : PERMANET ERROR": Text3.SelStart = Len(Text3.Text) - 1
         Debug.Print " STOP : PERMANET ERROR"
         Exit Function
      End If
        
      Text3.Text = Text3.Text & " ERROR, Retry " & CStr(try)
      Debug.Print " ERROR, Retry " & CStr(try)
      wait (60)
      GoTo re_send_it
   End If

   t = t + 1
   If t = 39 Then
      t = 0
      Text3.Text = ""
      bytesTxed.Caption = CStr((i + 1) / 1000) & "KB /" & CStr(m / 1000) & "KB"
   End If

   CurrentByte = i     ' for displaying speed

Next i


'send one END packet at the end
Call uart_send_pack(MSC, "####END" & Chr$(0) & Chr$(0) & Chr$(0), 10)
Text3.Text = Text3.Text & vbCrLf & "DATA WRITTEN"

bytesTxed.Caption = CStr((i / 1000)) & "KB /" & CStr(m / 1000) & "KB"
sendingData = False
Text3.Visible = False

End Function




'*************************************************************************************
'Function to send data packet via UART
'-------------------------------------------------------------------------------------
'- It accepts MSComm control, data string to be sent and lenght of data packet as parameter
'NOTE :-tough length of data is fixed to 10 byte, pktlen parameter is purposly included
'       to keep program extensible in future.
'      -It is responsibility of calling function to fill *dpkt with NULLs if data being sent
'       is less than 10 byte long .
'      -Aprropriate comm port must be opened before calling this function

Public Sub uart_send_pack(uMSC As MSComm, dpkt As String, pktlen As Integer)
Dim cs1, cs2, cs3 As String   'to hold control signal bytes
Dim vCode, vCodeH, vCodeL As Integer
Dim u_i As Integer

    MSC.InputLen = 1
    vCode = 0
    
    uMSC.Output = "D"
    
    'send data byte one by one
    For u_i = 1 To (pktlen)
        uMSC.Output = Mid$(dpkt, u_i, 1)  ': Debug.Print Mid(dpkt, u_i, 1)
        vCode = vCode + Asc(Mid$(dpkt, u_i)) ': Debug.Print Asc(Mid(dpkt, u_i)) & " " & vCode
    Next u_i
    
    'send check sum
    vCodeL = vCode And &HFF
    vCodeH = (vCode And &HFF00) / 256
    uMSC.Output = Chr(vCodeH)  ': Debug.Print Chr(vCodeH)
    uMSC.Output = Chr(vCodeL)   ': Debug.Print Chr(vCodeL)
    
    DoEvents
End Sub

'*************************************************************************************
'Function to get data packet via UART
'-------------------------------------------------------------------------------------
Public Function uart_get_pack(uMSC As MSComm, ByRef dpkt As String, pktlen As Integer) As Integer
Dim gcs1, gcs2, gcs3 As String   'to hold control signal bytes
Dim vCode, vCodeH, vCodeL As Integer
Dim u_i As Integer
Dim utmp As String
    
    MSC.InputLen = 1

    While (uMSC.InBufferCount < (pktlen + 3))
        DoEvents
    Wend
        
    
    gcs1 = uMSC.Input
    If (gcs1 = "C") Then                            'For control signal
        gcs2 = uMSC.Input: gcs3 = uMSC.Input
        If (gcs2 = gcs3) Then
            uart_get_pack = gcs3
        Else
            uart_get_pack = uERROR
        End If
        Exit Function
    
    ElseIf (gcs1 = "D") Then
        
        For u_i = 1 To pktlen                      'Receive data byes and compute sum
            utmp = uMSC.Input
            dpkt = dpkt & utmp
            vCode = vCode + Asc(utmp)
        Next u_i
        
        vCodeH = (vCode And &HFF00) / 256
        vCodeL = (vCode And &HFF)
        
        If vCodeH = Asc(uMSC.Input) Then
            If vCodeL = Asc(uMSC.Input) Then
                uart_get_pack = 0
                Exit Function
            End If
        End If
        
        uart_get_pack = uERROR
    End If
        
        uart_get_pack = uERROR
End Function

'*************************************************************************************
'Function to get control signal via UART
'-------------------------------------------------------------------------------------
Public Function uart_get_sig(uMSC1 As MSComm) As Integer
Dim us1 As String
Dim us2 As String
Dim timeOut As Integer

    MSC.InputLen = 1
    timeOut = 0
    While ((uMSC1.InBufferCount < 3))
        DoEvents
        timeOut = timeOut + 1
        If (timeOut > 32000) Then
           Debug.Print "TIME-OUT for response...error"
           wait (100)
           uart_get_sig = uERROR
           Exit Function
         End If
    Wend
    
    us1 = uMSC1.Input
    If (us1 = "C") Then                    'check for control signal
        us1 = uMSC1.Input
        us2 = uMSC1.Input
        If (us1 = us2) Then
            uart_get_sig = Asc(us1)
            Exit Function
        Else
            uart_get_sig = uERROR
            Exit Function
        End If
    Else
        uart_get_sig = uERROR
        Exit Function
    End If
    
End Function

'*************************************************************************************
'Function to send control signal via UART
'-------------------------------------------------------------------------------------
Public Sub uart_send_sig(uMSC2 As MSComm, uSig As Integer)

    
    uMSC2.Output = "C"
    uMSC2.Output = Chr(uSig)
    uMSC2.Output = Chr(uSig)
    
End Sub

Public Sub wait(n As Integer)

While (n > 1)
   Sleep 1
   n = n - 1
   If (n Mod 10) = 0 Then DoEvents
Wend

End Sub



