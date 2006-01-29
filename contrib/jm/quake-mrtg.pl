#!/usr/bin/perl5
#
#  quake-mrtg.pl
# 
#  counts the number of players currently on a given
#  quake2/quakeworld/unreal/etc server, using the 'qstat' 
#  program available from: ftp://ftp.activesw.com/pub/quake/
#
#  Usage:
#   Target[quakeserv]:  `quake-mrtg.pl quake.server.com 27910 Q2`
#   
#   ^^^ Gets usage from a Q2 server running on quake.server.com, 
#       port 27910.
#
#  - joey miller, inficad communications, llc.
#    <joeym@inficad.com>, 2/5/1999
#

my($qstat) = "./qstat";

$| = 1;

if ( scalar(@ARGV) < 3 ) {
    print STDERR "usage: $0 server.address port game-type\n\n";
    print STDERR "\tgame-types: QS, QW, QWM, H2S, HWS, Q2, UNS, HLS, SNS\n";
    print STDERR "\tQW = quakeworld, Q2 = quake2, etc, etc\n";
    exit -1;
}

my($serv) = $ARGV[0];
my($port) = $ARGV[1];
my($game) = $ARGV[2];

if ( ! open(QSTAT, "$qstat -raw : -default $game $serv:$port |") ) {
    print STDERR "Couldn't exec $qstat\n";
    exit -2;
}

my($users);
while(<QSTAT>) {
    ($users) = (split(/:/))[6];
    last;
}
close(QSTAT);

print "$users\n";
print "$users\n";
print "0\n";
print "$serv:$port\n";
    
    
