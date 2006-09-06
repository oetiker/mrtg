#!/usr/bin/perl

#-----------------------------------------------
# Return processor usage, for a specifig time range (5sec, 1min, 15min)
#
# Author: Dimitrios Stergiou <dste@intranet.gr> , 26/10/00
# Version : 1.0
#
# Usage: ./getproc.pl cisco_hostname time_range
# time_range can be:
#            3 (The overall CPU busy percentage in the last 5 secs)
#            4 (The overall CPU busy percentage in the last 1 mins)
#            5 (The overall CPU busy percentage in the last 15 mins)
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

# Query public community on router, return proc usage for specific time range
@command = snmpget($ARGV[0], "enterprises.9.9.109.1.1.1.1.$ARGV[1].1");
print @command[0];
