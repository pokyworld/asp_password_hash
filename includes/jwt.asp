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

function jwtGetPayload(token) {
    var tokenArray = token.split(".");
    if (tokenArray) {
        var payload = base64_decode(tokenArray[1]);
        return payload;
    }
    return false;
}
</script>
