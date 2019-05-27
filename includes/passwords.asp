<%

    Function Hash(strPassword, strIndividualSalt)
        Hash = HashSHA512Managed(strSiteSalt & strPassword & strIndividualSalt)
    End Function
    
    Function HashSHA512Managed(saltedPassword)
        Dim objSHA512, objUTF8
        Dim arrByte
        Dim strHash
        Set objUnicode = CreateObject("System.Text.UnicodeEncoding")
        Set objSHA512 = Server.CreateObject("System.Security.Cryptography.SHA512Managed")
    
        arrByte = objUnicode.GetBytes_4(saltedPassword)
        strHash = objSHA512.ComputeHash_2((arrByte))
        HashSHA512Managed = ToBase64String(strHash)
    End Function
    
    Function ToBase64String(arrByte)
        Dim xml: Set xml = CreateObject("MSXML2.DOMDocument.3.0")
        xml.LoadXml ""
        Set xmlNode = xml.createElement("b64")
        xmlNode.dataType = "bin.base64"
        xmlNode.nodeTypedValue = arrByte
        ToBase64String = Replace(xmlNode.Text,vbLf, "")
    End Function
%>