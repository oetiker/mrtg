<% @LANGUAGE="VBSCRIPT"        %>
<% Response.Expires = 0        %>
<% Server.ScriptTimeout = 1200 %>
<!-- #INCLUDE FILE="monitor.inc" -->
<%
  If ID = "" Then
    Response.Redirect(NoAuthURL)
  End If

  ' We only execute this code if the user actually submitted the configuration form from the page.
  If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
  
    ' Get the values that he or she entered at the configuration page.
    Password = Request.Form("Password")                    ' The circuit password.
    NewPassword = Request.Form("NewPassword")              ' Change password.
    NewConfirmedPassword = Request.Form("ConfirmPassword") ' Change password confirmation.
    EMail = Request.Form("TechEMail")                      ' Technical E-Mail address.
    Graph_Daily = Request.Form("Daily_Graph")              ' Display Daily Graphs.
    Graph_Weekly = Request.Form("Weekly_Graph")            ' Display Weekly Grahps.
    Graph_Monthly = Request.Form("Monthly_Graph")          ' Dispaly Monthly Graphs.
    Graph_Yearly =  Request.Form("Yearly_Graph")           ' Display Yearly Graphs.

    ' Check Graph_Daily
    If Graph_Daily = "" Then
      Graph_Daily = 0
    Else
      Graph_Daily = 1
    End If
    
    ' Check Graph_Weekly
    If Graph_Weekly = "" Then
      Graph_Weekly = 0
    Else
      Graph_Weekly = 1
    End If
    
    ' Check Graph_Monthly
    If Graph_Monthly = "" Then
      Graph_Monthly = 0
    Else
      Graph_Monthly = 1
    End If
    
    ' Check Graph_Yearly
    If Graph_Yearly = "" Then
      Graph_Yearly = 0
    Else
      Graph_Yearly = 1
    End If
    
    ' Did the user enter his or her password?
    If Password = "" Then                                  ' We dont have a password!
      Error = "Please Enter Your Password"
    End If

    ' Now that we have the password, compare in in the database...
    set rsPassword = DBConn.Execute("SELECT LinePassword FROM Monitor_Authenticate WHERE ID=" & ID)
    
    TempPass = rsPassword("LinePassword")                  ' Get the password in the database.

    rsPassword.close                                       ' Close the lookup record.
    Set rsPassword = Nothing
        
    If Password <> TempPass Then                           ' The password did not match the database.
      Error = "Invalid Password"
    End If

    If NewPassword <> "" Then                              ' Compare the NewPassword with the 
                                                           ' ConfirmedPassword...
      If NewPassword <> NewConfirmedPassword Then          ' The two password do not match.
        Error="Your Passwords Did Not Match"
      Else
        Password = NewPassword                             ' Set the new password to be updated in the
                                                           ' database.
      End If
    End If


    If Error = "" Then                                     ' If we do not have a error, everything is
                                                           ' well, lets update the records.

      If ID <> 1 Then                                      ' ID 1 is the guest account, dont update the
                                                           ' database.
        set rsUpdate = DBConn.Execute("UPDATE Monitor_Authenticate SET LinePassword='" & Password & "', " &_
                                                                       "EMail_Address='" & EMail & "', " &_
                                                                       "Graph_Day=" & Graph_Daily & ", " &_
                                                                       "Graph_Week=" & Graph_Weekly & ", " &_
                                                                       "Graph_Month=" & Graph_Monthly & ", " &_
                                                                       "Graph_Year=" & Graph_Yearly &_
                                                                       " WHERE (ID=" & ID & ")")

        Set rsUpdate = nothing                               ' Database update successfull.

      End If    

      ' Update Session information...
      Session("DBLinePassword") = Password                 ' Update the password for the session.
      Session("DBEMail_Address") = EMail                   ' Update the E-Mail for the session.
      If Graph_Daily = 1 Then                              ' Daily Graph
        Session("DBGraph_Day") = True
      Else
        Session("DBGraph_Day") = False
      End If
      If Graph_Weekly = 1 Then                             ' Weekly Graph
        Session("DBGraph_Week") = True
      Else
        Session("DBGraph_Week") = False
      End If
      If Graph_Monthly = 1 Then                            ' Monthly Graph
        Session("DBGraph_Month") = True
      Else
        Session("DBGraph_Month") = False
      End If
      If Graph_Yearly = 1 Then                             ' Yearly Graph
        Session("DBGraph_Year") = True
      Else
        Session("DBGraph_Year") = False
      End If
      
      Response.Redirect(MonitorURL)                        ' Everything is updated, go back to
                                                           ' monitor.
    End If
    
  End If   
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta http-equiv="Cache-Control" content="No Cache">
<meta http-equiv="Pragma" content="No Cache">
<meta http-equiv="Expires" content="0">
<link rel="StyleSheet" href="global/main.css" type="text/css">
<style type="text/css">
<!--
a:link       { color: #003399 }
a:visited    { color: #003399 }
a:hover      { color: red }
-->
</style>
</head>
<body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" onload="Clock()">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
 <tr>
  <td valign="top">
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
   <tr>
    <td valign="top" align="left"><font size="1"><img src="/images/spacer.gif" width="53" height="22" alt></font></td>
    <td valign="top" align="left" width="100%">
    <p class="HEADING"><span class="HEADING">Monitor Configuration For Circuit Number: <%= LineNumber %></span></td>
   </tr>
   <tr>
    <td valign="middle" align="left" colspan="2"><font size="1"><img border="0" src="/images/spacer.gif" width="110" height="19"><a href="default.asp?mode=logout">Logout
    of Monitor</a><img border="0" src="/images/spacer.gif" width="25" height="19"><a href="login.asp">Bandwidth Details</a></font></td>
   </tr>
  </table>
  <hr>
  <div align="left">
   <table border="0" cellpadding="2" cellspacing="0">
    <tr>
     <td valign="top" align="left"><font size="1">Circuit Number:</font></td>
     <td valign="top" align="left"><font size="1"><%= LineNumber %></font></td>
     <td valign="top" align="left"><font size="1"><img border="0" src="/images/spacer.gif" width="10" height="10"></font></td>
     <td valign="top" align="left"><font size="1">Circuit Speed:</font></td>
     <td valign="top" align="left"><font size="1"><%= LineSpeed %> <i>bps</i></font></td>
     <td valign="top" align="left"><font size="1"><img border="0" src="/images/spacer.gif" width="10" height="10"></font></td>
     <td valign="top" align="left"><font size="1">Technical Contact:</font></td>
     <td><a href="mailto:<%= EMail_Address %>"><font size="1"><%= EMail_Address %></font></a></td>
    </tr>
    <tr>
     <td colspan="8" valign="top" align="left"><font size="1">You Last Visited Monitor On: <%= LastVisit %></font></td>
    </tr>
   </table>
  </div>
  <hr>
  <%' Do we have a error that the user needs to know about?
  If Error <> "" Then %>
  <p class="COLUMNRED"><font size="1"><%= Error %></font></p>
  <% End If %>

  <p><font size="1">Please take note, for your changes to take affect, you must enter your password in the first password field.&nbsp; If you wish to change your
  password, you may then also complete the &quot;New Password&quot; and &quot;Confirm Password&quot; fields.</p>
  <form action="/config.asp" method="POST">
   <div align="left">
    <table border="0" cellpadding="2" cellspacing="1" width="822">
     <tr>
      <td align="right" valign="top" width="210"><font size="1">Your Password:</font></td>
      <td valign="top" width="106"><font size="1"><input type="password" name="Password" size="20" class="INPUT"></font></td>
     </font>
     <td valign="middle">
     <p class="COLUMNRED">Required For <b>ANY</b> changes to be made</td>
    </tr>
    <font size="1">
    <tr>
     <td align="right" valign="top" width="210"><font size="1">Change Your Password:</font></td>
     <td valign="top" width="106"><font size="1"><input type="password" name="NewPassword" size="20" class="INPUT"></font></td>
     <td valign="middle"><font size="1">New Password</font></td>
    </tr>
    <tr>
     <td align="right" valign="top" width="210"><font size="1">&nbsp;</font></td>
     <td valign="top" width="106"><font size="1"><input type="password" name="ConfirmPassword" size="20" class="INPUT"></font></td>
     <td valign="middle"><font size="1">Confirm Password</font></td>
    </tr>
    <tr>
     <td align="right" valign="top" width="210"><font size="1">Technical Contact E-Mail Address:</font></td>
     <td valign="top" width="106"><font size="1"><input type="text" name="TechEMail" size="20" value="<%= EMail_Address %>" class="INPUT"></font></td>
    </tr>
    <tr>
     <td align="right" valign="top" width="210"><font size="1">Show The Daily Graph:</font></td>
     <td valign="top" width="106"><font size="1"><input type="checkbox" name="Daily_Graph" value="1" <% if graph_day = true then%>checked <% end if%>></font></td>
     <td valign="top"></td>
    </tr>
    <tr>
     <td align="right" valign="top" width="210"><font size="1">Show The Weekly Graph:</font></td>
     <td valign="top" width="106"><font size="1"><input type="checkbox" name="Weekly_Graph" value="1" <% if graph_week = true then %>checked<% end if %>></font></td>
     <td valign="top"></td>
    </tr>
    <tr>
     <td align="right" valign="top" width="210"><font size="1">Show The Monthly Graph:</font></td>
     <td valign="top" width="106"><font size="1"><input type="checkbox" name="Monthly_Graph" value="1" <% if graph_month = true then %>checked<% end if %>></font></td>
     <td valign="top"></td>
    </tr>
    <tr>
     <td align="right" valign="top" width="210"><font size="1">Show The Yearly Graph:</font></td>
     <td valign="top" width="106"><font size="1"><input type="checkbox" name="Yearly_Graph" value="1" <% if graph_year = true then %>checked<% end if %>></font></td>
     <td valign="top"></td>
    </tr>
    <tr>
     <td align="center" valign="top" colspan="2" width="322">
     <p align="center"><input type="submit" value="Update Configuration" name="UPDATE" class="BUTTON"></td>
     <td valign="top"></td>
    </tr>
      </form>
    </table>
   </div>
   <hr>
  </font></td>
  </tr>
 </table>
 <table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr>
   <td>
   <div align="left">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
     <tr>
      <td colspan="2" valign="top" align="center">
      <p align="center"><font size="1"><b>©2000 <a href="mailto:cgknipe@mweb.co.za">Chris Knipe</a>.&nbsp; All Rights Reserved.</b></font></td>
     </tr>
     <tr>
      <td valign="top" align="right"><br>
      <img border="0" src="images/msie.gif" width="88" height="31"><img border="0" src="images/msprod.gif" width="88" height="31"><img border="0" src="images/spacer.gif" width="5" height="10"></td>
      <td width="100%" valign="top" align="left">&nbsp;
      <table border="0" cellspacing="0" cellpadding="0">
       <tr>
        <td width="63"><a href="http://ee-staff.ethz.ch/~oetiker/webtools/mrtg/mrtg.html"><img alt border="0" src="http://monitor.internal.sunnyline.co.za/images/mrtg-l.gif" width="63" height="25"></a></td>
        <td width="25"><a href="http://ee-staff.ethz.ch/~oetiker/webtools/mrtg/mrtg.html"><img alt="MRTG" border="0" src="http://monitor.internal.sunnyline.co.za/images/mrtg-m.gif" width="25" height="25"></a></td>
        <td width="388"><a href="http://ee-staff.ethz.ch/~oetiker/webtools/mrtg/mrtg.html"><img alt border="0" src="http://monitor.internal.sunnyline.co.za/images/mrtg-r.gif" width="388" height="25"></a></td>
       </tr>
      </table>
        <SPACER TYPE=VERTICAL SIZE=4>
      <table border="0" cellspacing="0" cellpadding="0">
       <tr valign="top">
        <td><font face="Arial,Helvetica" size="2"><a href="http://tobi.oetiker.ch">Tobias Oetiker</a> <a href="mailto:tobi@oetiker.ch">&lt;tobi@oetiker.ch&gt;</a>
        and&nbsp;<a href="http://www.bungi.com">Dave&nbsp;Rand</a>&nbsp;<a href="mailto:dlr@bungi.com">&lt;dlr@bungi.com&gt;</a></font></td>
       </tr>
      </table>
      <p>&nbsp;</td>
     </tr>
    </table>
   </div>
   </td>
  </tr>
 </table>
</body>
</html>
