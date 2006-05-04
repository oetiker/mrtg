#!/usr/local/bin/perl
# version 1.1, 27.06.97, philippe.simonet@swisstelecom.com

$outFile = 'distrib.html';
$mode = 'd';
$title = 'Mrtg Trafic Distribution';
$width = 300; $height = 160;
$count = 8;
$period = 'day';

$refreshInt=120; $refreshSeconds = $refreshInt * 60;
$theDate=localtime(time);

###########################################################
# read config files 
$i = 0;
open(CFG, "mrtg.cfg") || die "Couldn't read mrtg.cfg";
while (<CFG>) {
	$_ =~ tr/A-Z/a-z/;

	if (/^maxbytes\[(.*)\]: (\d*).*/i) {
		$maxbytes{$1} = $2;
		#print $maxbytes{$1};
	}

	if (/^pagetop\[(.*)\]: (.*)/i) {
		$pagetop{$1} = $2;
		#print $pagetop{$1}, "\n";
	}
}
close (CFG);

foreach $i ( keys %pagetop ) {
	next if ($maxbytes{$i} eq undef);
	next if ($pagetop{$i} eq undef);

	for ($j = 0; $j < $count; $j++ ) {
		$distr{$i}[$j][0] = 0;
		$distr{$i}[$j][1] = 0;
		$tot{$i} = 0;
	}

	open ( PIPE, "distrib -i $i.log -o $i.dist.$mode.gif -t $mode -w $width -h $height -r $maxbytes{$i} -d $count |" );
	while ( <PIPE> ) {
		if ( /(\d*):(\d*),(\d*).*/ ) {
			$distr{$i}[$1][0] = $2;
			$distr{$i}[$1][1] = $3;
		}
	}

	for ($j = 0; $j < $count; $j++ ) {
		$tot{$i} += ($j+1) * ($distr{$i}[$j][0] + $distr{$i}[$j][1]);
	}

	close ( PIPE );
}


###########################################################
# open files
open(OUT, ">$outFile") || die "Couldn't create $outFile";
open(SCORE, ">distrib.txt") || die "Couldn't create distrib.txt";

###########################################################
# print html head
$expTime=&expistr;

print OUT <<EOF;
<HTML>
<HEAD>
<TITLE>$title</TITLE>
</HEAD>
<META HTTP-EQUIV="Expires" CONTENT="$expTime">
<META HTTP-EQUIV="Refresh" CONTENT=$refreshSeconds>
<BODY bgcolor=#ffffff>
<H1>$title ($theDate)</H1> 

These graphs presents the trafic distribution information for last $period, based on data collected each 5 minutes by MRTG. </p>
They are refreshed each $refreshInt minutes. (green = input traffic, blue = output).
Darker is the color, bigger is the trafic. Bigger is the rectangle, bigger is the time when the traffic was effective.

<H1>Top 10 interfaces for last $period</H1>
<img src="distrib.gif">

<H1>All trafic distribution for last $period</H1>

Vertical scale: % of time/</P>
Horizontal scale: % of Maxbyte</P>

<table border="1" cellpadding="0" height="43">
    <tr>
        <th>maxbytes</th>
        <th>pagetop</th>
        <th>target</th>
        <th>URL</th>
    </tr>
EOF

foreach $i ( sort by_number (keys %pagetop) ) {
	next if ($maxbytes{$i} eq undef);
	next if ($pagetop{$i} eq undef);

	print SCORE "$i:";
	for ($j=0; $j < ($count-1); $j++) {
		print SCORE $distr{$i}[$j][0], "/", $distr{$i}[$j][1], ",";
	}
	print SCORE $distr{$i}[$count-1][0], "/", $distr{$i}[$count-1][1], "\n";

print OUT <<EOF;
<TR>
 <TD><CENTER>$maxbytes{$i}</CENTER></TD>
 <TD><CENTER>$pagetop{$i} $pc $post</CENTER></TD>
 <TD><CENTER>$i, score $tot{$i}</CENTER></TD>
 <TD><A HREF="$i.html"><img src="$i.dist.$mode.gif"></A></TD>
</TR>
EOF
}

print OUT <<EOF;
</TABLE>
</BODY>
</HTML>
EOF

close(OUT);
close(SCORE);

# computes top 10 lines distribution (-r 10)
`distrib -i distrib.txt -o distrib.gif -t x -w 700 -h 300 -d $count -r 10`;

exit (0);

# expiration time & date ########################################
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

# for sorting ########################################
sub by_number {
        $tot{$b} <=> $tot{$a};
}
