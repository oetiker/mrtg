#!/usr/bin/perl

#-----------------------------------------------
# Query a router about its memory pools and create MRTG cfg file for the pools
#
# Author: Dimitrios Stergiou <dste@intranet.gr> , 25/10/00
# Version : 1.0
#
# Usage: ./create-cfg-mem.pl cisco_hostname
#
# 1.0 Initial version, basic functionality
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

# Locate how many memory pools the router has
for ($i = 1; $i <= 5; $i++) {
	$command = snmpget($ARGV[0], "enterprises.9.9.48.1.1.1.2.$i");
	if ($command eq "1") { push @pools, $i; }
}

# loop through pools and find 
# 1) pool names
# 2) pool usage
# 3) pool availability
# maximum pool capacity is defined as: PoolSizeUsed + PoolSizeFree

foreach $pool (@pools) {
	@memtype = snmpget($ARGV[0], "enterprises.9.9.48.1.1.1.2.$pool");
	if ($memtype[0] eq "I/O") { $memtype[0]="IO"; }
	$target = "$ARGV[0]"."_"."$memtype[0]";

	@pu = snmpget($ARGV[0], "enterprises.9.9.48.1.1.1.5.$pool");
	@pf = snmpget($ARGV[0], "enterprises.9.9.48.1.1.1.6.$pool");

	$maxbytes = $pu[0]+$pf[0];

print<<EOF
Target[$target]: `/home/alexander1/dste/cisco/getmem.pl $ARGV[0] $pool`
Title[$target]: $nname memory used 
MaxBytes[$target]: $maxbytes
Unscaled[$target]: dwmy
PageTop[$target]: <H1> $nname memory used </H1>
Suppress[$target]: y
LegendI[$target]:  kbytes used
LegendO[$target]:
Legend1[$target]:  kbytes used
Legend2[$target]:
YLegend[$target]:  kbytes used
ShortLegend[$target]:  used
Options[$target]: gauge,growright

# ===================================
EOF
}
