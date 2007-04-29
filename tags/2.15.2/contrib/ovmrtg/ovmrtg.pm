#!/usr/local/bin/perl5
# -*- mode: Perl -*-
##################################################################
# Config file creator
##################################################################
# Created by Laurie Gellatly <gellatly@one.net.au>
# this produces an array of ip address and system names for each
# ip address passed to it, by pulling info
# off the device via snmp
#################################################################
#
# Distributed under the GNU copyleft
#
# $Id: ovmrtg.pm,v 1.1.1.1 2002/02/26 10:16:36 oetiker Exp $
#
package ovmrtg;

use Socket;
use strict;
use vars qw(@ISA @EXPORT $VERSION);
use Exporter;

$VERSION = '0.00';

@ISA = qw(Exporter);

@EXPORT = qw(ovsysnms ovcols);

sub ovsysnms(@);
sub ovcols(@);

my $DEBUG = 0;
my($router,$routerip,@res,@result,$cnt); 
my($op,$vendor); 

%snmpget::OIDS = (  'sysDescr' => '1.3.6.1.2.1.1.1.0',
		    'sysContact' => '1.3.6.1.2.1.1.4.0',
		    'sysName' => '1.3.6.1.2.1.1.5.0',
		    'sysLocation' => '1.3.6.1.2.1.1.6.0',
		    'sysUptime' => '1.3.6.1.2.1.1.3.0',
		    'ifNumber' =>  '1.3.6.1.2.1.2.1.0',
		    ###################################
		    # add the ifNumber ....
		    'ifDescr' => '1.3.6.1.2.1.2.2.1.2',
		    'ifType' => '1.3.6.1.2.1.2.2.1.3',
		    'ifIndex' => '1.3.6.1.2.1.2.2.1.1',
		    'ifSpeed' => '1.3.6.1.2.1.2.2.1.5', 
		    'ifOperStatus' => '1.3.6.1.2.1.2.2.1.8',             
		    'ifAdminStatus' => '1.3.6.1.2.1.2.2.1.7',            
		    # up 1, down 2, testing 3
		    'ipAdEntAddr' => '1.3.6.1.2.1.4.20.1.1',
		    'ipAdEntIfIndex' => '1.3.6.1.2.1.4.20.1.2',
		    'sysObjectID' => '1.3.6.1.2.1.1.2.0',
		    'CiscolocIfDescr' => '1.3.6.1.4.1.9.2.2.1.1.28',
		    'ifAlias' => '1.3.6.1.2.1.31.1.1.1.18'
		 );

