#!/usr/local/bin/perl
#
# Author: Russ Wright, Lawrence Berkeley National Laboratory December 1997
#
# This will look at the $trafficDir directory for MRTG generated HTML
# files, parse them and generate a listing of the most active interfaces
# in a file called "active.htlm" in the same directory
#
# modify this if you wish as long as the above credit is not removed
#
# The only weird thing I do is to skip tunnel interfaces (see code below)

#
# TWO VARIABLES YOU MUST CHANGE
#
##$trafficDir="/usr/ns-home/htdocs/traffic";
#
# I put it in a file and include it because I use it in other scripts
# if you don't - comment this out and uncomment the above line
require "trafficdir.include";

# CHANGE THIS to your organization name
$orgName="LBNL";

$outFile = "$trafficDir/active.html";

# The following may be changed and I admit that it isn't perfect how I decide
# to highlight stuff.
#
# if over this value, will bold entry
$highlightThresh = 15;
# if max is over this value, will bold entry
$highlightMaxThresh = 40;
# Refresh interval (minutes) for HTML doc
$refreshInt=10;
#
$refreshSeconds=60*$refreshInt;
#
# Max % to look at (if the Max is lower then we do not include in the list)
$maxThresh = 5;
$theDate=`date +"%m/%d/%y %H:%M"`;

open(LS, "ls $trafficDir/*.[0-9]*.html|") || die "Couldn't list directory";
while (<LS>) {
        chop;
        $theFile = $_;
        open(IN, "$theFile") || die "Couldn't open $theFile\n";
        $i=0;
        while (<IN>) {
                if (/Traffic Analysis for .*[0-9]<BR>(.*)<\/H1> <TABLE>/) {
                        if ($1 =~ /tunnel/i) {
# skip tunnels
                                last;
                        }
                        $desc{$theFile} = $1;
                }
                if (/\(([0-9.]*\%)\)/) {
                        $theList{$theFile}[$i++] = $1;
                }
        }
        close(IN);
}
close(LS);

#
#
# the array contains all the percentages: the following 6 for
#               daily, weekly, monthly, yearly
#
# 0 Max In
# 1 Avg In
# 2 Cur In
# 3 Max Out
# 4 Avg Out
# 5 Cur Out
#
#

open(OUT, ">$outFile") || die "Couldn't create $outFile";
&PrintHead;

foreach $key (keys %theList) {
# get sum of both max in and out
        $sumInOut = $theList{$key}[0] + $theList{$key}[4];
        if ( ($sumInOut > $maxThresh) ||
            ($curIn > $highlightThresh) ||
            ($curOut > $highlightThresh) ||
            ($avgIn > $highlightThresh) ||
            ($avgOut > $highlightThresh) ) {
                $printList{$key} = $sumInOut;
        }
}


foreach $key (sort by_percent (keys %printList)) {
        $theRouter = $key;
        $theRouter =~ s/.*\///;
        $theRouter =~ s/\.html//;
        $theFile = $key;
        $theFile =~ s/.*traffic\///;
        $maxIn= $theList{$key}[0];
        $avgIn= $theList{$key}[1];
        $curIn= $theList{$key}[2];
        $maxOut= $theList{$key}[3];
        $avgOut= $theList{$key}[4];
        $curOut= $theList{$key}[5];
        if ($maxIn > $highlightMaxThresh) {
                $maxIn= "<FONT COLOR=\"#FF0000\">$maxIn</FONT>";
        }
        if ($maxOut > $highlightMaxThresh) {
                $maxOut= "<FONT COLOR=\"#FF0000\">$maxOut</FONT>";
        }
        if ($curOut > $highlightThresh) {
                $curOut= "<FONT COLOR=\"#FF0000\">$curOut</FONT>";
        }
        if ($curIn > $highlightThresh) {
                $curIn= "<FONT COLOR=\"#FF0000\">$curIn</FONT>";
        }
        if ($avgIn > $highlightThresh) {
                $avgIn= "<FONT COLOR=\"#FF0000\">$avgIn</FONT>";
        }
        if ($avgOut > $highlightThresh) {
                $avgOut= "<FONT COLOR=\"#FF0000\">$avgOut</FONT>";
        }

        printf(OUT "<TR><TD><CENTER>$maxIn</CENTER></TD><TD><CENTER><P>$maxOut<
/CENTER></TD><TD><CENTER>$avgIn</CENTER></TD><TD><CENTER>$avgOut</CENTER></TD><
TD><CENTER>$curIn</CENTER></TD><TD><CENTER>$curOut</CENTER></TD><TD><A HREF=$th
eFile>$theRouter - $desc{$key}</A></TD></TR>\n");
}

&PrintTail;
close(OUT);

sub by_percent {
        $printList{$b} <=> $printList{$a};
}

sub PrintTail
{
print OUT <<EOF;
</TABLE>
</BODY>
</HTML>
EOF
}

sub PrintHead
{
$expTime=&expistr;

print OUT <<EOF;
<HTML>
<HEAD>
<TITLE>$orgName Most Active Subnets</TITLE>
</HEAD>
<META HTTP-EQUIV="Expires" CONTENT="$expTime">
<META HTTP-EQUIV="Refresh" CONTENT=$refreshSeconds>
<BODY bgcolor=#ffffff>
<H1>LBNL Most Active Subnets as of $theDate</H1>
<P> The following are sorted by the sum of the daily maximum input and daily ma
ximum output interface octets. This table is updated every $refreshInt minutes
and will automatically be updated if you are using Netscape.<P>
<B>Note</B>: Tunnels are not included in this list<P>
Values are in
<FONT COLOR="#FF0000">RED</FONT>
if the current or average is above $highlightThresh or if
the maximum value is over $highlightMaxThresh
<P>
<TABLE WIDTH="750" BORDER="1" CELLSPACING="2" CELLPADDING="0" HEIGHT="43">
<TR>
<TH >In Max %</TH>
<TH >Out Max %</TH>
<TH >In Avg %</TH>
<TH >Out Avg %</TH>
<TH >In Current %</TH>
<TH >Out Current %</TH>
<TH >Interface</TH></TR>
EOF
}

sub expistr {
  my ($time) = time+$refreshInt*60+5;
  my ($wday) = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat')[(gmtime($time))[6]];
  my ($month) = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep',
                 'Oct','Nov','Dec')[(gmtime($time))[4]];
  my ($mday,$year,$hour,$min,$sec) = (gmtime($time))[3,5,2,1,0];
  if ($mday<10) {$mday = "0$mday"};
  if ($hour<10) {$hour = "0$hour"};
  if ($min<10) {$min = "0$min";}
  if ($sec<10) {$sec = "0$sec";}
  return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
}

