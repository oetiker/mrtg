#!/usr/bin/perl

#
# Copyright (c) 1997 by Carlos Canau <canau@EUnet.pt>, EUnet Portugal.
# All Rights Reserved.
#
# See the file COPYRIGHT in the distribution for the exact terms.
#

$SNMPGet = '/usr/bin/snmpget';
$TableBase = '/home/mrtg/bin/ModemTable';
$Community = "public";
$progname = 'GetSNMPLinesUP.pl';
$Router = $ARGV[0];

$MAGICLEN = 20;

$UPTIME = "system.sysUpTime.0";
$NAME = "system.sysName.0";

if (!$Router) {
    die "$progname: $progname ROUTER\n";
}

$var = "$UPTIME $NAME "; $varlen = 2;
$buzy = 0;

open( TABLE, "$TableBase.$Router" );
while (<TABLE>) {
    chop;
    $var = $var . $_ . " "; $varlen++;
    if ($varlen >= $MAGICLEN) {
	open( GET, "$SNMPGet -v 1 $Router $Community $var |" );
	while ( <GET> ) {
	    chop;
### printf "---%s\n", $_;
	    if (/up\(1\)/) {
		$buzy++;
	    };
###	    if (/$UPTIME/) {
	    if (/^system\.sysUpTime/) {
		($dummy, $Uptime) = split(' = ', $_, 9999);
	    }
###	    if (/$NAME/) {
	    if (/^system\.sysName/) {
		($dummy, $Name) = split(' = ', $_, 9999);
	    }
	}
	close ( GET );
	$var = ""; $varlen = 0;
    }
}
close( TABLE );

if ($varlen) {
    open( GET, "$SNMPGet -v 1 $Router $Community $var |" );
    while ( <GET> ) {
	chop;
### printf "+++%s\n", $_;
	if (/up\(1\)/) {
	    $buzy++;
	};
###	    if (/$UPTIME/) {
	if (/^system\.sysUpTime/) {
	    ($dummy, $Uptime) = split(' = ', $_, 9999);
	}
###	    if (/$NAME/) {
	if (/^system\.sysName/) {
	    ($dummy, $Name) = split(' = ', $_, 9999);
	}
    }
    close ( GET );
}

printf "$buzy\n";
printf "$buzy\n";
printf "$Uptime\n";
printf "$Name\n";

