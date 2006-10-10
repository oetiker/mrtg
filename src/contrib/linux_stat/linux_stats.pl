#!/usr/bin/perl -Tw
####################################################################
#  linux_stats.pl     1.0            Mike Machado                  #
#                                    mike@innercite.com            #
#                                    2000-07-19                    #
#                                                                  #
#  Script to read traffic stats off linux 2.2 and greater systems  #
#                                                                  #
####################################################################
use strict;



#### Options ####
my $uptimeprog = '/usr/bin/uptime';	# Set to program to give system uptime
my $hostnameprog = '/bin/hostname';	# Set to program to give system hostname
my $defaultinterface = 'eth0';		# Set to default interface
my $defaultstatfile = '/proc/net/dev';	# Set to traffic stats file location


##### Nothing below here should have to be changed #####

if (@ARGV && $ARGV[0] eq '-h') {
	print "Usage: linux_stats.pl [interface] [stats file]\n";
	print "\tIf left blank 'eth0' and '/proc/net/dev' are used\n";
	print "\tInterface of 'ALL' will total all interface traffic, excluding lo\n";
	exit;
}

my $interface = shift || $defaultinterface;
my $statfile = shift || $defaultstatfile;

# Clear path and get uptime
delete $ENV{PATH};
delete $ENV{BASH_ENV};
my $uptime = `$uptimeprog`;
chomp($uptime);
my $hostname = `$hostnameprog`;
chomp($hostname);

my ($in, $out, $found);
open(STATS, $statfile) || die "Cannot open $statfile: $!\n";
while (<STATS>) {
	my $line = $_;
	chomp($line);
	if (uc($interface) eq 'ALL') {
		if ($line =~ /^\s+(.*):\s*(\d+)\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+(\d+)\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+$/) {
			next if $1 eq 'lo';
			$in += $2;
			$out += $3;
			$found++;
		}
	} else {
		if ($line =~ /^\s*$interface:\s*(\d+)\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+(\d+)\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+$/) {
			$in = $1;
			$out = $2;
			$found = 1;
			last;
		}
	}
}
close(STATS);

if (!$found) {
	print "0\n0\n$uptime\n$hostname: Unknown Interface: $interface\n";
} else {
	print "$in\n$out\n$uptime\n$hostname: Interface: $interface";
	if (uc($interface) eq 'ALL') {
		print " (counted $found interface";
		if ($found > 1) {
			print "s";
		}
		print ")";
	}
	print "\n";
}
