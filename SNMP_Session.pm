# -*- mode: Perl -*-
######################################################################
### SNMP Request/Response Handling
######################################################################
### The abstract class SNMP_Session defines objects that can be used
### to communicate with SNMP entities.  It has methods to send
### requests to and receive responses from an agent.
###
### Currently it has one subclass, SNMPv1_Session, which implements
### the SNMPv1 protocol.
######################################################################
### Created by:  Simon Leinen  <simon@switch.ch>
###
### Contributions and fixes by:
###
### Matthew Trunnell <matter@media.mit.edu>
### Tobias Oetiker <oetiker@ee.ethz.ch>
### Heine Peters <peters@dkrz.de>
######################################################################

package SNMP_Session;		

require 5.002;

use strict qw(vars subs);	# cannot use strict subs here
				# because of the way we use
				# generated file handles
use Exporter;
use vars qw(@ISA $VERSION @EXPORT);
use Socket;
use BER;

$VERSION = '0.52';

@ISA = qw(Exporter);

@EXPORT = qw();

my $default_debug = 0;

### Default initial timeout (in seconds) waiting for a response PDU
### after a request is sent.  Note that when a request is retried, the
### timeout is increased by BACKOFF (see below).
###
my $default_timeout = 2.0;

### Default number of retries for each SNMP request.  If no response
### is received after TIMEOUT seconds, the request is resent and a new
### response awaited with a longer timeout (see the documentation on
### BACKOFF below).
###
my $default_retries = 5;

### Default backoff factor for SNMP_Session objects.  This factor is
### used to increase the TIMEOUT every time an SNMP request is
### retried.
###
my $default_backoff = 1.0;

sub get_request  { 0 | context_flag };
sub getnext_request  { 1 | context_flag };
sub get_response { 2 | context_flag };
sub set_request { 3 | context_flag };

sub standard_udp_port { 161 };

sub open
{
    return SNMPv1_Session::open (@_);
}

sub timeout { $_[0]->{timeout} }
sub retries { $_[0]->{retries} }
sub backoff { $_[0]->{backoff} }

sub encode_request
{
    my($this, $reqtype, @encoded_oids_or_pairs) = @_;
    my($request);

    ++$this->{request_id};
    grep ($_=(ref ($_) eq 'ARRAY'
	      ? &encode_sequence ($_->[0], $_->[1])
	      : &encode_sequence ($_, encode_null())),
	  @encoded_oids_or_pairs);
    $request = encode_tagged_sequence
	($reqtype,
	 encode_int ($this->{request_id}),
	 encode_int_0, encode_int_0,
	 encode_sequence (@encoded_oids_or_pairs));
    return $this->wrap_request ($request);
}

sub encode_get_request
{
    my($this, @oids) = @_;
    return encode_request ($this, get_request, @oids);
}

sub encode_getnext_request
{
    my($this, @oids) = @_;
    return encode_request ($this, getnext_request, @oids);
}

sub encode_set_request
{
    my($this, @encoded_pairs) = @_;
    return encode_request ($this, set_request, @encoded_pairs);
}

sub decode_get_response
{
    my($this, $response) = @_;
    my @rest;
    @{$this->{'unwrapped'}};
}

sub wait_for_response
{
    my($this) = shift;
    my($timeout) = shift || 10.0;
    my($rin,$win,$ein) = ('','','');
    my($rout,$wout,$eout);
    vec($rin,$this->sockfileno,1) = 1;
    select($rout=$rin,$wout=$win,$eout=$ein,$timeout);
}

sub get_request_response
{
    my($this) = shift;
    my(@oids) = @_;
    return $this->request_response_4 ($this->encode_get_request (@oids),
				      get_response, \@oids);
}

sub set_request_response
{
    my($this) = shift;
    my(@pairs) = @_;
    return $this->request_response_4 ($this->encode_set_request (@pairs),
				      get_response, \@pairs);
}

