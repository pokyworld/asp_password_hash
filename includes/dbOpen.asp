<%
    Const adOpenDynamic = 2
    Const adLockOptimistic = 3

    Set dbConn = Server.CreateObject ("ADODB.Connection")
    dbConn.Open strConn

    Set dbCmd = Server.CreateObject ("ADODB.Command")
    dbCmd.ActiveConnection = dbConn
    dbCmd.CommandType = &H0001

%>