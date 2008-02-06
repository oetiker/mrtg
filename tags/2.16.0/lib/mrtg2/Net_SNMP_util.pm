### - *- mode: Perl -*-
######################################################################
### Net_SNMP_util -- SNMP utilities using Net::SNMP
######################################################################
### Copyright (c) 2005-2007 Mike Mitchell.
###
### This program is free software; you can redistribute it under the
### "Artistic License" included in this distribution (file "Artistic").
######################################################################
### Created by:  Mike Mitchell   <Mike.Mitchell@sas.com>
###
### Contributions and fixes by:
###
### Laszlo Herczeg <laszlo.herczeg@austinenergy.com>
###	ignore unimplemented SNMP_Session.pm options
###
### Daniel McDonald <dmcdonald@digicontech.com>
### 	make sure snmpwalk_flg stops when last instance in table is fetched
###
### Alexander Kozlov <avk@post.eao.ru>
###	Leave snmpwalk_flg early if no OIDs are returned
######################################################################

package Net_SNMP_util;

=head1 NAME

Net_SNMP_util - SNMP utilities based on Net::SNMP

=head1 SYNOPSIS

The Net_SNMP_util module implements SNMP utilities using the Net::SNMP module.
It implements snmpget, snmpgetnext, snmpwalk, snmpset, snmptrap, and
snmpgetbulk.  The Net_SNMP_util module assumes that the user has a basic
understanding of the Simple Network Management Protocol and related network
management concepts.

=head1 DESCRIPTION

The Net_SNMP_util module simplifies SNMP queries even more than Net::SNMP  
alone.  Easy-to-use "get", "getnext", "walk", "set", "trap", and "getbulk"
routines are provided, hiding all the details of a SNMP query.

=cut

# ==========================================================================

use strict;

## Validate the version of Perl

BEGIN
{
    die('Perl version 5.6.0 or greater is required') if ($] < 5.006);
}

## Handle importing/exporting of symbols

use vars qw( @ISA @EXPORT $VERSION $ErrorMessage);
use Exporter;

our @ISA = qw( Exporter );

our @EXPORT = qw(
    snmpget snmpgetnext snmpwalk snmpset snmptrap snmpgetbulk snmpmaptable
    snmpmaptable4 snmpwalkhash snmpmapOID snmpMIB_to_OID snmpLoad_OID_Cache
    snmpQueue_MIB_File ErrorMessage
);

## Version of the Net_SNMP_util module

our $VERSION = v1.0.15;

use Carp;

use Net::SNMP v5.0;

