#!c:\perl\bin

# dualpri.pl
#

#
# Created by  Eric Billeter 
# returns:
# Modems in use (value1)
# Chassis Capacity (value2)

use SNMP_Session;
use BER;
use Socket;
use strict;

%snmpget::OIDS = (  'value1' =>  '1.3.6.1.4.1.429.1.16.4.1.2',
                 );

my($community,$router) = split /\@/, $ARGV[0];
die <<USAGE  unless $community && $router;

USAGE: dualpri.pl 'SNMP_community'\@'aaa.bbb.ccc.ddd'

Where 'aaa.bbb.ccc.ddd' is the ip address for the Network Management Card.

USAGE


my($sysName,$sysUptime,$interfaces,$value1,$value2) =
    snmpgettable($router,$community,'value1');

exit(0);

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

        my $bulkindex = 3;
        while( $bulkindex < "96" ){     

        $tempo = substr ($value,$bulkindex,1);
        $bulkindex=$bulkindex+4;
        if( ord($tempo) eq '5' or ord($tempo) eq '3' or ord($tempo) eq '22' ){$value1=$value1 + 1 ;
                }
        if( ord($tempo) eq '2' or ord($tempo) eq '5' or ord($tempo) eq '3' or ord($tempo) eq '22' ){$value2=$value2 + 1 ;
                }
        }
      push @table, $tempo;
    } else {
      die "No answer from $ARGV[0]\n";
    }
    $enoid=$next_oid;
  }
  $session->close (); 
if( $value1 eq ''){$value1 = 0 };
if( $value2 eq ''){$value2 = 0 };
     print "$value1\n";
     print "$value2\n";
  return (@table);
}
