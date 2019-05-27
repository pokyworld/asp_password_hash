<%
' -------------------------------------------------------
' -- Password Functions
' -------------------------------------------------------
Function DecodePwd(tval)
  Pwd = tval
  For I = 1 to Len(Pwd)
    tChar = Mid(Pwd,I,3)
    TextValue = TextValue & Chr(((tChar+9)-118)+23)
    I = (I + 2)
  Next
  BinValue = Pwd
  DecodePwd = TextValue
End Function

Function EncodePwd(tval)
  Pwd = tval
  For I = 1 to Len(Pwd)
    BinValue = BinValue & (((Asc(Mid(Pwd,I,1))-9)+118)-23)
  Next
  TextValue = Pwd
  EncodePwd = BinValue
End Function

Function RandomPW(myLength)
  Const minLength = 5
  Const maxLength = 8
  Dim X, Y, strPW
  If myLength = 0 Then
    Randomize
    myLength = Int((maxLength * Rnd) + minLength)
  End If
  For X = 1 To myLength
    'Randomize the type of this character
    Y = Int((3 * Rnd) + 1) '(1) Numeric, (2) Uppercase, (3) Lowercase
    Select Case Y
    Case 1
      'Numeric character
      Randomize
      strPW = strPW & CHR(Int((9 * Rnd) + 48))
    Case 2
      'Uppercase character
      Randomize
      strPW = strPW & CHR(Int((25 * Rnd) + 65))
    Case 3
      'Lowercase character
      Randomize
      strPW = strPW & CHR(Int((25 * Rnd) + 97))
    End Select
  Next
  RandomPW = strPW
End Function

Function ValidatePassword(vPass,vLength,vUpper,vLower,vNumber,vSpecial)
  If Len(vPass) >= CLng(vLength) Then
    ' --------------------------------------------------------------------
    ' Check For Non-Allowed Chars. (ASCII: 1-32, 47, 92)
    ' --------------------------------------------------------------------
    fPassedNonAllowed = True
    For I = 1 to Len(vPass)
      If ((Asc(Mid(vPass,I,1)) >= 1) AND (Asc(Mid(vPass,I,1)) <= 32)) OR _
        (Asc(Mid(vPass,I,1))=47) OR (Asc(Mid(vPass,I,1))=92) Then
        fPassedNonAllowed = False
      End If
    Next

    ' --------------------------------------------------------------------
    ' Check for Required UpperCase Chars. (ASCII: 65-90)
    ' --------------------------------------------------------------------    
    fUpperCount = 0
    fPassedUpper = False
    For I = 1 to Len(vPass)
      If ((Asc(Mid(vPass,I,1)) >= 65) AND (Asc(Mid(vPass,I,1)) <= 90)) Then
        fUpperCount = fUpperCount + 1
      End If
    Next
    If (fUpperCount >= vUpper) Then
      fPassedUpper = True
    End If

    ' --------------------------------------------------------------------    
    ' Check for Required LowerCase Chars. (ASCII: 97-122)
    ' --------------------------------------------------------------------    
    fLowerCount = 0
    fPassedLower = False
    For I = 1 to Len(vPass)
      If ((Asc(Mid(vPass,I,1)) >= 97) AND (Asc(Mid(vPass,I,1)) <= 122)) Then
        fLowerCount = fLowerCount + 1
      End If
    Next
    If (fLowerCount >= vLower) Then
      fPassedLower = True
    End If

    ' --------------------------------------------------------------------    
    ' Check for Required Numeric Chars. (ASCII: 48-57)
    ' --------------------------------------------------------------------    
    fNumericCount = 0
    fPassedNumeric = False
    For I = 1 to Len(vPass)
      If ((Asc(Mid(vPass,I,1)) >= 48) AND (Asc(Mid(vPass,I,1)) <= 57)) Then
        fNumericCount = fNumericCount + 1
      End If
    Next
    If (fNumericCount >= vNumber) Then
      fPassedNumeric = True
    End If    

    ' --------------------------------------------------------------------    
    ' Check for Required Special Chars. (ASCII: 33-47, 58-64 and 91-96)
    ' --------------------------------------------------------------------    
    fSpecialCount = 0
    fPassedSpecial = False
    For I = 1 to Len(vPass)
      If ((Asc(Mid(vPass,I,1)) >= 33) AND (Asc(Mid(vPass,I,1)) <= 47)) OR _
        ((Asc(Mid(vPass,I,1)) >= 58) AND (Asc(Mid(vPass,I,1)) <= 64)) OR _
        ((Asc(Mid(vPass,I,1)) >= 91) AND (Asc(Mid(vPass,I,1)) <= 96)) Then
        fSpecialCount = fSpecialCount + 1
      End If
    Next
    If (fSpecialCount >= vSpecial) Then
      fPassedSpecial = True
    End If
    
    If fPassedNonAllowed AND fPassedUpper AND fPassedLower AND _
      fPassedNumeric AND fPassedSpecial Then
      ValidatePassword = True
    Else
      ValidatePassword = False
    End If
  Else
    ValidatePassword = False
  End If
