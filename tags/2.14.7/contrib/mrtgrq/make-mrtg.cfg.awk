BEGIN { 
#
# Global Variables Initialization
 mrtg_var_WorkDir = "/home/httpd/html/mrtg/mrtgrq"			# it will be inserted into MRTG config file
 mrtg_var_IconDir = "/img/"						# it will be inserted into MRTG config file and it will be used on HTML documents
 mrtg_var_Interval = "10"						# it will be inserted into MRTG config file
 mrtg_executable = "/usr/local/mrtg/mrtg"				# MRTG executable file with full path
 mrtg_mrtgrq_cfg = "/usr/local/mrtg/contrib/mrtgrq/mrtg-awk.cfg"	# MRTG config file for mrtgrq
 mrtgrq_css_file = "http://your.web.server/css/mrtg/mrtg.css"		# CSS File definition for HTML documents
 mrtgrq_maintainer_email = "Your Name &lt;your@email.address&gt;"	# Maintainer email address
#
# Start index number for array
 lines = 1
 startdate = systime()
 dataexpirarii = startdate+(mrtg_var_Interval*60)			# Expire date for HTML documents, +5 min (mrtg_var_Interval)
 dataexp = strftime("%c %Z", dataexpirarii)
 dataexpirarii = strftime("%d-%m-%Y %T %Z",dataexpirarii) 
}

{
 if ( $1 !~ /^Try/ && $1 !~ /^Conn/ && $1 !~ /^Escape/){
  array[lines, 1] = $1
  array[lines, 3] = $3
  array[lines, 4] = $4
  lines++
 }
}

END{
# 
 print ("WorkDir: " mrtg_var_WorkDir) > mrtg_mrtgrq_cfg
 print ("IconDir: " mrtg_var_IconDir) > mrtg_mrtgrq_cfg
 print ("Interval: " mrtg_var_Interval) > mrtg_mrtgrq_cfg
 print "\n\n#----------------------------------------------------------------------------\n\n" > mrtg_mrtgrq_cfg
#
##
#
 for ( k = 1; k < lines; k++ ){
#  print array[k, 1]"\t"array[k, 3]"\t"array[k, 4] > mrtg_mrtgrq_cfg
   print ("Target[" array[k, 1] "]: `echo | awk '{ print \"" array[k, 3]"\\n" array[k, 4]"\\n..., last check on: " strftime("%c %Z", startdate) "\\n" array[k, 1] "@cfrcta.ro\\n\"; exit }'`") > mrtg_mrtgrq_cfg
   print ("Title[" array[k, 1] "]: Diskspace Quota Report For " array[k, 1] "@cfrcta.ro") > mrtg_mrtgrq_cfg
   print ("MaxBytes[" array[k, 1] "]: " array[k, 4]) > mrtg_mrtgrq_cfg
   print ("AbsMax[" array[k, 1] "]: " int(array[k, 4]*1.1)) > mrtg_mrtgrq_cfg
   print ("AddHead[" array[k, 1] "]: <link rel=\"STYLESHEET\" type=\"text/css\" href=\"" mrtgrq_css_file "\">") > mrtg_mrtgrq_cfg
   print ("PageTop[" array[k, 1] "]: <H1 CLASS=\"h1\"><A HREF=\"javascript:history.back();\"><IMG SRC=\"" mrtg_var_IconDir "cubprev.gif\" BORDER=\"0\"></A> Diskspace Quota Report For &nbsp;&nbsp;&nbsp;<CODE><B>" array[k, 1] "@cfrcta.ro</B></CODE>") > mrtg_mrtgrq_cfg
   print (" </H1>") > mrtg_mrtgrq_cfg
   print (" <TABLE>") > mrtg_mrtgrq_cfg
   print ("   <TR><TD CLASS=\"ptb\">Service:</TD><TD CLASS=\"pth\"><B>Diskspace Quota</B></TD></TR>") > mrtg_mrtgrq_cfg
   print ("   <TR><TD CLASS=\"ptb\">Maintainer:</TD><TD CLASS=\"pth\"><B>" mrtgrq_maintainer_email "</B></TD></TR>") > mrtg_mrtgrq_cfg
   print ("   <TR><TD CLASS=\"ptb\">Last Checked On:</TD><TD CLASS=\"pth\"><B>" strftime("%c %Z", startdate) "</B></TD></TR>") > mrtg_mrtgrq_cfg
   print ("  </TABLE>") > mrtg_mrtgrq_cfg
   print ("Supress[" array[k, 1] "]: y") > mrtg_mrtgrq_cfg
   print ("LegendI[" array[k, 1] "]: used") > mrtg_mrtgrq_cfg
   print ("LegendO[" array[k, 1] "]: ") > mrtg_mrtgrq_cfg
   print ("Legend1[" array[k, 1] "]: used") > mrtg_mrtgrq_cfg
   print ("Legend2[" array[k, 1] "]: ") > mrtg_mrtgrq_cfg
   print ("YLegend[" array[k, 1] "]: used") > mrtg_mrtgrq_cfg
   print ("ShortLegend[" array[k, 1] "]: used") > mrtg_mrtgrq_cfg
   print ("Options[" array[k, 1] "]: gauge") > mrtg_mrtgrq_cfg
   print ("\n\n#-------------------\n\n") > mrtg_mrtgrq_cfg
 }
#
##
#
 system((mrtg_executable " " mrtg_mrtgrq_cfg " 2> /dev/null"))
#
##
#
}
