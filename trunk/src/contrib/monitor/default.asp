<% @LANGUAGE="VBSCRIPT"        %>
<% Response.Expires = 0        %>
<% Server.ScriptTimeout = 1200 %>
<% On Error Resume Next        %>
<!-- #INCLUDE FILE="monitor.inc" -->
<%
  ' Check if we have to log out... 
  If Request.QueryString("mode") = "logout" Then
    ' Update the circuit access date
    ' Get the record ID to update
    LineID = Session("DBID")

    If LineID = "" Then      ' The Session Expired
      Response.Redirect(LogOutURL)
    End If
    
    Set rsAuthenticate = DBConn.Execute("UPDATE Monitor_Authenticate SET LastVisit='" &_
                                           Month(Date()) & "/" & Day(Date()) & "/" &_
                                           Year(Date()) & " " & Time &"' WHERE (ID=" & LineID & ")")
    Session.Abandon
    Response.Redirect(LogOutURL)
  End If

' Status is a universal indicator implemented to show us which part of the authentication process is
'  failing.
' For now, Status has the following values.
'  0)  No errors, everything was successfull.
'  1)  Circuit number not found in the database.
'  2)  The given password did not match for the circuit number.
'  3)  We are logged out and should redirect back to SunnyLine

' We only execute this code if the user actually submitted the login form from the page.
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
  
  ' Get the values that he or she entered at the login page.
  Number = Request.Form("Number")
  Password = Request.Form("Password")

  ' Setup a default error code.  We use a incorrect circuit number here.
  Status = 1

  ' Did The User Enter a circuit number & password?
  If Number = "" Then
    Status = 1  ' No circuit number
  Elseif Password = "" Then
    Status = 2  ' No password
  Else
    Status = 0  ' We have a circuit number & password, lets continue.
  End If
  
  ' If we have both circuit number and password, compare it to the database.
  If Status = 0 Then
		
    ' Pull the circuit number from the database.
    Set rsAuthenticate = DBConn.Execute("SELECT * FROM Monitor_Authenticate WHERE LineNumber=" & Number)
 
    Do While not rsAuthenticate.EOF

      ' We need to give DBPassword an initial value.  If for instance, a client enteres a circuit 
      '  number which is not located in the database, the lookup will fail and DBPassword won't have a 
      '  value for us to compare to.  The Rnd Function should be secure enough?
      DBPassword = Rnd(10)
      DBID = rsAuthenticate("ID")
      DBLine = rsAuthenticate("LineNumber")
      DBPassword = rsAuthenticate("LinePassword")
      DBSpeed = rsAuthenticate("LineSpeed")
      DBEMail = rsAuthenticate("EMail_Address")
      DBG_Day = rsAuthenticate("Graph_Day")
      DBG_Week = rsAuthenticate("Graph_Week")
      DBG_Month = rsAuthenticate("Graph_Month")
      DBG_Year = rsAuthenticate("Graph_Year")
      DBG_EMail = rsAuthenticate("Graph_EMail")
      DBDate = rsAuthenticate("LastVisit")

      If DBPassword = Password Then

        ' We got what we wanted, close the database connection...  Just for incase.
        rsAuthenticate.close
        Set rsAuthenticate = nothing

        ' We setup the values inside the session before or after we move into monitor.
        ' This is just so that we don't have to do the entire lookup process again at displaying the graps to the user, if
        ' we save the values now, we are able to reference any setting in the DataBase that we would need at any given time.
        Session("DBID") = DBID
        Session("DBLineNumber") = DBLine
        Session("DBLinePassword") = DBPassword
        Session("DBLineSpeed") = DBSpeed
        Session("DBEMail_Address") = DBEMail
        Session("DBGraph_Day") = DBG_Day
        Session("DBGraph_Week") = DBG_Week
        Session("DBGraph_Month") = DBG_Month
        Session("DBGraph_Year") = DBG_Year
        Session("DBGraph_EMail") = DBG_EMail
        Session("DBLastVisit") = DBDate

        ' And we redirect !!
        Response.Redirect(MonitorURL)

      Else

        ' Passwords didnt match.  We are not going to worry about incorrect circuit numbers, that
        '  will just make it easier for someone to maybe guess a line number if he or she has 
        '  nothing better to do!
        Status = 2
      End If
      
      rsAuthenticate.MoveNext

    Loop
     
    '  If we are here, there was serious error.  This means perhaps a incorrect curciut number and or
    '   incorrect password.  In any case, the lookup did fail, and we have no reference what so ever to the given value for 
    '   the circuit number or password.  Close the database and send the user back to the login section.
    rsAuthenticate.close
    Set rsAuthenticate = nothing
  End If   

End If
%>
<html>
<head>
<meta http-equiv="Content-Language" content="en-za">
<meta http-equiv="Cache-Control" content="No Cache">
<meta http-equiv="Pragma" content="No Cache">
<meta http-equiv="Expires" content="0">
<title>Welcome To Monitor!!</title>
<link rel="StyleSheet" href="global/default.css" type="text/css">
<link rel="StyleSheet" href="global/additional.css" type="text/css">
</head>

<body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" onload="Clock()">
<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td valign="top">

