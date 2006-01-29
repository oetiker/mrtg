#!/usr/bin/perl

# PM3Lines.pl
#

#
# Created by  Carlos.Canau@EUnet.pt with cfgmaker  from Tobias Oetiker
# <oetiker@ee.ethz.ch> as skeleton
#
# returns:
# #modems used
# #isdn lines used
# sysName
# sysUptime
#

use SNMP_Session;
use BER;
use Socket;
use strict;

%snmpget::OIDS = (  'sysName' => '1.3.6.1.2.1.1.5.0',
                    'sysUptime' => '1.3.6.1.2.1.1.3.0',
                    'ifNumber' =>  '1.3.6.1.2.1.2.1.0',
                    'PM3UP' => '1.3.6.1.4.1.307.3.2.1.1.1.13',
                 );


my($community,$router) = split /\@/, $ARGV[0];
die <<USAGE  unless $community && $router;

USAGE: PM3Lines.pl 'community'\@'portmaster'

EXAMPLE:  PM3Lines.pl public\@dial0

USAGE


my($sysName,$sysUptime,$interfaces) =
    snmpget($router,$community,
            'sysName',  'sysUptime',  'ifNumber');
my @PM3UP = snmpgettable($router,$community, 'PM3UP');

my($value, $modems) = (0,0);

while (scalar @PM3UP){
    $value = shift @PM3UP;
    if ($value) {
        $modems++;
    }
}

my($isdn) = ($interfaces - 1); # ethernet
$isdn -= 1; # D-channel ???
$isdn -= $modems;
if ($isdn < 0) {
    $isdn = 0;
}

printf "$modems\n";
printf "$isdn\n";
printf "$sysUptime\n";
printf "$sysName\n";

exit(0);



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
    die "No answer from $ARGV[0]. You may be using the wrong community\n";
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
      die "No answer from $ARGV[0]\n";
    }
    $enoid=$next_oid;
  }
  $session->close ();    
  return (@table);
}
