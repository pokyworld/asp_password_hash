<%@ language="vbscript" %>
<!-- #include virtual="./lib/aspJSON1.17.asp" -->
<!-- #includes virtual="./config/default.asp" -->
<!-- #include virtual="./includes/dbOpen.asp" -->
<!-- #include virtual="./includes/passwords.asp" -->
<!-- #include virtual="./includes/jwt.asp" -->
<!-- #include virtual="./includes/functions.asp" -->
<%
    ' Response.Write("Logged In : " & Session("LoggedIn") & "<hr/>") 
    ErrorMsg = ""

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

    If Request.Form.Count >= 1 Then
        ' For Each item In Request.Form
        '     Response.Write "Form Item : " & item & " - " & Request.Form(item) & "<br/>"
        ' Next

        If Len(Trim(Request.Form("logout"))) >= 1 Then
            Session("LoggedIn") = False
            Response.Cookies("token").Expires = DateAdd("d", -1, Now())
            Response.Redirect(Request.ServerVariables("SCRIPT_NAME"))
        End If

        process = Trim(Request.Form("form"))
        email = Trim(Request.Form("email") & "")
        password = Trim(Request.Form("password") & "")
        validEmail = ValidateEmail(email)
        validPassword = ValidatePassword(password)
        
        If validEmail = False Then : ErrorMsg = "Invalid Email: Format"
        If validPassword = False Then : ErrorMsg = "Invalid Password: Format"

        '// Check whether user exists with that Username
        sql = "SELECT * FROM user WHERE email = '" & email & "' ORDER BY id DESC LIMIT 1;"
        Set RS = dbConn.Execute(sql)
        If Not RS.EOF Then
            dbID = CInt(RS("id")&"")
            dbEmail = RS("email")&""
            dbSalt = RS("salt")&""
            dbPassword = RS("password")&""
        Else
            ErrorMsg = "Invalid Email: Not Found"
        End If
        RS.Close
        Set RS = Nothing

        If process = "register" And validEmail = True And validPassword = True And dbEmail = "" Then

            salt = getRndString(32)
            hashedPassword = Hash(password, salt)

            '// Insert into DB
            sql = "call sp_insert_new_user("
            sql = sql & "'" & email & "', "
            sql = sql & "'" & salt & "', "
            sql = sql & "'" & hashedPassword & "');"

            Set RS = dbConn.Execute(sql)
            If Not RS.BOF And Not RS.EOF Then
                id = CLng(RS("id")&"")
            End If
            RS.Close
            Set RS = Nothing

        '//----------------------------
        '// Generate JWT
        '//----------------------------

            '// Header section
            header = jwtGetHeader()

            '// Payoad section
            Set oJSON = new aspJSON
            With oJSON.data
                .Add "iat", UTC.timestamp()
                .Add "exp", UTC.timestamp(86400)
                .Add "user", oJSON.Collection()
                With oJSON.data("user")
                    .Add "id", id
                    .Add "email", email
                End With
            End With
            payload = oJSON.JSONoutput()
            Set oJSON = Nothing

            '// Create JWT
            token = jwtGetToken(payload, header, jwtKey)
            verify = jwtVerifyToken(token, jwtKey)

            '// Save JWT to Cookies
            If verify = True Then
                Session("LoggedIn") = True
                Response.Cookies("token") = token
                Response.Cookies("token").Expires = DateAdd("d", 1, Now())
            Else
                Session("LoggedIn") = False
                ErrorMsg = "Failed to Verify Access Token"
            End If

        ElseIf Len(dbEmail) >= 1 Or process = "login" Then
            '// Email exists already

            hashedPassword = Hash(password, dbSalt)
            If hashedPassword = dbPassword Then

            '//----------------------------
            '// Generate JWT
            '//----------------------------

                '// Header section
                header = jwtGetHeader()

                '// Create payload as object
                Set oJSON = new aspJSON
                With oJSON.data
                    .Add "iat", UTC.timestamp()
                    .Add "exp", UTC.timestamp(86400)
                    .Add "user", oJSON.Collection()
                    With oJSON.data("user")
                        .Add "id", dbID
                        .Add "email", dbEmail
                    End With
                End With
                payload = oJSON.JSONoutput()
                Set oJSON = Nothing

                '// Create JWT
                token = jwtGetToken(payload, header, jwtKey)
                verify = jwtVerifyToken(token, jwtKey)

                ' '// If verified, Save JWT to Cookies
                If verify = True Then
                    Session("LoggedIn") = True
                    Response.Cookies("token") = token
                    Response.Cookies("token").Expires = DateAdd("d", 1, Now())
                Else
                    Session("LoggedIn") = False
                End If
            Else
                '// Otherwise return error
                ErrorMsg = "Invalid Credentials : Not Found"
            End If
        End If
    Else
        '// Display plain forms
    End If