End Function

Function getToken(myLength)
  Const minLength = 5
  Const maxLength = 64
  Dim X, Y, strPW
  If myLength = 0 Then
    Randomize
    myLength = Int((maxLength * Rnd) + minLength)
  End If
  For X = 1 To myLength
    'Randomize the type of this character
    Y = Int((3 * Rnd) + 1) '(1) Numeric, (2) Uppercase, (3) Lowercase
    Select Case Y
    Case 1
      'Numeric character
      Randomize
      strPW = strPW & CHR(Int((9 * Rnd) + 48))
    Case 2
      'Uppercase character
      Randomize
      strPW = strPW & CHR(Int((25 * Rnd) + 65))
    Case 3
      'Lowercase character
      Randomize
      strPW = strPW & CHR(Int((25 * Rnd) + 97))
    End Select
  Next
  getToken = strPW
End Function

Function expireToken(days)
  expStamp = Year(Date()+days) & "-" & Month(Date()+days) & "-" & Day(Date()+days) & " " & Time()  
  expireToken = expStamp
End Function

' -------------------------------------------------------
' -- MySQL Functions
' -------------------------------------------------------
Function MySQLAddHours(addHrs)
  If Hour(Time()) < (23-addHrs) Then
    ' -- Same Day
    mySQLAddHours = Year(Date()) & "-" & Month(Date()) & "-" & Day(Date()) & " " & (Hour(Time())+addHrs) & ":" & Minute(Time()) & ":" & Second(Time())
  Else
    ' -- Increment Day By 1
    mySQLAddHours = Year(Date()+1) & "-" & Month(Date()+1) & "-" & Day(Date()+1) & " " & (Hour(Time())+addHrs) & ":" & Minute(Time()) & ":" & Second(Time())
  End If
End Function

Function MySQLNow()
  vYear = Year(Date())
  vMonth = Month(Date())
  vDay = Day(Date())
  MySQLNow = vYear & "-" & vMonth & "-" & vDay & " " & _
    Hour(Time()) & ":" & Minute(Time()) & ":" & Second(Time())  
End Function

Function MySQLDate(vDate)
  vYear = Year(vDate)
  vMonth = Month(vDate)
  vDay = Day(vDate)
  MySQLDate = vYear & "-" & vMonth & "-" & vDay
End Function

' -------------------------------------------------------
' -- Date Functions
' -------------------------------------------------------

' -------------------------------------------------------
' -- String Functions
' -------------------------------------------------------


' -------------------------------------------------------
' -- Get the root url for exposing files to API
' -------------------------------------------------------
Function rootUrl()
    output = Request.ServerVariables("HTTP_HOST") & Request.ServerVariables("SCRIPT_NAME")
    output = Left(output,InstrRev(output, "/"))
    if Request.ServerVariables("HTTPS") = "off" then : prefix = "http://" : else :  prefix = "https://" : end if
    output = prefix & output
    rootUrl = output
End Function

' -------------------------------------------------------
' -- Removes JSON characters from Base64Data
' -------------------------------------------------------
Function cleanJSONImage(JSONBase64Data)
    Dim Base64Data 
    Base64Data = JSONBase64Data
    Base64Data = Replace(Base64Data, "\\/", "/")
    Base64Data = Replace(Base64Data, "\\n", "")
    Base64Data = Replace(Base64Data, "\\r", "")
    Base64Data = Replace(Base64Data, "\/", "/")
    Base64Data = Replace(Base64Data, "\n", "")
    Base64Data = Replace(Base64Data, "\r", "")
    Base64Data = Replace(Base64Data, " ", "+")
    cleanJSONImage = Base64Data
End Function

' -------------------------------------------------------
' -- Saves Converted Base64Image to File as Binary File
' -------------------------------------------------------
Function saveBase64ImageToFile(myBase64Data, filePathName)
    Dim CanvasStream
    Set CanvasStream = Base64Data2Stream(myBase64data)
    CanvasStream.SaveToFile filePathName, 2 'adSaveCreateOverWrite
    Set CanvasStream = Nothing
