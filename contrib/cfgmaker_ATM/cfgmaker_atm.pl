#!/usr/drwho/local/bin/perl
# -*- mode: Perl -*-
##################################################################
# Config file creator
##################################################################
# Created by Tobias Oetiker <oetiker@ee.ethz.ch>
# this produces a config file for one router, by bulling info
# off the router via snmp
#################################################################
#
# Distributed under the GNU copyleft
#
# $Id: cfgmaker_atm.pl,v 1.1.1.1 2002/02/26 10:16:31 oetiker Exp $
#
use SNMP_Session "0.56";
use BER "0.54";
use Socket;
use strict;
use vars '$DEBUG';
my $DEBUG = 0;

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
		    'ifAlias' => '1.3.6.1.2.1.31.1.1.1.18',
             'ifAtmLecConfigEntry' =>    '1.3.6.1.4.1.18.3.5.9.5.20.1.1.8',
		 'ifAtmLecConfigName' =>    '1.3.6.1.4.1.18.3.5.9.5.20.1.1.3',
             'ifAtmVclConfEntry' =>      '1.3.6.1.4.1.18.3.4.23.1.5.1.22',
             'ifAtmVclConf2'     =>      '1.3.6.1.4.1.18.3.4.23.1.5.1.2',
             'ifAtmVclConf3'     =>      '1.3.6.1.4.1.18.3.4.23.1.5.1.4',
             'ifAtmizerVclStatsEntry' => '1.3.6.1.4.1.18.3.4.23.3.4.1.7',
             'ifAtmizerVclStatsEntr1' => '1.3.6.1.4.1.18.3.4.23.3.4.1.1',
             'ifAtmizerVclStatsEntr2' => '1.3.6.1.4.1.18.3.4.23.3.4.1.3',
                    

		 );



