<% @LANGUAGE="VBSCRIPT"        %>
<% Response.Expires = 0        %>
<% Server.ScriptTimeout = 1200 %>
<!-- #INCLUDE FILE="monitor.inc" -->
<%
  If ID = "" Then                                               ' The Session Expired
    Response.Redirect(NoAuthURL)
  End If

  Set fs = CreateObject("Scripting.FileSystemObject")           ' FileSystemObject to copy graphs

  fs.CopyFile "c:\mrtg\targets\" & LineNumber & "-*.gif", "c:\InetPub\monitor.sunnyline.co.za\images\mrtg\"
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta http-equiv="Cache-Control" content="No Cache">
<meta http-equiv="Pragma" content="No Cache">
<meta http-equiv="Expires" content="0">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
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
    <td valign="top" align="left"><font size="1"><img src="images/spacer.gif" width="53" height="22" alt></font></td>
    <td valign="top" align="left" width="100%">
    <p class="HEADING"><span class="HEADING">Bandwidth Statistics For Circuit Number: <%= LineNumber %></span></td>
   </tr>
   <tr>
    <td valign="middle" align="left" colspan="2"><font size="1"><img border="0" src="images/spacer.gif" width="110" height="19"><a href="default.asp?mode=logout">Logout
    of Monitor</a><img border="0" src="images/spacer.gif" width="25" height="19"><a href="/config.asp">Configure Monitor</a></font></td>
   </tr>
  </table>
  <hr>
  <div align="left">
   <table border="0" cellpadding="2" cellspacing="0">
    <tr>
     <td valign="top" align="left"><font size="1">Circuit Number:</font></td>
     <td valign="top" align="left"><font size="1"><%= LineNumber %></font></td>
     <td valign="top" align="left"><font size="1"><img border="0" src="images/spacer.gif" width="10" height="10"></font></td>
     <td valign="top" align="left"><font size="1">Circuit Speed:</font></td>
     <td valign="top" align="left"><font size="1"><%= LineSpeed %> <i>bps</i></font></td>
     <td valign="top" align="left"><font size="1"><img border="0" src="images/spacer.gif" width="10" height="10"></font></td>
     <td valign="top" align="left"><font size="1">Technical Contact:</font></td>
     <td><a href="mailto:<%= EMail_Address %>"><font size="1"><%= EMail_Address %></font></a></td>
    </tr>
    <tr>
     <td colspan="8" valign="top" align="left"><font size="1">You Last Visited Monitor On: <%= LastVisit %></font></td>
    </tr>
   </table>
  </div>
  <hr>
  <% If Graph_Day = True Then %>
  <table border="0" cellpadding="0" cellspacing="0">
   <tr>
    <td valign="top">
    <p class="SEARCH" align="right"><font size="1"><b>Daily Graph<br>
    <img border="0" src="images/spacer.gif" height="10" width="100"></b></font></p>
    </td>
    <td valign="top"><font size="1"><img src="images/spacer.gif" width="10">Shows Your Bandwidth Usage Over the last&nbsp; 24 Hours</font></td>
   </tr>
   <tr>
    <td></td>
    <td><font size="1"><img src="/images/mrtg/<%= LineNumber%>-day.gif" alt="Daily Bandwidth Graph" width="380" height="130"></font></td>
   </tr>
  </table>
  <p>&nbsp;</p>
  <hr>
  <% End If %>
  <% If Graph_Week = True Then %>
  <table border="0" cellpadding="0" cellspacing="0">
   <tr>
    <td valign="top">
    <p class="SEARCH" align="right"><font size="1"><b>Weekly Graph<br>
    <img border="0" src="images/spacer.gif" height="10" width="100"></b></font></p>
    </td>
    <td valign="top"><font size="1"><img src="images/spacer.gif" width="10">Shows Your Bandwidth Usage Over the Last 7 Days</font></td>
   </tr>
   <tr>
    <td></td>
    <td><font size="1"><img src="/images/mrtg/<%= LineNumber%>-week.gif" alt="Weekly Bandwidth Graph" width="380" height="130"></font></td>
   </tr>
  </table>
  <p><font size="1"><br>
  </font></p>
  <hr>
  <% End If %>
  <% If Graph_Month = True Then %>
  <table border="0" cellpadding="0" cellspacing="0">
   <tr>
    <td valign="top">
    <p class="SEARCH" align="right"><font size="1"><b>Monthly Graph<br>
    <img border="0" src="images/spacer.gif" height="10" width="100"></b></font></p>
    </td>
    <td valign="top"><font size="1"><img src="images/spacer.gif" width="10">Shows Your Bandwidth Usage Over The Last Month</font></td>
   </tr>
   <tr>
    <td></td>
    <td><font size="1"><img src="/images/mrtg/<%= LineNumber%>-month.gif" alt="Monthly Bandwidth Graph" width="380" height="130"></font></td>
   </tr>
  </table>
  <p>&nbsp;</p>
  <hr>
  <% End If %>
  <% If Graph_Year = True Then %>
  <table border="0" cellpadding="0" cellspacing="0">
   <tr>
    <td valign="top">
    <p class="SEARCH" align="right"><font size="1"><b>Yearly Graph<br>
    <img border="0" src="images/spacer.gif" height="10" width="100"></b></font></p>
    </td>
    <td valign="top"><font size="1"><img src="images/spacer.gif" width="10">Shows Your Bandwidth Usage Over The Last Year</font></td>
   </tr>
   <tr>
    <td></td>
    <td><font size="1"><img src="/images/mrtg/<%= LineNumber%>-year.gif" alt="Yearly Bandwidth Graph" width="380" height="130"></font></td>
   </tr>
  </table>
  <p>&nbsp;</p>
  <hr>
  <% End If %>
  </td>
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
       <td><font face="Arial,Helvetica" size="2"><a href="http://ee-staff.ethz.ch/~oetiker">Tobias Oetiker</a> <a href="mailto:oetiker@ee.ethz.ch">&lt;oetiker@ee.ethz.ch&gt;</a>
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
