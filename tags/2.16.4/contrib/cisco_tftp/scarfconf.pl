#!/usr/local/bin/perl 
#
###############################################################
# Copyright 1999 Frontier GlobalCenter/Global Crossing
# Copy/Use/Modification is fine please mention us in any mods and
# send them to us. Also thanks to the perl snmp people!
###############################################################
#
# who to blame: pee@gblx.net Paul E. Erkkila
#
# A perl script to have a cisco router dump it's configs
# to a tftp host
#
# To use this script I recommend  defining a view on the router 
# that does NOT have full write such as
#
# snmp-server view configView system included
# snmp-server view configView ciscoConfigCopyMIB included
# snmp-server community [community name] view configView RW
#
# It needs to be RW so it can set table entries
#
# the CISCO-CONFIG-COPY mib is 12.x only as far as I
# can tell
#
# $Author: oetiker $
# $Id: scarfconf.pl,v 1.1.1.1 2002/02/26 10:16:32 oetiker Exp $
# $Revision: 1.1.1.1 $
#
#

require 5.003;
use strict;

## snmp perl
use SNMP_Session;
use SNMP_util "0.71";
use BER;


my $host       = $ARGV[0] || die "useage: $0 target community toHost ID";
my $community  = $ARGV[1] || die "useage: $0 target community toHost ID";
my $toHost     = $ARGV[2] || die "useage: $0 target community toHost ID";
my $randomid   = $ARGV[3] || die "useage: $0 target community toHost ID";


&snmpmapOID("cicsoMgmt",            "1.3.6.1.4.1.9.9.96");
&snmpmapOID("ccCopySourceFileType", "1.3.6.1.4.1.9.9.96.1.1.1.1.3");
&snmpmapOID("ccCopyDestFileType",   "1.3.6.1.4.1.9.9.96.1.1.1.1.4");
&snmpmapOID("ccCopyServerAddress",  "1.3.6.1.4.1.9.9.96.1.1.1.1.5");
&snmpmapOID("ccCopyFileName",       "1.3.6.1.4.1.9.9.96.1.1.1.1.6");
&snmpmapOID("ccCopyEntryRowStatus", "1.3.6.1.4.1.9.9.96.1.1.1.1.14");
&snmpmapOID("ccCopyState",          "1.3.6.1.4.1.9.9.96.1.1.1.1.10");


my ($oid,$response);

#
#  First a simple SNMP Get
#
my $hostopt = $community . "@" . $host;


# get system uptime to see if it's actually working :)
$oid = "sysUptime";
# print "Getting $oid from $host\n";
($response) = &snmpget($hostopt, $oid);
if ($response) {
#	print "$oid : $response\n";
} else {
	print "$host did not respond to SNMP query\n";
	exit;
}

# build the table row
# print "Sending Row Build (Create and Wait) ";
$oid = "ccCopyEntryRowStatus." . $randomid;
($response) = &snmpset($hostopt,$oid,'int',5);
if ($response) {
#    print "$oid : $response\n";
} else {
    print "Failure setgging $oid on $host\n";
    exit;
}

# 4 is running-config
# print "Setting source file type ";
$oid = "ccCopySourceFileType." . $randomid;
($response) = &snmpset($hostopt,$oid,'int',4);
if ($response) {
#    print "$oid : $response\n";
} else {
    print "Failure setting $oid on $host\n";
    exit;
}

# 1 is netfile
#print "Setting destination file type ";
$oid = "ccCopyDestFileType." . $randomid;
($response) = &snmpset($hostopt,$oid,'int',1);
if ($response) {
#    print "$oid : $response\n";
} else {
    print "Failure setting $oid on $host\n";
    exit;
}

# send it to this host
#print "Setting destination ip address ";
$oid = "ccCopyServerAddress." . $randomid;
($response) = &snmpset($hostopt,$oid,'ipaddr',$toHost);
if ($response) {
#    print "$oid : $response\n";
} else {
    print "Failure setting $oid on $host\n";
    exit;
}

# name to use
# print "Setting config file name ";
$oid = "ccCopyFileName." . $randomid;
my $filename = $host . "." . $randomid;
($response) = &snmpset($hostopt,$oid,'string',$filename);
if ($response) {
#    print "$oid : $response\n";
} else {
    print "Failure setting $oid on $host\n";
    exit;
}

# GO GO GO
print "Sending request to start copy operation ";
$oid = "ccCopyEntryRowStatus." . $randomid;
($response) = &snmpset($hostopt,$oid,'int',1);
if ($response) {
    print "$oid : $response\n";
} else {
   exit;
}


my $pollagain = 1;
while ($pollagain) {
my $pstatus = &waitForCompletion($hostopt);
if ($pstatus eq 1) {
    print "Waiting\n";
}
if ($pstatus eq 2) {
    print "Running\n";
}
if ($pstatus eq 3) {
    print "Successful\n";
    $pollagain = 0; 
}
if ($pstatus eq 4) {
    print "Copy Failed\n";
    $pollagain = 0;
}
sleep(1);
}


exit;
#### EOP  ###
#############



sub waitForCompletion {
my ($hostopt) = @_;

my $oid = "ccCopyState." . $randomid;
my $response;
($response) = &snmpget($hostopt, $oid);
if ($response) {
	return $response;
} else {
	print "$host did not respond to SNMP query\n";
	exit;
}


}




