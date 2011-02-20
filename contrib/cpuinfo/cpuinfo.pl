#!/usr/bin/perl

# ============================================================================
# CPU Usage script for mrtg
#
#    File: 	cpuinfo.pl
#    Author: 	Matthew Schumacher | schu@schu.net
#    Version: 	1.3	
#
#    Date:	8/17/2000	
#    Purpose:   This script reports CPU usage for user
#		and system to mrtg, along with uptime 
#		and the machine's hostname.
#
#    Usage:	./cpuinfo.pl [machine] [os]
#
#		For now [os] can only be "sun" or "linux"		
#
#
#    Info:	Designed on RedHat linux 6.2 with perl
#		version 5.005_03.  The script itself has
#		only been tested on Linux, however, it 
#		has been tested to connect to, and graph
#		CPU usage on sun and linux.  
#			
#		This script requires both sar and rsh to 
#		be installed and working.  Because linux
#		does not come with sar (mine didn't) it
#		may be necessary to download and install
#		it.  Get sar here: 
#
#	 	ftp://metalab.unc.edu/pub/Linux/system/status/sysstat-3.2.4.tar.gz	
#    
#		How it works:
#		
#		The script uses rsh (or ssh)  to run sar on the the
#		remote machine.  Sar samples the cpu time
#		for both user and system once per second
#		for 10 seconds.  It then reports an average
#		to the script, which parses out the information
#		and formats it in a way mrtg can understand.
#		The script also runs uptime to get the machine's
#		uptime and passes it to mrtg.
#		
#
#    [History]
#
#              1/4/2000  -  Added support for different rsh programs.
#              I also made the default rsh program ssh for security
#              reasons.
#
#	       3/9/2000 -  Removed the default os because it seemed 
#	       redundant.  Added code to support localhost as a machine
#              name.
#
#              8/17/2000 - Updated sar regex for sar command.  Sorry
#              for not keeping up with the email, I had some email
#              issues then finnaly I got my own domain and changed it
#              to schu@schu.net.
#
# ============================================================================
# Sample cfg:
#
# WorkDir: /home/httpd/html/mrtg
# Target[machine]: `/home/mrtg/run/cpuinfo.pl localhost linux`
# MaxBytes[machine]: 100
# Options[machine]: gauge, nopercent
# Unscaled[machine]: dwym
# YLegend[machine]: % of CPU used
# ShortLegend[machine]: %
# LegendO[machine]: &nbsp;CPU System:
# LegendI[machine]: &nbsp;CPU User:
# Title[machine]: Machine name
# PageTop[machine]: <H1>CPU usage for machine (schu's workstation)
#  </H1>
#  <TABLE>
#    <TR><TD>System:</TD><TD>Machine</TD></TR>
#   </TABLE>
#
# ============================================================================
# setup local vars
my($machine, $os);

# ============================================================================
# == Enter your rsh program here here ==

$rsh = "/usr/local/bin/ssh -x";		# Enter your rsh command here

# == You shouldn't need to edit anything below this line ==
#========================================================

# This checks for options passed cpuinfo.pl from the cmd line 
if (scalar(@ARGV) < 2) 
   {
   print("USAGE: cpuinfo.pl {machine} {os}\n");
   exit(-1);
   }     

if ($ARGV[0] ne '' && $ARGV[0] ne '#')
   {
   $machine = $ARGV[0];
   }

if ($ARGV[1] ne '' && $ARGV[1] ne '#')
   {
   $os = $ARGV[1];
   }

# Validate the os
SWITCH: 
{
  if ($os =~ /^sun$/){last SWITCH;}
  if ($os =~ /^linux$/){last SWITCH;}

  # DEFAULT: Die if we can't figure out what the os is 
  die "Can't figure out which OS the machine is.\n";
}

# Execute the appropriate subroutine based on the os
&$os;

exit(0);

#=======================================================
# Subroutines: names of subroutines are supported OSs.
#========================================================
sub sun
  {

   # Run commands
   if ($machine =~ 'localhost') 
   {
   $getcpu = `sar -u 1 10 | grep Average`;
   $getuptime = `uptime`;
   }
   else
   {
   $getcpu = `$rsh $machine "sar -u 1 10" | grep Average`;
   $getuptime = `$rsh $machine "uptime"`;
   }
 
   # Parse though getcpu and get data
   $getcpu =~ /^Average\s+(\d+)\s+(\d+)\s+/;
   $outputusr = $1;
   $outputsys = $2;

   # Print getcpu data for mrtg
   print $outputusr."\n";
   print $outputsys."\n";

   # Parse though getuptime and get data
   $getuptime =~ /^\s+\d{1,2}:\d{2}..\s+up\s+(\d+)\s+(......),/;

   # Print getuptime data for mrtg
   print $1." ".$2."\n"; 

   # Print machine name for mrtg
   print $machine."\n";

  }

sub linux
  {
   # Run commands
   if ($machine =~ 'localhost')
   {
   $getcpu = `/usr/local/bin/sar -u 1 10 | grep Average`;
   $getuptime = `/usr/bin/uptime`;
   }
   else
   {
   $getcpu = `$rsh $machine "/usr/local/bin/sar -u 1 10 | grep Average"`;
   $getuptime = `$rsh $machine "/usr/bin/uptime"`;
   }

   # Parse though getcpu and get data
   $getcpu =~ /^Average:\s+all\s+(\d+)\.\d+\s+\d+\.\d+\s+(\d+)\.\d+\s+\d+\.\d+/;  
   $getcpuusr = $1;
   $getcpusys = $2;

   # Print getcpu data for mrtg
   print $getcpuusr."\n";
   print $getcpusys."\n";

   # Parse though getuptime and get data
   $getuptime =~ /^\s+\d{1,2}:\d{2}..\s+up\s+(\d+)\s+(\w+),/;

   # Print getuptime data for mrtg
   print $1." ".$2."\n";

   # Print machine name for mrtg
   print $machine."\n";

  }
exit(0);
