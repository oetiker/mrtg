# ciscoindex.pl
###############################################################################
# Written 6/14/1999 by Tim Cimarusti	tim@cimware.com
#
# This PERL script will read in the MRTG config file and a Cisco router
# config file (created by the "write network" command) and create a HTML
# index for the interfaces that corresponds with MRTG.
# It sorts the output by interface type and adds descriptions,
# IP addresses, DLCI numbers, and bandwidth to the HTML.
#
###############################################################################
# usage : ciscoindex.pl <mrtg-config-file-name> <cisco-config-file-name>
#
# Note: The HTML document will be named <hostname>.html
#       where <hostname> is whatever is in the router config.
#
###############################################################################
#
# Revised 2/5/2001 - Now works with version 2.9.7 of MRTG
#
###############################################################################

$MRTGCFG = $ARGV[0];
$CiscoCFG = $ARGV[1];
&ProcessMRTGFile;
&ProcessCiscoFile;
&PrintHTML;
exit(0);

#
# Read the MRTG config file to find out the interfaces.
#
sub ProcessMRTGFile {
	open (MRTGFile, $MRTGCFG ) || die "Can't find MRTG config file. $!\n";
	while(<MRTGFile>) {
		chomp;
		if ($_ =~ /SetEnv/) {
			@a=split " ", $_;
			if ($a[0] eq "#") { next; }	# Skip commented interfaces
			$intf[$x]=substr($a[2],16,-1);	# Find the Interface name
			@c=split "]", substr($a[0],7);	# Find the name of the mrtg html page
			$num[$x]=$c[0];
			$x++;
		}
	}
	close MRTGFile;
}

#
# Read down the Cisco Router config file to find out info about each interface.
#
sub ProcessCiscoFile {
	open (CiscoFile, $CiscoCFG ) || die "Can't find Cisco config file. $!\n";
	while(<CiscoFile>) {
		chomp;
		if ($_ =~ /hostname /)   { $hostname = substr(lc,9); next;}
		if ($_ eq "no ip address") { next; }
		if ($_ eq "!") { $found="n"; }
		if ($_ =~ /interface /) {
			@x=split " ", $_;
			for ($i=0; $i <= $#num; $i++) {
				if ($x[1] eq $intf[$i]) { $found = "y"; last;}
			}
		}

		if ($found eq "y") {
		   if ($_ =~ /description/)    { $description[$i] = substr($_,13); }
		   if ($_ =~ /bandwidth/)      { @x=split " ", $_; $bandwidth[$i] = $x[1]; }
		   if ($_ =~ /interface-dlci/) { @x=split " ", $_; $dlci[$i] = $x[2]; }
		   if ($_ =~ /ip address/)     { @x=split " ", $_; $ipaddress[$i] = $x[2]; }
		}
	}
	close CiscoFile;
}

#
# Create a HTML document.
#
sub PrintHTML {
	# Change this to whatever directory you use for serving up the files
	$mrtgdir="/mrtg/$hostname/";

	$HTMLOut = $hostname.".html";
	open (HTMLFile, ">$HTMLOut") || die "Couldn't create HTMLOUT file. $!\n";

	# use binmode on UNIX servers
	binmode HTMLFile;

	print HTMLFile "<html>\n";
	print HTMLFile "<!-- Created by ciscoindex.pl : Visit www.cimware.com --->\n";
	print HTMLFile "<head><title>".$hostname.": Summary of today's activity</title>\n";
	print HTMLFile "<meta name='keywords' content='$hostname, MRTG'></head>\n";
	print HTMLFile "<body bgcolor=ffffff>\n";
	print HTMLFile "<h1>".$hostname."</h1>\n";
	print HTMLFile "<hr>\n\n";
#	print HTMLFile "<a href=".$mrtgdir.$hostname.".cpu.html><b>CPU</b></a><br>\n";
#	print HTMLFile "  <blockquote><font size=-1><i>\n";
#	print HTMLFile "  <a href=".$mrtgdir.$hostname.".cpu.html><img border=0 src=".$mrtgdir.$hostname.".cpu-day.png></a>\n";
#	print HTMLFile "</i></font></blockquote><hr>\n\n";
	print HTMLFile "\n";

	# I like to sort my interfaces.
	for ($i=0; $i <= $#num; $i++) { if (substr($intf[$i],0,4) eq "Fddi") { &PrintRecord; } }
	for ($i=0; $i <= $#num; $i++) { if (substr($intf[$i],0,12) eq "FastEthernet") { &PrintRecord; } }
	for ($i=0; $i <= $#num; $i++) { if (substr($intf[$i],0,8) eq "Ethernet") { &PrintRecord; } }
	for ($i=0; $i <= $#num; $i++) { if (substr($intf[$i],0,9) eq "TokenRing") { &PrintRecord; } }

	for ($i=0; $i <= $#num; $i++) { if (substr($intf[$i],0,7) eq "Serial0") { &PrintRecord; } }
	for ($i=0; $i <= $#num; $i++) { if (substr($intf[$i],0,7) eq "Serial1") { &PrintRecord; } }
	for ($i=0; $i <= $#num; $i++) { if (substr($intf[$i],0,7) eq "Serial2") { &PrintRecord; } }
	for ($i=0; $i <= $#num; $i++) { if (substr($intf[$i],0,7) eq "Serial3") { &PrintRecord; } }
	for ($i=0; $i <= $#num; $i++) { if (substr($intf[$i],0,7) eq "Serial4") { &PrintRecord; } }
	for ($i=0; $i <= $#num; $i++) { if (substr($intf[$i],0,7) eq "Serial5") { &PrintRecord; } }
	for ($i=0; $i <= $#num; $i++) { if (substr($intf[$i],0,7) eq "Serial6") { &PrintRecord; } }
	for ($i=0; $i <= $#num; $i++) { if (substr($intf[$i],0,7) eq "Serial7") { &PrintRecord; } }
	for ($i=0; $i <= $#num; $i++) { if (substr($intf[$i],0,7) eq "Serial8") { &PrintRecord; } }
	for ($i=0; $i <= $#num; $i++) { if (substr($intf[$i],0,7) eq "Serial9") { &PrintRecord; } }

	print HTMLFile "</body>\n";
	print HTMLFile "</html>\n";
	close (HTMLOut);
}

# Print section for each record.
sub PrintRecord {
	print HTMLFile "<a href=".$mrtgdir.$num[$i].".html><b>".$intf[$i]."</b></a><br>\n";
	print HTMLFile "  <blockquote><font size=-1><i>\n";
    if ($description[$i] ne "") { print HTMLFile "    Description : ".$description[$i]."<br>\n"; }
	if ($ipaddress[$i] ne "") { print HTMLFile "    IP Address  : ".$ipaddress[$i]."<br>\n"; }
	if ($bandwidth[$i] ne "") { print HTMLFile "    Bandwidth   : ".$bandwidth[$i]."<br>\n"; }
	if ($dlci[$i] ne "") { print HTMLFile "    DLCI        : ".$dlci[$i]."<br>\n"; }
	print HTMLFile "  <a href=".$mrtgdir.$num[$i].".html><img border=0 src=".$mrtgdir.$num[$i]."-day.png></a>\n";
	print HTMLFile "</i></font></blockquote><p>\n\n";
	print HTMLFile "\n";
}
