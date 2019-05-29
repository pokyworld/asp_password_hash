<!-- #includes virtual="./config/default.asp" -->
<!-- #include virtual="./lib/aspJSON1.17.asp" -->
<!-- #include virtual="./lib/passwords.asp" -->
<!-- #include virtual="./lib/jwt.asp" -->
<%

    token = URL.decode(Trim(Request.Cookies("token")&""))
    ' Response.Write "Token : " & token & "<hr/>"

    If Len(token) >= 1 Then

        '// Verify token
        verify = jwtVerifyToken(token, jwtKey)

        If verify = True Then
            header = jwtGetHeaderFromToken(token)
            payload = jwtGetPayloadFromToken(token)
            Set oJSON = new aspJSON
            oJSON.loadJSON(payload)
            expTime = CLng(Trim(oJSON.data("exp")&""))
            If expTime >= UTC.timestamp() Then
                email = Trim(oJSON.data("user")("email")&"")
                id = Trim(oJSON.data("user")("id")&"")

                '// Update the token in cookies
                token = jwtGetToken(payload, header, jwtKey)
                verify = jwtVerifyToken(token, jwtKey)
                
                '// Save JWT to Cookies
                If verify = True Then
                    Session("LoggedIn") = True
                    Response.Cookies("token") = token
                    Response.Cookies("token").Expires = DateAdd("d", 1, Now())
                Else
                    Session("LoggedIn") = True
                End If
            Else
                Session("LoggedIn") = False
            End If
        Else
            Session("LoggedIn") = False
        End If
        Set oJSON = Nothing
    Else
        Session("LoggedIn") = False
    End If

%>