# The OID numbers from RFC1213 (MIB-II) and RFC1315 (Frame Relay)
# are pre-loaded below.
%Net_SNMP_util::OIDS = 
  (
    'iso' => '1',
    'org' => '1.3',
    'dod' => '1.3.6',
    'internet' => '1.3.6.1',
    'directory' => '1.3.6.1.1',
    'mgmt' => '1.3.6.1.2',
    'mib-2' => '1.3.6.1.2.1',
    'system' => '1.3.6.1.2.1.1',
    'sysDescr' => '1.3.6.1.2.1.1.1.0',
    'sysObjectID' => '1.3.6.1.2.1.1.2.0',
    'sysUpTime' => '1.3.6.1.2.1.1.3.0',
    'sysUptime' => '1.3.6.1.2.1.1.3.0',
    'sysContact' => '1.3.6.1.2.1.1.4.0',
    'sysName' => '1.3.6.1.2.1.1.5.0',
    'sysLocation' => '1.3.6.1.2.1.1.6.0',
    'sysServices' => '1.3.6.1.2.1.1.7.0',
    'interfaces' => '1.3.6.1.2.1.2',
    'ifNumber' => '1.3.6.1.2.1.2.1.0',
    'ifTable' => '1.3.6.1.2.1.2.2',
    'ifEntry' => '1.3.6.1.2.1.2.2.1',
    'ifIndex' => '1.3.6.1.2.1.2.2.1.1',
    'ifInOctets' => '1.3.6.1.2.1.2.2.1.10',
    'ifInUcastPkts' => '1.3.6.1.2.1.2.2.1.11',
    'ifInNUcastPkts' => '1.3.6.1.2.1.2.2.1.12',
    'ifInDiscards' => '1.3.6.1.2.1.2.2.1.13',
    'ifInErrors' => '1.3.6.1.2.1.2.2.1.14',
    'ifInUnknownProtos' => '1.3.6.1.2.1.2.2.1.15',
    'ifOutOctets' => '1.3.6.1.2.1.2.2.1.16',
    'ifOutUcastPkts' => '1.3.6.1.2.1.2.2.1.17',
    'ifOutNUcastPkts' => '1.3.6.1.2.1.2.2.1.18',
    'ifOutDiscards' => '1.3.6.1.2.1.2.2.1.19',
    'ifDescr' => '1.3.6.1.2.1.2.2.1.2',
    'ifOutErrors' => '1.3.6.1.2.1.2.2.1.20',
    'ifOutQLen' => '1.3.6.1.2.1.2.2.1.21',
    'ifSpecific' => '1.3.6.1.2.1.2.2.1.22',
    'ifType' => '1.3.6.1.2.1.2.2.1.3',
    'ifMtu' => '1.3.6.1.2.1.2.2.1.4',
    'ifSpeed' => '1.3.6.1.2.1.2.2.1.5',
    'ifPhysAddress' => '1.3.6.1.2.1.2.2.1.6',
    'ifAdminHack' => '1.3.6.1.2.1.2.2.1.7',  
    'ifAdminStatus' => '1.3.6.1.2.1.2.2.1.7',
    'ifOperHack' => '1.3.6.1.2.1.2.2.1.8',             
    'ifOperStatus' => '1.3.6.1.2.1.2.2.1.8',
    'ifLastChange' => '1.3.6.1.2.1.2.2.1.9',
    'at' => '1.3.6.1.2.1.3',
    'atTable' => '1.3.6.1.2.1.3.1',
    'atEntry' => '1.3.6.1.2.1.3.1.1',
    'atIfIndex' => '1.3.6.1.2.1.3.1.1.1',
    'atPhysAddress' => '1.3.6.1.2.1.3.1.1.2',
    'atNetAddress' => '1.3.6.1.2.1.3.1.1.3',
    'ip' => '1.3.6.1.2.1.4',
    'ipForwarding' => '1.3.6.1.2.1.4.1',
    'ipOutRequests' => '1.3.6.1.2.1.4.10',
    'ipOutDiscards' => '1.3.6.1.2.1.4.11',
    'ipOutNoRoutes' => '1.3.6.1.2.1.4.12',
    'ipReasmTimeout' => '1.3.6.1.2.1.4.13',
    'ipReasmReqds' => '1.3.6.1.2.1.4.14',
    'ipReasmOKs' => '1.3.6.1.2.1.4.15',
    'ipReasmFails' => '1.3.6.1.2.1.4.16',
    'ipFragOKs' => '1.3.6.1.2.1.4.17',
    'ipFragFails' => '1.3.6.1.2.1.4.18',
    'ipFragCreates' => '1.3.6.1.2.1.4.19',
    'ipDefaultTTL' => '1.3.6.1.2.1.4.2',
    'ipAddrTable' => '1.3.6.1.2.1.4.20',
    'ipAddrEntry' => '1.3.6.1.2.1.4.20.1',
    'ipAdEntAddr' => '1.3.6.1.2.1.4.20.1.1',
    'ipAdEntIfIndex' => '1.3.6.1.2.1.4.20.1.2',
    'ipAdEntNetMask' => '1.3.6.1.2.1.4.20.1.3',
    'ipAdEntBcastAddr' => '1.3.6.1.2.1.4.20.1.4',
    'ipAdEntReasmMaxSize' => '1.3.6.1.2.1.4.20.1.5',
    'ipRouteTable' => '1.3.6.1.2.1.4.21',
    'ipRouteEntry' => '1.3.6.1.2.1.4.21.1',
    'ipRouteDest' => '1.3.6.1.2.1.4.21.1.1',
    'ipRouteAge' => '1.3.6.1.2.1.4.21.1.10',
    'ipRouteMask' => '1.3.6.1.2.1.4.21.1.11',
    'ipRouteMetric5' => '1.3.6.1.2.1.4.21.1.12',
    'ipRouteInfo' => '1.3.6.1.2.1.4.21.1.13',
    'ipRouteIfIndex' => '1.3.6.1.2.1.4.21.1.2',
    'ipRouteMetric1' => '1.3.6.1.2.1.4.21.1.3',
    'ipRouteMetric2' => '1.3.6.1.2.1.4.21.1.4',
    'ipRouteMetric3' => '1.3.6.1.2.1.4.21.1.5',
    'ipRouteMetric4' => '1.3.6.1.2.1.4.21.1.6',
    'ipRouteNextHop' => '1.3.6.1.2.1.4.21.1.7',
    'ipRouteType' => '1.3.6.1.2.1.4.21.1.8',
    'ipRouteProto' => '1.3.6.1.2.1.4.21.1.9',
    'ipNetToMediaTable' => '1.3.6.1.2.1.4.22',
    'ipNetToMediaEntry' => '1.3.6.1.2.1.4.22.1',
    'ipNetToMediaIfIndex' => '1.3.6.1.2.1.4.22.1.1',
    'ipNetToMediaPhysAddress' => '1.3.6.1.2.1.4.22.1.2',
    'ipNetToMediaNetAddress' => '1.3.6.1.2.1.4.22.1.3',
    'ipNetToMediaType' => '1.3.6.1.2.1.4.22.1.4',
    'ipRoutingDiscards' => '1.3.6.1.2.1.4.23',
    'ipInReceives' => '1.3.6.1.2.1.4.3',
    'ipInHdrErrors' => '1.3.6.1.2.1.4.4',
    'ipInAddrErrors' => '1.3.6.1.2.1.4.5',
    'ipForwDatagrams' => '1.3.6.1.2.1.4.6',
    'ipInUnknownProtos' => '1.3.6.1.2.1.4.7',
    'ipInDiscards' => '1.3.6.1.2.1.4.8',
    'ipInDelivers' => '1.3.6.1.2.1.4.9',
    'icmp' => '1.3.6.1.2.1.5',
    'icmpInMsgs' => '1.3.6.1.2.1.5.1',
    'icmpInTimestamps' => '1.3.6.1.2.1.5.10',
    'icmpInTimestampReps' => '1.3.6.1.2.1.5.11',
    'icmpInAddrMasks' => '1.3.6.1.2.1.5.12',
    'icmpInAddrMaskReps' => '1.3.6.1.2.1.5.13',
    'icmpOutMsgs' => '1.3.6.1.2.1.5.14',
    'icmpOutErrors' => '1.3.6.1.2.1.5.15',
    'icmpOutDestUnreachs' => '1.3.6.1.2.1.5.16',
    'icmpOutTimeExcds' => '1.3.6.1.2.1.5.17',
    'icmpOutParmProbs' => '1.3.6.1.2.1.5.18',
    'icmpOutSrcQuenchs' => '1.3.6.1.2.1.5.19',
    'icmpInErrors' => '1.3.6.1.2.1.5.2',
    'icmpOutRedirects' => '1.3.6.1.2.1.5.20',
    'icmpOutEchos' => '1.3.6.1.2.1.5.21',
    'icmpOutEchoReps' => '1.3.6.1.2.1.5.22',
    'icmpOutTimestamps' => '1.3.6.1.2.1.5.23',
    'icmpOutTimestampReps' => '1.3.6.1.2.1.5.24',
    'icmpOutAddrMasks' => '1.3.6.1.2.1.5.25',
    'icmpOutAddrMaskReps' => '1.3.6.1.2.1.5.26',
    'icmpInDestUnreachs' => '1.3.6.1.2.1.5.3',
    'icmpInTimeExcds' => '1.3.6.1.2.1.5.4',
    'icmpInParmProbs' => '1.3.6.1.2.1.5.5',
    'icmpInSrcQuenchs' => '1.3.6.1.2.1.5.6',
    'icmpInRedirects' => '1.3.6.1.2.1.5.7',
    'icmpInEchos' => '1.3.6.1.2.1.5.8',
    'icmpInEchoReps' => '1.3.6.1.2.1.5.9',
    'tcp' => '1.3.6.1.2.1.6',
    'tcpRtoAlgorithm' => '1.3.6.1.2.1.6.1',
    'tcpInSegs' => '1.3.6.1.2.1.6.10',
    'tcpOutSegs' => '1.3.6.1.2.1.6.11',
    'tcpRetransSegs' => '1.3.6.1.2.1.6.12',
    'tcpConnTable' => '1.3.6.1.2.1.6.13',
    'tcpConnEntry' => '1.3.6.1.2.1.6.13.1',
    'tcpConnState' => '1.3.6.1.2.1.6.13.1.1',
    'tcpConnLocalAddress' => '1.3.6.1.2.1.6.13.1.2',
    'tcpConnLocalPort' => '1.3.6.1.2.1.6.13.1.3',
    'tcpConnRemAddress' => '1.3.6.1.2.1.6.13.1.4',
    'tcpConnRemPort' => '1.3.6.1.2.1.6.13.1.5',
    'tcpInErrs' => '1.3.6.1.2.1.6.14',
    'tcpOutRsts' => '1.3.6.1.2.1.6.15',
    'tcpRtoMin' => '1.3.6.1.2.1.6.2',
    'tcpRtoMax' => '1.3.6.1.2.1.6.3',
    'tcpMaxConn' => '1.3.6.1.2.1.6.4',
    'tcpActiveOpens' => '1.3.6.1.2.1.6.5',
    'tcpPassiveOpens' => '1.3.6.1.2.1.6.6',
    'tcpAttemptFails' => '1.3.6.1.2.1.6.7',
    'tcpEstabResets' => '1.3.6.1.2.1.6.8',
    'tcpCurrEstab' => '1.3.6.1.2.1.6.9',
    'udp' => '1.3.6.1.2.1.7',
    'udpInDatagrams' => '1.3.6.1.2.1.7.1',
    'udpNoPorts' => '1.3.6.1.2.1.7.2',
    'udpInErrors' => '1.3.6.1.2.1.7.3',
    'udpOutDatagrams' => '1.3.6.1.2.1.7.4',
    'udpTable' => '1.3.6.1.2.1.7.5',
    'udpEntry' => '1.3.6.1.2.1.7.5.1',
    'udpLocalAddress' => '1.3.6.1.2.1.7.5.1.1',
    'udpLocalPort' => '1.3.6.1.2.1.7.5.1.2',
    'egp' => '1.3.6.1.2.1.8',
    'egpInMsgs' => '1.3.6.1.2.1.8.1',
    'egpInErrors' => '1.3.6.1.2.1.8.2',
    'egpOutMsgs' => '1.3.6.1.2.1.8.3',
    'egpOutErrors' => '1.3.6.1.2.1.8.4',
    'egpNeighTable' => '1.3.6.1.2.1.8.5',
    'egpNeighEntry' => '1.3.6.1.2.1.8.5.1',
    'egpNeighState' => '1.3.6.1.2.1.8.5.1.1',
    'egpNeighStateUps' => '1.3.6.1.2.1.8.5.1.10',
    'egpNeighStateDowns' => '1.3.6.1.2.1.8.5.1.11',
    'egpNeighIntervalHello' => '1.3.6.1.2.1.8.5.1.12',
    'egpNeighIntervalPoll' => '1.3.6.1.2.1.8.5.1.13',
    'egpNeighMode' => '1.3.6.1.2.1.8.5.1.14',
    'egpNeighEventTrigger' => '1.3.6.1.2.1.8.5.1.15',
    'egpNeighAddr' => '1.3.6.1.2.1.8.5.1.2',
    'egpNeighAs' => '1.3.6.1.2.1.8.5.1.3',
    'egpNeighInMsgs' => '1.3.6.1.2.1.8.5.1.4',
    'egpNeighInErrs' => '1.3.6.1.2.1.8.5.1.5',
    'egpNeighOutMsgs' => '1.3.6.1.2.1.8.5.1.6',
    'egpNeighOutErrs' => '1.3.6.1.2.1.8.5.1.7',
    'egpNeighInErrMsgs' => '1.3.6.1.2.1.8.5.1.8',
    'egpNeighOutErrMsgs' => '1.3.6.1.2.1.8.5.1.9',
    'egpAs' => '1.3.6.1.2.1.8.6',
    'transmission' => '1.3.6.1.2.1.10',
    'frame-relay' => '1.3.6.1.2.1.10.32',
    'frDlcmiTable' => '1.3.6.1.2.1.10.32.1',
    'frDlcmiEntry' => '1.3.6.1.2.1.10.32.1.1',
    'frDlcmiIfIndex' => '1.3.6.1.2.1.10.32.1.1.1',
    'frDlcmiState' => '1.3.6.1.2.1.10.32.1.1.2',
    'frDlcmiAddress' => '1.3.6.1.2.1.10.32.1.1.3',
    'frDlcmiAddressLen' => '1.3.6.1.2.1.10.32.1.1.4',
    'frDlcmiPollingInterval' => '1.3.6.1.2.1.10.32.1.1.5',
    'frDlcmiFullEnquiryInterval' => '1.3.6.1.2.1.10.32.1.1.6',
    'frDlcmiErrorThreshold' => '1.3.6.1.2.1.10.32.1.1.7',
    'frDlcmiMonitoredEvents' => '1.3.6.1.2.1.10.32.1.1.8',
    'frDlcmiMaxSupportedVCs' => '1.3.6.1.2.1.10.32.1.1.9',
    'frDlcmiMulticast' => '1.3.6.1.2.1.10.32.1.1.10',
    'frCircuitTable' => '1.3.6.1.2.1.10.32.2',
    'frCircuitEntry' => '1.3.6.1.2.1.10.32.2.1',
    'frCircuitIfIndex' => '1.3.6.1.2.1.10.32.2.1.1',
    'frCircuitDlci' => '1.3.6.1.2.1.10.32.2.1.2',
    'frCircuitState' => '1.3.6.1.2.1.10.32.2.1.3',
    'frCircuitReceivedFECNs' => '1.3.6.1.2.1.10.32.2.1.4',
    'frCircuitReceivedBECNs' => '1.3.6.1.2.1.10.32.2.1.5',
    'frCircuitSentFrames' => '1.3.6.1.2.1.10.32.2.1.6',
    'frCircuitSentOctets' => '1.3.6.1.2.1.10.32.2.1.7',
    'frOutOctets' => '1.3.6.1.2.1.10.32.2.1.7',
    'frCircuitReceivedFrames' => '1.3.6.1.2.1.10.32.2.1.8',
    'frCircuitReceivedOctets' => '1.3.6.1.2.1.10.32.2.1.9',
    'frInOctets' => '1.3.6.1.2.1.10.32.2.1.9',
    'frCircuitCreationTime' => '1.3.6.1.2.1.10.32.2.1.10',
    'frCircuitLastTimeChange' => '1.3.6.1.2.1.10.32.2.1.11',
    'frCircuitCommittedBurst' => '1.3.6.1.2.1.10.32.2.1.12',
    'frCircuitExcessBurst' => '1.3.6.1.2.1.10.32.2.1.13',
    'frCircuitThroughput' => '1.3.6.1.2.1.10.32.2.1.14',
    'frErrTable' => '1.3.6.1.2.1.10.32.3',
    'frErrEntry' => '1.3.6.1.2.1.10.32.3.1',
    'frErrIfIndex' => '1.3.6.1.2.1.10.32.3.1.1',
    'frErrType' => '1.3.6.1.2.1.10.32.3.1.2',
    'frErrData' => '1.3.6.1.2.1.10.32.3.1.3',
    'frErrTime' => '1.3.6.1.2.1.10.32.3.1.4',
    'frame-relay-globals' => '1.3.6.1.2.1.10.32.4',
    'frTrapState' => '1.3.6.1.2.1.10.32.4.1',
    'snmp' => '1.3.6.1.2.1.11',
    'snmpInPkts' => '1.3.6.1.2.1.11.1',
    'snmpInBadValues' => '1.3.6.1.2.1.11.10',
    'snmpInReadOnlys' => '1.3.6.1.2.1.11.11',
    'snmpInGenErrs' => '1.3.6.1.2.1.11.12',
    'snmpInTotalReqVars' => '1.3.6.1.2.1.11.13',
    'snmpInTotalSetVars' => '1.3.6.1.2.1.11.14',
    'snmpInGetRequests' => '1.3.6.1.2.1.11.15',
    'snmpInGetNexts' => '1.3.6.1.2.1.11.16',
    'snmpInSetRequests' => '1.3.6.1.2.1.11.17',
    'snmpInGetResponses' => '1.3.6.1.2.1.11.18',
    'snmpInTraps' => '1.3.6.1.2.1.11.19',
    'snmpOutPkts' => '1.3.6.1.2.1.11.2',
    'snmpOutTooBigs' => '1.3.6.1.2.1.11.20',
    'snmpOutNoSuchNames' => '1.3.6.1.2.1.11.21',
    'snmpOutBadValues' => '1.3.6.1.2.1.11.22',
    'snmpOutGenErrs' => '1.3.6.1.2.1.11.24',
    'snmpOutGetRequests' => '1.3.6.1.2.1.11.25',
    'snmpOutGetNexts' => '1.3.6.1.2.1.11.26',
    'snmpOutSetRequests' => '1.3.6.1.2.1.11.27',
    'snmpOutGetResponses' => '1.3.6.1.2.1.11.28',
    'snmpOutTraps' => '1.3.6.1.2.1.11.29',
    'snmpInBadVersions' => '1.3.6.1.2.1.11.3',
    'snmpEnableAuthenTraps' => '1.3.6.1.2.1.11.30',
    'snmpInBadCommunityNames' => '1.3.6.1.2.1.11.4',
    'snmpInBadCommunityUses' => '1.3.6.1.2.1.11.5',
    'snmpInASNParseErrs' => '1.3.6.1.2.1.11.6',
    'snmpInTooBigs' => '1.3.6.1.2.1.11.8',
    'snmpInNoSuchNames' => '1.3.6.1.2.1.11.9',
    'ifName' => '1.3.6.1.2.1.31.1.1.1.1',
    'ifInMulticastPkts' => '1.3.6.1.2.1.31.1.1.1.2',
    'ifInBroadcastPkts' => '1.3.6.1.2.1.31.1.1.1.3',
    'ifOutMulticastPkts' => '1.3.6.1.2.1.31.1.1.1.4',
    'ifOutBroadcastPkts' => '1.3.6.1.2.1.31.1.1.1.5',
    'ifHCInOctets' => '1.3.6.1.2.1.31.1.1.1.6',
    'ifHCInUcastPkts' => '1.3.6.1.2.1.31.1.1.1.7',
    'ifHCInMulticastPkts' => '1.3.6.1.2.1.31.1.1.1.8',
    'ifHCInBroadcastPkts' => '1.3.6.1.2.1.31.1.1.1.9',
    'ifHCOutOctets' => '1.3.6.1.2.1.31.1.1.1.10',
    'ifHCOutUcastPkts' => '1.3.6.1.2.1.31.1.1.1.11',
    'ifHCOutMulticastPkts' => '1.3.6.1.2.1.31.1.1.1.12',
    'ifHCOutBroadcastPkts' => '1.3.6.1.2.1.31.1.1.1.13',
    'ifLinkUpDownTrapEnable' => '1.3.6.1.2.1.31.1.1.1.14',
    'ifHighSpeed' => '1.3.6.1.2.1.31.1.1.1.15',
    'ifPromiscuousMode' => '1.3.6.1.2.1.31.1.1.1.16',
    'ifConnectorPresent' => '1.3.6.1.2.1.31.1.1.1.17',
    'ifAlias' => '1.3.6.1.2.1.31.1.1.1.18',
    'ifCounterDiscontinuityTime' => '1.3.6.1.2.1.31.1.1.1.19',
    'experimental' => '1.3.6.1.3',
    'private' => '1.3.6.1.4',
    'enterprises' => '1.3.6.1.4.1',
  );

