<%@ language="vbscript" %>
<!-- #include virtual="./lib/aspJSON1.17.asp" -->
<!-- #include virtual="./includes/dbOpen.asp" -->
<!-- #include virtual="./includes/passwords.asp" -->
<!-- #include virtual="./includes/functions.asp" -->
<%
    If Request.Form.Count >= 1 Then

        Process = Trim(Request.Form("form"))
        email = Trim(Request.Form("email") & "")
        password = Trim(Request.Form("password") & "")
        validEmail = ValidateEmail(email)
        validPassword = ValidatePassword(password)
        
        Response.Write "Valid Email Format (" & email & ") : " & validEmail & "<br/>"
        Response.Write "Valid Password Format (" & password & ") : " & validPassword  & "<br/>"

        '// Check whether user exists with that Username
        sql = "SELECT * FROM user WHERE email = '" & email & "' ORDER BY id DESC LIMIT 1;"
        Set RS = dbConn.Execute(sql)
        If Not RS.EOF Then
            dbId = CLng(RS("id")&"")
            dbEmail = RS("email")&""
            dbSalt = RS("salt")&""
            dbPassword = RS("password")&""
            Response.Write "Email : FOUND<br/>"
        Else
            Response.Write "Email : NOT FOUND<br/>"
        End If
        RS.Close
        Set RS = Nothing

        If Process = "register" And validEmail = True And validPassword = True And dbEmail = "" Then

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

            '// Record the User as Logged In

            '// Save JWT to Cookies

        ElseIf Len(dbEmail) >= 1 Then
            '// Email exists already
            Response.Write "Process : " & process & "<br/>"
            hashedPassword = Hash(password, dbSalt)
            If hashedPassword = dbPassword Then
                '// If hash of new password matches, then login
                Response.Write "Password Matches: PASS - LOGIN<br/>"
            Else
                '// Otherwise return error
                Response.Write "Password Matches: FAIL - ERROR<br/>"

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
        <div id="alerts"></div>
        <div class="row">

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
            <div class="col-sm-hidden col-md-2">&nbsp;</div>
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
        </div>
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