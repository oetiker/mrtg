# summarise.pl
#
#	Summarise some whodo log/csv files into a single file. The old files
#	are then deleted.
#
# Args are:
#	i	path of input log/CSV files. If no arg is given, this defaults to
#		yesterday's files.
#	o	path of output CSV file. If no arg is given, this defaults to
#		YYYYMMDD.csv where the date is the latest date in the input data.
#
#	v1.0	11/11/98	Tony Farr
#
use Getopt::Std;
use File::Basename;
use strict;
use vars qw/ $opt_i $opt_o /;

# Directory for output logs/csv files.
my $LOGPATH= "D:\\logs\\whodo\\";

my $progname = basename($0);
my $usage= "Usage: $progname -i input_path -o output_file\n";
getopts('i:o:') || die $usage;
my @flist= get_input_files($opt_i);
if ( scalar(@flist) < 1 ) {
	die "$progname: No files to process!";
}
my ($trafficref, $endtime, $duration)= get_traffic(@flist);
if (! $opt_o) {
	($_)= split(/ /, $endtime);
	my ($d,$m,$y) = split/\//;
	$opt_o= dirname($flist[0]) . "\\" . sprintf "%d%02d%02d.csv",$y,$m,$d;
}
print_stats($trafficref, $endtime, $duration, $opt_o);
unlink @flist;
exit 0;



sub get_input_files {
# Returns a list of input files to be processed
	my($path)= @_;
	if (! $path) {
		my $t = time() - 24*60*60;
		my ($mday,$mon,$year) = ( localtime($t) )[3..5];
		$path= $LOGPATH . sprintf("%d%02d%02d-*.csv",$year+1900,$mon+1,$mday);
	}
	glob($path);
}



sub get_traffic {
# Read the log files (specified in @_) & summarise into a hash
	my($fname, $lastf, $lasttime, $hr, $min, $sec, $duration, $src, $dst, $bytes, %traffic);
	foreach $fname (@_) {
		open(CSV, "< $fname") || warn "$progname: unable to open $fname; $!";
		# First line is a header giving end time
		$_= <CSV> || warn "$progname: $fname is empty\n";
		chomp;
		$_= (split/,/)[1];
		if ($fname gt $lastf) {
			$lastf= $fname;
			$lasttime= $_;
		}
		# Second line is a header giving period covered by this log
		$_= <CSV> || die "$progname: $fname lacks second header line\n";
		chomp;
		$_= (split/,/)[1];
		($hr, $min, $sec)= split/:/;
		$duration += $sec + 60 * ($min + 60*$hr);
		# The rest of the file has traffic for particular sources & destinations
		while (<CSV>) {
			($src, $dst, $bytes)= split/,/;
			$traffic{$src}{$dst} += $bytes;
		}
		close(CSV);
	}
	return(\%traffic, $lasttime, $duration);
}



sub print_stats {
# Print out the traffictab in csv format
	use integer;
	my ($trafficref, $endtime, $duration, $fname)= @_;
	open (CSVFILE,">$fname") || die "$progname: Could not open file $fname; $!\n";
	print CSVFILE "End Time:,$endtime\n";
	my $sec= $duration % 60;
	$_= ($duration - $sec) / 60;
	my $min= $_ % 60;
	my $hr= ($_ - $min) / 60;
	print CSVFILE "Duration:,$hr:$min:$sec\n";
	foreach my $s (sort keys %$trafficref) {
		foreach my $d (sort keys %{$$trafficref{$s}}) {
			print CSVFILE "$s,$d,$$trafficref{$s}{$d}\n";
		}
	}
	close(CSVFILE);
}
