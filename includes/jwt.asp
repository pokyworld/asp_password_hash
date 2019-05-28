<!-- #include virtual="./lib/jwt.all.asp" -->
<%

Function jwtGetHeader()
    Set oJSON = new aspJSON
    With oJSON.data
        .Add "alg", "HS256"
        .Add "typ", "JWT"
    End With
    header = oJSON.JSONoutput()
    Set oJSON = Nothing
    jwtGetHeader = header
End Function

%>

<script language="javascript" runat="server">

function jwtGetToken(payload, header, jwtKey){
    var token = new jwt.WebToken(payload, header);
    var signed = token.serialize(jwtKey);
    return signed;
}

function jwtVerifyToken(sh256Token, jwtKey) {
    // var x = [127, 205, 206, 39, 112, 246, 196, 93, 65, 131, 203, 238, 111, 219, 75, 123, 88, 7, 51, 53, 123, 233, 239, 19, 186, 207, 110, 60, 123, 209, 84, 69];
    // var y = [199, 241, 68, 205, 27, 189, 155, 126, 135, 44, 223, 237, 185, 238, 185, 244, 179, 105, 93, 110, 169, 11, 36, 173, 138, 70, 35, 40, 133, 136, 229, 173];
    
    var token = jwt.WebTokenParser.parse(sh256Token);
    // token.verify(x, y);
    return token.verify(jwtKey);
    // return token;
}

function jwtGetPayload(token) {
    var tokenArray = token.split(".");
    if (tokenArray) {
        var payload = base64_decode(tokenArray[1]);
        return payload;
    }
    return false;
}
</script>
