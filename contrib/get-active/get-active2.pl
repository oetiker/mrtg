#!/usr/bin/perl
#
# Author: Russ Wright, Lawrence Berkeley National Laboratory December 1997
# Local modifications by Wee-Meng Lee  HP Singapore (colour/lynx)
#    and Mark Mushkin  HP Santa Clara  (avg/max/min that suit our needs)
#  Last Update on  Oct 14, 1997
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
$trafficDir="/usr/local/httpd/htdocs";
#
# I put it in a file and include it because I use it in other scripts
# if you don't - comment this out and uncomment the above line
#require "trafficdir.include";

# CHANGE THIS to your organization name
$orgName="HP Singapore - IT Site Infrastructure";

$outFile = "$trafficDir/active.html";

# The following may be changed and I admit that it isn't perfect how I decide
# to highlight stuff.
#

#values over this will be displayed in the specified color
#  these are for the MAX values
$maxAMBER = 70;
$maxRED = 90;
# these are for the Average and Current values
$AMBER = 30;
$RED = 60;

#Defining the colors
$REDcolor="#ff0000";
$AMBERcolor="#ffff00";
$GREENcolor="#00ff00";

# Refresh interval (minutes) for HTML doc
$refreshInt=10;
#
$refreshSeconds=60*$refreshInt;
#
# Max % to look at (if the Max is lower then we do not include in the list)
#$maxThresh = 5;
$maxThresh = 0;
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
#        $sumInOut = $theList{$key}[0] + $theList{$key}[4]; # use for max
         $sumInOut = $theList{$key}[1] + $theList{$key}[4]; # use for avg
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

        printf(OUT "<TR>");

        if ($maxIn > $maxRED) {
                printf(OUT "<TD BGCOLOR=$REDcolor><CENTER>$maxIn</CENTER></TD>");
        } elsif ($maxIn > $maxAMBER) {
                printf(OUT "<TD BGCOLOR=$AMBERcolor><CENTER>$maxIn</CENTER></TD>");
        } else {
                printf(OUT "<TD BGCOLOR=$GREENcolor><CENTER>$maxIn</CENTER></TD>");
        }
        printf(OUT "    ");

        if ($maxOut > $maxRED) {
                printf(OUT "<TD BGCOLOR=$REDcolor><CENTER>$maxOut</CENTER></TD>");
        } elsif ($maxOut > $maxAMBER) {
                printf(OUT "<TD BGCOLOR=$AMBERcolor><CENTER>$maxOut</CENTER></TD>");
        } else {
                printf(OUT "<TD BGCOLOR=$GREENcolor><CENTER>$maxOut</CENTER></TD>");
        }
        printf(OUT "    ");

        if ($avgIn > $RED) {
                printf(OUT "<TD BGCOLOR=$REDcolor><CENTER>$avgIn</CENTER></TD>");
        } elsif ($avgIn > $AMBER) {
                printf(OUT "<TD BGCOLOR=$AMBERcolor><CENTER>$avgIn</CENTER></TD>");
        } else {
                printf(OUT "<TD BGCOLOR=$GREENcolor><CENTER>$avgIn</CENTER></TD>");
        }
        printf(OUT "    ");

        if ($avgOut > $RED) {
                printf(OUT "<TD BGCOLOR=$REDcolor><CENTER>$avgOut</CENTER></TD>");
        } elsif ($avgOut > $AMBER) {
                printf(OUT "<TD BGCOLOR=$AMBERcolor><CENTER>$avgOut</CENTER></TD>");
        } else {
                printf(OUT "<TD BGCOLOR=$GREENcolor><CENTER>$avgOut</CENTER></TD>");
        }
        printf(OUT "    ");

        if ($curIn > $RED) {
                printf(OUT "<TD BGCOLOR=$REDcolor><CENTER>$curIn</CENTER></TD>");
        } elsif ($curIn > $AMBER) {
                printf(OUT "<TD BGCOLOR=$AMBERcolor><CENTER>$curIn</CENTER></TD>");
        } else {
                printf(OUT "<TD BGCOLOR=$GREENcolor><CENTER>$curIn</CENTER></TD>");
        }
        printf(OUT "    ");

        if ($curOut > $RED) {
                printf(OUT "<TD BGCOLOR=$REDcolor><CENTER>$curOut</CENTER></TD>");
        } elsif ($curOut > $AMBER) {
                printf(OUT "<TD BGCOLOR=$AMBERcolor><CENTER>$curOut</CENTER></TD>");
        } else {
                printf(OUT "<TD BGCOLOR=$GREENcolor><CENTER>$curOut</CENTER></TD>");
        }
        printf(OUT "    ");

        printf(OUT "<TD><A HREF=${theRouter}\.html>$theRouter</A></TD></TR><p>\n");

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
<TITLE>$orgName Most Active Interface</TITLE>
</HEAD>
<META HTTP-EQUIV="Expires" CONTENT="$expTime">
<META HTTP-EQUIV="Refresh" CONTENT=$refreshSeconds>
<BODY bgcolor=#ffffff>
<H1>Most Active Interfaces as of $theDate</H1>
<P> The following are sorted by the sum of the daily average input
and daily average output (In Avg% + Out Avg%) interface octets. 
This table is updated every $refreshInt minutes and will automatically 
be updated if you are using Netscape.<P>

<B>Value ranges: </B><P>
MAX Values are: <FONT COLOR="#ff0000">RED if \> $maxRED </font>, and 
<B>YELLOW if \> $maxAMBER </font></B><P>
<P>
Average & Current Values are: <FONT COLOR="#ff0000">RED if \> $RED </font>, and <B>YELLOW if \> $AMBER </font></B><P>
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
<P>
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
