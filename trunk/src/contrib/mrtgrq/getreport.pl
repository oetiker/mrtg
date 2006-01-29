#!/usr/bin/perl
# This script is used to establish a TCP connection with a host to get the 
# report of disk-space quota provided by repquota utility.
#
# use: ./getreport.pl <hostname> <port number>
#
# By Steven Micallef <smic@wire.net.au> on the 24/4/1999.
# Modified by Adrian Turcu <adrianturcu@yahoo.com> on 18/9/2000.

use Net::Telnet ();

$hostname = $ARGV[0];
$port = $ARGV[1];

# If you've changed the port showdisk.pl runs on, change it here too.
#$port = 9047;

$i = 0;

if ($hostname eq "" || $port eq "" )
{
  print "Usage: $0 <hostname> <port number>\n";
  exit;
}

$t = new Net::Telnet ( Host => $hostname, Port => $port);
$t->open("$hostname");

do
{
  $data = $t->getline(Timeout => 40);
    print $data;
} while ( $data );