# GIL
my %revOIDS = ();	# Reversed %Net_SNMP_util::OIDS hash
my $RevNeeded = 1;

undef $Net_SNMP_util::Host;
undef $Net_SNMP_util::Session;
undef $Net_SNMP_util::Version;
undef $Net_SNMP_util::LHost;
undef $Net_SNMP_util::IPv4only;
undef $Net_SNMP_util::ContextEngineID;
undef $Net_SNMP_util::ContextName;
$Net_SNMP_util::Debug = 0;
$Net_SNMP_util::SuppressWarnings = 0;
$Net_SNMP_util::CacheFile = "OID_cache.txt";
$Net_SNMP_util::CacheLoaded = 0;
$Net_SNMP_util::ReturnArrayRefs = 0;
$Net_SNMP_util::ReturnHashRefs = 0;
$Net_SNMP_util::MaxRepetitions = 12;

### Prototypes
sub snmpget ($@);
sub snmpgetnext ($@);
sub snmpopen ($$$);
sub snmpwalk ($@);
sub snmpwalk_flg ($$@);
sub snmpset ($@);
sub snmptrap ($$$$$@);
sub snmpgetbulk ($$$@);
sub snmpwalkhash ($$@);
sub toOID (@);
sub snmpmapOID (@);
sub snmpMIB_to_OID ($);
sub Check_OID ($);
sub snmpLoad_OID_Cache ($);
sub snmpQueue_MIB_File (@);
sub ASNtype ($);
sub error_msg ($);
sub MIB_fill_OID ($);

sub version () { $VERSION; }

=head1 Option Notes

=over

=item host Parameter

SNMP parameters can be specified as part of the hostname/ip address passed
as the first argument.  The syntax is

    community@host:port:timeout:retries:backoff:version

If the community is left off, it defaults to "public".
If the port is left off, it defaults to 161 for everything but snmptrap().
The snmptrap() routine uses a default port of 162.
Timeout and retries defaults to whatever Net::SNMP uses, currently 5.0 seconds
and 1 retry (2 tries total).
The backoff parameter is currently unimplemented.
The version parameter defaults to SNMP version 1.  Some SNMP values such as
64-bit counters have to be queried using SNMP version 2.  Specifying "2" or
"2c" as the version parameter will accomplish this.  The snmpgetbulk routine
is only supported in SNMP version 2 and higher.  Additional security features
are available under SNMP version 3.

Some machines have additional security features that only allow SNMP
queries to come from certain IP addresses.  If the host doing the query
has multiple interfaces, it may be necessary to specify the interface
the query should come from.  The port parameter is further broken down into

    remote_port!local_address!local_port

Here are some examples:

    somehost
    somehost:161
    somehost:161!192.168.2.4!4000  use 192.168.2.4 and port 4000 as source
    somehost:!192.168.2.4          use 192.168.2.4 as source
    somehost:!!4000                use port 4000 as source

Most people will only need to use the first form ("somehost").

=item OBJECT IDENTIFIERs

To further simplify SNMP queries, the query routines use a small table that
maps the textual representation of OBJECT IDENTIFIERs to their dotted notation.
The OBJECT IDENTIFIERs from RFC1213 (MIB-II) and RFC1315 (Frame Relay) are
preloaded.  This allows OBJECT IDENTIFIERs like "ifInOctets.4" to be used
instead of the more cumbersome "1.3.6.1.2.1.2.2.1.10.4".

Several functions are provided to manage the mapping table.  Mapping entries
can be added directly, SNMP MIB files can be read, and a cache file with the
text-to-OBJECT-IDENTIFIER mappings are maintained.  By default, the file
"OID_cache.txt" is loaded, but it can by changed by setting the variable
$Net_SNMP_util::CacheFile to the desired file name.  The functions to
manipulate the mappings are:

    snmpmapOID			Add a textual OID mapping directly
    snmpMIB_to_OID		Read a SNMP MIB file
    snmpLoad_OID_Cache		Load an OID-mapping cache file
    snmpQueue_MIB_File		Queue a SNMP MIB file for loading on demand

=item Net::SNMP extensions

This module is built on top of Net::SNMP.  Net::SNMP has a different method
of specifying SNMP parameters.  To support this different method, this module
will accept an optional hash reference containing the SNMP parameters. The
hash may contain the following:

	[-port		=> $port,]
	[-localaddr	=> $localaddr,]
	[-localport     => $localport,]
	[-version       => $version,]
	[-domain        => $domain,]
	[-timeout       => $seconds,]
	[-retries       => $count,]
	[-maxmsgsize    => $octets,]
	[-debug         => $bitmask,]
	[-community     => $community,]   # v1/v2c  
	[-username      => $username,]    # v3
	[-authkey	=> $authkey,]     # v3  
	[-authpassword  => $authpasswd,]  # v3  
	[-authprotocol  => $authproto,]   # v3  
	[-privkey       => $privkey,]     # v3  
	[-privpassword  => $privpasswd,]  # v3  
	[-privprotocol  => $privproto,]   # v3
	[-contextengineid => $engine_id,] # v3 
	[-contextname     => $name,]      # v3

Please see the documentation for Net::SNMP for a description of these
parameters.

=item SNMPv3 Arguments

A SNMP context is a collection of management information accessible by a SNMP 
entity.  An item of management information may exist in more than one context 
and a SNMP entity potentially has access to many contexts.  The combination of 
a contextEngineID and a contextName unambiguously identifies a context within 
an administrative domain.  In a SNMPv3 message, the contextEngineID and 
contextName are included as part of the scopedPDU.  All methods that generate 
a SNMP message optionally take a B<-contextengineid> and B<-contextname> 
argument to configure these fields.

=over

=item Context Engine ID

The B<-contextengineid> argument expects a hexadecimal string representing
the desired contextEngineID.  The string must be 10 to 64 characters (5 to 
32 octets) long and can be prefixed with an optional "0x".  Once the 
B<-contextengineid> is specified it stays with the object until it is changed 
again or reset to default by passing in the undefined value.  By default, the 
contextEngineID is set to match the authoritativeEngineID of the authoritative
SNMP engine.

=item Context Name

The contextName is passed as a string which must be 0 to 32 octets in length 
using the B<-contextname> argument.  The contextName stays with the object 
until it is changed.  The contextName defaults to an empty string which 
represents the "default" context.

=back

=back

=cut

# [public methods] ---------------------------------------------------

=head1 Functions

=head2 snmpget() - send a SNMP get-request to the remote agent

    @result = snmpget(
		[community@]host[:port[:timeout[:retries[:backoff[:version]]]]],
		[\%param_hash],
		@oids
	    );

This function performs a SNMP get-request query to gather data from the remote
agent on the host specified.  The message is built using the list of OBJECT
IDENTIFIERs passed as an array.  Each OBJECT IDENTIFIER is placed into a single
SNMP GetRequest-PDU in the same order that it held in the original list.

The requested values are returned in an array in the same order as they were
requested.  In scalar context the first requested value is returned.

=cut

