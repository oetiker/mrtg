#!/usr/bin/perl
# Displays disk info to the hosts that connect to it.
#
# No command line options, just put it in /etc/inetd.conf as shown in
# the README file.
#
# By Steven Micallef <smic@wire.net.au> on the 24/4/1999.

foreach $_ (`df -k | grep -v "Filesystem"`)
{
  ($device, $size, $used, $free, $percent, $mount) = split(/\s+/);
  chop($percent);
  print "$percent\n";
}