%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Roboto:100,300,400,500&display=swap" rel="stylesheet">

    <!-- Bootstrap -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css"
        integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css"
        integrity="sha384-oS3vJWv+0UjzBfQzYUhtDYW+Pj2yciDJxpsK1OYPAYjqT085Qq/1cq5FLXAZQ7Ay" crossorigin="anonymous">

    <title>Password Hashing</title>
    <link rel="icon" type="image/x-icon" href="favicon.ico" />

    <style>
        * {
            font-family: 'Roboto', sans-serif;
        }

        .help-block {
            font-size: 0.7rem;
        }

        @media (max-width: 400px) {
            .help-block {
                font-size: 0.7rem;
            }
        }
    </style>
</head>

<body>
    <div class="container">

        <h2>SHA256 Password Hashing</h2>
        <hr />
        <% If Session("LoggedIn") = False Then %>
        <!-- Login or Register -->
        <div id="alerts">
        <% If Len(ErrorMsg) >= 1 Then %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Error: </strong> <% =ErrorMsg %>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        <% End If %>
        </div>
        <div class="row">
            <div class="col mb-5">
                <form id="login" class="form-horizontal" action="#" method="POST">
                    <fieldset>
                        <legend class="">Login</legend>
                        <div class="form-group">
                            <!-- E-mail -->
                            <label for="l_email">E-mail</label>
                            <input type="email" autocomplete="username email" id="l_email" name="email" placeholder=""
                                class="form-control input-xlarge">
                            <p class="help-block">Please provide your E-mail</p>
                        </div>

                        <div class="form-group">
                            <!-- Password-->
                            <label for="l_password">Password</label>
                            <input type="password" autocomplete="new-password" id="l_password" name="password"
                                placeholder="" class="form-control input-xlarge">
                            <p class="help-block">Password should be at least 8 characters</p>
                        </div>

                        <div class="form-group">
                            <!-- Button -->
                            <button class="btn btn-success">Login</button>
                        </div>

                        <input type="hidden" name="form" value="login" />

                    </fieldset>
                </form>
            </div>
            <div class="col-sm-hidden col-md-2">&nbsp;</div>
            <div class="col-sm-12 col-md-5 mb-5">
                <form id="register" class="form-horizontal" action="#" method="POST">
                    <fieldset>
                        <legend class="">Register</legend>
                        <div class="form-group">
                            <!-- E-mail -->
                            <label for="r_email">E-mail</label>
                            <input type="email" autocomplete="username email" id="r_email" name="email" placeholder=""
                                class="form-control input-xlarge">
                            <p class="help-block">Please provide your E-mail</p>
                        </div>

                        <div class="form-group">
                            <!-- Password-->
                            <label for="r_password">Password</label>
                            <input type="password" autocomplete="new-password" id="r_password" name="password"
                                placeholder="" class="form-control input-xlarge">
                            <p class="help-block">Password should be at least 8 characters</p>
                        </div>

                        <div class="form-group">
                            <!-- Password -->
                            <label for="r_password_confirm">Password (Confirm)</label>
                            <input type="password" autocomplete="new-password" id="r_password_confirm" placeholder=""
                                class="form-control input-xlarge">
                            <p class="help-block">Please confirm password</p>
                        </div>

                        <div class="form-group">
                            <!-- Button -->
                            <button class="btn btn-success">Register</button>
                        </div>

                        <input type="hidden" name="form" value="register" />

                    </fieldset>
                </form>
            </div>
        </div>
        <% Else '// Logged in %>
            <h3>Welcome: <% =email %><h3>
            <form method="post">
                <label for="logout"><small>Not <% =email%>?</small></label>
                <input id="logout" name="logout" type="submit" class="btn btn-dark btn-large" value="Login in as New user" />
            </form>
        <% End If %>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
        crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"
        integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ"
        crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"
        integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm"
        crossorigin="anonymous"></script>

    <script src="./scripts/form-validation.js"></script>
</body>

</html>
<%
    Function ValidateEmail(email)
        pattern = "^[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]@[\w-\.]*[a-zA-Z0-9]\.[a-zA-Z]{2,7}$"
        ValidateEmail = RegExTest(email, pattern)
    End Function

    Function ValidatePassword(password)
        If Len(password) < 8 Then : ValidatePassword = False : Exit Function
        If Len(RegExReplace(password, "[^0-9]", "")) = 0 Then : ValidatePassword = False : Exit Function
        If Len(RegExReplace(password, "[^a-z]", "")) = 0 Then : ValidatePassword = False : Exit Function
        If Len(RegExReplace(password, "[^A-Z]", "")) = 0 Then : ValidatePassword = False : Exit Function
        If Len(RegExReplace(password, "[a-zA-Z0-9]", "")) = 0 Then : ValidatePassword = False : Exit Function
        ValidatePassword = True
    End Function
%>
<!-- #include virtual="./includes/dbClose.asp" -->