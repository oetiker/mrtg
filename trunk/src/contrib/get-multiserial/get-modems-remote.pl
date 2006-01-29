#! /usr/bin/perl
#
# get-modems-remote.pl
#
# Connects to a TCP port get's there the number of occupied modems
# and prints'em out
#
# The other side consists of a silly programm (a la get-modems.pl ;)
# that just prints the number of active lines.
#
# ex:
# /etc/services :
#   getmodems	9999/tcp
# /etc/inetd.conf:
#   getmodems  stream  tcp  nowait  nobody  /usr/bin/get-modems.pl get-modems.pl
#
# Thanks to Larry Wall for the nice example in the Lama Perl-tutorial
#
# (c) T.Pospisek <tpo@spin.ch> Distributed under GNU copyleft
#
# History:
# ??-??-97	initial release for mrtg
# 13-05-99	cleaned up a little bit - thanks to Dancho Kanev
#               <dancho@globcom.net> for "buging" me ;-)

# ---- please adapt the following two lines to your local configuration ---

# The name of the remote server
$remote_server='jesus';

# The name of the service
$service='getmodems';

#-- end of user configurable stuff     ---

use Socket;

$sockaddr = 'S n a4 x8';
chop($hostname = `hostname`);
($name, $aliases, $proto) = getprotobyname('tcp');
($name, $aliases, $port) = getservbyname($service,'tcp');
($name, $aliases, $type, $len, $thisaddr) = gethostbyname($hostname);
($name, $aliases, $type, $len, $thataddr) = gethostbyname($remote_server);
$thisport = pack($sockaddr, &AF_INET, 0, $thisaddr);
$thatport = pack($sockaddr, &AF_INET, $port, $thataddr);

socket(S, &PF_INET, &SOCK_STREAM, $proto) ||
        die "dial-in-check : cannot create socket\n";
bind(S, $thisport) ||
        die "dial-in-check : cannot bind socket\n";
connect(S, $thatport) ||
        die "dial-in-check : cannot bind socket\n";
while (<S>) {
        print;
}
# print "0\n";
# print "0\n";
# print "$remote_server\n";
