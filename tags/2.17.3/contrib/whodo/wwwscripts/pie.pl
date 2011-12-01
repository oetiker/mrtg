#	pie.pl
#
# CGI script to generate a pie graph (GIF) showing WAN traffic broken down by
# source or destination.
# This script is currently invoked via CGI by analyse.pl
#
# Modification History
######################
# v1.0	   Oct 98	Tony Farr	Original coding
# v2.0	17 Nov 98	Tony Farr	Change to CGI script. Split out analyse as separate script.
# v2.1	23/12/98	Tony Farr	Add description of period to top of graph
##############################################################################

use strict;
use File::Basename;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use GIFgraph::pie;
use GD;

my ($period, $field, $str, $summarise);

my $LOGPATH= "D:\\logs\\whodo";			# Directory where csv/logs are stored.

my $q = new CGI;

if ($q->param('src_duration')) {		# Show sources
	$period= $q->param('src_duration');
	$str= $q->param('dest');
	$field= 1;
} else {								# Show destinations
	$period= $q->param('dest_duration');
	$str= $q->param('src');
	$field= 2;
}

$summarise= $q->param('summarise');
my ($end, @flist)= get_input_files($period, $LOGPATH);

my $trafficref= get_traffic($str, $summarise, $field, @flist);
print $q->header('image/gif');
make_graph($period, $end, $trafficref, "-");
exit 0;



sub get_input_files {
# Returns a list of input files to be processed
	my($period, $path)= @_;
	my(@retvals, $fname, $lastfname, $start, $end);
	if ($period ne "30 minutes") {
		my($t,$mday,$mon,$year,$wday);
		$t= time();
		if ($period eq "day") {
			$t -= 24*60*60;
			($mday,$mon,$year) = ( localtime($t) )[3..5];
			$end= $start= sprintf("%d%02d%02d",$year+1900,$mon+1,$mday);
		} elsif ($period eq "week") {
			$wday = (localtime($t))[6];
			$t -= ($wday+1)*24*60*60;
			($mday,$mon,$year) = ( localtime($t) )[3..5];
			$end= sprintf("%d%02d%02d",$year+1900,$mon+1,$mday);
			$t -= 6*24*60*60;
			($mday,$mon,$year) = ( localtime($t) )[3..5];
			$start= sprintf("%d%02d%02d",$year+1900,$mon+1,$mday);
		} elsif ($period eq "month") {
			$mday = (localtime($t))[3];
			$t -= $mday*24*60*60;
			($mday,$mon,$year) = ( localtime($t) )[3..5];
			$end= sprintf("%d%02d%02d",$year+1900,$mon+1,$mday);
			$t -= (days_in_month($mon,$year+1900) - 1) * 24 * 60 * 60;
			($mday,$mon,$year) = ( localtime($t) )[3..5];
			$start= sprintf("%d%02d%02d",$year+1900,$mon+1,$mday);
		} else {
			die "$0: Logic error; $!";
		}
	}
	while ( $fname = glob("$path/*.csv") ) {
		if ($period eq "30 minutes") {
			if ($fname gt $retvals[0]) {
				$retvals[0]= $fname;
				$lastfname= basename($fname);
			}
		} else {
			my $datepart= substr( basename($fname), 0, 8 );
			if ($datepart ge $start && $datepart le $end) {
				push(@retvals, $fname);
				if ($datepart gt $lastfname) {
					$lastfname= $datepart;
				}
			}
		}
	}
	if (length($lastfname) > 8) {
		$lastfname =~ s|^(\d\d\d\d)(\d\d)(\d\d)-(\d\d)(\d\d).*|$4:$5 on $3/$2/$1|;
	} else {
		$lastfname =~ s|^(\d\d\d\d)(\d\d)(\d\d).*|$3/$2/$1|;
	}
	($lastfname, @retvals);
}



sub days_in_month {
	(31, $_[1] % 4 ? 28 : 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)[${_[0]}];
}



sub get_traffic {
# Read the log files (specified in @flist) & summarise into a hash
	my($s, $summarise, $field, @flist)= @_;
	my($fname, $src, $dst, $bytes, $key, %traffic, $sum);
	foreach $fname (@flist) {
		open(CSV, "< $fname") || warn "$0: unable to open $fname; $!";
		<CSV>;		# Logs start with a couple of header lines
		<CSV>;
		while (<CSV>) {
			($src, $dst, $bytes)= split(/,/, $_);
			if ( $field == 1 ? $dst =~ $s : $src =~ $s ) {
				$key= ($field == 1) ? $src : $dst ;
				$traffic{$key} += $bytes;
				$sum+= $bytes;
			}
		}
		close(CSV);
	}
	if ( $summarise ) {
		my $significant= $sum * .025;
		foreach $s (keys %traffic) {
			if ( $traffic{$s} < $significant ) {
				$traffic{"Miscellaneous"} += $traffic{$s};
				delete $traffic{$s};
			}
		}
	}
	return \%traffic;
}



sub make_graph {
# Take a (reference to a) hash containing traffic stats & create a pie chart
	my($period, $end, $dataref, $fname)= @_;

	my @sources= sort( {uc($a) cmp uc($b)} keys(%$dataref) );
	my @traffic= map($$dataref{$_},@sources);

	my ($t, $sum);
	foreach $t (@traffic) {
		$sum+= $t;
	}
	for (my $i = 0; $i <= $#sources; $i++) {
		$t= int(100*$traffic[$i]/$sum + .5);
		$sources[$i]= $i+1 . ". $sources[$i] ($t%)";
	}

	my $my_graph = new GIFgraph::pie(500, 510 + $#sources*11);
	$my_graph->set( 'start_angle' => 180,	'3d' => 0,	'title' => "For the $period ending $end" );
	$my_graph->set_text_clr("black");
	$my_graph->set_legend(@sources);
	$my_graph->set_legend_font(gdSmallFont);
	$my_graph->plot_to_gif( $fname, [[1..$#sources+1], \@traffic] );
}
