<%@ LANGUAGE="VBSCRIPT" %>
<html>

<head>
<meta NAME="GENERATOR" Content="Microsoft FrontPage 3.0">
<meta HTTP-EQUIV="Content-Type" content="text/html; charset=iso-8859-1">
<title>MRTG DATA</title>
</head>

<body bgcolor="#FFFFFF" text="#000000" link="#0000FF" vlink="#0000FF" alink="#0000FF">

<h1>Your-Router-Name_here</h1>
<h3>Ports on Router</h3>
<%
	Set fs = CreateObject("Scripting.FileSystemObject")
    Dim fs, f, f1, fc, fstr, linklen, bufflink
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set f = fs.GetFolder("e:\inetpub\wwwroot\mrtg\pages\Your-Router-Name_here")
    Set fc = f.Files
    For Each f1 in fc
		fstr = LCase(f1.name)
		If Right(fstr, 8) = "-day.gif"  Then
		linklen = Len(fstr)
		buffLink = Mid(fstr,1,(linklen - 8))
			
			Response.Write ("<table><tr><td>")	
					
			Response.Write("<a href=" & buffLink & ".html>") 
			Response.Write ("<img src=" & f1.name & " border=0> ")
			Response.write ("</td><td>")
			Response.write (bufflink & "<br>")
			Response.Write VbCrLf 
			Response.write "</td></tr></table>" & VbCrLf
		End If
    Next
%>        
</body>
</html>
