#!/usr/bin/perl
# This script is used to establish a TCP connection with a host to get the 
# disk info provided by showdisk.pl.
#
# use: ./getdisk.pl <hostname> <disk number>
#
# By Steven Micallef <smic@wire.net.au> on the 24/4/1999.
# Externale bug fixed by Alon Goldberg <pyro@elapsed.net> 27/2/2000.

use Net::Telnet;

$hostname = $ARGV[0];
$disk_no = $ARGV[1];

# If you've changed the port showdisk.pl runs on, change it here too.
$port = 9047;

$i = 0;

if (!defined($disk_no)) { print "Usage: $0 <hostname> <disk number>\n"; exit }

$t = new Net::Telnet ( Host => $hostname, Port => $port);
$t->open("$hostname");

while ($i ne $disk_no) {
  $data = $t->getline(Timeout => 40);
  $i++;
  print $data, 0, "\n" if $i eq $disk_no;
}

