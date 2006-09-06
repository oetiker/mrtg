<%
  ' Create ADO connection component to connect with our SQL database.
  Set DBConn = Server.CreateObject("ADODB.Connection")
  DBConn.Open "DSN=SunnyLine"

  ' Redirection URLs used.
  LogOutURL = "/default.asp"                        ' The URL we redirect to when someone logs out of montior.
  MonitorURL = "/login.asp"                         ' The URL we redirect to after a successfull circuit number has been identified.
  NoAuthURL = "/default.asp"                        ' The URL we redirect to when we don't have a database ID for the account anymore.

  ' The session Details
  ID = Session("DBID")                              ' DataBase Entry ID.
  LineNumber = Session("DBLINENUMBER")              ' Circuit Number.
  LinePassword = Session("DBLINEPASSWORD")          ' Circuit Password.
  LineSpeed = Session("DBLINESPEED")                ' Circuit Speed.
  EMail_Address = Session("DBEMAIL_ADDRESS")        ' Contact E-Mail Address.
  Graph_Day = Session("DBGRAPH_DAY")                ' Daily Graphs.
  Graph_Week = Session("DBGRAPH_WEEK")              ' Weekly Graphs.
  Graph_Month = Session("DBGRAPH_MONTH")            ' Monthly Graphs.
  Graph_Year = Session("DBGRAPH_YEAR")              ' Yearly Graphs.
  LastVisit = Session("DBLASTVISIT")                ' Last Time Visited.
%>