sub getnext_request_response
{
    my($this) = shift;
    my(@oids) = @_;
    return $this->request_response_4 ($this->encode_getnext_request (@oids),
				      get_response, \@oids);
}

sub request_response_4
{
    my $this = shift;
    my $req = shift;
    my $response_tag = shift;
    my $oids = shift;
    my $retries = $this->retries;
    my $timeout = $this->timeout;

    $this->send_query ($req)
	|| return $this->error ("send_query: $!");
    while ($retries > 0) {
	if ($this->wait_for_response($timeout)) {
	    my($response_length);

	    $response_length
		= $this->receive_response_2 ($response_tag, $oids);
	    if ($response_length) {
		return $response_length;
	    } else {
		return undef;
	    }
	} else {
	    ## No response received - retry
	    --$retries;
	    $timeout *= $this->backoff;
	    $this->send_query ($req)
		|| return $this->error ("send_query: $!");
	}
    }
    0;
}

sub version { $VERSION; }

package SNMPv1_Session;

use strict qw(vars subs);	# see above
use vars qw(@ISA);
use SNMP_Session;
use Socket;
use BER;

@ISA = qw(SNMP_Session);

sub snmp_version { 0 }

sub open
{
    my($this,$remote_hostname,$community,$port,$max_pdu_len) = @_;
    my($name,$aliases,$remote_addr,$socket);

    my $udp_proto = 0;

    $community = 'public' unless defined $community;
    $port = SNMP_Session::standard_udp_port unless defined $port;
    $max_pdu_len = 8000 unless defined $max_pdu_len;

    $remote_addr = inet_aton ($remote_hostname)
	|| return &error_return ($this."::open(\"$remote_hostname\",...): "
				 ."couldn't resolve host name to IP address");
    $socket = 'SNMP'.sprintf ("%s:04x", inet_ntoa ($remote_addr), $port);
    (($name,$aliases,$udp_proto) = getprotobyname('udp'))
	unless $udp_proto;
    $udp_proto=17 unless $udp_proto;
    socket ($socket, PF_INET, SOCK_DGRAM, $udp_proto)
	|| return &error_return ($this."::open(\"$remote_hostname\",...): socket: $!");
    $remote_addr = pack_sockaddr_in ($port, $remote_addr);
    bless {
	'sock' => $socket,
	'sockfileno' => fileno ($socket),
	'community' => $community,
	'remote_hostname' => $remote_hostname,
	'remote_addr' => $remote_addr,
	'max_pdu_len' => $max_pdu_len,
	'pdu_buffer' => '\0' x $max_pdu_len,
	'request_id' => int (rand 0x80000000 + rand 0xffff),
	'timeout' => $default_timeout,
	'retries' => $default_retries,
	'backoff' => $default_backoff,
	'debug' => $default_debug,
	};
}

sub sock { $_[0]->{sock} }
sub sockfileno { $_[0]->{sockfileno} }
sub remote_addr { $_[0]->{remote_addr} }
sub pdu_buffer { $_[0]->{pdu_buffer} }
sub max_pdu_len { $_[0]->{max_pdu_len} }

sub close
{
    my($this) = shift;
    close ($this->sock) || $this->error ("close: $!");
}

sub wrap_request
{
    my($this) = shift;
    my($request) = shift;

    encode_sequence (encode_int ($this->snmp_version),
		     encode_string ($this->{community}),
		     $request);
}

my @error_status_code = qw(noError tooBig noSuchName badValue readOnly
			   genErr noAccess wrongType wrongLength
			   wrongEncoding wrongValue noCreation
			   inconsistentValue resourceUnavailable
			   commitFailed undoFailed authorizationError
			   notWritable inconsistentName);

