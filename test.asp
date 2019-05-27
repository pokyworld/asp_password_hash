<%@ language="vbscript" %>
<!-- #include virtual="./lib/aspJSON1.17.asp" -->
<!-- #includes virtual="./config/default.asp" -->
<!-- #include virtual="./includes/dbOpen.asp" -->
<!-- #include virtual="./includes/passwords.asp" -->
<!-- #include virtual="./includes/functions.asp" -->
<%
    '// Test Alpha
    string1 = "Ab1@Cd2#Ef3/Gh4|"
    string1 = "des@pokyworld.c"

pattern = "^[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]@[\w-\.]*[a-zA-Z0-9]\.[a-zA-Z]{2,7}$"

    ' pattern = "[0-9]"   '// Strips All numbers
    ' pattern = "[^0-9]"   '// Strips All Non-numbers

    ' pattern = "/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$"

    test = RegExTest(string1, pattern)

    ' Set arrResults = RegExResults(string1, pattern)
    ' For each result in arrResults
    '     Response.Write result.Submatches(0) & "<br/>"
    ' Next
    ' test = RegExReplace(string1 & "", pattern, "")
    
    Response.Write "Result: " & test & "<br/>"
    salt = getRndString(32)
    Response.Write "Salt: " & salt & "<br/>"


%>
<!-- #include virtual="./includes/dbClose.asp" -->
