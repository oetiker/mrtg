# collect.pl
#
#	Collect IP accounting data from a cisco router and summarise it
#	into a CSV file. The file shows number of bytes sent from each
#	source device to each destination network.
#	Optionally, the data is also summarised by source (all destinations added
#	together) and written out to an mrtg config file.
#	There are also two input files. "networks" is used to map network
#	addresses to names. "sources" is optional & is used to map source
#	addresses to host names.
#
# Args are:
#	h	help
#	a	path of mrtg config file for data by source
#	n	path of a "networks" file used to map network addresses to names
#	o	path of output CSV file. Defaults to YYYYMMDD-HHMMSS.CSV
#	s	path of a "sources" file mapping source addresses to host names
#
#	v1.0	17/9/98		Tony Farr	Original
#	v1.1	16/12/98	Tony Farr	Add horrid kludge to collect Exchange traffic
#									by source
#	v1.2	22/3/99		Tony Farr	Tidy up
#	v1.3	25/3/99		Tony Farr	Remove v1.1 kludge
#									Just generate one mrtg line/data set
#

use SNMP_util;
use Getopt::Std;
use File::Basename;
use strict;
use Socket;

use vars qw/$opt_h $opt_a $opt_n $opt_o $opt_s/;

#	CONSTANTS
# Note inclusion of the write community string
my $HOST= '0ztrad3@canb-wan';
# Directory for output logs/csv files.
my $LOGPATH= "D:\\logs\\whodo\\";
# Directory for MRTG config files for traffic sources
my $SOURCEDIR= "D:\\www\\mrtg\\whodo";
# Any source generating more than BIGBYTES per poll will be added to the sources config file automatically
my $BIGBYTES= 40000000;

my(@dstdesc, @dstaddr, @dstmask, @srcaddr, @srcdesc, %traffictab);
my $progname = basename($0);
my $usage = "Usage: $progname [-h] [-a mrtg_config_file] [-n network_file] [-o output_file] [-s source_address_file]\n";
# Parse Command Line:
die $usage unless getopts('ha:n:o:s:');
if ( defined($opt_h) ) {
	print $usage;
	exit(0);
}
if ( defined($opt_n) ) {
	load_nets($opt_n);
}
unless ( defined($opt_o) ) {
	my ($sec,$min,$hour,$mday,$month,$year) = localtime;
	$opt_o= $LOGPATH . sprintf("%d%02d%02d-%02d%02d%02d.csv", $year+1900,++$month,$mday,$hour,$min,$sec);
}
if ( defined($opt_s) ) {
	load_sources($opt_s);
}
my $age= checkpoint_stats($HOST);
get_stats($HOST);
print_stats($opt_o);
if ( defined($opt_a) ) {
	make_sources_config($opt_a);
}
exit(0);



sub load_nets {
# Loads 3 arrays:
#	@dstaddr - a list of IP addresses
#	@dstdesc - a list of the corresponding descriptions
#	@dstmask - a list of the corresponding bitmasks
# The tables are loaded from a list of filenames passed in @_. That file
# can be a networks file. The file(s) should have format:
#		netdescription	10.10.10	/25
# The "/25" is the mask & may be preceeded by a "#". It is optional.
	my(@flist)= @_;
	my ($desc, $end, $masksz);
	while (my $fname= shift(@flist)) {
		open(NETWORKS, "<$fname") || warn "$progname: unable to open $fname; $!";
		while (<NETWORKS>) {
			# Process #includes after dealing with the current file
			if ( /^#\s*include\s+(\S+)/ ) {
				push(@flist, $1);
				next;
			}
			if ( /^\s*(\w+)\s+(\S+)(.*)/ ) {
				$desc= $1;
				$_= $2;
				$end= $3;
				push(@dstdesc, $desc);
				my $octets = 1 + tr/././;
				$_ .= ".0" x (4 - $octets);
				push( @dstaddr, aton($_) );
				if ( $end =~ /\/(\d+)/ ) {
					$masksz= $1;
				} else {
					$masksz= $octets * 8;
				}
				push( @dstmask, pack("B32", "1" x $masksz . "0" x 32) );
			}
		}
		close(NETWORKS);
	}
}