End Function

' -------------------------------------------------------
' -- Converts Base64Image to Binary
' -------------------------------------------------------
Function Base64Data2Stream(sData)
    Set Base64Data2Stream = Server.CreateObject("Adodb.Stream")
        Base64Data2Stream.Type = 1 'adTypeBinary
        Base64Data2Stream.Open
    With Server.CreateObject("MSXML2.DomDocument.6.0").createElement("b64")
        .dataType = "bin.base64"
        .text = sData
        Base64Data2Stream.Write .nodeTypedValue 'write bytes of decoded base64 to stream
        Base64Data2Stream.Position = 0
    End With
End Function

' -------------------------------------------------------
' -- Generate GUID or alphaNumeric string of a given length
' -------------------------------------------------------
Function getGUID()
	Set TypeLib = CreateObject("Scriptlet.TypeLib")
	myGuid = TypeLib.Guid
	myGuid = Left(myGuid, Len(myGuid)-2)
  'If Not brackets = True Then
    ' getGUID = Trim(Replace(Replace(myGuid,"{",""),"}",""))
  'else
  	getGUID = Trim(myGuid)
  'End If
End Function

Function getRndString(length)
	Set TypeLib = CreateObject("Scriptlet.TypeLib")
	myGuid = TypeLib.Guid
	myGuid = Left(myGuid, Len(myGuid)-2)
	myGuid = Trim(Replace(Replace(Replace(myGuid, Chr(123), ""), Chr(125), ""), "-", ""))
	getRndString = LCase(Left(myGuid, length))
End Function

' -------------------------------------------------------
' -- Required for Connecting to DB from within Functions
' -------------------------------------------------------
Function OpenCn() 
    Dim Cn 
    Set Cn = Server.CreateObject("ADODB.Connection") 
    Cn.Open strConn
    set OpenCn = Cn 
End Function

' -------------------------------------------------------
' -- Write text (log) items to file
' -------------------------------------------------------
Function Write2File(filePathName, msgToWrite)
    dim fs, f
    Const ForReading = 1, ForWriting = 2, ForAppending = 8
    set fs = Server.CreateObject("Scripting.FileSystemObject") 
    set f = fs.OpenTextFile(filePathName, ForAppending, True)
    f.WriteLine("[" & Now() & "] - " & msgToWrite)
    f.close
    set f=nothing
    set fs=nothing
End Function

' -------------------------------------------------------
' -- Write sql string and result (1st Record) to file
' -------------------------------------------------------
Function WriteSql2File(sql, sqlCmd)
	filePathName = Application("logs") & DatePrefix & "data.txt"
	Write2File filePathName, "sql : " & sql
	Write2File filePathName, "----------------------------------------------------------"
	Select Case sqlCmd
		Case "select"
			if LCase(Left(sql,4)) = "call" then : Exit Function
			Set rs = Server.CreateObject("ADODB.RecordSet")
			rs.Open sql, dbConn
			If Not rs.BOF and Not rs.EOF Then
				For Each field in rs.fields
					Write2File filePathName, field.name & " : " & field.value
				Next		
			End If
			rs.Close
			Set rs = Nothing
		Case Else
			'dbConn.Execute(sql)	'// Do not process
	End Select
End Function

Function ProcessSql(sql, sqlCmd)
	filePathName = Application("logs") & DatePrefix & "data.txt"
	Select Case sqlCmd
		Case "select"
			Set rs = Server.CreateObject("ADODB.RecordSet")
			rs.Open sql, dbConn
			If Not rs.BOF and Not rs.EOF Then
				For Each field in rs.fields
					Write2File filePathName, field.name & " : " & field.value
				Next		
			End If
			Set ProcessSql = rs
		Case Else
			dbConn.Execute(sql)
	End Select
End Function

' -------------------------------------------------------
' -- Handles Padding of Strings to a given length
' -------------------------------------------------------
Function DatePrefix()
	vYear = Year(Date())
	vMonth = PadLeft(Month(Date()), "0", 2)
	vDay = PadLeft(Day(Date()), "0", 2)
    DatePrefix = vYear & vMonth & vDay & "_"
End Function

' -------------------------------------------------------
' -- Handles Padding of Strings to a given length
' -------------------------------------------------------
Function PadLeft(sInput, sPadding, iLen)
    sOutput = sInput
    Do While Len(sOutput) < iLen
        sOutput = sPadding & sOutput
    Loop
    PadLeft = sOutput
End Function

