#!/usr/bin/perl
#
# byte counter for a Equinox SST card with analog modem pool
# for use with mrtg2
#
# by Mike Gaertner <mg@forum.org.kh>
# 20 Apr 2000
#
# Returns the total sum of the input and output character counter 
# from an SST card for all ports you specify 
#
# NEEDS the Linux driver version 3-35c for SST based boards
#
# --- sample.cfg file ---
#  #MaxBytes = (8 x 56kbit/s modems) / 8 = 56000 bytes/s total capacity
#  #           adjust this to the number of modems you have
#
#  Target[modems]: `/usr/local/mlog3/bin/mrtg/get-equi.pl`
#  MaxBytes[modems]: 56000
#  Title[modems]: OFIX modem pool traffic (8 Modems)
#  Options[modems]: growright
#  XSize[modems]: 500
#  YSize[modems]: 200
#  WithPeak[modems]: my
#  PageTop[modems]: <H1>Traffic Analysis modem pool (8 Modems)</H1>
# -------
#
# Edit the @m array 
# @m = Modems you want to monitor without ttyQ
#
# check the $sstty path
#

use strict;

my(@m,$sstty,$port,$i,$o,$new_i,$new_o,$source);

# modems
@m = ("1a5","1a6","1a7","1a8","1a9","1a10","1a11","1a12") ;

$sstty = "/usr/bin/sstty -s ";
$source = "equinox modempool";

$new_i = 0;
$new_o = 0;

foreach $port ( @m ) {

	open ( STAT, "$sstty $port |" ) ;
	while( <STAT> ) {
                if ( /input/ ) {
			($i,$o) = (split(/ +/))[8,11] ;
			$new_i += hex($i);
			$new_o += hex($o);
                }
	}
	close(STAT);
}

print $new_i,"\n",$new_o,"\n",&uptime(),"\n$source\n"  ;

#find out when the board driver was last loaded
sub uptime {

    my($start,$now,$diff,$s,$m,$h,$d,$hms);
    $start = (stat("/etc/eqnx/logfile"))[10] ;
    $now = time() ;
    $diff = $now - $start ;

    $s = $diff % 60;
    $diff = ($diff - $s) / 60;
    $m = $diff % 60;
    $diff = ($diff - $m) / 60;
    $h = $diff % 24;
    $diff = ($diff - $h) / 24;
    $d = $diff ;
    
    $hms.= ($h < 10 ? " " : "") . $h;
    $hms.= ($m < 10 ? ":0" : ":") . $m;
    $hms.= ($s < 10 ? ":0" : ":") . $s;
    return "$d days, $hms";
}

