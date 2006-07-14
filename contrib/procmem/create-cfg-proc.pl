#!/usr/bin/perl

#-----------------------------------------------
# Create mrtg.cfg for CPU processor usage
#
# Author: Dimitrios Stergiou <dste@intranet.gr> , 25/10/00
# Version : 1.0
#
# Usage: ./create-cfg-proc.pl cisco_hostname
#
# 1.0 Initial version, basic functionality
# 1.1 Check if router supports functionality
#-----------------------------------------------

# Import libraries
use lib "/home/alexander1/dste/cisco";
use MRTG_lib "2.090006";
use SNMP_Session "0.77";
use BER "0.77";
use SNMP_util "0.77";
use locales_mrtg "0.07";

# Suppress warnings
$SNMP_Session::suppress_warnings = 3;

# Define processor counters
@counters=("5sec", "1min", "15min");

# Check if router can support CPU proccess MIB
# Just poll a "5 sec" valur, for CPU 1, if we get answer it works
@test = snmpget($ARGV[0], "enterprises.9.9.109.1.1.1.1.3.1");
die "Processor util poll doesn't work for router $ARGV[0] $!\n" unless  ($test[0]=~/[0-9]/);

# loop through processor counters
foreach $counter (@counters) {
	$target = "$ARGV[0]"."_"."$counter";
	if ($counter eq "5sec") { $instance=3; }
	if ($counter eq "1min") { $instance=4; }
	if ($counter eq "15min") { $instance=5; }

print<<EOF
Target[$target]: `/home/alexander1/dste/cisco/getproc.pl $ARGV[0] $instance`
Title[$target]: $counter processor usage
MaxBytes[$target]: 100
Unscaled[$target]: dwmy
PageTop[$target]: <H1> $counter processor usage </H1>
Suppress[$target]: y
LegendI[$target]:  %
LegendO[$target]:
Legend1[$target]:  %
Legend2[$target]:
YLegend[$target]:  %
ShortLegend[$target]:  used
Options[$target]: gauge,growright

# ===================================
EOF
}