Function PadRight(sInput, sPadding, iLen)
    sOutput = sInput
    Do While Len(sOutput < iLen)
        sOutput = sOutput & sPadding
    Loop
    PadRight = sOutput
End Function

' -------------------------------------------------------
' -- PCase for showing strings in Proper Case
' -------------------------------------------------------
Function PCase(strInput)
    Dim iPosition,iSpace,strOutput  
    iPosition = 1
    Do While InStr(iPosition, strInput, " ", 1) <> 0
        iSpace = InStr(iPosition, strInput, " ", 1)
        strOutput = strOutput & UCase(Mid(strInput, iPosition, 1))
        strOutput = strOutput & LCase(Mid(strInput, iPosition + 1, iSpace - iPosition))
        iPosition = iSpace + 1
    Loop
    iPosition = 1
    Do While InStr(iPosition, strInput, "-", 1) <> 0
        iSpace = InStr(iPosition, strInput, "-", 1)
        strOutput = strOutput & UCase(Mid(strInput, iPosition, 1))
        strOutput = strOutput & LCase(Mid(strInput, iPosition + 1, iSpace - iPosition))
        iPosition = iSpace + 1
    Loop
    strOutput = strOutput & UCase(Mid(strInput, iPosition, 1))
    strOutput = strOutput & LCase(Mid(strInput, iPosition + 1))
    PCase = strOutput
End Function

' -------------------------------------------------------
' -- Get Geo Location from IP address
' -------------------------------------------------------
Function getGeoIP(ip)

    If Len(ip) < 7 then: ip = Request.ServerVariables("REMOTE_ADDR")

    url = "http://ip-api.com/json/" & ip
    Set xmlHttp = Server.createobject("MSXML2.XMLHTTP.6.0") 
    xmlHttp.open "GET", url, False 
    xmlHttp.send
    strResp = xmlHttp.responseText
    set xmlHttp = nothing

    ' {
    '   "as": "AS45629 JasTel Network",
    '   "city": "Bangkok",
    '   "country": "Thailand",
    '   "countryCode": "TH",
    '   "isp": "TRIPLETNET",
    '   "lat": 13.7159,
    '   "lon": 100.417,
    '   "org": "",
    '   "query": "171.7.134.2",
    '   "region": "10",
    '   "regionName": "Bangkok",
    '   "status": "success",
    '   "timezone": "Asia/Bangkok",
    '   "zip": "10160"
    ' }

    If Len(strResp) >= 1 Then
        Set iJSON = new aspJSON
        iJSON.loadJSON(strResp) 

        Dim arr_result(2)
        If iJSON.data("status") = "fail" Then
            '// Error response ??
        Else       
            lat = iJSON.data("lat")
            lon = iJSON.data("lon")
            Set iJSON = Nothing
            sql = "update t_profile_coords set ip_address = " & SQLstr(ip_address) & ", lat = " & SQLstr(lat) & ", lon = " & SQLstr(lon) & ", device_type_id = 4, last_updated = " & SQLstr(MySqlNow) & " where vm_id = " & vmID & ";"
            WriteSql2File sql, "update"
            dbConn.Execute(sql)
            arr_result(0) = ip_address
            arr_result(1) = lat
            arr_result(2) = lon
        End If
    End If

    ' sResult = oJSON.data("city") & "," oJSON.data("countryCode") & "," & oJSON.data("lat") & "," & oJSON.data("lon")
    ' Response.Write sResult & "<br>"

	Set iJSON = Nothing
    getGeoIP = arr_result


End Function

' -------------------------------------------------------
' -- Encode string with Base64
' -------------------------------------------------------
Public Function base64_encode( byVal strIn )

	Dim Base64Chars
	Base64Chars =	"ABCDEFGHIJKLMNOPQRSTUVWXYZ" & _
			"abcdefghijklmnopqrstuvwxyz" & _
			"0123456789" & _
			"+/"

	Dim c1, c2, c3, w1, w2, w3, w4, n, strOut
	For n = 1 To Len( strIn ) Step 3
		c1 = Asc( Mid( strIn, n, 1 ) )
		c2 = Asc( Mid( strIn, n + 1, 1 ) + Chr(0) )
		c3 = Asc( Mid( strIn, n + 2, 1 ) + Chr(0) )
		w1 = Int( c1 / 4 ) : w2 = ( c1 And 3 ) * 16 + Int( c2 / 16 )
		If Len( strIn ) >= n + 1 Then 
			w3 = ( c2 And 15 ) * 4 + Int( c3 / 64 ) 
		Else 
			w3 = -1
		End If
		If Len( strIn ) >= n + 2 Then 
			w4 = c3 And 63 
		Else 
			w4 = -1
		End If
		strOut = strOut + mimeencode( w1 ) + mimeencode( w2 ) + _
					mimeencode( w3 ) + mimeencode( w4 )
	Next
	base64_encode = strOut