sub load_sources {
# Loads a pair of arrays: @srcaddr (a list of IP addresses) and @srcdesc
# (a list of the corresponding descriptions). The files are loaded from
# a list of filenames passed in @_. That file can be a hosts file. However "address" entries
# can be perl regular exprs as well literal addresses. For compatibility,
# "." when used as a wild card must be expressed "\." - i.e. the reverse of normal.
	my(@flist)= @_;
	while (my $fname= shift(@flist)) {
		open(HOSTS, "<$fname") || warn "$progname: unable to open $fname; $!";
		while (<HOSTS>) {
			# Process #includes after dealing with the current file
			if ( /^#\s*include\s+(\S+)/ ) {
				push(@flist, $1);
				next;
			}
			($_)= split(/#/);
			if ( /(\S+)\s+(\S+)/ ) {
				push(@srcdesc, $2);
				$_= $1;
				s/\./\\\./g;			# Replace "." with "\."
				s/\\\\\././g;	# If we now have "\\.", replace with "."
				push(@srcaddr, $_);
			}
		}
		close(HOSTS);
	}
}



sub checkpoint_stats {
# Take a checkpoint on IP accounting on the given router & return the duration of it.
# The checkpoint is done by doing a get  then a set on actCheckPoint
	my ($age);

	# Find how long since the last checkpoint
	($age) = snmpget ($_[0], '1.3.6.1.4.1.9.2.4.8.0');
	warn "$progname: No actAge returned.\n" unless $age;

	# Check to see if we've lost any data
	($_) = snmpget ($_[0], '1.3.6.1.4.1.9.2.4.6.0');
	warn "$progname: Accounting table overflow - $_ bytes lost.\n" if $_ > 0;

	# Do a new checkpoint
	($_) = snmpget ($_[0], '1.3.6.1.4.1.9.2.4.11.0');
	die "$progname: No actCheckPoint returned.\n" unless defined;
	snmpset ($_[0], '1.3.6.1.4.1.9.2.4.11.0', 'integer', $_);
	$age;
}



sub get_stats {
# Summarise the checkpoint by destination network (not host).
# Summary is placed into %traffictab - a hash of hashes indexed by
# source device & destination network.
	my($src, $dstnet);
	my @response = snmpwalk ($_[0], '1.3.6.1.4.1.9.2.4.9.1.4' );
	foreach $_ (@response) {
		/(\d+\.\d+\.\d+\.\d+)\.(\d+\.\d+\.\d+\.\d+):(\d+)/ ||
				die "$progname: Cannot parse response from walk.\n";
		$dstnet= addr_to_net($2);
		$src= addr_to_src($1);
		$traffictab{$src}{$dstnet} += $3;
	}
}



sub print_stats {
# Print out the traffictab in csv format
	my ($sec,$min,$hour,$mday,$month,$year) = localtime(time());
	$year += 1900;
	$month++;
	open (CSVFILE,">$_[0]") || die "$progname: Could not open file $_[0]; $!\n";
	printf CSVFILE "End Time:,%d/%02d/%d %d:%02d:%02d\n",$mday,$month,$year,$hour,$min,$sec;
	print CSVFILE "Duration:,$age\n";		# Bug alert. This breaks if $age > 1 day
	my($s, $d);
	foreach $s (sort keys %traffictab) {
		foreach $d (sort keys %{$traffictab{$s}}) {
			print CSVFILE "$s,$d,$traffictab{$s}{$d}\n";
		}
	}
	close(CSVFILE);
}



sub make_sources_config {
# Print out an mrtg config file
	my($cfgfile)= @_;
	my(%cfgentries, $src, $dst, $t, $misc);
	# Load current cfg entries
	if ( open(CFG, "<$cfgfile") ) {
		while (<CFG>) {
			if ( /^\s*Target\[([^\]]*)/ && $1 ne "Miscellaneous" ) {
				$cfgentries{ uc($1) }= 1;
			}
		}
		close(CFG);
	}
	# Write out the header of a new config file
	open(CFG,">$cfgfile") || die "$progname: Could not open file $cfgfile; $!\n";
	write_sources_header();
	# For each traffictab entry, if it's large or there's an existing CFG entry, write out a new CFG entry
	foreach $src (keys %traffictab) {
		$t= 0;
		foreach $dst (keys %{$traffictab{$src}}) {
			$t += $traffictab{$src}{$dst};
		}
		if ( $cfgentries{ uc($src) } ) {
			delete $cfgentries{ uc($src) };
			write_source_entry($src, $t);
		} elsif ( $t > $BIGBYTES ) {
			write_source_entry($src, $t);
		} else {
			$misc += $t;
		}
	}
	# Write out new entries for any CFG entries that existed previously but we've
	# missed because they generated no traffic this time.
	foreach $src (keys %cfgentries) {
		write_source_entry($src, 0);
	}
	# Write an entry for the miscellaneous odds & ends
	write_source_entry("Miscellaneous", $misc);
	close(CFG);
}



sub write_sources_header {
	print CFG <<END_OF_HEADER;
WorkDir: $SOURCEDIR
IconDir: /mrtg/
Interval: 30

END_OF_HEADER
}



sub write_source_entry {
	print CFG <<END_OF_ENTRY;

Title[$_[0]]: Traffic from $_[0]
PageTop[$_[0]]: <H1>Traffic from $_[0]</H1>
MaxBytes[$_[0]]: 12500000
Options[$_[0]]: growright, bits, absolute, nopercent
Colours[$_[0]]: w#ffffff,blue#0000e0,w#ffffff,r#ff0000
Target[$_[0]]: `perl -e "print \\"0\\n$_[1]\\""`
YLegend[$_[0]]: Bits per Second
ShortLegend[$_[0]]: bps
Legend1[$_[0]]:
Legend2[$_[0]]: Traffic from $_[0]
LegendI[$_[0]]:
LegendO[$_[0]]: &nbsp;Traffic:

END_OF_ENTRY
}



sub addr_to_net {
# Returns the name/description of the network of the given address.
# Addresses are looked up in @dstaddr first. If that fails, the address is returned.
	my($i, $dst);
	$dst= aton($_[0]);
	for ($i=0; $i < @dstaddr; $i++) {
		if ( ($dst & $dstmask[$i]) eq $dstaddr[$i] ) {
			return $dstdesc[$i];
		}
	}
	$_[0] =~ /(.*)\..*/;		# Assume Class C & strip off the last octet
	$1;
}



sub BEGIN {
	my ($lastaddr, $lastsrc);
sub addr_to_src {
# Returns the name/description of the given address.
# Addresses are looked up in @srcaddr first. If there's no match, a dns lookup is tried.
# If that fails, the address is returned.
	if ( $_[0] eq $lastaddr ) {
		return $lastsrc;
	} else {
		$lastaddr= $_[0];
		for (my $i=0; $i < @srcaddr; $i++) {
			if ($_[0] =~ /^$srcaddr[$i]$/ ) {
				$lastsrc= $srcdesc[$i];
				return $lastsrc;
			}
		}
		my $addr= aton($_[0]);
		if ($lastsrc= gethostbyaddr($addr, AF_INET)) {
			$lastsrc =~ s/\.austrade\.gov\.au$//i;
		} else {
			$lastsrc= $_[0];
		}
		return $lastsrc;
	}
}
}



sub aton {
# I found the standard "inet_aton" very slow (on Windows).
# Hence this version. It only handles dotted decimal addresses -
# not names.
	$_[0] =~ /(\d+).(\d+).(\d+).(\d+)/;
	chr($1).chr($2).chr($3).chr($4);
}