#
# snmpget.
#
sub snmpget ($@) {
  my($host, @vars) = @_;
  my($session, @enoid, %args, $ret, $oid, @retvals);

  $session = &snmpopen($host, 0, \@vars);
  if (!defined($session)) {
    carp "SNMPGET Problem for $host"
      unless ($Net_SNMP_util::SuppressWarnings > 1);
    return undef;
  }

  @enoid = &toOID(@vars);
  return undef unless defined $enoid[0];

  $args{'-varbindlist'} = \@enoid;
  if ($Net_SNMP_util::Version > 2) {
    $args{'-contextengineid'} = $Net_SNMP_util::ContextEngineID
      if (defined($Net_SNMP_util::ContextEngineID));
    $args{'-contextname'} = $Net_SNMP_util::ContextName
      if (defined($Net_SNMP_util::ContextName));
  }

  $ret = $session->get_request(%args);

  if ($ret) {
      foreach $oid (@enoid) {
      push @retvals, $ret->{$oid} if (exists($ret->{$oid}));
    }
    return wantarray ? @retvals : $retvals[0];
  }
  $ret = join(' ', @vars);
  error_msg("SNMPGET Problem for $ret on ${host}: " . $session->error());
  return undef;
}

=head2 snmpgetnext() - send a SNMP get-next-request to the remote agent

    @result = snmpgetnext(
		[community@]host[:port[:timeout[:retries[:backoff[:version]]]]],
		[\%param_hash],
		@oids
	    );

This function performs a SNMP get-next-request query to gather data from the
remote agent on the host specified.  The message is built using the list of
OBJECT IDENTIFIERs passed as an array.  Each OBJECT IDENTIFIER is placed into a
single SNMP GetNextRequest-PDU in the same order that it held in the original
list.

The requested values are returned in an array in the same order as they were
requested.  The OBJECT IDENTIFIER number is added as a prefix to each value
using a colon as a separator, like '1.3.6.1.2.1.2.2.1.2.1:ethernet'.
In scalar context the first requested value is returned.

=cut

#
# snmpgetnext.
#
sub snmpgetnext ($@) {
  my($host, @vars) = @_;
  my($session, @enoid, %args, $ret, $oid, @retvals);

  $session = &snmpopen($host, 0, \@vars);
  if (!defined($session)) {
    carp "SNMPGETNEXT Problem for $host"
      unless ($Net_SNMP_util::SuppressWarnings > 1);
    return undef;
  }

  @enoid = &toOID(@vars);
  return undef unless defined $enoid[0];

  $args{'-varbindlist'} = \@enoid;
  if ($Net_SNMP_util::Version > 2) {
    $args{'-contextengineid'} = $Net_SNMP_util::ContextEngineID
      if (defined($Net_SNMP_util::ContextEngineID));
    $args{'-contextname'} = $Net_SNMP_util::ContextName
      if (defined($Net_SNMP_util::ContextName));
  }

  $ret = $session->get_next_request(%args);

  if ($ret) {
      foreach $oid (@enoid) {
      push @retvals, $oid . ':' . $ret->{$oid} if (exists($ret->{$oid}));
    }
    return wantarray ? @retvals : $retvals[0];
  }
  $ret = join(' ', @vars);
  error_msg("SNMPGETNEXT Problem for $ret on ${host}: " . $session->error());
  return undef;
}

=head2 snmpgetbulk() - send a SNMP get-bulk-request to the remote agent

    @result = snmpgetbulk(
		[community@]host[:port[:timeout[:retries[:backoff[:version]]]]],
		$nonrepeaters,
		$maxrepetitions,
		[\%param_hash],
		@oids
	    );

This function performs a SNMP get-bulk-request query to gather data from the
remote agent on the host specified.

=over

=item *

The B<$nonrepeaters> value specifies the number of variables in the @oids list
for which a single successor is to be returned.  If it is null or undefined,
a value of 0 is used.

=item *

The B<$maxrepetitions> value specifies the number of successors to be returned
for the remaining variables in the @oids list.  If it is null or undefined,
the default value of 12 is used.

=item *

The message is built using the list of
OBJECT IDENTIFIERs passed as an array.  Each OBJECT IDENTIFIER is placed into a
single SNMP GetNextRequest-PDU in the same order that it held in the original
list.

=back

The requested values are returned in an array in the same order as they were
requested.

B<NOTE:> This function can only be used when the SNMP version is set to
SNMPv2c or SNMPv3.

=cut

#
# snmpgetbulk.
#
sub snmpgetbulk ($$$@) {
  my($host, $nr, $mr, @vars) = @_;
  my($session, %args, @enoid, $ret);
  my($oid, @retvals);

  $session = &snmpopen($host, 0, \@vars);
  if (!defined($session)) {
    carp "SNMPGETBULK Problem for $host"
      unless ($Net_SNMP_util::SuppressWarnings > 1);
    return undef;
  }

  if ($Net_SNMP_util::Version < 2) {
    carp "SNMPGETBULK Problem for $host : must use SNMP version > 1"
      unless ($Net_SNMP_util::SuppressWarnings > 1);
    return undef;
  }

  $args{'-nonrepeaters'} = $nr if ($nr > 0);
  $mr = $Net_SNMP_util::MaxRepetitions if ($mr <= 0);
  $args{'-maxrepetitions'} = $mr;

  if ($Net_SNMP_util::Version > 2) {
    $args{'-contextengineid'} = $Net_SNMP_util::ContextEngineID
      if (defined($Net_SNMP_util::ContextEngineID));
    $args{'-contextname'} = $Net_SNMP_util::ContextName
      if (defined($Net_SNMP_util::ContextName));
  }

  @enoid = &toOID(@vars);
  return undef unless defined $enoid[0];

  $args{'-varbindlist'} = \@enoid;
  $ret = $session->getbulk_request(%args);

  if ($ret) {
    @enoid = &Net::SNMP::oid_lex_sort(keys %$ret);
    foreach $oid (@enoid) {
      push @retvals, $oid . ":" . $ret->{$oid};
    }
    return (@retvals);
  } else {
    $ret = join(' ', @vars);
    error_msg("SNMPGETBULK Problem for $ret on ${host}: " . $session->error());
    return undef;
  }
}


=head2 snmpwalk() - walk OBJECT IDENTIFIER tree(s) on the remote agent

    @result = snmpwalk(
		[community@]host[:port[:timeout[:retries[:backoff[:version]]]]],
		[\%param_hash],
		@oids
	    );

This function performs a sequence of SNMP get-next-request or get-bulk-request
(if the SNMP version is 2 or higher) queries to gather data from the remote
agent on the host specified.  The initial message is built using the list of
OBJECT IDENTIFIERs passed as an array.  Each OBJECT IDENTIFIER is placed into a
single SNMP GetNextRequest-PDU in the same order that it held in the original
list.  Queries continue until all the returned OBJECT IDENTIFIERs are no longer
a child of the base OBJECT IDENTIFIERs.

The requested values are returned in an array in the same order as they were
requested.  The OBJECT IDENTIFIER number is added as a prefix to each value
using a colon as a separator, like '1.3.6.1.2.1.2.2.1.2.1:ethernet'.  If only
one OBJECT IDENTIFIER is requested, just the "instance" part of the OBJECT
IDENTIFIER is added as a prefix, like '1:ethernet', '2:ethernet', '3:fddi'.

=cut

#
# snmpwalk.
#
sub snmpwalk ($@) {
  my($host, @vars) = @_;
  return(&snmpwalk_flg($host, undef, @vars));
}

=head2 snmpset() - send a SNMP set-request to the remote agent

    @result = snmpset(
		[community@]host[:port[:timeout[:retries[:backoff[:version]]]]],
		[\%param_hash],
		$oid1, $type1, $value1,
		[$oid2, $type2, $value2 ...]
	    );

This function is used to modify data on the remote agent using a SNMP
set-request.  The message is built using the list of values consisting of groups
of an OBJECT IDENTIFIER, an object type, and the actual value to be set.
The object type can be one of the following strings:

    integer | int
    string | octetstring | octet string
    oid | object id | object identifier
    ipaddr | ip addr4ess
    timeticks
    uint | uinteger | uinteger32 | unsigned int | unsigned integer | unsigned integer32
    counter | counter 32
    counter64
    gauge | gauge32

The object type may also be an octet corresponding to the ASN.1 type.  See
the Net::SNMP documentation for more information.

The requested values are returned in an array in the same order as they were
requested.  In scalar context the first requested value is returned.

=cut

#
# snmpset.
#
sub snmpset($@) {
  my($host, @vars) = @_;
  my($session, @vals, %args, $ret);
  my($oid, $type, $value, @enoid, @retvals);

  $session = &snmpopen($host, 0, \@vars);
  if (!defined($session)) {
    carp "SNMPSET Problem for $host"
      unless ($Net_SNMP_util::SuppressWarnings > 1);
    return undef;
  }

  if ($Net_SNMP_util::Version > 2) {
    $args{'-contextengineid'} = $Net_SNMP_util::ContextEngineID
      if (defined($Net_SNMP_util::ContextEngineID));
    $args{'-contextname'} = $Net_SNMP_util::ContextName
      if (defined($Net_SNMP_util::ContextName));
  }

  while(@vars) {
    ($oid) = toOID((shift @vars));
    $ret   = shift @vars;
    $value = shift @vars;
    $type  = ASNtype($ret);
    if (!defined($type)) {
      carp "Unknown SNMP type: $type\n"
	unless ($Net_SNMP_util::SuppressWarnings > 1);
    }
    push @vals, $oid, $type, $value;
    push @enoid, $oid;
  }
  return undef unless defined $vals[0];

  $args{'-varbindlist'} = \@vals;

  $ret = $session->set_request(%args);
  if ($ret) {
      foreach $oid (@enoid) {
      push @retvals, $ret->{$oid} if (exists($ret->{$oid}));
    }
    return wantarray ? @retvals : $retvals[0];
  }
  $ret = join(' ', @enoid);
  error_msg("SNMPSET Problem for $ret on ${host}: " . $session->error());
  return undef;
}

=head2 snmptrap() - send a SNMP trap to the remote manager

    @result = snmptrap(
		[community@]host[:port[:timeout[:retries[:backoff[:version]]]]],
		$enterprise,
		$agentaddr,
		$generictrap,
		$specifictrap,
		[\%param_hash],
		$oid1, $type1, $value1, 
		[$oid2, $type2, $value2 ...]
	    );

This function sends a SNMP trap to the remote manager on the host specified.
The message is built using the list of values consisting of groups of an
OBJECT IDENTIFIER, an object type, and the actual value to be set.
The object type can be one of the following strings:

    integer | int
    string | octetstring | octet string
    oid | object id | object identifier
    ipaddr | ip addr4ess
    timeticks
    uint | uinteger | uinteger32 | unsigned int | unsigned integer | unsigned integer32
    counter | counter 32
    counter64
    gauge | gauge32

