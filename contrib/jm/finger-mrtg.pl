#!/usr/bin/perl5
#
# finger-mrtg.pl -
#
#	executes "finger @hostname" (hostname is the argument passed into
#	the script) and counts how many logins there currently are on that 
#	machine.
#	
#	if machine is 'localhost', we just execute 'finger' instead, w/ no 
#	arguments.
#
#	example Target line:
#	
#	Target[shellbox1]: `/path/to/finger-mrtg.pl shellbox1.mydomain.com`
#
#
# -joey miller, inficad communications, llc.
#  <joeym@inficad.com>


if ( ! $ARGV[0] ) { exit; }

# output:
#
# [user1.inficad.com]
# Login    Name                 Tty   Idle  Login Time   Office     Office Phone
# username blah blah            *pd     43  Feb  3 16:55
# hello    lada lada             pa   5:16  Feb  3 15:21

if ( $ARGV[0] =~ /localhost/ ) {
    open(FINGER, "/usr/bin/finger |") || exit;
} else {
    open(FINGER, "/usr/bin/finger \@$ARGV[0] |") || exit;
}

while (<FINGER>) {
  if ( /^\[.*\]/ ) { next; }
  if ( /^Login/ ) { next; }
  $count++;
}

print "$count\n";
print "$count\n";
print "0\n";
print "$ARGV[0]\n";
