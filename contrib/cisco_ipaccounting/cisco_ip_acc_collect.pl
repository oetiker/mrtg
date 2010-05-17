#!/usr/bin/perl

##############################################################################
#
# cisco_ip_acc_collect.pl 
# (c) 1999 by Dolphins Network Systems, Matthias Cramer <cramer@dolphins.ch>
#
# Licence: LGPL
#
##############################################################################
#
# This Script is very loosly based on whodo from Tony Farr
#
# This Script gets IP-accounting data from a Cisco Router
# In the network file you can define networks which you like to analyse.
#
# Special modules : Net::Netmask, SNMP_util
#
##############################################################################
#
# Version History
#  V0.9            First Public Release
#
##############################################################################


use Getopt::Std;
use File::Basename;
use Net::Netmask;
use strict;
use Socket;

# Adjust this path to where you MRTG resides, so that SNMP_util
# can be found.

use lib "/usr/local/mrtg";
use SNMP_util;

#
# Some variables to adjust.
#

# The write community of your router
my $HOST= 'writecommunity@router';

# Where is your network file
my $NETWORK = "/usr/local/mrtg/cisco_ipaccounting/networks";

# Where to write the accounting info
my $OUTDIR  = "/usr/local/mrtg/cisco_ipaccounting/";


# Below here you should have to be changed

my %network;
my %in;
my %out;

open (NET, $NETWORK);
my $line;
my $block;

while ($line = <NET>) {
  $line =~ /(.+?)[\s]+(.+)/;
  my $name = $2;
  $block=new Net::Netmask($1);
  $block->storeNetblock();
  $in{$block->base()}=0;
  $out{$block->base()}=0;
  $network{$name} .= $block->base() . ":";
}

&checkpoint_stats($HOST);
&get_stats($HOST);

# print "Base       \tIn\tOut\n";
#   print "$base\t$in{$base}\t$out{$base}\n";

foreach my $k_network (keys %network) {
   my @base = split(/:/, $network{$k_network});
   my $base_in = 0;
   my $base_out = 0;
   foreach my $i_base (@base) {
     $base_in  += $in{$i_base};
     $base_out += $out{$i_base};
   }

   open(OUT, ">$OUTDIR"."log_"."$k_network");

   print OUT "$base_in\n";
   print OUT "$base_out\n";
   print OUT "\n";
   print OUT "$k_network\n";

   close (OUT);
}

sub checkpoint_stats {
# Take a checkpoint on IP accounting on the given router & return the duration
# The checkpoint is done by doing a get  then a set on actCheckPoint
        my ($age);

        # Find how long since the last checkpoint
        ($age) = snmpget ($_[0], '1.3.6.1.4.1.9.2.4.8.0');
        warn "No actAge returned.\n" unless $age;

        # Check to see if we've lost any data
        ($_) = snmpget ($_[0], '1.3.6.1.4.1.9.2.4.6.0');
        warn "Accounting table overflow - $_ bytes lost.\n" if $_ > 0;

        # Do a new checkpoint
        ($_) = snmpget ($_[0], '1.3.6.1.4.1.9.2.4.11.0');
        die "No actCheckPoint returned.\n" unless defined;
        snmpset ($_[0], '1.3.6.1.4.1.9.2.4.11.0', 'integer', $_);
        $age;
}


sub get_stats {
# Summarise the checkpoint by destination network (not host).
# Summary is placed into %traffictab - a hash of hashes indexed by
# source device & destination network.

	my($src, $dst,$traffic);
	my @response = snmpwalk ($_[0], '1.3.6.1.4.1.9.2.4.9.1.4' );

	foreach $_ (@response) {
		/(\d+\.\d+\.\d+\.\d+)\.(\d+\.\d+\.\d+\.\d+):(\d+)/ ||
			die "Cannot parse response from walk.\n";
		$dst=$2;
		$src=$1;
		$traffic=$3;
		$block = findNetblock($src);
		if ($block) {
                   $out{$block->base()} += $traffic;
                }
		$block = findNetblock($dst);
		if ($block) {
                   $in{$block->base()} += $traffic;
                }
	}
}


