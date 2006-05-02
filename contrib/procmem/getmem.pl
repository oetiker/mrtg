#!/usr/bin/perl

#-----------------------------------------------
# Return memory usage for a specific Cisco memory pool
#
# Author: Dimitrios Stergiou <dste@intranet.gr> , 25/10/00
# Version : 1.0
#
# Usage: ./getmem.pl cisco_hostname memory_pool
#
# 1.0 Initial version, basic functionality
#-----------------------------------------------

# Import libraries
use lib "/usr/local/mrtg/lib/mrtg2";
use MRTG_lib "2.090006";
use SNMP_Session "0.77";
use BER "0.77";
use SNMP_util "0.77";
use locales_mrtg "0.07";

# Query public community on router, return memory used in current pool
@command = snmpget($ARGV[0], "enterprises.9.9.48.1.1.1.5.$ARGV[1]");
print @command[0];
