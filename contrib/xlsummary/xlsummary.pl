# xlsummary.pl
#
# Extract summary figures from the MRTG log files. In particular it summarises
# all sites (i.e. as many as will fit on a page) into a single Excel chart.
#
# Args are:
#	h	help
#	d,w,m	do stats for last day, week or month
#	f	directory containing mrtg log files
#
#	v1.1	17/2/99	Tony Farr
#

use Getopt::Std;
use File::Basename;
use strict;

my $progname = basename($0);
my $usage = "Usage: $progname [-h] [-dwm] [-f path_of_logs]\n";

use vars qw/$opt_h $opt_d $opt_w $opt_m $opt_f/;
getopts('hdwmf:') || die $usage;
if ( defined($opt_h) ) {
	print $usage;
	exit(0);
}
if ( $opt_d + $opt_w + $opt_m != 1) {
	die $usage;
}
if ( $opt_f ) {
	chdir $opt_f || die "$progname: Unable to chdir to $opt_f; $!";
}

my ($start, $end) = &get_duration;
my $fin= $ENV{"TMP"}."\\$$.csv";
write_csv($start, $end, $fin);
my $fout = "$opt_f\\" . basename($progname,".pl") . ".xls";
graph_csv($start, $end, $fin, $fout);
unlink($fin);

exit(0);



sub write_csv {
	my ($start, $end, $fname)= @_;
	# Process all the log files
	open(CSV, ">$fname");
	print CSV "Site, Maximum, Minimum, Halfway\n";
	foreach my $fname (sort glob("*.log")) {
		my ($t, $lastt, $sumt, $deltat, $max, $lastmax, $summax, $min, $lastmin, $summin);
		open(LOG, "<$fname") || die "$progname: Unable to open $fname; $!";
		<LOG>;							# Skip the header line
		while (<LOG>) {
			chomp;
			($t, $max, $min)= split/ /;
			if ($t < $start) { last };	# Log has latest first
			if ($t <= $end) {
				if ($lastmax) {			# Zeroes mean the link was down.
					$deltat= $lastt - $t;
					$sumt += $deltat;
					$summax += $lastmax * $deltat;
					$summin += $lastmin * $deltat;
				}
				($lastt, $lastmax, $lastmin)= ($t, $max, $min);
			}
		}
		# This is site specific. The devices we ping have names like SSSS-rtr
		# or SSSS-lan where SSSS is the site name. This strips off the "-rtr"
		# or "-lan" suffix.
		my $target= ucfirst( basename($fname, "-lan\.log", "-rtr\.log", "\.log") );
		if ($sumt) {
			print CSV "$target, ". ($summax/$sumt) .", ". ($summin/$sumt) .", ". (($summax+$summin)/(2*$sumt)) ."\n";
		}
		close(LOG);
	}
	close(CSV);
}



sub get_duration {
# Returns the starttime & endtime to be reported on
	my($starttime, $endtime);
	my $t= time;
	my ($sec,$min,$hour,$mday,$mon,$year,$wday) = localtime($t);
	if ($opt_d) {
		$endtime= $t - ($sec + 60*$min + 60*60*$hour);
		$starttime= $endtime - 24*60*60;
	} elsif ($opt_w) {
		$endtime= $t - ($sec + 60*$min + 60*60*$hour + 24*60*60*$wday);
		$starttime= $endtime - 7*24*60*60;
	} else {						# opt_m
		$endtime= $t - ($sec + 60*$min + 60*60*$hour + 24*60*60*($mday-1));
		$starttime= $endtime - days_in_month($mon - 1, $year)*24*60*60;
	}
	($starttime, $endtime);
}



sub days_in_month {
	(31, $_[1] % 4 ? 28 : 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)[${_[0]}];
}



sub graph_csv {
	use Win32::OLE::Const 'Microsoft Excel';
	use Win32::OLE::Const 'Microsoft Office';
	use POSIX;

	my ($start, $end, $fin, $fout)= @_;

	# use existing instance if Excel is already running
	my $xl;
	eval {$xl = Win32::OLE->GetActiveObject('Excel.Application')};
	die "$progname: Excel not installed" if $@;
	unless (defined $xl) {
		$xl = Win32::OLE->new('Excel.Application', sub {$_[0]->Quit;})
			|| die "$progname: Cannot start Excel; $!";
	}
	# open the CSV
	my $book = $xl->Workbooks->Open($fin);

	# Sort data into descending order
	my $sheet = $book->Worksheets(1);
	my $a1 = $sheet->Cells(1, 1);
	my $range = $sheet->Range($a1, $a1->End(xlDown)->End(xlToRight));
	$range->Sort( {Key1 => $sheet->Range("D2"), Order1 => xlDescending} );

	# Put data into a chart. The most that can be sensibly squeezed in
	# is 52 sites. So select the slowest.
	$sheet->Range($a1, $sheet->Cells(53, 4))->Select;
	$book->Charts->Add;
	# And format it.
	my $chart= $book->ActiveChart;
	$chart->{'ChartType'} = xlStockHLC;
	$chart->{'HasLegend'} = msoFalse;
	$chart->{'HasTitle'} = msoTrue;
	# The description here fits ping response times.
	$chart->ChartTitle->Characters->{'Text'} =
			"Typical Maximum & Minimum Round Trip Times (msecs) between ".
			localtime($start) ." and ". localtime($end);
	$chart->PlotArea->Interior->{'ColorIndex'} = xlNone;
	$chart->ChartGroups(1)->HiLoLines->Border->{'Weight'} = xlMedium;
	$chart->PageSetup->{'LeftMargin'} = 5;
	$chart->PageSetup->{'RightMargin'} = 5;
	$chart->PageSetup->{'TopMargin'} = 5;
	$chart->PageSetup->{'BottomMargin'} = 10;
	$chart->PageSetup->{'Orientation'} = xlLandscape;
	$chart->Axes(xlCategory)->TickLabels->Font->{'Size'} = 8;
	$chart->Axes(xlValue)->TickLabels->Font->{'Size'} = 8;

	# save and exit
	$book->SaveAs($fout, xlWorkbookNormal);
	$book->Close;
	undef $xl;
}