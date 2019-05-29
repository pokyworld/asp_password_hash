<%
    If IsObject(dbConn) = True Then : dbConn.Close
    If IsObject(dbCmd) = True Then : Set dbCmd = Nothing
    If IsObject(dbConn) = True Then : Set dbConn = Nothing
%>