sub ovcols(@) {
   my @args = @_;  
   my @r;
   $op = $args[0];
   shift @args;
   if ($op eq "+"){
      $op = "C";
   } else {
      $op = "XC";
   }
   while($router=$args[0]){
  my($sysDescr,$sysContact,$sysName,$sysLocation,$ifNumber,$sysObjectID) =
    snmpget($router,
	    'sysDescr','sysContact','sysName',  'sysLocation', 'ifNumber', 'sysObjectID');

   my ($sint2mon);
   my $cc = " ";
   $sysDescr =~ s/\r/<BR>/g;  # Change returns to <BR>
   my($ciscobox) = ($sysObjectID =~ /cisco/);
   my($portmaster) = ($sysObjectID =~ /livingston/);
   $vendor = ($ciscobox || $portmaster) ;
   my($ifInErrors) = '1.3.6.1.2.1.2.2.1.14';
   my($ifOutErrors) = '1.3.6.1.2.1.2.2.1.20';

  my @ipadent = snmpgettable($router, 'ipAdEntAddr');
  print STDERR "Got Addresses\n" if $DEBUG;
  my @ipadentif = snmpgettable($router, 'ipAdEntIfIndex');
  print STDERR "Got IfTable\n" if $DEBUG;

  my(%ipaddr, %iphost,$index);
  while (scalar @ipadentif){
    $index = shift @ipadentif;
    $ipaddr{$index} = shift @ipadent;
    $iphost{$index} = 
      gethostbyaddr(pack('C4',split(/\./,$ipaddr{$index})), AF_INET);
    if ($iphost{$index} eq ''){
	 $iphost{$index} = $ipaddr{$index};
    }   
    
  }

  my(@ifdescr) = snmpgettable($router, 'ifDescr');
  print STDERR "Got IfDescr\n" if $DEBUG;
  my(@iftype) = snmpgettable($router, 'ifType');
  print STDERR "Got IfType\n" if $DEBUG;
  my(@ifspeed) = snmpgettable($router, 'ifSpeed');
  print STDERR "Got IfSpeed\n" if $DEBUG;
  my(@ifadminstatus) = snmpgettable($router, 'ifAdminStatus');
  print STDERR "Got IfStatus\n" if $DEBUG;
  my(@ifoperstatus) = snmpgettable($router, 'ifOperStatus');
  print STDERR "Got IfOperStatus\n" if $DEBUG;
  my(@ifindex) = snmpgettable($router, 'ifIndex');
  print STDERR "Got IfIndex\n" if $DEBUG;

  my(%sifdesc,%siftype,%sifspeed,%sifadminstatus,%sifoperstatus,%sciscodescr);

  ### May need the cisco IOS version number so we know which oid to use
  ###   to get the cisco description.
  ###
  ### - mjd 2/5/98 (Mike Diehn) (mdiehn@mindspring.net)
  ###
  my ($cisco_ver, $cisco_descr_oid, @ciscodescr);
  if ( $ciscobox ) {
    ($cisco_ver) = ($sysDescr =~ /Version\s+([\d.]+)/);
    $cisco_descr_oid = ($cisco_ver ge "11.3") ? "ifAlias" : "CiscolocIfDescr";
  }
  
  while (scalar @ifindex) {

  # as these arrays get filled from the bottom, 
  # we need to empty them from the botom as well ...
  # fifo

    $index = shift @ifindex;
    $sifdesc{$index} = shift @ifdescr;
    $siftype{$index} = shift @iftype;
    $sifspeed{$index} = shift @ifspeed;
    $sifadminstatus{$index} = shift @ifadminstatus;
    $sifoperstatus{$index} = shift @ifoperstatus;

    if ($portmaster) {
      # Trying to extract extra info livingston
      # We can only approximate speeds
      # 
      # so we think that ppp can do 76800 bit/s, and slip 38400.
      # (actualy, slip is a bit faster, but usualy users with newer modems
      # use ppp). Alternatively, you can set async speed to 115200 or
      # 230400 (the maximum speed supported by portmaster).
      # 
      # But if the interface is ptpW (sync), max speed is 128000
      # change it to your needs. On various Portmasters there are
      # various numbers of sync interfaces, so modify it.
      # 
      #  The most commonly used PM-2ER has only one sync.
      # 
      #  Paul Makeev (mac@redline.ru)
      # 

      if ($siftype{$index} eq 'ppp') {
	      if ($sifdesc{$index} eq 'ptpW1') {
		      $sifspeed{$index} = 128000;
	      } else {
		      $sifspeed{$index} = 76800;
	      }
      } elsif ($siftype{$index} eq 'slip') {
	      $sifspeed{$index} = 38400;
      } elsif ($siftype{$index} eq 'ethernetCsmacd') {
	      $sifspeed{$index} = 10000000;
      }
    }

    ### Move this section south so we know what type of
    ###  circuit we're looking at before we retrieve
    ###  the cisco interface alias.
    ###
    ### This whole cicso thing should be re-written, but since
    ###   this script doesn't need to run quickly...
    ###
    ###  - mjd 2/5/98
    ###
    # Get the user configurable interface description entered in the config 
    # if it's a cisco-box
    #
    if ($ciscobox) {

	my ($enoid, @descr);

	$enoid = $snmpget::OIDS{"$cisco_descr_oid"} . "." . $index;

	if ( $cisco_ver ge "11.2" or $siftype{$index} ne 'frame-relay' ) {

	  ### This is either not a frame-relay sub-interface or
	  ###  this router is running IOS 11.2+ and interface
	  ###  type won't matter. In either of these cases, it's
	  ###  ok to try getting the ifAlias or ciscoLocIfDesc.
	  ###
	  @descr = snmpget($router, $enoid);

	} else {

	  ### This is a frame-relay sub-interface *and* the router
	  ###  is running an IOS older than 11.2. Therefore, we can
	  ###  get neither ifAlias nor ciscoLocIfDesc. Do something
	  ###  useful.
	  ###
	  @descr = ("Cisco PVCs descriptions require IOS 11.2+.");

	} # end if else

	### Put whatever I got into the array we'll use later to append the result
	###   of this operation onto the results from the ifDescr fetch.
	###
	push @ciscodescr, shift @descr;

    } # end if ($ciscobox)

    # especially since cisco does not return a if
    # descr for each interface it has ...
    ## JB 2/8/97 - sometimes IOS inserts E1 controllers in the standard-MIB
    ## interface table, but not in the local interface table. This puts the
    ## local interface description table out-of-sync. the following 
    ## modification skips over E1 cards as interfaces.
    #
    ### I suspect that the mod I made above, to use the ifAlias
    ###   oid if possible, may cause problems here. If it seems
    ###   that your descriptions are out of sync, try commenting
    ###   out the "if ( condition )" and it's closing right brace
    ###   so that the "shift @ciscodescr" get executed for *all*
    ###   iterations of this loop.
    ###
    ### - mjd 2/5/95
    ###
    if ($ciscobox && $siftype{$index} ne 'ds1') {
	  $sciscodescr{$index} = "<BR>" . (shift @ciscodescr) if @ciscodescr;
    }
}

  foreach $index ( sort { $a <=> $b } keys %sifdesc) {
    my $speed = int($sifspeed{$index} / 8); # bits to byte
# LJG Change to report in Bits
#    my $speed_str=&fmi($speed);
    my $speed_str=&fmi($sifspeed{$index});
    my $name="$router.$index";
    my $namerr="$router.$index.err";

  if (($sifadminstatus{$index} ne "up")
# this check added by Josh - don't query E1-stack controllers
      || ($siftype{$index} eq 'ds1')
	|| ($siftype{$index} eq 'softwareLoopback')
	|| ($speed == 0 ) 
# LJG Change to report all in Bits
#	|| ($speed > 400 * 10**6)  #speeds of 400 MByte/s are not realistic
	|| ($speed > 3200 * 10**6)  #speeds of 400 MByte/s are not realistic
        || ($sifoperstatus{$index} eq 'down')
        || (($sifdesc{$index}=~ /Dialer/) && ($ciscobox))) {
########
######## This Interface is one of the following
######## - administratively not UP
######## - it is in test mode
######## - it is a softwareLoopback interface
######## - has a unrealistic speed setting
######## It is commented out for this reason.
########
  }else {
    $sint2mon = $sint2mon .$cc.$index;
    $cc = ",";
  }
  }
  if ($ciscobox){
      $r[@r]="MIB .1.3.6.1.4.1.9.2.1.58 avgBusy5 units INTEGER R";
      $r[@r]="$op $router .1.3.6.1.* 300 > 0 1 <= 0 1 xA s 58720263 ALL -";
   }
  $r[@r]="MIB .1.3.6.1.2.1.1.3 sysUpTime units TIMETICKS R";
  $r[@r]="$op $router .1.3.6.1.* 300 > 0 1 <= 0 1 xA s 58720263  ALL -";
  $r[@r]="MIB .1.3.6.1.2.1.2.2.1.10 IfInOctets units/sec COUNTER R";
  $r[@r]="$op $router .1.3.6.1.* 300 > 0 1 <= 0 1 xA s 58720263 LIST $sint2mon";
  $r[@r]="MIB .1.3.6.1.2.1.2.2.1.16 IfOutOctets units/sec COUNTER R";
  $r[@r]="$op $router .1.3.6.1.* 300 > 0 1 <= 0 1 xA s 58720263 LIST $sint2mon";
  $r[@r]="MIB .1.3.6.1.2.1.2.2.1.14 IfInErrors units/sec COUNTER R";
  $r[@r]="$op $router .1.3.6.1.* 300 > 0 1 <= 0 1 xA s 58720263 LIST $sint2mon";
  $r[@r]="MIB .1.3.6.1.2.1.2.2.1.20 IfOutErrors units/sec COUNTER R";
  $r[@r]="$op $router .1.3.6.1.* 300 > 0 1 <= 0 1 xA s 58720263 LIST $sint2mon";
  shift @args;
   }
   return (@r);
}
  
