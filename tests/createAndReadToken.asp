<%@ language="vbscript" %>
<!-- #includes virtual="./config/default.asp" -->
<!-- #include virtual="./lib/aspJSON1.17.asp" -->
<!-- #include virtual="./includes/dbOpen.asp" -->
<!-- #include virtual="./includes/passwords.asp" -->
<!-- #include virtual="./includes/jwt.asp" -->
<!-- #include virtual="./includes/functions.asp" -->

<%
    header = jwtGetHeader()
    Response.Write "Header : " & header & "<br/>"

'// Get data for payload
    id = 192
    email = "john.doe@example.com"

'// Create payload as object
    Set oJSON = new aspJSON
    With oJSON.data
        .Add "user", oJSON.Collection()
        With oJSON.data("user")
            .Add "id", id
            .Add "email", email
        End With
    End With
    payload = oJSON.JSONoutput()
    Set oJSON = Nothing
    Response.Write "Payload : " & payload & "<br/>"

'// Create JWT
    token = jwtGetToken(payload, header, jwtKey)
    Response.Write "Token : " & token & "<hr/>"

'// Verify Token
    verify = jwtVerifyToken(token, jwtKey)
    Response.Write "Verify Token : " & verify & "<hr/>"

'// Get Payload From Token
    payload = jwtGetPayloadFromToken(token)

    If Len(payload) >= 1 Then
        Set oJSON = new aspJSON
        oJSON.loadJSON(payload)
        id = oJSON.data("user")("id")&""
        email = oJSON.data("user")("email")&""
        Response.Write "id : " & id & "<br/>"
        Response.Write "email : " & email & "<br/>"
        Set oJSON = Nothing
    End If

%>

<!-- #include virtual="./includes/dbClose.asp" -->
