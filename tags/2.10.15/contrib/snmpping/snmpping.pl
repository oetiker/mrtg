#!/usr/sepp/bin/perl
use lib qw(../../run);
use BER;
require 'SNMP_Session.pm';

my $host = @ARGV[0];
my $community = @ARGV[1];
my $port = 161;

$session = SNMP_Session->open ($host, $community, $port) 
	|| die "couldn't open SNMP session to $host";

$oid1 = encode_oid (1, 3, 6, 1, 2, 1, 1, 1, 0);

if ($session->get_request_response ($oid1)) {
     ($bindings) = $session->decode_get_response($session->{pdu_buffer});
        while ($bindings ne '') {
        ($binding,$bindings) = &decode_sequence ($bindings);
        ($oid,$value) = &decode_by_template ($binding, "%O%@");
        print $pretty_oids{$oid}," => ",
        &pretty_print ($value), "\n";
        }
}