sub snmpgettable{
  my($host,$var) = @_;
  my($next_oid,$enoid,$orig_oid, 
     $response, $bindings, $binding, $t1, $t2,$outoid,
     $upoid,$oid,@table,$tempo);
  die "Unknown SNMP var $var\n" 
    unless $snmpget::OIDS{$var};
  
  $orig_oid = $snmpget::OIDS{$var}." ";
  $enoid=$orig_oid;
  open(SNMPG, "snmpwalk $host $orig_oid |");
#  print STDERR $orig_oid;
  while ($tempo =<SNMPG>){
#      print STDERR $tempo;
      ($t1, $t2, $tempo ) = split /:/ , $tempo ,3;
      if (!$tempo){
	 if ($t2){
	    $t1 = $t1 .":".$t2;
	 }
	 $tempo = pop(@table)." ".$t1 ;
      }
      $tempo=~s/\t/ /g;
      $tempo=~s/\n/ /g;
      $tempo=~s/^\s+//;
      $tempo=~s/\s+$//;
      push @table, $tempo;
     
  }
 close (SNMPG);    
  return (@table);
}

sub fmi {
  my($number) = $_[0];
  my(@short);
# LJG Change to report in Bits
#  @short = ("Bytes/s","kBytes/s","MBytes/s","GBytes/s");
  @short = ("Bits/s","kBits/s","MBits/s","GBits/s");
  my $digits=length("".$number);
  my $divm=0;
  while ($digits-$divm*3 > 3) { $divm++; }
  my $divnum = $number/10**($divm*3);
  return sprintf("%1.1f %s",$divnum,$short[$divm]);
}