End Function

Private Function mimeencode( byVal intIn )
	Dim Base64Chars
	Base64Chars =	"ABCDEFGHIJKLMNOPQRSTUVWXYZ" & _
			"abcdefghijklmnopqrstuvwxyz" & _
			"0123456789" & _
			"+/"

	If intIn >= 0 Then 
		mimeencode = Mid( Base64Chars, intIn + 1, 1 ) 
	Else 
		mimeencode = ""
	End If
End Function	


' -------------------------------------------------------
' -- Decode string with Base64
' -------------------------------------------------------
Public Function base64_decode( byVal strIn )
	Dim Base64Chars
	Base64Chars =	"ABCDEFGHIJKLMNOPQRSTUVWXYZ" & _
			"abcdefghijklmnopqrstuvwxyz" & _
			"0123456789" & _
			"+/"
	Dim w1, w2, w3, w4, n, strOut
	For n = 1 To Len( strIn ) Step 4
		w1 = mimedecode( Mid( strIn, n, 1 ) )
		w2 = mimedecode( Mid( strIn, n + 1, 1 ) )
		w3 = mimedecode( Mid( strIn, n + 2, 1 ) )
		w4 = mimedecode( Mid( strIn, n + 3, 1 ) )
		If w2 >= 0 Then _
			strOut = strOut + _
				Chr( ( ( w1 * 4 + Int( w2 / 16 ) ) And 255 ) )
		If w3 >= 0 Then _
			strOut = strOut + _
				Chr( ( ( w2 * 16 + Int( w3 / 4 ) ) And 255 ) )
		If w4 >= 0 Then _
			strOut = strOut + _
				Chr( ( ( w3 * 64 + w4 ) And 255 ) )
	Next
	base64_decode = strOut
End Function

Private Function mimedecode( byVal strIn )
	Dim Base64Chars
	Base64Chars =	"ABCDEFGHIJKLMNOPQRSTUVWXYZ" & _
			"abcdefghijklmnopqrstuvwxyz" & _
			"0123456789" & _
			"+/"
	If Len( strIn ) = 0 Then 
		mimedecode = -1 : Exit Function
	Else
		mimedecode = InStr( Base64Chars, strIn ) - 1
	End If
End Function

' -------------------------------------------------------
' -- URLEncode string
Function URLEncode(s)
	Dim strTmpVal : strTmpVal = s
	Dim strRetVal : strRetVal = ""
	Dim intAsc : intAsc = 0
	Dim strHex : strHex = ""

	Dim i, strChr : For i = 1 To Len(strTmpVal)
		strChr = Mid(strTmpVal, i, 1)
				
		If InStr(1, OAUTH_UNRESERVED, strChr) = 0 Then
			intAsc = Asc(strChr)
					
			If intAsc < 32 Or intAsc > 126 Then
				strHex = encodeURIComponent(strChr)
			Else
				strHex = "%" & Hex(intAsc)
			End If

			strRetVal = strRetVal & strHex
		Else
			strRetVal = strRetVal & strChr
		End If
	Next

	URLEncode = strRetVal
End Function

' -------------------------------------------------------
' -- Regex Function
' -------------------------------------------------------
Function RegExResults(strTarget, strPattern)

    Set regEx = New RegExp
    regEx.Pattern = strPattern
    regEx.Global = true
    Set RegExResults = regEx.Execute(strTarget)
    Set regEx = Nothing

End Function

' -------------------------------------------------------
' -- Regex Test against Pattern
' -------------------------------------------------------
Function RegExTest(input, pattern)
    Set regex = New RegExp
    regex.Pattern = pattern
    regex.Global = True
    regex.IgnoreCase = False
    RegExTest = regex.Test(input)
    Set regex = Nothing
End Function

' -------------------------------------------------------
' -- Regex Replace - strip characters by regex pattern
' -------------------------------------------------------
Function RegexReplace(sInput, sPattern, sReplacement)

    ' pattern = "[0-9]"   '// Strips All numbers
    ' pattern = "[^0-9]"   '// Strips All Non-numbers

    dim objRegExp : set objRegExp = new RegExp
    with objRegExp
    .Pattern = sPattern
    .Global = True
    .Multiline = True
    end with
    RegexReplace = objRegExp.replace(sInput, sReplacement)
    set objRegExp = nothing
End Function

%>