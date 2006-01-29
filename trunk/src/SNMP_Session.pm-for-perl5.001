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
### Tobias Oetiker <oetiker@ee.ethz.ch>
### Heine Peters <peters@dkrz.de>
######################################################################

package SNMP_Session;		

### The following two lines only work with Perl 5.002 or later.
### We leave them commented out until everybody has that, including NT
### users.  In addition, use strict doesn't work with the current code
### because of the file handle we construct.  We should really use
### FileHandle objects or something similar, but this seems to be
### somewhat in flux in Perl 5.
##use strict;
##use vars qw(@ISA);
use Socket;
use BER;

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

### `pack' template for AF_INET socket address.
### Should be removed in 5.002 or later.
my $sockaddr_in = 'S n a4 x8';

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
    my($this, $reqtype, @encoded_oids) = @_;
    my($request);

    # turn each of the encoded OIDs into an encoded pair of the OID
    # and a NULL.
    grep($_ = encode_sequence($_,encode_null()),@encoded_oids);

    ++$this->{request_id};
    $request = encode_tagged_sequence
	($reqtype,
	 encode_int ($this->{request_id}),
	 encode_int (0),
	 encode_int (0),
	 encode_sequence (@encoded_oids));
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
    return $this->request_response_3 ($this->encode_get_request (@oids), get_response);
}

sub getnext_request_response
{
    my($this) = shift;
    my(@oids) = @_;
    return $this->request_response_3 ($this->encode_getnext_request (@oids), get_response);
}

sub request_response_3
{
    my $this = shift;
    my $req = shift;
    my $response_tag = shift;
    my $retries = $this->retries;
    my $timeout = $this->timeout;

    $this->send_query ($req)
	|| die "send_query: $!";
    while ($retries > 0) {
	if ($this->wait_for_response($timeout)) {
	    my($response_length);

	    $response_length = $this->receive_response_1 ($response_tag);
	    if ($response_length) {
		return $response_length;
	    }
	} else {
	    ## No response received - retry
	    --$retries;
	    $timeout *= $this->backoff;
	    $this->send_query ($req)
		|| die "send_query: $!";
	}
    }
    0;
}

package SNMPv1_Session;

### The following two lines only work with Perl 5.002 or later.
### We leave them commented out until everybody has that, including NT
### users.  In addition, use strict doesn't work with the current code
### because of the file handle we construct.  We should really use
### FileHandle objects or something similar, but this seems to be
### somewhat in flux in Perl 5.
##use strict;
##use vars qw(@ISA);
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

    ## Should be replaced by the following in 5.002 or later:
    ## $remote_addr = inet_aton ($remote_hostname)
    ## 	   || die "inet_aton($remote_hostname) failed";
    ## $socket = 'SNMP'.sprintf ("%s:04x",
    ## 				 inet_ntoa ($remote_addr), $port);
    if ($remote_hostname =~ /^\d+\.\d+\.\d+\.\d+$/) {
	$remote_addr = pack('C4',split(/\./,$remote_hostname));
    } else {
	$remote_addr = (gethostbyname($remote_hostname))[4]
	    || die (host_not_found_error ($remote_hostname, $?));
    }
    $socket = 'SNMP'.sprintf ("%08x04x",
			      unpack ("N", $remote_addr), $port);
    ## end of pre-5.002 code

    (($name,$aliases,$udp_proto) = getprotobyname('udp'))
	unless $udp_proto;
    $udp_proto=17 unless $udp_proto;
    socket ($socket, PF_INET, SOCK_DGRAM, $udp_proto)
	|| die "socket: $!";
    ## Should be replaced by the following in 5.002 or later:
    ## $remote_addr = pack_sockaddr_in ($port, $remote_addr);
    $remote_addr = pack ($sockaddr_in, AF_INET, $port, $remote_addr);
    ## end of pre-5.002 code
    bless {
	'sock' => $socket,
	'sockfileno' => fileno ($socket),
	'community' => $community,
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

## Should be removed in 5.002 or later.
sub host_not_found_error
{
    my ($hostname, $h_errno) = @_;
    my ($message);

    $message = "host $hostname not found";
    return $message unless $?;
    return $message.": ".(('no such host', 'temporary name service failure',
			   'name service error', 'host has no address')[$?-1])
	if $? > 0 && $? < 5;
    return $message.", h_errno==".$?;
}

sub sock { $_[0]->{sock} }
sub sockfileno { $_[0]->{sockfileno} }
sub remote_addr { $_[0]->{remote_addr} }
sub pdu_buffer { $_[0]->{pdu_buffer} }
sub max_pdu_len { $_[0]->{max_pdu_len} }

sub close
{
    my($this) = shift;
    close ($this->sock) || die "close: $!";
}

sub wrap_request
{
    my($this) = shift;
    my($request) = shift;

    encode_sequence (encode_int ($this->snmp_version),
		     encode_string ($this->{community}),
		     $request);
}

sub unwrap_response_4
{
    my($this,$response,$tag,$request_id,$community,@rest);
    ($this,$response,$tag,$request_id) = @_;
    ($community,$request_id,@rest) = decode_by_template ($response, "%{%0i%s%*{%i%*i%*i%{%@", 
							   $tag,
							   $this->snmp_version (),
							   0);
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

sub receive_response_1
{
    my $this = shift;
    my $response_tag = shift;
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
    eval '@unwrapped = $this->unwrap_response_4 ($response, $response_tag, $this->{"request_id"})';
    if ($@ || !$unwrapped[0]) {
	return 0;
    }
    $this->{'unwrapped'} = \@unwrapped;
    return length $this->pdu_buffer;
}

sub pretty_address
{
    my($addr) = shift;
    ## Should be replaced by the following in 5.002 or later:
    ## my($port,$ipaddr) = unpack_sockaddr_in($addr);
    ## return sprintf ("[%s].%d",inet_ntoa($ipaddr),$port);
    my($family,$port,@ipaddr) = unpack($sockaddr_in,$addr);
    @ipaddr = unpack ('CCCC',$ipaddr[0]);
    return sprintf ("[%d.%d.%d.%d].%d",@ipaddr,$port);
    ## end of pre-5.002 code
}

sub describe
{
    my($this) = shift;

    printf "SNMP_Session: %s (size %d timeout %g)\n",
    &pretty_address ($this->remote_addr),$this->max_pdu_len,
    $this->timeout;
}

1;
