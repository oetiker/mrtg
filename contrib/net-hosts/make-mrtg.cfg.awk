
BEGIN { 
#
## Global Variables Initialization (Feel you free to edit as needed)
#
#
 mrtg_var_WorkDir = "/usr/local/mrtg/contrib/net-hosts"			# it will be inserted into MRTG config file
 mrtg_var_IconDir = "http://www.your.domain/img/"			# it will be inserted into MRTG config file and it will be used on HTML documents
 mrtg_var_Interval = "5"						# it will be inserted into MRTG config file
 mrtg_executable = "/usr/local/mrtg/mrtg"				# MRTG executable file with full path
 mrtg_nethosts_cfg = "/usr/local/mrtg/contrib/net-hosts/mrtg-awk.cfg"	# MRTG config file for net-hosts
 nethosts_internet_path = "/usr/local/mrtg/contrib/net-hosts"		# the path for internet IPs file (without / at the end)
 nethosts_css_file = "http://www.your.domain/css/mrtg/net-hosts.css"	# CSS File definition for HTML documents
 nethosts_maintainer_email = "Your Name &lt;your@email.address&gt;"	# Maintainer email address
#
## Start index number for array
#
 lines = 1
 startdate = systime()
 dataexpirarii = startdate+300						# Expire date for HTML documents, +5 min (mrtg_var_Interval)
 dataexp = strftime("%c %Z", dataexpirarii)
 dataexpirarii = strftime("%d-%m-%Y %T %Z",dataexpirarii) 
 system((">" mrtg_nethosts_cfg))
}

{
#
# The state from fping for every IP is inserted into array
 state=$2$3
 ip=$1
 array[lines,1] = ip
 array[lines,2] = state
 lines++
}

END {
 close(FILENAME)
#
## Variables Definition
#
 header="<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2//EN\"> \
<HTML> \
<HEAD> \
<META HTTP-EQUIV=\"Refresh\" CONTENT=\"300\"> \
<META HTTP-EQUIV=\"Pragma\" CONTENT=\"no-cache\"> \
<META HTTP-EQUIV=\"Expires\" CONTENT=\""dataexp"\"> \
<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=iso-8859-1\"> \
<link rel=\"STYLESHEET\" type=\"text/css\" href=\"" nethosts_css_file "\"> \
<TITLE>Internet Conection Statistics Overview</TITLE> \
</HEAD> \
<BODY> \
<H1 CLASS=\"h1\"><A HREF=\"javascript:history.back();\">Main Index</A> +++ Internet Conection Statistics Overview</H1>"
 footer="<BR></BODY></HTML>"
#
 lastmod=("<CENTER><SMALL>Last modified: <FONT STYLE=\"color: darkblue;\">" strftime("%d-%m-%Y %T %Z",startdate) "</FONT>.</SMALL></CENTER>")
 expire="<CENTER><SMALL>Expire on: <FONT STYLE=\"color: darkblue;\">"dataexpirarii"</FONT>.</SMALL></CENTER>"
# 
 tablestart="<TABLE BORDER=0 WIDTH=\"100%\"> \
<TR> \
<TH CLASS=\"pth\">Index</TH> \
<TH CLASS=\"pth\">Name</TH> \
<TH CLASS=\"pth\">IP</TH> \
<TH CLASS=\"pth\">Status</TH> \
<TH CLASS=\"pth\">Last Changed On</TH> \
</TR>"
 tableend="</table><BR>"
# 
 startraw="<TR>"
 endrow="</TR>"
# 
 startcell="<TD CLASS=\"ptb\">"
 endcell="</TD>"
# 
 startlongcell="<TD CLASS=\"ptb\" COLSPAN=\"5\">"
# 
 imgdown=("<IMG SRC=\"" mrtg_var_IconDir "redball.gif\">")
 imgup=("<IMG SRC=\"" mrtg_var_IconDir "grnball.gif\">")
# 
 pstart="<P CLASS=\"ptb\">"
 pend="</P>"
#
##
# 
 print header > (mrtg_var_WorkDir "/internet.html")
 print tablestart >> (mrtg_var_WorkDir "/internet.html")
#
# 
 print ("WorkDir: " mrtg_var_WorkDir) > mrtg_nethosts_cfg
 print ("IconDir: " mrtg_var_IconDir) > mrtg_nethosts_cfg
 print ("Interval: " mrtg_var_Interval) > mrtg_nethosts_cfg
 print "\n\n#----------------------------------------------------------------------------\n\n" > mrtg_nethosts_cfg
#
##
#
 xx = 1
 kontor = 0
 succesiv = "0"
# 
## Fping results processing
#
 while ((getline line < (nethosts_internet_path "/internet")) > 0 ){
  split(line, l, ":")
  for ( i = 1 ; i < lines; i++ ){
   if ( array[i, 1] == l[1] ){
    break
   }
  }
  if ( l[4] == 1 ){
   last_state = "isalive"
  }
  else {
   last_state = "isdad"
  }
  myfun(xx, i, l[2], l[3], last_state)
  i++
  xx++
 }
 close((nethosts_internet_path "/internet"))
#
##
#
 print tableend >> (mrtg_var_WorkDir "/internet.html")
 print lastmod >> (mrtg_var_WorkDir "/internet.html")
 print expire >> (mrtg_var_WorkDir "/internet.html")
 print footer >> (mrtg_var_WorkDir "/internet.html")
#
##
#
 system(("mv -f " nethosts_internet_path "/tmpinternet " nethosts_internet_path "/internet"))
 system((mrtg_executable " " mrtg_nethosts_cfg " 2> /dev/null"))
}