sub unwrap_response_5
{
    my($this,$response,$tag,$request_id,$oids,$community,@rest);
    my ($error_status,$error_index,$snmpver);
    ($this,$response,$tag,$request_id,$oids) = @_;
    ($snmpver,$community,$request_id,$error_status,$error_index,@rest)
	= decode_by_template ($response, "%{%i%s%*{%i%i%i%{%@",
			      $tag);
    return $this->error ("Received SNMP response with unknown snmp-version field $snmpver")
	unless $snmpver == $this->snmp_version;
    if ($error_status != 0 || $error_index != 0) {
	my ($oid, $errmsg);
	$errmsg = $error_status_code[$error_status] || $error_status;
	$oid = $oids->[$error_index-1]
	    if $error_index > 0 && $error_index-1 <= $#{$oids};
	$oid = $oid->[0]
	    if ref($oid) eq 'ARRAY';
	return $this->error ("Received SNMP response with error code\n"
				."  error status: $errmsg\n"
				."  index ".$error_index
				.(defined($oid)
				  ? " (OID: ".&BER::pretty_oid($oid).")"
				  : ""));
    }
    if ($this->{'debug'}) {
	warn "$community != $this->{community}"
	    unless $community eq $this->{community};
	warn "$request_id != $this->{request_id}"
	    unless $request_id == $this->{request_id};
    }
    return undef unless $community eq $this->{community};
    return undef unless $request_id == $this->{request_id};
    @rest;
}

sub send_query
{
    my($this) = shift;
    my($query) = shift;
    send ($this->sock,$query,0,$this->remote_addr);
}

sub receive_response_2
{
    my $this = shift;
    my $response_tag = shift;
    my $oids = shift;
    my($remote_addr);
    $remote_addr = recv ($this->sock,$this->{'pdu_buffer'},$this->max_pdu_len,0);
    return 0 unless $remote_addr;
    my $response = $this->{'pdu_buffer'};
    ##
    ## Check whether the response came from the address we've sent the
    ## request to.  If this is not the case, we should probably ignore
    ## it, as it may relate to another request.
    ##
    if ($this->{'debug'} && $remote_addr ne $this->{'remote_addr'}) {
	warn "Response came from ".&pretty_address ($remote_addr)
	    .", not ".&pretty_address($this->{'remote_addr'});
    }

    my @unwrapped = ();
    eval '@unwrapped = $this->unwrap_response_5 ($response, $response_tag, $this->{"request_id"}, $oids)';
    if ($@ || !$unwrapped[0]) {
	$this->{'unwrapped'} = undef;
	return 0;
    }
    $this->{'unwrapped'} = \@unwrapped;
    return length $this->pdu_buffer;
}

sub pretty_address
{
    my($addr) = shift;
    my($port,$ipaddr) = unpack_sockaddr_in($addr);
    return sprintf ("[%s].%d",inet_ntoa($ipaddr),$port);
}

sub describe
{
    my($this) = shift;
    print $this->to_string (),"\n";
}

sub to_string
{
    my($this) = shift;
    my ($class,$prefix);

    $class = ref($this);
    $prefix = ' ' x (length ($class) + 2);
    ($class." (remote host: \"".$this->{remote_hostname}
     ."\" ".&pretty_address ($this->remote_addr)."\n"
     .$prefix."  community: \"".$this->{'community'}."\"\n"
     .$prefix." request ID: ".$this->{'request_id'}."\n"
     .$prefix."PDU bufsize: ".$this->{'max_pdu_len'}." bytes\n"
     .$prefix."    timeout: ".$this->{timeout}."s\n"
     .$prefix."    retries: ".$this->{retries}."\n"
     .$prefix."    backoff: ".$this->{backoff}.")");
##    sprintf ("SNMP_Session: %s (size %d timeout %g)",
##	       &pretty_address ($this->remote_addr),$this->max_pdu_len,
##	       $this->timeout);
}

sub error_return
{
    my $message = shift;
    $message =~ s/^/  /mg;
    warn ("Error:\n".$message."\n");
    return undef;
}

sub error
{
    my $this = shift;
    my $message = shift;
    my $session = $this->to_string;
    $session =~ s/^/  /mg;
    $message =~ s/^/  /mg;
    warn ("SNMP Error:\n".$message."\n".$session."\n");
    return undef;
}

1;
