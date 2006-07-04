#!/usr/bin/perl

# PMLines.pl
#
# 1998/08/04

#
# Created by  Carlos.Canau@EUnet.pt with cfgmaker  from Tobias Oetiker
# <oetiker@ee.ethz.ch> as skeleton
#
# returns:
# #modems
# #isdn
# sysName
# sysUptime
#

# 1998/10/30
#
# Modified by Butch Kemper <kemper@tstar.net> to allow multiple PortMasters
# to be specified on the argument line and to output the totals.
#

# 1999/4/18
#
# Modified by Butch Kemper <kemper@tstar.net> to process PM2 systems and
# to distingish between async and isdn ports.
#
# Changed name to PM2lines.pl
#

# 1999/4/19
#
# Modified by Butch Kemper <kemper@tstar.net> to process both PM2 and PM3
# systems.
#
# Changed name to PMlines.pl
#


# 2000/9/5
#
# Modified by Robert Boyle (robert@tellurian.net) to work with 
# Lucent's VERY broken PM4 SNMP. Now uses modem number in use to determine if
# call is ISDN or analog. If modem = "M0" then call is ISDN 
# Not pretty, but it does work. Somone who is a better PERL programmer than I 
# may want to integrate these changes into the base PMlines.pl script and make
# determination of which method to use based on chassis type.
#
# Changed name to PM4lines.pl
#

# 2000/9/19
#
# Modified AGAIN by Robert Boyle (robert@tellurian.net) to work with 
# all Lucent Portmaster 2/3/4 chassis. Now uses port speed to determine if
# call is ISDN or analog. If speed is 56000 or 64000 then call is ISDN. 
# This may cause a false ISDN reading if someone has a perfect v.90 connection.
#
# Changed name back to PMlines.pl
#


use SNMP_Session;
use BER;
use Socket;
use strict;

%snmpget::OIDS = (  'sysName' => '1.3.6.1.2.1.1.5.0',
		    'sysUptime' => '1.3.6.1.2.1.1.3.0',
		    'ifNumber' =>  '1.3.6.1.2.1.2.1.0',
		    'PMip' => '1.3.6.1.4.1.307.3.2.1.1.1.14',
		    'PMty' => '1.3.6.1.4.1.307.3.2.1.1.1.11',
		);

my($tot_isdn,$tot_modems,$args) = (0,0,0);
my($input_string,$PROGNAME,$sysUptime,$sysName,$interfaces)="";
($PROGNAME = $0) =~ s/.*\///;

diexit(0) if $#ARGV < 0;

for ($args=0; $args < $#ARGV+1; $args++) {
   $input_string = $ARGV[$args];
   my($community,$router) = split /\@/, $input_string;

   diexit(0) unless $community && $router;

   ($sysName,$sysUptime,$interfaces) =
      snmpget($router,$community,'sysName','sysUptime','ifNumber');
   my @PMip = snmpgettable($router,$community,'PMip');
   my @PMty = snmpgettable($router,$community,'PMty');
   my ($i);

   for ($i=0; $i < $#PMip+1; $i++) 
         {

      if ($PMip[$i] ne "0.0.0.0") {
         if ($PMty[$i] ne "56000" and $PMty[$i] ne "64000") {
			$tot_modems++;
         }
         else {
            $tot_isdn++;
		 }
      }
   }
}

printf "$tot_modems\n";
printf "$tot_isdn\n";
printf "$sysUptime\n";
printf "$sysName\n";

exit(0);

sub diexit {
   die ("USAGE: $PROGNAME  community\@portmaster [community\@portmaster]" .
        " \.\.\.\n" .
        "       community   = snmp read community string\n" .
        "       portmaster  = FQN of PortMaster\n");
}

sub snmpget{
  my($host,$community,@vars) = @_;
  my(@enoid, $var,$response, $bindings, $binding, $value, $inoid,$outoid,
     $upoid,$oid,@retvals);
  foreach $var (@vars) {
    die "Unknown SNMP var $var\n"
      unless $snmpget::OIDS{$var};
    push @enoid,  encode_oid((split /\./, $snmpget::OIDS{$var}));
  }
  srand();
  my $session = SNMP_Session->open ($host ,
                                 $community,
                                 161);
  if ($session->get_request_response(@enoid)) {
    $response = $session->pdu_buffer;
    ($bindings) = $session->decode_get_response ($response);
    $session->close ();
    while ($bindings) {
      ($binding,$bindings) = decode_sequence ($bindings);
      ($oid,$value) = decode_by_template ($binding, "%O%@");
      my $tempo = pretty_print($value);
      $tempo=~s/\t/ /g;
      $tempo=~s/\n/ /g;
      $tempo=~s/^\s+//;
      $tempo=~s/\s+$//;

      push @retvals,  $tempo;
    }

    return (@retvals);
  } else {
    die "No answer from $input_string. You may be using the wrong community\n";
  }
}

sub snmpgettable{
  my($host,$community,$var) = @_;
  my($next_oid,$enoid,$orig_oid,
     $response, $bindings, $binding, $value, $inoid,$outoid,
     $upoid,$oid,@table,$tempo);
  die "Unknown SNMP var $var\n"
    unless $snmpget::OIDS{$var};

  $orig_oid = encode_oid(split /\./, $snmpget::OIDS{$var});
  $enoid=$orig_oid;
  srand();
  my $session = SNMP_Session->open ($host ,
                                 $community,
                                 161);
  for(;;)  {
    if ($session->getnext_request_response(($enoid))) {
      $response = $session->pdu_buffer;
      ($bindings) = $session->decode_get_response ($response);
      ($binding,$bindings) = decode_sequence ($bindings);
      ($next_oid,$value) = decode_by_template ($binding, "%O%@");
      # quit once we are outside the table
      last unless BER::encoded_oid_prefix_p($orig_oid,$next_oid);
      $tempo = pretty_print($value);
      #print "$var: '$tempo'\n";
      $tempo=~s/\t/ /g;
      $tempo=~s/\n/ /g;
      $tempo=~s/^\s+//;
      $tempo=~s/\s+$//;
      push @table, $tempo;

    } else {
      die "No answer from $input_string\n";
    }
    $enoid=$next_oid;
  }
  $session->close ();
  return (@table);
}