<table border="0" cellpadding="0" cellspacing="0" width="100%">
 <tr>
  <td valign="top" align="left"><font size="1"><img src="images/spacer.gif" width="53" height="52" alt></font></td>
  <td valign="top" align="left" width="100%">
  <h1><span class="HEADING"><font face="Verdana,Arial,Helvetica" size="1">Welcome to Monitor.SunnyLine.co.za</font></span></h1>
  </td>
 </tr>
</table>

<p><font size="1">Congratulations on the purchase of your high-speed permanent connections to the Internet.&nbsp; Please take a moment and log on to our monitoring system
to see you bandwidth usage.</font></p>

<p><font size="1">Your Circuit number will be the number printed on your Data Unit installed by Telkom (The small black box where your NTU or Modem plugs into).&nbsp; If
you have any problems locating your Circuit number, or have problems authenticating with this service, please contact us for immediate assistance at <a href="mailto:support@sunnyline.co.za">support@sunnyline.co.za</a></font></p>

<p><font size="1">Wondering what is Monitor! Well, don't worry, read up all about monitor by clicking <a href="/monitor.html">here</a>.</p>
<form method="POST" action="default.asp">
 <div align="center">
  <center>
  <table border="0" cellpadding="2" cellspacing="1">
   <tr>
    <td>
    <div align="right">
     <p><font size="1">Circuit Number:</font>
    </div>
    </td>
    <td><font size="1"><input type="text" name="Number" size="20" value="<%= Number %>"></font></td>
    <td>
    <div align="left">
     <p><b><font color="#FF0000" size="1"><% If Status = 1 Then
                                             Response.Write ("Invalid Circuit Number!!!")
                                           End If %></font></b>
    </div>
    </td>
   </tr>
   <tr>
    <td>
    <div align="right">
     <p><font size="1">Your Password:</font>
    </div>
    </td>
    <td><font size="1"><input type="password" name="Password" size="20" maxlength="8"></font></td>
    <td>
    <div align="left">

     <p><b><font color="#FF0000" size="1"><% If Status = 2 Then
                                             Response.Write ("Invalid Password!!!")
                                           End If %></font></b>
    </div>
    </td>
   </tr>
   <tr>
    <td colspan="2" align="center"><font size="1"><input type="submit" value="Submit" class="BUTTON"></font></td>
    <td></td>
   </tr>
  </table>
  </center>
 </div>
</form>

&nbsp;
<div align="center">
 <center>
 <table border="0" cellpadding="0" cellspacing="0">
  <tr>
   <td colspan="2">
   <p class="Greenhead" align="center"><font size="1">Guest Users:</font></td>
  </tr>
  <tr>
   <td align="right"><font size="1">Please log in with Circuit Number:&nbsp;</font></td>
   <td align="left"><font size="1"><b>1234567890</b></font></td>
  </tr>
  <tr>
   <td align="right"><font size="1">and Password:&nbsp;</font></td>
   <td align="left"><font size="1"><b>12345678</b></font></td>
  </tr>
  <tr>
   <td align="left" colspan="2">
   <p align="center"><font size="1">to see a demo of this service right now.</font></td>
  </tr>
 </table>
 </center>
</div>
&nbsp;</font>

</td></tr></table>
<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td>

<div align="left">
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
      <td colspan="2" valign="top" align="center">
        <p align="center"><font size="1"><b>©2000 SunnyLine Internet Services.&nbsp; All Rights Reserved.</b></font></td>
    </tr>
    <tr>
      <td valign="top" align="right"><br>
        <img border="0" src="images/msie.gif" width="88" height="31"><img border="0" src="images/msprod.gif" width="88" height="31"><img border="0" src="images/spacer.gif" width="5" height="10"></td>
      <td width="100%" valign="top" align="left">&nbsp;
        <table border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="63"><a href="http://ee-staff.ethz.ch/~oetiker/webtools/mrtg/mrtg.html"><img alt border="0" src="/images/mrtg-l.gif" width="63" height="25"></a></td>
            <td width="25"><a href="http://ee-staff.ethz.ch/~oetiker/webtools/mrtg/mrtg.html"><img alt="MRTG" border="0" src="/images/mrtg-m.gif" width="25" height="25"></a></td>
            <td width="388"><a href="http://ee-staff.ethz.ch/~oetiker/webtools/mrtg/mrtg.html"><img alt border="0" src="/images/mrtg-r.gif" width="388" height="25"></a></td>
          </tr>
        </table>
        <SPACER TYPE=VERTICAL SIZE=4>
        <table border="0" cellspacing="0" cellpadding="0">
          <tr valign="top">
            <td><font face="Arial,Helvetica" size="2"><a href="http://ee-staff.ethz.ch/~oetiker">Tobias Oetiker</a> <a href="mailto:oetiker@ee.ethz.ch">&lt;oetiker@ee.ethz.ch&gt;</a>
              and&nbsp;<a href="http://www.bungi.com">Dave&nbsp;Rand</a>&nbsp;<a href="mailto:dlr@bungi.com">&lt;dlr@bungi.com&gt;</a></font></td>
          </tr>
        </table>
        <p>&nbsp;</td>
    </tr>
  </table>
</div>

</td></tr>
</table></body>

</html>