sub ovsysnms (@){
my @args = @_;  
  while($router = $args[0]){
  my($sysName)= snmpget($router, 'sysName');
### The next three lines can be deleted once Someone gives this box a name

  if ($router eq '10.26.254.1') {
      $sysName = 'nrgiga';
  }
  if ($sysName eq ""){
     $sysName = $router;
  }
#  $sysName =~ tr/[A-Z]/[a-z]/;
# Don't like to do it this way but...
#  @res=`ovtopodump $router`;
#  for ($cnt = 0 ; $cnt < @res; $cnt++){
#     $_ = $res[$cnt];
#     if (/IP ADDR: (.*)/){
   @res=`ping $router -n 1`;
   for ($cnt = 0 ; $cnt < @res; $cnt++){
      $_ = $res[$cnt];
      if (/from (.*):.*/) {
         $routerip = $1; 
         last;
     }
   }
   @res= `ovobjprint -a "IP Hostname" "SNMP sysName"=$sysName`;
   $_ = $res[4];
   if(!/NO FIELD VALUES FOUND/){
      ($router) = ($res[4] =~ m@\"(.*)\"@ );
   }
  $result[@result]= $routerip."\,".$sysName."\,".$router;
  shift @args;
  }
  return @result;
}
  
sub snmpget{  
  my($host,@vars) = @_;
  my(@enoid, $var,$response, $bindings, $binding, $value, $inoid,$outoid,
     $upoid,$oid,@retvals,$t1,$t2,@resp,$tempo);
  my($hackcisco);
  foreach $var (@vars) {
    die "Unknown SNMP var $var\n" 
      unless $snmpget::OIDS{$var} || $var =~ /^\d+[\.\d+]*\.\d+$/;
    if ($var =~ /^\d+[\.\d+]*\.\d+/) {
	$value = $value.$var." ";
	$hackcisco = 1;
    } else {
	$value = $value.$snmpget::OIDS{$var}." ";
	$hackcisco = 0;
    }
  }
  open(SNMPG, "snmpget $host $value |");
  while ($tempo =<SNMPG>){
      ($t1, $t2, $tempo ) = split /:/ , $tempo, 3;
      if (!$tempo){
	 if ($t2){
	    $t1 = $t1 .":".$t2;
	 }
	 $tempo = pop(@retvals)." ".$t1 ;
      }
      $tempo=~s/\t/ /g;
      $tempo=~s/\n/ /g;
      $tempo=~s/^\s+//;
      $tempo=~s/\s+$//;
      push @retvals,  $tempo;
  }
  close (SNMPG);    
    return (@retvals);
}
1;

