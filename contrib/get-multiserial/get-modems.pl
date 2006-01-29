#!/usr/local/bin/perl
#
# Returns number of active analog and digital dial-ins
#
# This script could be very much improved - it's a quick hack
# and it works ...
#
# I'm doing a "w" sorting out all the important tty's (ttyC for cyclades
# boards) and checking if the correspond to the digita lines
#
# T.Pospisek <tpo@spin.ch> :
#
# Distributed under the GNU copyleft
#
 
# Number of active tty's
$isdn  = 0;
$modem = 0;

# Name of this host
$my_name = "Dial-In";

# Our digital lines
$tty{"ttyC12"}="i";
$tty{"ttyC13"}="i";
$tty{"ttyC14"}="i";
$tty{"ttyC15"}="i";
$tty{"ttyC16"}="i";
$tty{"ttyC24"}="i";
$tty{"ttyC25"}="i";

open(TTYS, "w -hs|cut -b 10-17|fgrep ttyC|");
while(<TTYS>) {
   chop;
   s/\s+//;
   if( $tty{"$_"} ) { 
       $isdn++;
   } else {
       $modem++;
   }
}
print "$modem\n";
print "$isdn\n";
print "0\n";
print "$my_name\n";