function myfun(f_rindex, f_index, f_name, f_olddate, f_last_state)
{
 if( ! f_olddate ){
  f_olddate = startdate
 }
#
 if(array[f_index, 2] == "isalive"){
  statew = 1
  succesiv = "0"
  kontor = 0
  if ( f_last_state == array[f_index, 2] ) {
   datew = f_olddate
  }
  else {
   datew = startdate
  }
  print array[f_index, 1]":"f_name":"datew":"statew > (nethosts_internet_path "/tmpinternet")
  print startrow startcell f_rindex endcell > (mrtg_var_WorkDir "/internet.html")
  print (startcell "<A HREF=\"" tolower(f_name) ".html\">" f_name "</A>" endcell) > (mrtg_var_WorkDir "/internet.html")
  print startcell array[f_index, 1] endcell > (mrtg_var_WorkDir "/internet.html") 
  print startcell imgup endcell > (mrtg_var_WorkDir "/internet.html")
  print startcell strftime("%c %Z", datew) endcell > (mrtg_var_WorkDir "/internet.html") 
  print endrow > (mrtg_var_WorkDir "/internet.html")
  print "Target[" f_name "]: `echo | awk '{ print \"1\\n1\\n..., last changed on: " strftime("%c %Z", datew) "\\n" array[f_index, 1] "\\n\"; exit }'`" > mrtg_nethosts_cfg
 }
 else {
  statew = 0
  if( succesiv == "0" ){
   succesiv = "1"
  }
  kontor++
  if ( f_last_state == array[f_index, 2] ) {
   datew = f_olddate
  }
  else {
   datew = startdate
  }
  print array[f_index, 1]":"f_name":"datew":"statew > (nethosts_internet_path "/tmpinternet")
  print startrow startcell f_rindex endcell > (mrtg_var_WorkDir "/internet.html")
  print (startcell "<A HREF=\"" tolower(f_name) ".html\">" f_name "</A>" endcell) > (mrtg_var_WorkDir "/internet.html")
  print startcell array[f_index, 1] endcell > (mrtg_var_WorkDir "/internet.html") 
  print startcell imgdown endcell > (mrtg_var_WorkDir "/internet.html")
  print startcell strftime("%c %Z", datew) endcell > (mrtg_var_WorkDir "/internet.html") 
  print endrow > (mrtg_var_WorkDir "/internet.html")
  print "Target[" f_name "]: `echo | awk '{ print \"0\\n0\\n..., last changed on: " strftime("%c %Z", datew) "\\n" array[f_index, 1] "\\n\"; exit }'`" > mrtg_nethosts_cfg
 } 
  print "Title[" f_name "]: " f_name > mrtg_nethosts_cfg
  print "MaxBytes[" f_name "]: 1" > mrtg_nethosts_cfg
  print "AbsMax[" f_name "]: 1" > mrtg_nethosts_cfg
  print ("AddHead[" f_name "]: <link rel=\"STYLESHEET\" type=\"text/css\" href=\"" nethosts_css_file "\">") > mrtg_nethosts_cfg
  print ("PageTop[" f_name "]: <H1 CLASS=\"h1\"><A HREF=\"javascript:history.back();\"><IMG SRC=\"" mrtg_var_IconDir "cubprev.gif\" BORDER=\"0\"></A> Connection State for&nbsp;&nbsp;&nbsp;<CODE><B>" f_name "</B></CODE>") > mrtg_nethosts_cfg
  print " </H1>" > mrtg_nethosts_cfg
  print " <TABLE>" > mrtg_nethosts_cfg
  print "   <TR><TD CLASS=\"ptb\">System:</TD><TD CLASS=\"pth\"><B>" f_name " (" array[f_index, 1] ")</B></TD></TR>" > mrtg_nethosts_cfg
  print ("   <TR><TD CLASS=\"ptb\">Maintainer:</TD><TD CLASS=\"pth\"><B>" nethosts_maintainer_email "</B></TD></TR>") > mrtg_nethosts_cfg
  print "   <TR><TD CLASS=\"ptb\">Service:</TD><TD CLASS=\"pth\"><B>Internet Connection</B></TD></TR>" > mrtg_nethosts_cfg
  print "   <TR><TD CLASS=\"ptb\">IP:</TD><TD CLASS=\"pth\"><B>" f_name " (" array[f_index, 1] ")</B></TD></TR>" > mrtg_nethosts_cfg
  print "   <TR><TD CLASS=\"ptb\">Last Changed On:</TD><TD CLASS=\"pth\"><B>" strftime("%c %Z", datew) "</B></TD></TR>" > mrtg_nethosts_cfg
  print "  </TABLE>" > mrtg_nethosts_cfg
  print "Supress[" f_name "]: y" > mrtg_nethosts_cfg
  print "LegendI[" f_name "]: used" > mrtg_nethosts_cfg
  print "LegendO[" f_name "]: " > mrtg_nethosts_cfg
  print "Legend1[" f_name "]: used" > mrtg_nethosts_cfg
  print "Legend2[" f_name "]: " > mrtg_nethosts_cfg
  print "YLegend[" f_name "]: used" > mrtg_nethosts_cfg
  print "ShortLegend[" f_name "]: used" > mrtg_nethosts_cfg
  print "Options[" f_name "]: gauge" > mrtg_nethosts_cfg
  print "YTics[" f_name "]: 1"  > mrtg_nethosts_cfg
  print "\n\n#-------------------\n\n" > mrtg_nethosts_cfg
}


