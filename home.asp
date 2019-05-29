<%@ language="vbscript" %>
<!-- #include virtual="./lib/dbOpen.asp" -->
<!-- #include virtual="./lib/functions.asp" -->
<% 
    ErrorMsg = "" 
%>
<!-- #include virtual="./includes/token-auto-login.asp" -->

<%
    '// Initial state settings
    If Request.Form.Count = 0 Then 
        ' Session("LoggedIn") = True
        nickname = "SilveradoCruz"
        Response.Write("Logged In : " & Session("LoggedIn") & "<hr/>") 
    End If

    If Len(Trim(Request.Form("logout"))) >= 1 Then : LogoutUser()

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

    <title>Home Page with Modal Login</title>
    <link rel="icon" type="image/x-icon" href="favicon.ico" />

</head>

<body>
    <div class="container">
        <header>
            <nav class="navbar navbar-expand-lg navbar-light bg-light">
                <button class="navbar-toggler" type="button" data-toggle="collapse"
                    data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false"
                    aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <a class="navbar-brand" href="#">Navbar</a>
                <button id="authModalShow" class="btn btn-light d-block d-md-none" data-toggle="modal"
                    data-target="#authModal" type="button">
                    <i class=" fas fa-sign-in-alt "></i>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav mr-auto">
                        <li class="nav-item active">
                            <a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">Link</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">Link</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">Link</a>
                        </li>
                    </ul>
                    <ul class="navbar-nav ml-auto">
                        <% If Session("LoggedIn") = False Then %>
                        <li class="nav-item active">
                            <a class="nav-link" href="#" data-toggle="modal"
                    data-target="#authModal">Login<span class="sr-only">(current)</span></a>
                        </li>
                        <% Else %>
                        <li class="nav-item">
                            <a class="nav-link disabled"href="#">Welcome: <% =nickname %></a>
                            

                        </li>
                        <li class="nav-item">
                            <form class="nav-item" method="post">
                                <input id="logout" name="logout" type="submit" class="btn btn-light" value="Logout" />
                            </form>
                        </li>
                        <% End If %>
                    </ul>
                </div>
            </nav>
        </header>

        <main-content>
            <h2>Home Page with Modal Login</h2>
            <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Molestias nobis esse ipsam quia eligendi hic.
                Quibusdam odio hic, debitis, quod laudantium similique voluptatum pariatur nesciunt obcaecati voluptate
                adipisci laboriosam aliquam?</p>
            <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Molestias nobis esse ipsam quia eligendi hic.
                Quibusdam odio hic, debitis, quod laudantium similique voluptatum pariatur nesciunt obcaecati voluptate
                adipisci laboriosam aliquam?</p>
        </main-content>

        <footer>
        </footer>


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

<!-- #include virtual="./includes/auth-modal.asp" -->
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
<!-- #include virtual="./lib/dbClose.asp" -->