The object type may also be an octet corresponding to the ASN.1 type.  See
the Net::SNMP documentation for more information.

A true value is returned if sending the trap is successful.  The undefined value
is returned when a failure has occurred.

When the trap is sent as SNMPv2c, the B<$enterprise>, B<$agentaddr>,
B<$generictrap>, and B<$specifictrap> arguments are ignored.  Furthermore,
the first two (oid, type, value) tuples should be:

=over

=item *

sysUpTime.0 - ('1.3.6.1.2.1.1.3.0', 'timeticks', $timeticks)

=item *

snmpTrapOID.0 - ('1.3.6.1.6.3.1.1.4.1.0', 'oid', $oid)

=back

B<NOTE:> This function can only be used when the SNMP version is set to
SNMPv1 or SNMPv2c.

=cut

#
# Send an SNMP trap
#
sub snmptrap($$$$$@) {
  my($host, $ent, $agent, $gen, $spec, @vars) = @_;
  my($oid, $type, $value, $ret, @enoid, @vals);
  my($session, %args);

  $session = &snmpopen($host, 1, \@vars);
  if (!defined($session)) {
    carp "SNMPTRAP Problem for $host"
      unless ($Net_SNMP_util::SuppressWarnings > 1);
    return undef;
  }

  if ($Net_SNMP_util::Version == 1) {
    $args{'-enterprise'} = $ent if (defined($ent) and (length($ent) > 0));
    $args{'-agentaddr'} = $agent if (defined($agent) and (length($agent) > 0));
    $args{'-generictrap'} = $gen if (defined($gen) and (length($gen) > 0));
    $args{'-specifictrap'} = $spec if (defined($spec) and (length($spec) > 0));
  } elsif ($Net_SNMP_util::Version > 2) {
    carp "SNMPTRAP Problem for $host : must use SNMP version 1 or 2"
      unless ($Net_SNMP_util::SuppressWarnings > 1);
  }

  while(@vars) {
    ($oid) = toOID((shift @vars));
    $ret   = shift @vars;
    $value = shift @vars;
    $type  = ASNtype($ret);
    if (!defined($type)) {
      carp "unknown SNMP type: $type"
	unless ($Net_SNMP_util::SuppressWarnings > 1);
    }
    push @vals, $oid, $type, $value;
    push @enoid, $oid;
  }
  return undef unless defined $vals[0];

  $args{'-varbindlist'} = \@vals;

  if ($Net_SNMP_util::Version == 1) {
    $ret = $session->trap_request(%args);
  } else {
    $ret = $session->snmpv2_trap(%args);
  }

  if (!$ret) {
    $ret = join(' ', @enoid);
    error_msg("SNMPTRAP Problem for $ret on ${host}: " . $session->error());
  }
  return $ret;
}

=head2 snmpmaptable() - walk OBJECT IDENTIFIER tree(s) on the remote agent

    $result = snmpmaptable(
		[community@]host[:port[:timeout[:retries[:backoff[:version]]]]],
		\&function,
		[\%param_hash],
		@oids
	    );

This function performs a sequence of SNMP get-next-request or get-bulk-request
(if the SNMP version is 2 or higher) queries to gather data from the remote
agent on the host specified.  The initial message is built using the list of
OBJECT IDENTIFIERs passed as an array.  Each OBJECT IDENTIFIER is placed into a
single SNMP GetNextRequest-PDU in the same order that it held in the original
list.  Queries continue until all the returned OBJECT IDENTIFIERs are no longer
a child of the base OBJECT IDENTIFIERs.  The OBJECT IDENTIFIERs must correspond
to column entries for a conceptual row in a table.  They may however be columns
in different tables as long as each table is indexed the same way.

=over

=item *

The B<\&function> argument will be called once per row of the table.  It
will be passed the row index as a partial OBJECT IDENTIFIER in dotted notation,
e.g. "1.3" or "10.0.1.34", and the values of the requested table columns in
that row.

=back

The number of rows in the table is returned on success.  The undefined value
is returned when a failure has occurred.

=cut

#
# walk a table, calling a user-supplied function for each
# column of a table.
#
sub snmpmaptable($$@) {
  my($host, $fun, @vars) = @_;
  return snmpmaptable4($host, $fun, 0, @vars);
}

=head2 snmpmaptable4() - walk OBJECT IDENTIFIER tree(s) on the remote agent

    $result = snmpmaptable4(
		[community@]host[:port[:timeout[:retries[:backoff[:version]]]]],
		\&function,
		$maxrepetitions,
		[\%param_hash],
		@oids
	    );

This function performs a sequence of SNMP get-next-request or get-bulk-request
(if the SNMP version is 2 or higher) queries to gather data from the remote
agent on the host specified.  The initial message is built using the list of
OBJECT IDENTIFIERs passed as an array.  Each OBJECT IDENTIFIER is placed into a
single SNMP GetNextRequest-PDU in the same order that it held in the original
list.  Queries continue until all the returned OBJECT IDENTIFIERs are no longer
a child of the base OBJECT IDENTIFIERs.  The OBJECT IDENTIFIERs must correspond
to column entries for a conceptual row in a table.  They may however be columns
in different tables as long as each table is indexed the same way.

=over

=item *

The B<\&function> argument will be called once per row of the table.  It
will be passed the row index as a partial OBJECT IDENTIFIER in dotted notation,
e.g. "1.3" or "10.0.1.34", and the values of the requested table columns in
that row.

=item *

The B<$maxrepetitions> argument specifies the number of rows to be returned
by a single get-bulk-request.  If it is null or undefined, the default value
of 12 is used.

=back

The number of rows in the table is returned on success.  The undefined value
is returned when a failure has occurred.

=cut

sub snmpmaptable4($$$@) {
  my($host, $fun, $max_reps, @vars) = @_;
  my($session, @enoid, %args, $ret);
  my($oid, $soid, $toid, $inst, @row, $nr);

  $session = &snmpopen($host, 0, \@vars);
  if (!defined($session)) {
    carp "SNMPMAPTABLE Problem for $host"
      unless ($Net_SNMP_util::SuppressWarnings > 1);
    return undef;
  }

  @enoid = toOID(@vars);
  return undef unless defined $enoid[0];

  if ($Net_SNMP_util::Version > 1) {
    $max_reps = $Net_SNMP_util::MaxRepetitions if ($max_reps <= 0);
    $args{'-maxrepetitions'} = $max_reps;
  }
  if ($Net_SNMP_util::Version > 2) {
    $args{'-contextengineid'} = $Net_SNMP_util::ContextEngineID
      if (defined($Net_SNMP_util::ContextEngineID));
    $args{'-contextname'} = $Net_SNMP_util::ContextName
      if (defined($Net_SNMP_util::ContextName));
  }

  $args{'-columns'} = \@enoid;

  $ret = $session->get_entries(%args);

  if ($ret) {
    $soid = $enoid[0];
    $nr = 0;
    foreach $oid (&Net::SNMP::oid_lex_sort(keys %$ret)) {
      if (&Net::SNMP::oid_base_match($soid, $oid)) {
	$inst = substr($oid, length($soid)+1);
	undef @row;
	foreach $toid (@enoid) {
	  push @row, $ret->{$toid . "." . $inst};
	}
	&$fun($inst, @row);
	$nr++;
      } else {
	return($nr) if ($nr > 0);
      }
    }
    return($nr);
  } else {
    $ret = join(' ', @vars);
    error_msg("SNMPMAPTABLE Problem for $ret on ${host}: " . $session->error());
    return undef;
  }
}

=head2 snmpwalkhash() - send a SNMP get-next-request to the remote agent

    @result = snmpwalkhash(
		[community@]host[:port[:timeout[:retries[:backoff[:version]]]]],
		\&function(),
		[\%param_hash],
		@oids,
		[\%hash]
	    );

This function performs a sequence of SNMP get-next-request or get-bulk-request
(if the SNMP version is 2 or higher) queries to gather data from the remote
agent on the host specified.  The message is built using the list of
OBJECT IDENTIFIERs passed as an array.  Each OBJECT IDENTIFIER is placed into a
single SNMP GetNextRequest-PDU in the same order that it held in the original
list.  Queries continue until all the returned OBJECT IDENTIFIERs are outside
of the tree specified by the initial OBJECT IDENTIFIERs.

The B<\&function> is called once for every returned value.  It is passed a
reference to a hash, the hostname, the textual OBJECT IDENTIFIER, the
dotted-numberic OBJECT IDENTIFIER, the instance, the value and the requested
textual OBJECT IDENTIFIER.  That function can customize the result so the
values can be extracted later by hosts, by oid_names, by oid_numbers,
by instances... like these:

    $hash{$host}{$name}{$inst} = $value;
    $hash{$host}{$oid}{$inst} = $value;
    $hash{$name}{$inst} = $value;
    $hash{$oid}{$inst} = $value;
    $hash{$oid . '.' . $ints} = $value;
    $hash{$inst} = $value;
    ...

If the last argument to B<snmpwalkhash> is a reference to a hash, that hash
reference is passed to the passed-in function instead of a local hash
reference.  That way the function can look up other objects unrelated
to the current invocation of B<snmpwalkhash>.

The snmpwalkhash routine returns the hash.

=cut

#
# Walk the MIB, putting everything you find into hashes.
#
sub snmpwalkhash($$@) {
#  my($host, $hash_sub, @vars) = @_;
  return(&snmpwalk_flg( @_ ));
}


=head2 snmpmapOID() - add texual OBJECT INDENTIFIER mapping

    snmpmapOID(
	$text1, $oid1,
	[ $text2, $oid2 ...]
    );

This routine adds entries to the table that maps textual representation of
OBJECT IDENTIFIERs to their dotted notation.  For example, 

    snmpmapOID('ciscoCPU', '1.3.6.1.4.1.9.9.109.1.1.1.1.5.1');

allows the string 'ciscoCPU' to be used as an OBJECT IDENTIFIER in any SNMP
query routine.

This routine doesn't return anything.

=cut

#
#  Add passed-in text, OID pairs to the OID mapping table.
#
sub snmpmapOID(@)
{
  my(@vars) = @_;
  my($oid, $txt);

  $Net_SNMP_util::ErrorMessage = '';
  while($#vars >= 0) {
    $txt = shift @vars;
    $oid = shift @vars;

    next unless($txt =~ /^[a-zA-Z][\w\-]*(\.[a-zA-Z][\w\-])*$/);
    next unless($oid =~ /^\d+(\.\d+)*$/);

    $Net_SNMP_util::OIDS{$txt} = $oid;
    $RevNeeded = 1;
    print "snmpmapOID: $txt => $oid\n" if $Net_SNMP_util::Debug;
  }

  return undef;
}

