#!/usr/bin/perl5
#
# news-mrtg.pl -
#
# 
# joey miller, inficad communications, llc
# <joeym@inficad.com>  1999/02/02
#


if ( ! $ARGV[0] ) { exit; }
if ( ! $ARGV[1] ) { $port = 22; }
else { $port = $ARGV[1]; }

if ( $ARGV[0] =~ /localhost/ ) {
    open(NFO, " (uptime ; ps auxw |grep nnrp |grep -v grep) |") || exit -1;
} else {
    open(NFO, "ssh -p $port $ARGV[0] 'uptime ; ps auxw |grep nnrp |grep -v grep' |") || exit -1;
}
while (<NFO>) {
  if ( ! $count )  {
	($uptime) = $_ =~ /^.*(up.*),\s\d+user/;
  }
  $count++;
}
close(NFO);

$count--;
$uptime =~ s/,$//;

print "$count\n";
print "$count\n";
print "$uptime\n";
print "$ARGV[0]\n";