sub main {


  my(%ifType_d)=('1'=>'Other',
		 '2'=>'regular1822',
		 '3'=>'hdh1822',
		 '4'=>'ddnX25',
		 '5'=>'rfc877x25',
		 '6'=>'ethernetCsmacd',
		 '7'=>'iso88023Csmacd',
		 '8'=>'iso88024TokenBus',
		 '9'=>'iso88025TokenRing',
		 '10'=>'iso88026Man',
		 '11'=>'starLan',
		 '12'=>'proteon10Mbit',
		 '13'=>'proteon80Mbit',
		 '14'=>'hyperchannel',
		 '15'=>'fddi',
		 '16'=>'lapb',
		 '17'=>'sdlc',
		 '18'=>'ds1',
		 '19'=>'e1',
		 '20'=>'basicISDN',
		 '21'=>'primaryISDN',
		 '22'=>'propPointToPointSerial',
		 '23'=>'ppp',
		 '24'=>'softwareLoopback',
		 '25'=>'eon',
		 '26'=>'ethernet-3Mbit',
		 '27'=>'nsip',
		 '28'=>'slip',
		 '29'=>'ultra',
		 '30'=>'ds3',
		 '31'=>'sip',
		 '32'=>'frame-relay',
		 '33'=>'rs232',
		 '34'=>'para',
		 '35'=>'arcnet',
		 '36'=>'arcnetPlus',
		 '37'=>'atm',
		 '38'=>'miox25',
		 '39'=>'sonet',
		 '40'=>'x25ple',
		 '41'=>'iso88022llc',
		 '42'=>'localTalk',
		 '43'=>'smdsDxi',
		 '44'=>'frameRelayService',
		 '45'=>'v35',
		 '46'=>'hssi',
		 '47'=>'hippi',
		 '48'=>'modem',
		 '49'=>'aal5',
		 '50'=>'sonetPath',
		 '51'=>'sonetVT',
		 '52'=>'smdsIcip',
		 '53'=>'propVirtual',
		 '54'=>'propMultiplexor',
		 '55'=>'100BaseVG'
		 );

  my($vendor)=0;
  if ($ARGV[0] eq '--vendor') {
	$vendor = 1; shift @ARGV};

  my($community,$router) = split /\@/, $ARGV[0];
  die <<USAGE  unless $community && $router;

USAGE: cfgmaker [--vendor] 'community'\@'router'

use the --vendor option to try and wrestle some better information
from willing livingston and cisco routers ... (may not work)

EXAMPLE:  cfgmaker public\@ezwf7.ethz.ch >>mrtg.cfg


USAGE

  
  
  my($sysDescr,$sysContact,$sysName,$sysLocation,$ifNumber,$sysObjectID) =
    snmpget($router,$community,
	    'sysDescr','sysContact','sysName',	'sysLocation', 'ifNumber', 'sysObjectID');

   $sysDescr =~ s/\r/<BR>/g;  # Change returns to <BR>
   my($cisco_router_sysid) = '1\.3\.6\.1\.4\.1\.9';
   my($livingston_router_sysid) = '1\.3\.6\.1\.4\.1\.307';
   my($ciscobox) = ($sysObjectID =~ /^$cisco_router_sysid/);
   my($portmaster) = ($sysObjectID =~ /^$livingston_router_sysid/);

    print <<ECHO;

WorkDir: d:\\mrtg\\pub\\www\\stats\\mrtg

######################################################################
# Description: $sysDescr
#     Contact: $sysContact
# System Name: $sysName
#    Location: $sysLocation
#.....................................................................
ECHO

  my @ipadent = snmpgettable($router,$community, 'ipAdEntAddr');
  print  "Got Addresses\n" if $DEBUG;
  my @ipadentif = snmpgettable($router,$community, 'ipAdEntIfIndex');
  print  "Got IfTable\n" if $DEBUG;
  my @ifatmlec = snmpgettable($router,$community, 'ifAtmLecConfigEntry');
    print  "Got ifAtmLecConfigEntry\n" if $DEBUG;
  my @ifatmlecName = snmpgettable($router,$community, 'ifAtmLecConfigName');
    print  "Got ifatmlecName\n" if $DEBUG;
  my @ifatmvcl = snmpgettable($router,$community, 'ifAtmVclConfEntry');
    print  "Got ifAtmVclConfEntry\n" if $DEBUG;
  my @ifatmpvc = snmpgettable($router,$community, 'ifAtmizerVclStatsEntry');
    print  "Got ifAtmizerVclStatsEntry\n" if $DEBUG;
  my @ifatmVclConf2 = snmpgettable($router,$community, 'ifAtmVclConf2');
    print  "Got ifAtmVclConf2\n" if $DEBUG; 
 my @ifatmVclConf3 = snmpgettable($router,$community, 'ifAtmVclConf3');
    print  "Got ifAtmVclConf3\n" if $DEBUG;
my @ifatmpvc1 = snmpgettable($router,$community, 'ifAtmizerVclStatsEntr1');
    print  "Got ifatmpvc1\n" if $DEBUG;
my @ifatmpvc2 = snmpgettable($router,$community, 'ifAtmizerVclStatsEntr2');
    print  "Got ifatmpvc2\n" if $DEBUG;


# get circuit name  'ifAtmVclConf2'
# get atm Interface number  'ifAtmVclConf3'
# get atm interface -> atm_name  'ifAtmVclConfEntry'



  my(%ipaddr, %iphost,$index);

  while (scalar @ipadentif){
    $index = shift @ipadentif;
    $ipaddr{$index} = shift @ipadent;
 #   $iphost{$index} = 
 #     gethostbyaddr(pack('C4',split(/\./,$ipaddr{$index})), AF_INET);
 #   if ($iphost{$index} eq ''){
	 $iphost{$index} = ' '; 
 #   }
  }

  my(@ifdescr) = snmpgettable($router,$community, 'ifDescr');
  print  "Got IfDescr\n" if $DEBUG;
  my(@iftype) = snmpgettable($router,$community, 'ifType');
  print  "Got IfType\n" if $DEBUG;
  my(@ifspeed) = snmpgettable($router,$community, 'ifSpeed');
  print  "Got IfSpeed\n" if $DEBUG;
  my(@ifadminstatus) = snmpgettable($router,$community, 'ifAdminStatus');
  print  "Got IfAdminStatus\n" if $DEBUG;
  my(@ifoperstatus) = snmpgettable($router,$community, 'ifOperStatus');
  print  "Got IfOperStatus\n" if $DEBUG;
  my(@ifindex) = snmpgettable($router,$community, 'ifIndex');
  print  "Got IfIndex\n" if $DEBUG;

  my(%sifdesc,%siftype,%sifspeed,%sifadminstatus,%sifoperstatus,%sciscodescr);

  ### May need the cisco IOS version number so we know which oid to use
  ###   to get the cisco description.
  ###
  ### - mjd 2/5/98 (Mike Diehn) (mdiehn@mindspring.net)
  ###
  my ($cisco_ver, $cisco_descr_oid, @ciscodescr);
 my (%atmindex, %atmindex2, %atmCir, %atmindex5, $atmindex2);

  if ( $ciscobox ) {
    ($cisco_ver) = ($sysDescr =~ m/Version\s+([\d.]+)\(\d+\)\w*?,/o);
    $cisco_descr_oid = ($cisco_ver ge "11.2") ? "ifAlias" : "CiscolocIfDescr";
  }
print  "Print from ifatmlecname \n" if $DEBUG;

  while (scalar @ifatmlecName) {
    $index = shift @ifatmlecName;
    $sifdesc{$index} = shift @ifatmlec;
    $siftype{$index} = '';
    $sifspeed{$index} = '';
    $sifadminstatus{$index} = '';
    $sifoperstatus{$index} = '';
    my $atm_Index = $index;
    my $name = "$router.$index";
    my $name2 = "$router.$sifdesc{$index}";

print  "$sifdesc{$index}: '$sifdesc{$index}'\n" if $DEBUG;
print  "$index: $atm_Index: $name:  $name2:  $sifdesc{$index}\n" if $DEBUG;
 
    }
 my $jet2;
  

  	print  " sifdesc  \n" if $DEBUG; 
foreach $jet2 (%sifdesc) {
	print  "$jet2  \n" if $DEBUG; 
	}


print  "Print from ifatmpvc1 \n" if $DEBUG;

    while  (scalar @ifatmpvc2) {
   $index = shift @ifatmpvc2;
    $atmindex{$index} = $index;
    $atmCir{$index} = shift @ifatmpvc1;
    my $atm_Index_Base = $index;
    my $atm_Index = $atmindex{$index};
    my $name = $atmCir{$index};
    my $atm_index2 = $atmindex2{$index};
print  "$index: $atm_Index_Base: $atm_Index:  $name: $atm_index2\n" if $DEBUG;
 

print  "$index: '$index'\n" if $DEBUG;
print  "$atmindex{$index}: '$atmindex{$index}'\n" if $DEBUG;
print  "$atmCir{$index}: '$atmCir{$index}'\n" if $DEBUG;
print  "$atmindex2{$index}: '$atmindex2{$index}'\n" if $DEBUG;    
}

    while  (scalar @ifatmVclConf3) {
   $index = shift @ifatmVclConf3;
   $atmindex2{$index} = shift @ifatmvcl;
}
  	print  " atmindex  \n" if $DEBUG; 

 foreach $jet2 (%atmindex) {
	print  "$jet2  \n" if $DEBUG; 
	}


  	print  " atmCir  \n" if $DEBUG; 
foreach $jet2 (%atmCir) {
	print  "$jet2  \n" if $DEBUG; 
	}

  	print  " atmindex2 \n" if $DEBUG; 
foreach $jet2 (%atmindex2) {
	print  "$jet2  \n" if $DEBUG; 
	}


print  "Print from ifatmVclconf3 \n" if $DEBUG;



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

    if ($portmaster && $vendor) {
      
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

      if ($siftype{$index} eq '23') {
              if ($sifdesc{$index} eq 'ptpW1') {
                      $sifspeed{$index} = 128000;
              } else {
                      $sifspeed{$index} = 76800;
              }
      } elsif ($siftype{$index} eq '28') {
              $sifspeed{$index} = 38400;
      } elsif ($siftype{$index} eq '6') {
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
    if ($ciscobox && $vendor) {

	my ($enoid, @descr);

	$enoid = $snmpget::OIDS{"$cisco_descr_oid"} . "." . $index;

	if ( $cisco_ver ge "11.2" or $siftype{$index} != '32' ) {

	  ### This is either not a frame-relay sub-interface or
	  ###  this router is running IOS 11.2+ and interface
	  ###  type won't matter. In either of these cases, it's
	  ###  ok to try getting the ifAlias or ciscoLocIfDesc.
	  ###
	  @descr = snmpget($router,$community, $enoid);

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

    } # end if ($cisco_box && $vendor)

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
    if ($ciscobox && $siftype{$index} != 18) {
          $sciscodescr{$index} = "<BR>" . (shift @ciscodescr) if @ciscodescr;
    }
}

 my $jet;
  	print  " atmindex2  \n" if $DEBUG; 

 foreach $jet (%atmindex2) {
	print  "$jet  \n" if $DEBUG; 
	}

  	print  " sifdesc  \n" if $DEBUG; 
foreach $jet (%sifdesc) {
	print  "$jet  \n" if $DEBUG; 
	}

  	print  " atmCir  \n" if $DEBUG; 
foreach $jet (%atmCir) {
	print  "$jet  \n" if $DEBUG; 
	}

  	print  " atmindex \n" if $DEBUG; 
foreach $jet (%atmindex) {
	print  "$jet  \n" if $DEBUG; 
	}

print  " Possible Targets  \n" if $DEBUG; 

  foreach $index ( sort { $atmindex2{$a} <=> $atmindex2{$b} } keys %atmindex2) {
    my $c;
	my $index2 = $atmindex2{$index}; 
#        my $name = "$router.$sifdesc{$index2}.$atmindex2{$index}.$index";
        my $name = "$router.$index2.$index";
	my $target1 = "1.3.6.1.4.1.18.3.4.23.3.4.1.7.$atmCir{$index}.0.$index";
	my $target2 = "1.3.6.1.4.1.18.3.4.23.3.4.1.21.$atmCir{$index}.0.$index";
	
	print  "$index: $index2: $name: $target1: $target2:  \n" if $DEBUG;

   $c = '';
    
  print <<ECHO;
${c}
${c}Target[$name]: $target1&$target2:$community\@$router * 53
${c}MaxBytes[$name]: 19400000 
${c}Title[$name]: $sysName ($iphost{$index}):  $index2 <- $index $sifdesc{$index2}
${c}PageTop[$name]: <H1>Traffic Analysis for $index2 <- $index $sifdesc{$index2}
${c} $sciscodescr{$index}</H1>
${c} <TABLE>
${c}   <TR><TD>System:</TD><TD>$sysName in $sysLocation</TD></TR>
${c}   <TR><TD>Maintainer:</TD><TD>$sysContact</TD></TR>
${c}   <TR><TD>Interface:</TD><TD>$sifdesc{$index} ($index)</TD></TR>
${c}   <TR><TD>IP:</TD><TD>$iphost{$index} ($ipaddr{$index})</TD></TR>
${c}   <TR><TD>Max Speed:</TD>
${c}       <TD>19.4MB ($ifType_d{$siftype{$index}})</TD></TR>
${c}  </TABLE>
${c}
#---------------------------------------------------------------
ECHO
  }
}
  
main;
exit(0);

sub snmpget{  
  my($host,$community,@vars) = @_;
  my(@enoid, $var,$response, $bindings, $binding, $value, $inoid,$outoid,
     $upoid,$oid,@retvals);
  my($hackcisco);
  foreach $var (@vars) {
    die "Unknown SNMP var $var\n" 
      unless $snmpget::OIDS{$var} || $var =~ /^\d+[\.\d+]*\.\d+$/;
    if ($var =~ /^\d+[\.\d+]*\.\d+/) {
	push @enoid,  encode_oid((split /\./, $var));
	$hackcisco = 1;
    } else {
	push @enoid,  encode_oid((split /\./, $snmpget::OIDS{$var}));
	$hackcisco = 0;
    }
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
      if ($hackcisco) {
	  return ("");
      } else {
	  die "No answer from $ARGV[0]. You may be using the wrong community\n";
      }
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
      print  "$var: '$tempo'\n" if $DEBUG;
      
      $tempo=~s/\t/ /g;
      $tempo=~s/\n/ /g;
      $tempo=~s/^\s+//;
      $tempo=~s/\s+$//;
      push @table, $tempo;
     
    } else {
      warn "No sensible answer from $ARGV[0] for $var ... results may be wrong!\n";
	last;
    }
    $enoid=$next_oid;
  }
  $session->close ();    
  return (@table);
}

sub fmi {
  my($number) = $_[0];
  my(@short);
  @short = ("Bytes/s","kBytes/s","MBytes/s","GBytes/s");
  my $digits=length("".$number);
  my $divm=0;
  while ($digits-$divm*3 > 4) { $divm++; }
  my $divnum = $number/10**($divm*3);
  return sprintf("%1.1f %s",$divnum,$short[$divm]);
}