=head2 snmpLoad_OID_Cache() - Read a file of cached OID mappings

    $result = snmpLoad_OID_Cache(
		$file
    );

This routine opens the file named by the B<$file> argument and reads it.
The file should contain text, OBJECT IDENTIFIER pairs, one pair
per line.  It adds the pairs as entries to the table that maps textual
representation of OBJECT IDENTIFIERs to their dotted notation.
Blank lines and anything after a '#' or between '--' is ignored.

This routine returns 0 on success and -1 if the B<$file> could not be opened.

=cut

#
# Open the passed-in file name and read it in to populate
# the cache of text-to-OID map table.  It expects lines
# with two fields, the first the textual string like "ifInOctets",
# and the second the OID value, like "1.3.6.1.2.1.2.2.1.10".
#
# blank lines and anything after a '#' or between '--' is ignored.
#
sub snmpLoad_OID_Cache ($) {
  my($arg) = @_;
  my($txt, $oid);

  $Net_SNMP_util::ErrorMessage = '';
  if (!open(CACHE, $arg)) {
    error_msg("snmpLoad_OID_Cache: Can't open ${arg}: $!");
    return -1;
  }

  while(<CACHE>) {
    s/#.*//;				# '#' starts a comment
    s/--.*--//g;			# comment delimited by '--', like MIBs
    s/--.*//;				# comment started by '--'
    next if (/^$/);
    next unless (/\s/);			# must have whitespace as separator
    chomp;
    ($txt, $oid) = split(' ', $_, 2);
    $txt = $1 if ($txt =~ /^[\'\"](.*)[\'\"]/);
    $oid = $1 if ($oid =~ /^[\'\"](.*)[\'\"]/);
    if (($txt =~ /^\.?\d+(\.\d+)*\.?$/)
    and  ($oid !~ /^\.?\d+(\.\d+)*\.?$/)) {
	my($a) = $oid;
	$oid = $txt;
	$txt = $a;
    }
    $oid =~ s/^\.//;
    $oid =~ s/\.$//;
    &snmpmapOID($txt, $oid);
  }
  close(CACHE);
  return 0;
}

=head2 snmpMIB_to_OID() - Read a MIB file for textual OID mappings

    $result = snmpMIB_to_OID(
		$file
    );

This routine opens the file named by the B<$file> argument and reads it.
The file should be an SNMP Management Information Base (MIB) file
that describes OBJECT IDENTIFIERs supported by an SNMP agent.
per line.  It adds the textual representation of the OBJECT IDENTIFIERs
to the text-to-OID mapping table.

This routine returns the number of entries added to the table or -1 if
the B<$file> could not be opened.

=cut

#
# Read in the passed MIB file, parsing it
# for their text-to-OID mappings
#
sub snmpMIB_to_OID ($) {
  my($arg) = @_;
  my($cnt, $quote, $buf, %tOIDs, $tgot);
  my($var, @parts, $strt, $indx, $ind, $val);

  $Net_SNMP_util::ErrorMessage = '';
  if (!open(MIB, $arg)) {
    error_msg("snmpMIB_to_OID: Can't open ${arg}: $!");
    return -1;
  }
  print "snmpMIB_to_OID: loading $arg\n" if $Net_SNMP_util::Debug;
  $cnt = 0;
  $quote = 0;
  $tgot = 0;
  $buf = '';
  while(<MIB>) {
    if ($quote) {
      next unless /"/;
      $quote = 0;
    } else {
	s/--.*--//g;		# throw away comments (-- anything --)
	s/^\s*--.*//;		# throw away comments at start of line
    }
    chomp;

    $buf .= ' ' . $_;

    $buf =~ s/"[^"]*"//g;
    if ($buf =~ /"/) {
      $quote = 1;
      next;
    }
    $buf =~ s/--.*--//g;	# throw away comments (-- anything --)
    $buf =~ s/--.*//;		# throw away comments (-- anything EOL)
    $buf =~ s/\s+/ /g;
    if ($buf =~ /DEFINITIONS *::= *BEGIN/) {
	$cnt += MIB_fill_OID(\%tOIDs) if ($tgot);
	$buf = '';
	%tOIDs = ();
	$tgot = 0;
	next;
    }
    $buf =~ s/OBJECT-TYPE/OBJECT IDENTIFIER/;
    $buf =~ s/OBJECT-IDENTITY/OBJECT IDENTIFIER/;
    $buf =~ s/OBJECT-GROUP/OBJECT IDENTIFIER/;
    $buf =~ s/MODULE-IDENTITY/OBJECT IDENTIFIER/;
    $buf =~ s/ IMPORTS .*\;//;
    $buf =~ s/ SEQUENCE *{.*}//;
    $buf =~ s/ SYNTAX .*//;
    $buf =~ s/ [\w\-]+ *::= *OBJECT IDENTIFIER//;
    $buf =~ s/ OBJECT IDENTIFIER.*::= *{/ OBJECT IDENTIFIER ::= {/;

    if ($buf =~ / ([\w\-]+) OBJECT IDENTIFIER *::= *{([^}]+)}/) {
      $var = $1;
      $buf = $2;
      $buf =~ s/ +$//;
      $buf =~ s/\s+\(/\(/g;	# remove spacing around '('
      $buf =~ s/\(\s+/\(/g;
      $buf =~ s/\s+\)/\)/g;	# remove spacing before ')'
      @parts = split(' ', $buf);
      $strt = '';
      foreach $indx (@parts) {
	if ($indx =~ /([\w\-]+)\((\d+)\)/) {
	  $ind = $1;
	  $val = $2;
	  if (exists($tOIDs{$strt})) {
	    $tOIDs{$ind} = $tOIDs{$strt} . '.' . $val;
	  } elsif ($strt ne '') {
	    $tOIDs{$ind} = "${strt}.${val}";
	  } else {
	    $tOIDs{$ind} = $val;
	  }
	  $strt = $ind;
	  $tgot = 1;
	} elsif ($indx =~ /^\d+$/) {
	  if (exists($tOIDs{$strt})) {
	    $tOIDs{$var} = $tOIDs{$strt} . '.' . $indx;
	  } else {
	    $tOIDs{$var} = "${strt}.${indx}";
	  }
	  $tgot = 1;
	} else {
	  $strt = $indx;
	}
      }
      $buf = '';
    }
  }
  $cnt += MIB_fill_OID(\%tOIDs) if ($tgot);
  $RevNeeded = 1 if ($cnt > 0);
  return $cnt;
}

=head2 snmpQueue_MIB_File() - queue a MIB file for reading "on demand"

    snmpQueue_MIB_File(
	$file1,
	[$file2, ...]
    );

This routine queues the list of SNMP MIB files for later processing.
Whenever a text-to-OBJECT IDENTIFIER lookup fails, the list of queued MIB
files is consulted.  If it isn't empty, the first MIB file in the list is
removed and passed to B<snmpMIB_to_OID()>.  The lookup is attempted again,
and if that still fails the next MIB file in the list is removed and passed
to B<snmpMIB_to_OID()>. This process continues until the lookup succeeds
or the list is exhausted.

This routine doesn't return anything.

=cut

#
# Save the passed-in list of MIB files until an OID can't be
# found in the existing table.  At that time the MIB file will
# be loaded, and the lookup attempted again.
#
sub snmpQueue_MIB_File (@) {
  my(@files) = @_;
  my($file);

  $Net_SNMP_util::ErrorMessage = '';
  foreach $file (@files) {
    push(@Net_SNMP_util::MIB_Files, $file);
  }
}

# [private methods] -------------------------------------

#
# Start an snmp session
#
sub snmpopen ($$$) {
  my($host, $type, $vars) = @_;
  my($nhost, $port, $community, $lhost, $lport, $nlhost);
  my($timeout, $retries, $backoff, $version, $v4onlystr);
  my($opts, %args, $tmp, $sess);
  my($debug, $maxmsgsize);

  $type = 0 if (!defined($type));
  $community = "public";
  $nlhost = "";

  ($community, $host) = ($1, $2) if ($host =~ /^(.*)@([^@]+)$/);

  # We can't split on the : character because a numeric IPv6
  # address contains a variable number of :'s
  if( ($host =~ /^(\[.*\]):(.*)$/) or ($host =~ /^(\[.*\])$/) ) {
    # Numeric IPv6 address between []
    ($host, $opts) = ($1, $2);
  } else {
    # Hostname or numeric IPv4 address
    ($host, $opts) = split(':', $host, 2);
  }
  ($port, $timeout, $retries, $backoff, $version, $v4onlystr)
    = split(':', $opts, 6) if(defined($opts) and (length $opts > 0) );

  undef($timeout) if (defined($timeout) and length($timeout) <= 0);
  undef($retries) if (defined($retries) and length($retries) <= 0);
  undef($backoff) if (defined($backoff) and length($backoff) <= 0);
  undef($version) if (defined($version) and length($version) <= 0);

  $v4onlystr = "" unless defined $v4onlystr;

  if (defined($port) and ($port =~ /^([^!]*)!(.*)$/)) {
    ($port, $lhost) = ($1, $2);
    $nlhost = $lhost;
    ($lhost, $lport) = ($1, $2) if ($lhost =~ /^(.*)!(.*)$/);
    undef($lport) if (defined($lport) and (length($lport) <= 0));
  }
  undef($port) if (defined($port) and length($port) <= 0);

  if (ref $vars->[0] eq 'HASH') {
    undef($debug);
    undef($maxmsgsize);
    undef $Net_SNMP_util::ContextEngineID;
    undef $Net_SNMP_util::ContextName;
    $opts = shift @$vars;
    foreach $type (keys %$opts) {
      if ($type =~ /^-?return_array_refs$/i) {
	$Net_SNMP_util::ReturnArrayRefs = $opts->{$type};
      } elsif ($type =~ /^-?return_hash_refs$/i) {
	$Net_SNMP_util::ReturnHashRefs = $opts->{$type};
      } elsif ($type =~ /^-?contextengineid$/i) {
	$Net_SNMP_util::ContextEngineID = $opts->{$type};
      } elsif ($type =~ /^-?contextname$/i) {
	$Net_SNMP_util::ContextName = $opts->{$type};
      } elsif ($type =~ /^-?maxrepetitions$/i) {
	$Net_SNMP_util::MaxRepetitions = $opts->{$type};
      } elsif ($type =~ /^-?default_max_repetitions$/i) {
	$Net_SNMP_util::MaxRepetitions = $opts->{$type};
      } elsif ($type =~ /^-?version$/i) {
	$version = $opts->{$type};
      } elsif ($type =~ /^-?port$/i) {
	$port = $opts->{$type};
      } elsif ($type =~ /^-?localaddr$/i) {
	$lhost = $opts->{$type};
      } elsif ($type =~ /^-?community$/i) {
	$community = $opts->{$type};
      } elsif ($type =~ /^-?timeout$/i) {
	$timeout = $opts->{$type};
      } elsif ($type =~ /^-?retries$/i) {
	$retries = $opts->{$type};
      } elsif ($type =~ /^-?maxmsgsize$/i) {
	$maxmsgsize = $opts->{$type};
      } elsif ($type =~ /^-?debug$/i) {
	$debug = $opts->{$type};
      } elsif ($type =~ /^-?backoff$/i) {
	next;		# XXXX not implemented in Net::SNMP
      } elsif ($type =~ /^-?avoid_negative_request_ids$/i) {
	next;		# XXXX not implemented in Net::SNMP
      } elsif ($type =~ /^-?lenient_source_/i) {
	next;		# XXXX not implemented in Net::SNMP
      } elsif ($type =~ /^-?use_16bit_request_ids$/i) {
	next;		# XXXX not implemented in Net::SNMP
      } elsif ($type =~ /^-?use_getbulk$/i) {
	next;		# XXXX not implemented in Net::SNMP
      } else {
	$tmp = $type;
	$tmp = '-' . $tmp unless ($tmp =~ /^-/);
	$args{$tmp} = $opts->{$type};
      }
    }
  }

  $port = 162 if ($type == 1 and !defined($port));
  $nhost = "$community\@$host";
  $nhost .= ":" . $port if (defined($port));
  undef($lhost) if (defined($lhost) and (length($lhost) <= 0));

  $version = '1' unless defined $version;
  if ($version =~ /1/) {
    $version = 1;
  } elsif ($version =~ /2/) {
    $version = 2;
  } elsif ($version =~ /3/) {
    $version = 3;
  }
  $Net_SNMP_util::ErrorMessage = '';
  if ((!defined($Net_SNMP_util::Session))
    or ($Net_SNMP_util::Host ne $nhost)
    or ($Net_SNMP_util::Version ne $version)
    or ($Net_SNMP_util::LHost ne $nlhost)
    or ($Net_SNMP_util::IPv4only ne $v4onlystr)) {
    if (defined($Net_SNMP_util::Session)) {
      $Net_SNMP_util::Session->close();    
      undef $Net_SNMP_util::Session;
      undef $Net_SNMP_util::Host;
      undef $Net_SNMP_util::Version;
      undef $Net_SNMP_util::LHost;
      undef $Net_SNMP_util::IPv4only;
    }

    $args{'-hostname'} = $host;
    $args{'-port'} = $port if (defined($port));
    $args{'-localaddr'} = $lhost if (defined($lhost));
    $args{'-localport'} = $lport if (defined($lport));
    $args{'-version'} = $version;
    $args{'-domain'} = "udp/ipv4" if (length($v4onlystr) > 0);
    $args{'-timeout'} = $timeout if (defined($timeout));
    $args{'-retries'} = $retries if (defined($retries));
    $args{'-maxmsgsize'} = $maxmsgsize if (defined($maxmsgsize));
    $args{'-debug'} = $debug if (defined($debug));
    $args{'-community'} = $community unless ($community eq "public");
    delete $args{'-community'} if ($version == 3);

    ($sess, $tmp) = Net::SNMP->session(%args);

    if (defined($sess)) {
      $Net_SNMP_util::Session = $sess;
      $Net_SNMP_util::Host = $nhost;
      $Net_SNMP_util::Version = $version;
      $Net_SNMP_util::LHost = $nlhost;
      $Net_SNMP_util::IPv4only = $v4onlystr;
    } else {
      error_msg("SNMPopen failed: $tmp\n");
      return(undef);
    }
    return $Net_SNMP_util::Session;
  } else {
    $Net_SNMP_util::Session->timeout($timeout)
      if (defined($timeout) and (length($timeout) > 0));
    $Net_SNMP_util::Session->retries($retries)
      if (defined($retries) and (length($retries) > 0));
    $Net_SNMP_util::Session->maxmsgsize($maxmsgsize)
      if (defined($maxmsgsize) and (length($maxmsgsize) > 0));
    $Net_SNMP_util::Session->debug($debug)
      if (defined($debug) and (length($debug) > 0));
    $Net_SNMP_util::Session->{_context_engine_id} = undef
      if (!defined($Net_SNMP_util::ContextEngineID));
    $Net_SNMP_util::Session->{_context_name} = undef
      if (!defined($Net_SNMP_util::ContextName));
  }
  return $Net_SNMP_util::Session;
}

#
#  Given an OID in either ASN.1 or mixed text/ASN.1 notation, return an OID.
#
sub toOID(@) {
  my(@vars) = @_;
  my($oid, $var, $tmp, $tmpv, @retvar);

  undef @retvar;
  foreach $var (@vars) {
    ($oid, $tmp) = &Check_OID($var);
    if (!$oid and $Net_SNMP_util::CacheLoaded == 0) {
      $tmp = $Net_SNMP_util::SuppressWarnings;
      $Net_SNMP_util::SuppressWarnings = 1000;

      &snmpLoad_OID_Cache($Net_SNMP_util::CacheFile);

      $Net_SNMP_util::CacheLoaded = 1;
      $Net_SNMP_util::SuppressWarnings = $tmp;

      ($oid, $tmp) = &Check_OID($var);
    }
    while (!$oid and $#Net_SNMP_util::MIB_Files >= 0) {
      $tmp = $Net_SNMP_util::SuppressWarnings;
      $Net_SNMP_util::SuppressWarnings = 1000;

      snmpMIB_to_OID(shift(@Net_SNMP_util::MIB_Files));

      $Net_SNMP_util::SuppressWarnings = $tmp;

      ($oid, $tmp) = &Check_OID($var);
      if ($oid) {
	open(CACHE, ">>$Net_SNMP_util::CacheFile");
	print CACHE "$tmp\t$oid\n";
	close(CACHE);
      }
    }
    if ($oid) {
      $var =~ s/^$tmp/$oid/;
    } else {
      carp("Unknown SNMP var $var\n")
	unless ($Net_SNMP_util::SuppressWarnings > 1);
      next;
    }
    while ($var =~ /\"([^\"]*)\"/) {
      $tmp = sprintf("%d.%s", length($1), join(".", map(ord, split(//, $1))));
      $var =~ s/\"$1\"/$tmp/;
    }
    print "toOID: $var\n" if $Net_SNMP_util::Debug;
    push(@retvar, $var);
  }
  return @retvar;
}

#
# Check to see if an OID is in the text-to-OID cache.
# Returns the OID and the corresponding text as two separate
# elements.
#
sub Check_OID ($) {
  my($var) = @_;
  my($tmp, $tmpv, $oid);

  if ($var =~ /^[a-zA-Z][\w\-]*(\.[a-zA-Z][\w\-]*)*/)
  {
    $tmp = $&;
    $tmpv = $tmp;
    for (;;) {
      last if exists($Net_SNMP_util::OIDS{$tmpv});
      last if !($tmpv =~ s/^[^\.]*\.//);
    }
    $oid = $Net_SNMP_util::OIDS{$tmpv};
    if ($oid) {
      return ($oid, $tmp);
    } else {
      return undef;
    }
  }
  return ($var, $var);
}

sub snmpwalk_flg ($$@) {
  my($host, $hash_sub, @vars) = @_;
  my($session, %args, @enoid, @poid, $toid, $oid, $got);
  my($val, $ret, %soid, %nsoid, @retvals, $tmp);
  my(%rethash, $h_ref, @tmprefs);
  my($stop);

  $session = &snmpopen($host, 0, \@vars);
  if (!defined($session)) {
    carp "SNMPWALK Problem for $host"
      unless ($Net_SNMP_util::SuppressWarnings > 1);
    return undef;
  }

  $h_ref = (ref $vars[$#vars] eq "HASH") ? pop(@vars) : \%rethash;

  @enoid = toOID(@vars);
  return undef unless defined $enoid[0];

  #
  # Create/Refresh a reversed hash with oid -> name
  #
  if (defined($hash_sub) and ($RevNeeded)) {
      %revOIDS = reverse %Net_SNMP_util::OIDS;
      $RevNeeded = 0;
  }

  #
  # Create temporary array of refs to return values
  #
  foreach $oid (0..$#enoid)  {
    my $tmparray = [];
    $tmprefs[$oid] = $tmparray;
    $nsoid{$oid} = $oid;
  }

  $got = 0;
  @poid = @enoid;

  if ($Net_SNMP_util::Version > 1) {
    $args{'-maxrepetitions'} = $Net_SNMP_util::MaxRepetitions;
  }
  if ($Net_SNMP_util::Version > 2) {
    $args{'-contextengineid'} = $Net_SNMP_util::ContextEngineID
      if (defined($Net_SNMP_util::ContextEngineID));
    $args{'-contextname'} = $Net_SNMP_util::ContextName
      if (defined($Net_SNMP_util::ContextName));
  }

  while($#poid >= 0) {
    $args{'-varbindlist'} = \@poid;
    if (($Net_SNMP_util::Version > 1)
    and ($Net_SNMP_util::MaxRepetitions > 1)) {
      $ret = $session->get_bulk_request(%args);
    } else {
      $ret = $session->get_next_request(%args);
    }
    last if (!defined($ret));

    %soid = %nsoid;
    undef %nsoid;
    $stop = 0;
    foreach $oid (&Net::SNMP::oid_lex_sort(keys %$ret)) {
      $got = 1;
      $tmp = -1;
      foreach $toid (@enoid) {
	$tmp++;
	if (&Net::SNMP::oid_base_match($toid, $oid)
	and (!exists($soid{$toid}) or ($oid ne $soid{$toid}))) {
	  $nsoid{$toid} = $oid;
	  if (defined($hash_sub)) {
	    #
	    # extract name of the oid, if possible, the rest becomes the
	    # instance
	    #
	    my $inst = "";
	    my $upo = $toid;
	    while (!exists($revOIDS{$upo}) and length($upo)) {
	      $upo =~ s/(\.\d+?)$//;
	      if (defined($1) and length($1)) {
		$inst = $1 . $inst;
	      } else {
		$upo = "";
		last;
	      }
	    }	
	    if (length($upo) and exists($revOIDS{$upo})) {
	      $upo = $revOIDS{$upo} . $inst;
	    } else {
	      $upo = $toid;
	    }

	    my $qoid = $oid;
	    my $tmpo;
	    $inst = "";
	    while (!exists($revOIDS{$qoid}) and length($qoid)) {
	      $qoid =~ s/(\.\d+?)$//;
	      if (defined($1) and length($1)) {
		$inst = $1 . $inst;
	      } else {
		$qoid = "";
		last;
	      }
	    }	
	    if (length($qoid) and exists($revOIDS{$qoid})) {
	      $tmpo = $qoid;
	      $qoid = $revOIDS{$qoid};
	    } else {
	      $qoid = $oid;
	      $tmpo = $toid;
	      $inst = substr($oid, length($tmpo)+1);
	    }
	    #
	    # call hash_sub
	    #
	    &$hash_sub($h_ref, $host, $qoid, $tmpo, $inst, $ret->{$oid}, $upo);
	  } else {
	    my $tmpo;
	    my $tmpv = $ret->{$oid};
	    $tmpo = substr($oid, length($toid)+1);
	    push @{$tmprefs[$tmp]}, "$tmpo:$tmpv";
	  }
	} else {
	  $stop = 1 if ($#enoid == 0);
	}
      }
    }
    undef @poid;
    @poid = values %nsoid if (!$stop);
  }
  if ($got) {
    if (defined($hash_sub)) {
	return ($h_ref) if ($Net_SNMP_util::ReturnHashRefs);
    	return (%$h_ref);
    } elsif ($Net_SNMP_util::Return_array_refs)  {
      return (@tmprefs);
    } else {
      do {
	$got = 0;
	foreach $toid (0..$#enoid) {
	  next if (scalar(@{$tmprefs[$toid]}) <= 0);
	  $got = 1;
	  $oid = shift(@{$tmprefs[$toid]});
	  if ($#enoid > 0) {
	    ($oid, $val) = split(':', $oid, 2);
	    $oid = $enoid[$toid] . '.' . $oid;
	    push(@retvals, "$oid:$val");
	  } else {
	    push(@retvals, $oid);
	  }
	}
      } while($got);
      return (@retvals);
    }
  } else {
    $ret = join(' ', @vars);
    error_msg("SNMPWALK Problem for $ret on ${host}: " . $session->error());
    return undef;
  }
}

#
# When passed a string, return the ASN.1 type that corresponds to the
# string.
#
sub ASNtype($) {
  my($type) = @_;

  $type =~ tr/A-Z/a-z/;
  if ($type eq "int") {
    $type = 0x02;
  } elsif ($type eq "integer") {
    $type = 0x02;
  } elsif ($type eq "string") {
    $type = 0x04;
  } elsif ($type eq "octetstring") {
    $type = 0x04;
  } elsif ($type eq "octet string") {
    $type = 0x04;
  } elsif ($type eq "oid") {
    $type = 0x06;
  } elsif ($type eq "object id") {
    $type = 0x06;
  } elsif ($type eq "object identifier") {
    $type = 0x06;
  } elsif ($type eq "ipaddr") {
    $type = 0x40;
  } elsif ($type eq "ip address") {
    $type = 0x40;
  } elsif ($type eq "timeticks") {
    $type = 0x43;
  } elsif ($type eq "uint") {
    $type = 0x47;
  } elsif ($type eq "uinteger") {
    $type = 0x47;
  } elsif ($type eq "uinteger32") {
    $type = 0x47;
  } elsif ($type eq "unsigned int") {
    $type = 0x47;
  } elsif ($type eq "unsigned integer") {
    $type = 0x47;
  } elsif ($type eq "unsigned integer32") {
    $type = 0x47;
  } elsif ($type eq "counter") {
    $type = 0x41;
  } elsif ($type eq "counter32") {
    $type = 0x41;
  } elsif ($type eq "counter64") {
    $type = 0x46;
  } elsif ($type eq "gauge") {
    $type = 0x42;
  } elsif ($type eq "gauge32") {
    $type = 0x42;
  } elsif (($type <= 0) or ($type > 255)) {
    return undef;
  }
  return $type;
}

#
# set the ErrorMessage global and print an error message
#
sub error_msg($)
{
  my($msg) = @_;
  $Net_SNMP_util::ErrorMessage = $msg;
  if ($Net_SNMP_util::SuppressWarnings <= 1) {
    $Carp::CarpLevel++;
    carp($msg);
    $Carp::CarpLevel--;
  }
}

#
# Fill the OIDS hash with results from the MIB parsing
#
sub MIB_fill_OID($)
{
  my($href) = @_;
  my($cnt, $changed, @del, $var, $val, @parts, $indx);
  my(%seen);

  $cnt = 0;
  do {
    $changed = 0;
    @del = ();
    foreach $var (keys %$href) {
      $val = $href->{$var};
      @parts = split('\.', $val);
      $val = '';
      foreach $indx (@parts) {
	if ($indx =~ /^\d+$/) {
	  $val .= '.' . $indx;
	} else {
	  if (exists($Net_SNMP_util::OIDS{$indx})) {
	    $val = $Net_SNMP_util::OIDS{$indx};
	  } else {
	    $val .= '.' . $indx;
	  }
	}
      }
      if ($val =~ /^[\d\.]+$/) {
	$val =~ s/^\.//;
	if (!exists($Net_SNMP_util::OIDS{$var})
	|| (length($val) > length($Net_SNMP_util::OIDS{$var}))) {
	  $Net_SNMP_util::OIDS{$var} = $val;
	  print "'$var' => '$val'\n" if $Net_SNMP_util::Debug;
	  $changed = 1;
	  $cnt++;
	}
	push @del, $var;
      }
    }
    foreach $var (@del) {
      delete $href->{$var};
    }
  } while($changed);

  $Carp::CarpLevel++;
  foreach $var (sort keys %$href) {
    $val = $href->{$var};
    $val =~ s/\..*//;
    next if (exists($seen{$val}));
    $seen{$val} = 1;
    $seen{$var} = 1;
    error_msg(
	"snmpMIB_to_OID: prefix \"$val\" unknown, load the parent MIB first.\n"
    );
  }
  $Carp::CarpLevel--;
  return $cnt;
}


# [documentation] ------------------------------------------------------------

=head1 EXPORTS

The Net_SNMP_util module uses the F<Exporter> module to export useful
constants and subroutines.  These exportable symbols are defined below and
follow the rules and conventions of the F<Exporter> module (see L<Exporter>).

=over

=item Exportable

&snmpget, &snmpgetnext, &snmpgetbulk, &snmpwalk, &snmpset, &snmptrap,
&snmpmaptable, &snmpmaptable4, &snmpwalkhash, &snmpmapOID, &snmpMIB_to_OID,
&snmpLoad_OID_Cache, &snmpQueue_MIB_File, ErrorMessage

=back

=head1 EXAMPLES

=head2 1. SNMPv1 get-request for sysUpTime

This example gets the sysUpTime from a remote host.

    #! /usr/local/bin/perl
    use strict;
    use Net_SNMP_util;
    my ($host, $ret)
    $host = shift || 'localhost';
    $ret = snmpget($host, 'sysUpTime');

    print("sysUpTime for $host is $ret\n");

    exit 0;

=head2 2. SNMPv3 set-request of sysContact

This example sets the sysContact information on the remote host to 
"Help Desk x911".  The parameters passed to the snmpset function are for
the demonstration of syntax only.  These parameters will need to be
set according to the SNMPv3 parameters of the remote host used by the script. 

    #! /usr/local/bin/perl
    use strict;
    use Net_SNMP_util;
    my($host, %v3hash, $ret);
    $host = shift || 'localhost';
    $v3hash{'-version'}		= 'snmpv3';
    $v3hash{'-username'}	= 'myv3Username';
    $v3hash{'-authkey'}		= '0x05c7fbde31916f64da4d5b77156bdfa7';
    $v3hash{'-authprotocol'}	= 'md5';
    $v3hash{'-privkey'}		= '0x93725fd3a02a48ce02df4e065a1c1746';

    $ret = snmpset($host, \%v3hash, 'sysContact', 'string', 'Help Desk x911');

    print "sysContact on $host is now $ret\n";
    exit 0;

=head2 3. SNMPv2c walk for ifTable

This example gets the contents of the ifTable by sending get-bulk-requests
until the responses are no longer part of the ifTable.  The ifTable can also
be retrieved using C<snmpmaptable>.

    #! /usr/local/bin/perl
    use strict;
    use Net_SNMP_util;
    my($host, @ret, $oid, $val);
    $host = shift || 'localhost';

    @ret = snmpwalk($host . ':::::2', 'ifTable');
    foreach $val (@ret) {
	($oid, $val) = split(':', $val, 2);
	print "$oid => $val\n";
    }
    exit 0;

=head2 4. SNMPv2c maptable collecting ifDescr, ifInOctets, and ifOutOctets.

This example collects a table containing the columns ifDescr, ifInOctets, and
ifOutOctets.  A printing function is called once per row.

    #! /usr/local/bin/perl
    use strict;
    use Net_SNMP_util;

    sub printfun($$$$) {
	my($inst, $desc, $in, $out) = @_;
	printf "%3d %-52.52s %10d %10d\n", $inst, $desc, $in, $out;
    }

    my($host, @ret);
    $host = shift || 'localhost';

    printf "%-3s %-52s %10s %10s\n", "Int", "Description", "In", "Out";
    @ret = snmpmaptable($host . ':::::2', \&printfun,
			'ifDescr', 'ifInOctets', 'ifOutOctets');

    exit 0;

=head1 REQUIREMENTS

=over

=item *

The Net_SNMP_util module uses syntax that is not supported in versions of Perl 
earlier than v5.6.0. 

=item *

The Net_SNMP_util module uses the F<Net::SNMP> module, and as such may depend
on other modules.  Please see the documentaion on F<Net::SNMP> for more
information.

=back

=head1 AUTHOR

Mike Mitchell <Mike.Mitchell@sas.com>

=head1 ACKNOWLEGEMENTS

The original concept for this module was based on F<SNMP_Session.pm> written
by Simon Leinen <simon@switch.ch>

=head1 COPYRIGHT

Copyright (c) 2007 Mike Mitchell.  All rights reserved.  This program 
is free software; you may redistribute it and/or modify it under the same
terms as Perl itself.

=cut

# ======================================================================
1; # [end Net_SNMP_util]
