# -*- mode: Perl -*-
package MRTG_lib;
###################################################################
# MRTG 2.16.2  Support library MRTG_lib.pm
###################################################################
# Created by Tobias Oetiker <tobi@oetiker.ch>
#            and Dave Rand <dlr@bungi.com>
#
# For individual Contributers check the CHANGES file
#
###################################################################
#
# Distributed under the GNU General Public License
#
###################################################################

require 5.005;
use strict;
use vars qw($OS $SL $PS @EXPORT @ISA $VERSION %timestrpospattern);

if (eval {local $SIG{__DIE__}; require Net_SNMP_util} ) {
	import Net_SNMP_util;
} else {
	require SNMP_util; 
        import SNMP_util;
}

my %mrtgrules;

BEGIN {
    # Automatic OS detection ... do NOT touch
    if ( $^O =~ /^(?:(ms)?(dos|win(32|nt)?))/i ) {
        $OS = 'NT';
        $SL = '\\';
        $PS = ';';
    } elsif ( $^O =~ /^NetWare$/i ) {
	$OS = 'NW';
	$SL = '/';
	$PS = ';';
    } elsif ( $^O =~ /^VMS$/i ) {
        $OS = 'VMS';
        $SL = '.';
        $PS = ':';
    } elsif ( $^O =~ /^os2$/i ) {
	$OS = 'OS2';
	$SL = '/';
	$PS = ';';
    }  else {
        $OS = 'UNIX';
        $SL = '/';
        $PS = ':';
    }
}

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(readcfg cfgcheck setup_loghandlers 
	     datestr expistr ensureSL timestamp
             create_pid demonize_me debug log2rrd storeincache readfromcache clearfromcache cleanhostkey
	     populateconfcache readconfcache writeconfcache
	     v4onlyifnecessary);

$VERSION = 2.100016;

%timestrpospattern =
      (
       'NO' => 0,
       'LU' => 1,
       'RU' => 2,
       'LL' => 3,
       'RL' => 4
      );

%mrtgrules =
      (                         # General CFG
       'workdir' => 
       [sub{$_[0] && (-d $_[0])}, sub{"Working directory $_[0] does not exist"}],

       'htmldir' =>
       [sub{$_[0] && (-d $_[0])}, sub{"Html directory $_[0] does not exist"}],

       'imagedir' =>
       [sub{$_[0] && (-d $_[0])}, sub{"Image directory $_[0] does not exist"}],

       'logdir' =>
       [sub{$_[0] && (-d $_[0] )}, sub{"Log directory $_[0] does not exist"}],

       'forks' =>
       [sub{$_[0] && (int($_[0]) > 0 and $MRTG_lib::OS eq 'UNIX')},
        sub{"Less than 1 fork or not running on Unix/Linux"}],

       'refresh' => 
       [sub{int($_[0]) >= 300}, sub{"$_[0] should be 300 seconds or more"}],

       'enablesnmpv3' =>
       [sub{((lc($_[0])) eq 'yes' or (lc($_[0])) eq 'no')}, sub{"$_[0] must be yes or no"}],

       'enableipv6' =>
       [sub{((lc($_[0])) eq 'yes' or (lc($_[0])) eq 'no')}, sub{"$_[0] must be yes or no"}],

       'interval' => 
       [sub{$_[0] =~ /(\d+)(?::(\d+))?/ ; 
            my $int = $1*60; $int += $2 if $2;
            $int >= 1 and $int <= 60*60}, sub{"$_[0] should be at least 1 Second (0:01) and no more than 60 Minutes (60)"}], 

       'writeexpires' =>  
       [sub{1}, sub{"Internal Error"}],

       'nomib2' => 
       [sub{1}, sub{"Internal Error"}],

       'singlerequest' => 
       [sub{1}, sub{"Internal Error"}],

       'icondir' =>
       [sub{$_[0]}, sub{"Directory argument missing"}],

       'language' =>
       [sub{1}, sub{"Mrtg not localized for $_[0] - defaulting to english"}],

       'loadmibs' =>
       [sub{$_[0]}, sub{"No MIB Files specified"}],

       'userrdtool' =>
       [sub{0}, sub{"UseRRDtool is not valid any more. Use LogFormat, PathAdd and LibAdd instead"}],

       'userrdtool[]' =>
       [sub{0}, sub{"UseRRDtool[] is not valid any more. Check the new xyz*bla[] syntax for passing parameters to tool xyz who reads the mrtg.cfg"}],
       
       'logformat' =>
       [sub{$_[0] =~ /^(rateup|rrdtool)$/}, sub{"Invalid Logformat '$_[0]'"}],

       'pathadd' =>
       [sub{-d $_[0]}, sub{"$_[0] is not the name of a directory"}],

       'libadd' =>
       [sub{-d $_[0]}, sub{"$_[0] is not the name of a directory"}],
       
       'runasdaemon' =>
       [sub{1}, sub{"Internal Error"}],

       'nodetach' =>
       [sub{1}, sub{"Internal Error"}],

       'maxage' =>
       [sub{(($_[0] =~ /^[0-9]+$/) and ($_[0] > 0)) },
        sub{"$_[0] must be a Number bigger than 0"}],

       'nospacechar' =>
       [sub{length($_[0]) == 1}, sub{"$_[0] must be one character long"}],

       'snmpoptions' =>
       [sub{ debug('eval',"snmpotions $_[0]");local $SIG{__DIE__}; eval( '{'.$_[0].'}' ); return not $@},
        sub{"Must have the format \"OptA => Number, OptB => 'String', ... \""}],

       'conversioncode' =>
       [sub{-r $_[0]}, sub{"Cannot read conversion code file $_[0]"}],

       # Per Router CFG
       'target[]' => 
       [sub{1}, sub{"Internal Error"}], #will test this later

       'snmpoptions[]' =>
       [sub{ debug('eval',"snmpotions[] $_[0]");local  $SIG{__DIE__}; eval('{'.$_[0].'}' ); return not $@},
        sub{"Must have the format \"OptA => Number, OptB => 'String', ... \""}],

       'routeruptime[]' => 
       [sub{1}, sub{"Internal Error"}], #will test this later

       'routername[]' => 
       [sub{1}, sub{"Internal Error"}], #will test this later

       'nohc[]' =>
       [sub{((lc($_[0])) eq 'yes' or (lc($_[0])) eq 'no')}, sub{"$_[0] must be yes or no"}],

       'maxbytes[]' => 
       [sub{(($_[0] =~ /^[0-9]+$/) && ($_[0] > 0)) },
        sub{"$_[0] must be a Number bigger than 0"}],

       'maxbytes1[]' =>
       [sub{(($_[0] =~ /^[0-9]+$/) && ($_[0] > 0))},
        sub{"$_[0] must be numerical and larger than 0"}],

       'maxbytes2[]' =>
       [sub{(($_[0] =~ /^[0-9]+$/) && ($_[0] > 0))},
        sub{"$_[0] must a number bigger than 0"}],

       'ipv4only[]' =>
       [sub{((lc($_[0])) eq 'yes' or (lc($_[0])) eq 'no')}, sub{"$_[0] must be yes or no"}],

       'absmax[]' => 
       [sub{($_[0] =~ /^[0-9]+$/)}, sub{"$_[0] must be a Number"}],

       'title[]' => 
       [sub{1}, sub{"Internal Error"}], #what ever the user chooses.

       'directory[]' => 
       [sub{1}, sub{"Internal Error"}], #what ever the user chooses.

       'clonedirectory[]' =>
       [sub{1}, sub{"Internal Error"}], #what ever the user chooses.

       'pagetop[]' => 
       [sub{1}, sub{"Internal Error"}], #what ever the user chooses.

       'bodytag[]' => 
       [sub{1}, sub{"Internal Error"}], #what ever the user chooses.

       'pagefoot[]' => 
       [sub{1}, sub{"Internal Error"}], #what ever the user chooses.

       'addhead[]' => 
       [sub{1}, sub{"Internal Error"}], #what ever the user chooses.

       'rrdrowcount[]' => 
       [sub{1}, sub{"Internal Error"}], #what ever the user chooses.

       'rrdhwrras[]' =>
       [sub{$_[0] =~ /^RRA:(HWPREDICT|SEASONAL|DEVPREDICT|DEVSEASONAL|FAILURES):\S+(\s+RRA:(HWPREDICT|SEASONAL|DEVPREDICT|DEVSEASONAL|FAILURES):\S+)*$/},
        sub{"This does not look like rrdtool HW RRAs. Check the rrdcreate manual page for inspiration. ($_[0])"}],

       'extension[]' =>
       [sub{1}, sub{"Internal Error"}], #what ever the user chooses.

       'unscaled[]' => 
       [sub{$_[0] =~ /[ndwmy]+/i}, sub{"Must be a string of [n]one, [d]ay, [w]eek, [m]onth, [y]ear"}],

       'weekformat[]' => 
       [sub{$_[0] =~ /[UVW]/}, sub{"Must be either W, V, or U"}],

       'withpeak[]' =>
       [sub{$_[0] =~ /[ndwmy]+/i}, sub{"Must be a string of [n]one, [d]ay, [w]eek, [m]onth, [y]ear"}],

       'suppress[]' =>
       [sub{$_[0] =~ /[ndwmy]+/i}, sub{"Must be a string of [n]one, [d]ay, [w]eek, [m]onth, [y]ear"}],

       'xsize[]' =>
       [sub{((int($_[0]) >= 30) && (int($_[0]) <= 600))}, sub{"$_[0] must be between 30 and 600 pixels"}],

       'ysize[]' =>
       [sub{(int($_[0]) >= 30)}, sub{"Must be >= 30 pixels"}],

       'ytics[]' =>
       [sub{(int($_[0]) >= 1) }, sub{"Must be >= 1"}],

       'yticsfactor[]' =>
       [sub{$_[0] =~ /[-+0-9.efg]+/}, sub{"Should be a numerical value"}],

       'factor[]' =>
       [sub{$_[0] =~ /[-+0-9.efg]+/}, sub{"Should be a numerical value"}],

       'step[]'  =>
       [sub{(int($_[0]) >= 0)}, sub{"$_[0] must be > 0"}],

       'timezone[]' =>
       [sub{1}, sub{"Internal Error"}],

       'options[]' =>
       [sub{1}, sub{"Internal Error"}],

       'colours[]' =>
       [sub{1}, sub{"Internal Error"}],

       'background[]' =>
       [sub{1}, sub{"Internal Error"}],

       'kilo[]' => 
       [sub{($_[0] =~ /^[0-9]+$/)}, sub{"$_[0] must be a Integer Number"}],
       #define whatever k should be (1000, 1024, ???)

       'kmg[]' =>
       [sub{1}, sub{"Internal Error"}],

       'pngtitle[]' =>
       [sub{1}, sub{"Internal Error"}],

       'ylegend[]' =>
       [sub{1}, sub{"Internal Error"}],

       'shortlegend[]' =>
       [sub{1}, sub{"Internal Error"}],

       'legend1[]' =>
       [sub{1}, sub{"Internal Error"}],

       'legend2[]' =>
       [sub{1}, sub{"Internal Error"}],

       'legend3[]' =>
       [sub{1}, sub{"Internal Error"}],

       'legend4[]' =>
       [sub{1}, sub{"Internal Error"}],

       'legend5[]' =>
       [sub{1}, sub{"Internal Error"}],

       'legendi[]' =>
       [sub{1}, sub{"Internal Error"}],

       'legendo[]' =>
       [sub{1}, sub{"Internal Error"}],

       'setenv[]' => 
       [sub{$_[0] =~ /^(?:[-\w]+=\"[^"]*"(?:\s+|$))+$/},
        sub{"$_[0] must be XY=\"dddd\" AASD=\"kjlkj\" ... "}],


       'xzoom[]' =>
       [sub{($_[0] =~ /^[0-9]+(?:\.[0-9]+)?$/)},
        sub{"$_[0] must be a Number xxx.xxx"}],

       'yzoom[]' =>
       [sub{($_[0] =~ /^[0-9]+(?:\.[0-9]+)?$/)},
        sub{"$_[0] must be a Number xxx.xxx"}],

       'xscale[]' =>
       [sub{($_[0] =~ /^[0-9]+(?:\.[0-9]+)?$/)},
        sub{"$_[0] must be a Number xxx.xxx"}],

       'yscale[]' =>
       [sub{($_[0] =~ /^[0-9]+(?:\.[0-9]+)?$/)},
        sub{"$_[0] must be a Number xxx.xxx"}],

       'threshdir' =>
       [sub{$_[0] && (-d $_[0])}, sub{"Threshold directory $_[0] does not exist"}],
 
       'threshhyst' =>
       [sub{($_[0] =~ /^[0-9]+(?:\.[0-9]+)?$/)},
        sub{"$_[0] must be a Number xxx.xxx"}],

       'hwthreshhyst' =>
       [sub{($_[0] =~ /^[0-9]+(?:\.[0-9]+)?$/)},
        sub{"$_[0] must be a Number xxx.xxx"}],

       'threshmailserver' =>
       [sub{$_[0] && gethostbyname($_[0])}, sub{"Unknown mailserver hostname $_[0]"}],

       'threshmailsender' =>
       [sub{$_[0] && ($_[0] =~ /\S+\@\S+/)}, sub{"ThreshMailAddress $_[0] does not look like an email address at all"}],

       'threshmini[]' =>
       [sub{1}, sub{"Internal Threshold Config Error"}],

       'threshmino[]' =>
       [sub{1}, sub{"Internal Threshold Config Error"}],

       'threshmaxi[]' =>
       [sub{1}, sub{"Internal Threshold Config Error"}],

       'threshmaxo[]' =>
       [sub{1}, sub{"Internal Threshold Config Error"}],

       'threshdesc[]' =>
       [sub{1}, sub{"Internal Threshold Config Error"}],

       'threshprogi[]' =>
       [sub{$_[0] && (-e $_[0])}, sub{"Threshold program $_[0] cannot be executed"}],

       'threshprogo[]' =>
       [sub{$_[0] && (-e $_[0])}, sub{"Threshold program $_[0] cannot be executed"}],

       'threshprogoki[]' =>
       [sub{$_[0] && (-e $_[0])}, sub{"Threshold program $_[0] cannot be executed"}],

       'threshprogoko[]' =>
       [sub{$_[0] && (-e $_[0])}, sub{"Threshold program $_[0] cannot be executed"}],

       'threshmailaddress[]' =>
       [sub{$_[0] && ($_[0] =~ /\S+\@\S+/)}, sub{"ThreshMailAddress $_[0] does not look like an email address at all"}],

       'hwthreshmini[]' =>
       [sub{1}, sub{"Internal Threshold Config Error"}],

       'hwthreshmino[]' =>
       [sub{1}, sub{"Internal Threshold Config Error"}],

       'hwthreshmaxi[]' =>
       [sub{1}, sub{"Internal Threshold Config Error"}],

       'hwthreshmaxo[]' =>
       [sub{1}, sub{"Internal Threshold Config Error"}],

       'hwthreshdesc[]' =>
       [sub{1}, sub{"Internal Threshold Config Error"}],

       'hwthreshprogi[]' =>
       [sub{$_[0] && (-e $_[0])}, sub{"Threshold program $_[0] cannot be executed"}],

       'hwthreshprogo[]' =>
       [sub{$_[0] && (-e $_[0])}, sub{"Threshold program $_[0] cannot be executed"}],

       'hwthreshprogoki[]' =>
       [sub{$_[0] && (-e $_[0])}, sub{"Threshold program $_[0] cannot be executed"}],

       'hwthreshprogoko[]' =>
       [sub{$_[0] && (-e $_[0])}, sub{"Threshold program $_[0] cannot be executed"}],

       'hwthreshmailaddress[]' =>
       [sub{$_[0] && ($_[0] =~ /\S+\@\S+/)}, sub{"ThreshMailAddress $_[0] does not look like an email address at all"}],

       'timestrpos[]' => 
       [sub{$_[0] =~ /^(no|[lr][ul])$/i}, sub{"Must be a string of NO, LU, RU, LL, RL"}],

       'timestrfmt[]' => 
       [sub{1}, sub{"Internal Error"}] #what ever the user chooses.
);


# config file reading

sub readcfg ($$$$;$$) {
    my $cfgfile = shift;
    my $routers = shift;
    my $cfg = shift;
    my $rcfg = shift;
    my $extprefix = shift || '';
    my $extrules = shift;
    my ($first,$second,$key,$userules);
    my (%seen);
    my (%pre,%post,%deflt,%defaulted);
    unless ($cfgfile) {
        die "ERROR: readfg: no configfile specified\n";
    }
    unless (ref($routers) eq 'ARRAY' and ref($cfg) eq 'HASH'
            and ref($rcfg) eq 'HASH') {
        die "ERROR: readcfg called with wrong arguments\n";
    }
    if ($extprefix and ref($extrules) ne 'HASH') {
        die "ERROR: readcfg called with wrong args for mrtg extension\n";
    }
    my $hand;
    my $file;
    my @filestack;
    local *CFG;
    if ($cfgfile eq '-'){$cfgfile = '<&STDIN'};
    open (CFG, $cfgfile) || die "ERROR: unable to open config file: $cfgfile\n";
    $hand = *CFG;
    my @handstack;
    my $nextfile = $cfgfile;
    my %routerhash;
    while (1) {        
        if (eof $hand || not defined ($_ = <$hand>) ) {
                close $hand;
                if (scalar @handstack){
                        $hand = pop @handstack;
                        $nextfile = pop @filestack;
                        next;
                } else {
                        last;
                }
        }
        $file=$nextfile;
        chomp;
        my $line = $.;
        if (/^include:\s*(.*?\S)\s*$/i){
                push @filestack, $file;
                push @handstack, $hand;
                $nextfile = $1;
                local *FH;
                open (FH, $nextfile)
                 || open (FH, ($cfgfile =~ m#(.+)${MRTG_lib::SL}[^${MRTG_lib::SL}]+$#)[0] . ${MRTG_lib::SL} . $nextfile)
                 || do { die "ERROR: unable to open include file: $nextfile\n"};
                $hand = *FH;
                next;
        }

        debug('cfg',"$file\[$.\]: $_");
                
        s/\t/ /g;               #replace tab by space
        s/\r$//;                # kill dos newlines ...
        s/ +$//g;               #remove space at the end of the line
        next if /^ *\#/;       #ignore comment lines
        next if /^ *$/;        #ignore empty lines
        # oops spelling error
        s/^supress/suppress/gi;

                
        # the line we got starts with white space so it is to be appended to what ever
        # was on the previous line.

        if (defined $first && /^\s+(.*\S)\s*$/) {
            if (defined $second) {
               $second eq '^' && do { $pre{$first} .= "\n".$1; next};
               $second eq '$' && do { $post{$first} .= "\n".$1; next};
               $second eq '_' && do { $deflt{$first} .= "\n".$1; next};
               $$rcfg{$first}{$second} .= " ".$1;
            } else {
               $$cfg{$first} .= "\n".$1;
            }
            next;
        }
    
        if (defined $first && defined $second && defined $post{$first} && ($second !~ /^[\$^_]$/)) {
            if (defined $defaulted{$first}{$second}) {
                $$rcfg{$first}{$second} = $post{$first};
                delete $defaulted{$first}{$second};
            } else {
                $$rcfg{$first}{$second} .= ( defined $$cfg{nospacechar} and $post{$first} =~ /(.*)\Q$$cfg{nospacechar}\E$/) ? $1 : " ".$post{$first} ;
            }
        }

        if (defined $first and $first =~ m/^([^*]+)\*(.+)$/) {
            $userules = ($1 eq $extprefix ? $extrules : '');
        } else {
            $userules = \%mrtgrules;
        }

        if ($first && defined $deflt{$first} && ($second eq '_')) {
            quickcheck($first,$second,$deflt{$first},$file,$line,$userules)
        } elsif ($first && $second && ($second !~ /^[\$^_]$/)) {
            quickcheck($first,$second,$$rcfg{$first}{$second},$file,$line,$userules)
        } elsif ($first && not $second) {
            quickcheck($first,0,$$cfg{$first},$file, $line,$userules)
        }

        if (/^([A-Za-z0-9*]+)\[(\S+)\]\s*:\s*(.*\S?)\s*$/) {
            $first = lc($1);
            $second = lc($2);
            # For us spelling-handicapped Americans. ;)
            # James Overbeck, grendel@gmo.jp, 2003/01/19
            if ($first eq 'colors') { $first = 'colours' };
            if ($second eq '^') {
                if ($3 ne '') {
                    $pre{$first}=$3;
                } else {
                    delete $pre{$first};
                }
                next;
            }
            if ($second eq '$') {
                if ($3 ne '') {
                    $post{$first}=$3;
                } else {
                    delete $post{$first};
                }
                next;
            }
            if ($second eq '_') {
                if ($3 ne '') {
                    $deflt{$first}=$3;
                } else {
                    delete $deflt{$first};
                }
                next;
            }

            if (not defined $routerhash{$second}) {
                    push (@{$routers}, $second);
                    $routerhash{$second} = 1;
            }
      
            # make sure that default tags spring into existance upon first 
            # call of a router

            foreach $key (keys %deflt) {
                if (! defined $$rcfg{$key}{$second}) {
                    $$rcfg{$key}{$second} = $deflt{$key};
                    $defaulted{$key}{$second} = 1;
                }
            }

            # make sure that prefix-only tags spring into existance upon first 
            # call of a router

            foreach $key (keys %pre) {
                if (! defined $$rcfg{$key}{$second}) {
                    delete $defaulted{$key}{$second} if $defaulted{$key}{$second};
                    $$rcfg{$key}{$second} = ( defined $$cfg{nospacechar} && $pre{$key} =~ m/(.*)\Q$$cfg{nospacechar}\E$/ ) ? $1 : $pre{$key}." ";
                }
            }

            if ($seen{$first}{$second}) {
                die ("ERROR: Line $line ($_) in CFG file ($file)\n".
                     "contains a duplicate definition for $first\[$second].\n".
                     "First definition is on line $seen{$first}{$second}\n")
            } else {
                $seen{$first}{$second} = $line;
            }

            if ($defaulted{$first}{$second}) {
                $$rcfg{$first}{$second} = '';
                delete $defaulted{$first}{$second};
            }
            $$rcfg{$first}{$second} .= $3;

            next;

        }
        if (/^(\S+):\s*(.*\S)\s*$/) {
            $first = lc($1);    
            $$cfg{$first} = $2;
            $second = '';
            next;
        }
        die "ERROR: Line $line ($_) in CFG file ($file)  does not make sense\n";
    }

    # append $ stuff to the very last tag in cfg file if necessary 
    if (defined $first && defined $second && defined $post{$first} && ($second !~ /^[\$^_]$/)) {
        if ($defaulted{$first}{$second}) {
            $$rcfg{$first}{$second} = $post{$first};
            delete $defaulted{$first}{$second};
        } else {
            $$rcfg{$first}{$second} .= 
	      ( defined $$cfg{'nospacechar'} && $post{$first} =~ /(.*)\Q$$cfg{nospacechar}\E$/ ) ? $1 : " ".$post{$first} ;      
        }
    }
  
    #check the last input line
    if ($first =~ m/^([^*]+)\*(.+)$/) {
        $userules = ($1 eq $extprefix ? $extrules : '');
    } else {
        $userules = \%mrtgrules;
    }
    if ($first && defined $deflt{$first} && ($second eq '_')) {
        quickcheck($first,$second,$deflt{$first},$file,$.,$userules)
    } elsif ($first && $second && ($second !~ /^[\$^_]$/)) {
        quickcheck($first,$second,$$rcfg{$first}{$second},$file,$.,$userules)
    } elsif ($first && not $second) {
        quickcheck($first,0,$$cfg{$first},$file,$.,$userules)
    }

    close (CFG);
}

# quick checks

sub quickcheck ($$$$$$) {
    my ($first,$second,$arg,$file,$line,$rules) = @_;
    return unless ref($rules) eq 'HASH';
    my $braces = $second ? '[]':'';
    if (exists $rules->{$first.$braces}) {
        if (&{$rules->{$first.$braces}[0]}($arg)) {
            return 1;
        } else {
            if ($second) {
                die "ERROR: CFG Error in \"$first\[$second\]\", line $line: ".
                  &{$rules->{$first.$braces}[1]}($arg)."\n\n"; 
            } else {
                die "ERROR: CFG Error in \"$first\", line $line: ".
                  &{$rules->{$first.$braces}[1]}($arg)."\n\n"; 
            } 
        }
    }
    die "ERROR: CFG Error Unknown Option \"$first\" on line $line or above.\n".
      "           Check doc/reference.txt for Help\n\n";
}

# complex config checks

sub mkdirhier ($){
    my @dirs = split /\Q${MRTG_lib::SL}\E+/, shift;
    my $path = "";
    while (@dirs){
	$path .= shift @dirs;
	$path .= ${MRTG_lib::SL};
	if (! -d $path){
                warn ("WARNING: $path did not exist I will create it now\n");
		mkdir $path, 0777  or die ("ERROR: mkdir $path: $!\n");
	}
    }
}

sub cfgcheck ($$$$;$) {
    my $routers = shift;
    my $cfg = shift;
    my $rcfg = shift;
    my $target = shift;
    my $opts = shift || {};
    my ($rou, $confname, $one_option);
    # Target index hash. Keys are "int:community@router" target definition
    # strings and values are indices of the @$target array. Used to avoid
    # duplicate entries in @$target.
    my $targIndex = { };
    my $error="no";
    my(@known_options) = qw(growright bits noinfo absolute gauge nopercent avgpeak derive
			    integer perhour perminute transparent dorelpercent 
			    unknaszero withzeroes noborder noarrow noi noo
			    nobanner nolegend logscale secondmean pngdate printrouter expscale);

    snmpmapOID('hrSystemUptime' => '1.3.6.1.2.1.25.1.1');

    if (defined $$cfg{workdir}) {
        die ("ERROR: WorkDir must not contain spaces when running on Windows. (Yeat another reason to get Linux)\n")
                if ($OS eq 'NT' or $OS eq 'OS2') and $$cfg{workdir} =~ /\s/;
        ensureSL(\$$cfg{workdir});
        $$cfg{logdir}=$$cfg{htmldir}=$$cfg{imagedir}=$$cfg{workdir};
        mkdirhier "$$cfg{workdir}"  unless $opts->{check};
        
    } elsif ( not (defined $$cfg{logdir} or defined $$cfg{htmldir} or defined $$cfg{imagedir})) {
          die ("ERROR: \"WorkDir\" not specified in mrtg config file\n");
	  $error = "yes";
    } else {
        if (! defined $$cfg{logdir}) {
            warn ("WARNING: \"LogDir\" not specified\n");
            $error = "yes";
        } else {
          ensureSL(\$$cfg{logdir});
          mkdirhier $$cfg{logdir} unless $opts->{check};
        }
        if (! defined $$cfg{htmldir}) {
            warn ("WARNING: \"HtmlDir\" not specified\n");
            $error = "yes";
        } else {
          ensureSL(\$$cfg{htmldir});
          mkdirhier $$cfg{htmldir}  unless $opts->{check};
        }
        if (! defined $$cfg{imagedir}) {
            warn ("WARNING: \"ImageDir\" not specified\n");
            $error = "yes";
        } else {
          ensureSL(\$$cfg{imagedir});
          mkdirhier $$cfg{imagedir}  unless $opts->{check};
        }
    }
    if ($cfg->{threshmailserver} and not $cfg->{threshmailsender}){
	warn ("WARNING: If \"ThreshMailServer\" is defined, then \"ThreshMailSender\" must be defined too.\n");
        $error = "yes";
    }
    if ($cfg->{threshmailsender} and not $cfg->{threshmailserver}){
	warn ("WARNING: If \"ThreshMailSender\" is defined, then \"ThreshMailServer\" must be defined too.\n");
        $error = "yes";
    }
 
    $cfg->{threshhyst} = 0.1 unless $cfg->{threshhyst};
    # build relativ path from htmldir to image dir.
    my @htmldir = split /\Q${MRTG_lib::SL}\E+/, $$cfg{htmldir};
    my @imagedir =  split /\Q${MRTG_lib::SL}\E+/, $$cfg{imagedir};
    while (scalar @htmldir > 0 and $htmldir[0] eq $imagedir[0]) {
    	shift @htmldir; shift @imagedir;
    }
    # this is for the webpages so we use / path separator always
    $$cfg{imagehtml} = "";
    foreach my $dir ( @htmldir ) {
        $$cfg{imagehtml} .= "../" if $dir;
    }
    map {$$cfg{imagehtml} .= "$_/" } @imagedir;
    # relative path is built
    debug('dir', "imagehtml = $$cfg{imagehtml}");

    $SNMP_util::CacheFile = "$$cfg{'logdir'}oid-mib-cache.txt";

    if (defined $$cfg{loadmibs}) {
        my($mibFile);
        foreach $mibFile (split /[,\s]+/, $$cfg{loadmibs}) {
            snmpQueue_MIB_File($mibFile);
        }
    }
    if(defined $$cfg{pathadd}){
        ensureSL(\$$cfg{pathadd});        
        $ENV{PATH} = "$$cfg{pathadd}${MRTG_lib::PS}$ENV{PATH}";
    }
    if(defined $$cfg{libadd}){
        ensureSL(\$$cfg{libadd});
        debug('eval',"libadd $$cfg{libadd}\n");
	local $SIG{__DIE__};
        eval "use lib qw( $$cfg{libadd} )";
	my @match;
	foreach my $dir (@INC){
		push @match, $dir if -f "$dir/RRDs.pm";
	}
	warn "WARN: found several copies of RRDs.pm in your path: ".
        (join ", ", @match)." I will be using $match[0]. This could ".
	"be a problem if this is an old copy and you think I would be using a newer one!\n"
		if $#match > 0;
    }
    $$cfg{logformat} = 'rateup' unless defined $$cfg{logformat};

    if($$cfg{logformat} eq 'rrdtool') {
        my ($name);
        if ($MRTG_lib::OS eq 'NT' or $MRTG_lib::OS eq 'OS2'){
            $name = "rrdtool.exe";
        } elsif ($MRTG_lib::OS eq 'NW'){
            $name = "rrdtool.nlm";
        } else {
            $name = "rrdtool";
        }
        foreach my $path (split /\Q${MRTG_lib::PS}\E/, $ENV{PATH}) {
            ensureSL(\$path);
            -f "$path$name" && do { 
                $$cfg{'rrdtool'} = "$path$name";
                last;}
        };
        die "ERROR: could not find $name. Use PathAdd: in mrtg.cfg to help mrtg find rrdtool\n" 
                unless defined $$cfg{rrdtool};
        debug ('rrd',"found rrdtool in $$cfg{rrdtool}");
        my $found;
        foreach my $path (@INC) {
            ensureSL(\$path);
            -f "${path}RRDs.pm" && do { 
                $found=1;
                last;}
        };
        die "ERROR: could not find RRDs.pm. Use LibAdd: in mrtg.cfg to help mrtg find RRDs.pm\n" 
                unless defined $found;
    }
    if (defined $$cfg{snmpoptions}) {
	   debug('eval',"redef snmpotions $cfg->{snmpoptions}");
	   local $SIG{__DIE__};
           $cfg->{snmpoptions} = eval('{'.$cfg->{snmpoptions}.'}');
    }

    # default interval is 5 minutes
    if ($cfg->{interval} and $cfg->{interval} =~ /(\d+)(?::(\d+))?/){
	$cfg->{interval} = $1;
	$cfg->{interval} += $2/60.0 if $2;
    } else {
        $cfg->{interval} = 5;
    }
    unless ($$cfg{logformat} eq 'rrdtool') {
        # interval has to be 5 minutes at least without userrdtool
        if ($$cfg{interval} < 5.0) {
            die "ERROR: CFG Error in \"Interval\": should be at least 5 Minutes (unless you use rrdtool)";
        }
    }

    # Check for a Conversion Code file and evaluate its contents, which
    # should consist of one or more subroutine definitions. The code goes
    # into the MRTGConversion name space.
    if( exists $cfg->{ conversioncode } ) {
        open CONV, $cfg->{ conversioncode }
            or die "ERROR: Can't open file $cfg->{ conversioncode }\n";
        my $code = "local \$SIG{__DIE__};package MRTGConversion;\n". join( '', <CONV> ) . "1;\n";
        close CONV;
        debug('eval',"covnversioncode  $cfg->{ conversioncode }");
        die "ERROR: File $cfg->{ conversioncode } conversion code evaluation failed\n$@\n"
            unless eval $code;
    }
    my $thresh_error;

    foreach $rou (@$routers) {
        # and now for the testing
	if (defined $rcfg->{threshmailaddress}{$rou}){
	    if (not defined  $cfg->{threshmailserver} and not $thresh_error){
		warn (qq{ERROR: ThreshMailAddress[$rou]: specified without "ThreshMailServer:"});
		$error = "yes";
		$thresh_error = "yes";
            }
	    # the dependency between sender and server is taken care of already
	}	
	if (! defined $rcfg->{snmpoptions}{$rou}) {
		$rcfg->{snmpoptions}{$rou} = {%{$cfg->{snmpoptions}}}
		  if defined $cfg->{snmpoptions};
    	} else {
                debug('eval',"redef snmpoptions[$rou] $rcfg->{snmpoptions}{$rou}");
 		local $SIG{__DIE__};
    	        $rcfg->{snmpoptions}{$rou} = eval('{'.$rcfg->{snmpoptions}{$rou}.'}');
        }
        $rcfg->{snmpoptions}{$rou}{avoid_negative_request_ids} = 1;
        # $rcfg->{snmpoptions}{$rou}{domain} = 'udp';
        
        if (! defined $$rcfg{"title"}{$rou}) {
            warn ("WARNING: \"Title[$rou]\" not specified\n");
            $error = "yes";
        }
        if (defined $$rcfg{'directory'}{$rou} and $$rcfg{'directory'}{$rou} ne "") {
            # They specified a directory for this router.  Append the
            # pathname seperator to it (so that it can either be present or
            # absent, and the rules for including it are the same).
	    ensureSL(\$$rcfg{'directory'}{$rou});
            for my $x (qw(imagedir logdir htmldir)) {
                mkdirhier $$cfg{$x}.$$rcfg{directory}{$rou}  unless $opts->{check};
            }                   
            $$rcfg{'directory_web'}{$rou} = $$rcfg{'directory'}{$rou};
	    $$rcfg{'directory_web'}{$rou} =~ s/\Q${MRTG_lib::SL}\E+/\//g;
            debug('dir', "directory for $rou '$$rcfg{'directory_web'}{$rou}'");
        } else {
                $$rcfg{'directory'}{$rou}="";
                $$rcfg{'directory_web'}{$rou}="";
        }

     	if (defined $$rcfg{"pagetop"}{$rou}) {
            $$rcfg{"pagetop"}{$rou} =~ s/\\n/\n/g;
        }


        if (defined $$rcfg{"pagefoot"}{$rou}) {
            # allow for linebreaks
            $$rcfg{"pagefoot"}{$rou} =~ s/\\n/\n/g;
        }
 
        $$rcfg{"maxbytes1"}{$rou} = $$rcfg{"maxbytes"}{$rou} unless defined $$rcfg{"maxbytes1"}{$rou};
        $$rcfg{"maxbytes2"}{$rou} = $$rcfg{"maxbytes"}{$rou} unless defined $$rcfg{"maxbytes2"}{$rou};

        if (    not defined $$rcfg{"maxbytes"}{$rou} 
            and not defined $$rcfg{"maxbytes1"}{$rou} 
            and not defined $$rcfg{"maxbytes2"}{$rou}) {
            warn ("WARNING: \"MaxBytes[$rou]\" not specified\n");
            $error = "yes";
        } else {

        if (not defined $$rcfg{"maxbytes1"}{$rou}) {
            warn ("WARNING: \"MaxBytes1[$rou]\" not specified\n");
            $error = "yes";
        }
        if (not defined $$rcfg{"maxbytes2"}{$rou}) {
            warn ("WARNING: \"MaxBytes2[$rou]\" not specified\n");
            $error = "yes";
        }
        }
        # set default extension
        if (! defined $$rcfg{"extension"}{$rou}) {
            $$rcfg{"extension"}{$rou}="html";
        }

        # set default size 
        if (! defined $$rcfg{"xsize"}{$rou}) {
            $$rcfg{"xsize"}{$rou}=400;
        } 
        if (! defined $$rcfg{"ysize"}{$rou}) {
            $$rcfg{"ysize"}{$rou}=100;
        }
        if (! defined $$rcfg{"ytics"}{$rou}) {
            $$rcfg{"ytics"}{$rou}=4;
        }
        if (! defined $$rcfg{"yticsfactor"}{$rou}) {
            $$rcfg{"yticsfactor"}{$rou}=1;
        }
        if (! defined $$rcfg{"factor"}{$rou}) {
            $$rcfg{"factor"}{$rou}=1;
        }
    
        if (defined $$rcfg{"options"}{$rou}) {      
            my $opttemp = lc($$rcfg{"options"}{$rou});          
            delete $$rcfg{"options"}{$rou};
            foreach $one_option (split /[,\s]+/, $opttemp) {
                if (grep {$one_option eq $_} @known_options) {
                    $$rcfg{'options'}{$one_option}{$rou} = 1;
                } else {
                    warn ("WARNING: Option[$rou]: \"$one_option\" is unknown\n");
                    $error="yes";
                }
            }
	    if ($rcfg->{'options'}{derive}{$rou} and not $cfg->{logformat} eq 'rrdtool'){
		    warn ("WARNING: Option[$rou]: \"derive\" works only with rrdtool logformat\n");
		    $error="yes";
	    }
        }
        #
        # Check out routeruptime definition
        #
        if (defined $$rcfg{"routeruptime"}{$rou}) {
            ($$rcfg{"community"}{$rou},$$rcfg{"router"}{$rou}) =
              split(/@/,$$rcfg{"routeruptime"}{$rou});
        }
        #
        # Check out target definition
        #
        if (defined $$rcfg{"target"}{$rou}) {
            $$rcfg{targorig}{$rou} = $$rcfg{target}{$rou};
	    debug ('tarp',"Starting $rou -> $$rcfg{target}{$rou}");
            # Decide whether to turn on IPv6 support for this target.
            # IPv6 support is turned on only if the EnableIPv6 global
            # setting is yes and the IPv4Only per-target setting is no.
            # If IPv6 is disabled, we set IPv4Only to true for all
            # targets, thus disabling all IPv6-related code.
            my $ipv4only = 1;
            if ($$cfg{enableipv6} and $$cfg{enableipv6} eq 'yes') {
                # IPv4Only is off by default
                $ipv4only = 0
                  unless (defined $$rcfg{ipv4only}{$rou}) && (lc($$rcfg{ipv4only}{$rou}) eq 'yes');
            }
	    # Check if nohc has been set, designating a low-speed interface
	    # without working HC counters.  Default is that high-speed
	    # counters exist.
	    my $nohc = 0;
	    $nohc = 1 if (defined $$rcfg{nohc}{$rou}) && (lc($$rcfg{nohc}{$rou}) eq 'yes');
	    
	    ( $$rcfg{target}{$rou}, $$rcfg{uniqueTarget}{$rou} ) =
		targparser( $$rcfg{target}{$rou}, $target, $targIndex, $ipv4only, $rcfg->{snmpoptions}{$rou}, $nohc );
        } else {
            warn ("WARNING: I can't find a \"target[$rou]\" definition\n");
            $error = "yes";
        }

        # colors format: name#hexcol,
        if (defined $$rcfg{"colours"}{$rou}) {
            if ($$rcfg{'options'}{'dorelpercent'}{$rou}) {
                if ($$rcfg{"colours"}{$rou} =~  
                    /^([^\#]+)(\#[0-9a-f]{6})\s*,\s*
                     ([^\#]+)(\#[0-9a-f]{6})\s*,\s*
                     ([^\#]+)(\#[0-9a-f]{6})\s*,\s*
                     ([^\#]+)(\#[0-9a-f]{6})\s*,\s*
                     ([^\#]+)(\#[0-9a-f]{6})/ix) {
                    ($$rcfg{'col1'}{$rou}, $$rcfg{'rgb1'}{$rou},
                     $$rcfg{'col2'}{$rou}, $$rcfg{'rgb2'}{$rou},
                     $$rcfg{'col3'}{$rou}, $$rcfg{'rgb3'}{$rou},
                     $$rcfg{'col4'}{$rou}, $$rcfg{'rgb4'}{$rou},
                     $$rcfg{'col5'}{$rou}, $$rcfg{'rgb5'}{$rou}) = 
                       ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);
                } else {
                    warn ("WARNING: \"colours[$rou]\" for colour definition\n".
                          "       use the format: Name#hexcolour, Name#Hexcolour,...\n",
                          "       note, that dorelpercent requires 5 colours");
                    $error="yes";
                }
            } else {            
                if ($$rcfg{"colours"}{$rou} =~  
                    /^([^\#]+)(\#[0-9a-f]{6})\s*,\s*
                     ([^\#]+)(\#[0-9a-f]{6})\s*,\s*
                     ([^\#]+)(\#[0-9a-f]{6})\s*,\s*
                     ([^\#]+)(\#[0-9a-f]{6})/ix) {
                    ($$rcfg{'col1'}{$rou}, $$rcfg{'rgb1'}{$rou},
                     $$rcfg{'col2'}{$rou}, $$rcfg{'rgb2'}{$rou},
                     $$rcfg{'col3'}{$rou}, $$rcfg{'rgb3'}{$rou},
                     $$rcfg{'col4'}{$rou}, $$rcfg{'rgb4'}{$rou}) =
                       ($1, $2, $3, $4, $5, $6, $7, $8);
                } else {
                    warn "WARNING: \"colours[$rou]\" for colour definition\n".
                          "       use the format: Name#hexcolour, Name#Hexcolour,...\n";
                    $error="yes";
                }
            }
        } else {            
            if (defined $$rcfg{'options'}{'dorelpercent'}{$rou}) {
                ($$rcfg{'col1'}{$rou}, $$rcfg{'rgb1'}{$rou},
                 $$rcfg{'col2'}{$rou}, $$rcfg{'rgb2'}{$rou},
                 $$rcfg{'col3'}{$rou}, $$rcfg{'rgb3'}{$rou},
                 $$rcfg{'col4'}{$rou}, $$rcfg{'rgb4'}{$rou},
                 $$rcfg{'col5'}{$rou}, $$rcfg{'rgb5'}{$rou}) = 
                   ("GREEN","#00cc00",
                    "BLUE","#0000ff",
                    "DARK GREEN","#006600",
                    "MAGENTA","#ff00ff",
                    "AMBER","#ef9f4f");
            } else {            
                ($$rcfg{'col1'}{$rou}, $$rcfg{'rgb1'}{$rou},
                 $$rcfg{'col2'}{$rou}, $$rcfg{'rgb2'}{$rou},
                 $$rcfg{'col3'}{$rou}, $$rcfg{'rgb3'}{$rou},
                 $$rcfg{'col4'}{$rou}, $$rcfg{'rgb4'}{$rou}) =
                   ("GREEN","#00cc00",
                    "BLUE","#0000ff",
                    "DARK GREEN","#006600",
                    "MAGENTA","#ff00ff");
            }
        }
        # Background color, format: #rrggbb
        if (! defined $$rcfg{'background'}{$rou}) {
            $$rcfg{'background'}{$rou} = "#ffffff";
        }
        if ($$rcfg{'background'}{$rou} =~ /^(\#[0-9a-f]{6})/i) {
            $$rcfg{'backgc'}{$rou} = "$1";
        } else {
            warn "WARNING: \"background[$rou]: ".
                  "$$rcfg{'background'}{$rou}\" for colour definition\n".
                  "       use the format: #rrggbb\n";
            $error="yes";
        }

        if (! defined  $$rcfg{'kilo'}{$rou}) {
            $$rcfg{'kilo'}{$rou} = 1000;
        }
        if (defined $$rcfg{'kmg'}{$rou}) {
            $$rcfg{'kmg'}{$rou} =~ s/\s+//g;
        }

        if (! defined $$rcfg{'xzoom'}{$rou}) {
            $$rcfg{'xzoom'}{$rou} = 1.0;
        }
        if (! defined $$rcfg{'yzoom'}{$rou}) {
            $$rcfg{'yzoom'}{$rou} = 1.0;
        }
        if (! defined $$rcfg{'xscale'}{$rou}) {
            $$rcfg{'xscale'}{$rou} = 1.0;
        }
        if (! defined $$rcfg{'yscale'}{$rou}) {
            $$rcfg{'yscale'}{$rou} = 1.0;
        }
        if (! defined $$rcfg{'timestrpos'}{$rou}) {
            $$rcfg{'timestrpos'}{$rou} = 'NO';
        }
        if (! defined $$rcfg{'timestrfmt'}{$rou}) {
            $$rcfg{'timestrfmt'}{$rou} = "%Y-%m-%d %H:%M";
        }
        if ($error eq "yes") {        
            die "ERROR: Please fix the error(s) in your config file\n";
        }
    }
}

# make sure string ends with a slash.
sub ensureSL($) {
#  return;
  my $ref = shift;
  return if not $$ref;
  debug('dir',"ensure path IN:  '$$ref'");
  if (${MRTG_lib::SL} eq '\\'){
     # two slashes at the start of the string are OK
     $$ref =~ s/(.)\Q${MRTG_lib::SL}\E+/$1${MRTG_lib::SL}/g;
  } else {
     $$ref =~ s/\Q${MRTG_lib::SL}\E+/${MRTG_lib::SL}/g;
  }
  $$ref =~ s/\Q${MRTG_lib::SL}\E*$/${MRTG_lib::SL}/;
  debug('dir',"ensure path OUT: '$$ref'");
}

# convert current supplied time into a nice date string

sub datestr ($) {
    my ($time) = shift || return 0;
    my ($wday) = ('Sunday','Monday','Tuesday','Wednesday',
                  'Thursday','Friday','Saturday')[(localtime($time))[6]];
    my ($month) = ('January','February' ,'March' ,'April' ,
                   'May' , 'June' , 'July' , 'August' , 'September' , 
                   'October' ,
                   'November' , 'December' )[(localtime($time))[4]];
    my ($mday,$year,$hour,$min) = (localtime($time))[3,5,2,1];
    if ($min<10) {
        $min = "0$min";
    }
    return "$wday, $mday $month ".($year+1900)." at $hour:$min";
}


# create expire date for expiery in ARG Minutes

sub expistr ($) {
    my ($time) = time+int($_[0]*60)+5;
    my ($wday) = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat')[(gmtime($time))[6]];
    my ($month) = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep', 
                   'Oct','Nov','Dec')[(gmtime($time))[4]];
    my ($mday,$year,$hour,$min,$sec) = (gmtime($time))[3,5,2,1,0];
    if ($mday<10) {
        $mday = "0$mday";
    }
    ;
    if ($hour<10) {
        $hour = "0$hour";
    }
    ;
    if ($min<10) {
        $min = "0$min";
    }
    if ($sec<10) {
        $sec = "0$sec";
    }
    return "$wday, $mday $month ".($year+1900)." $hour:$min:$sec GMT";
}

sub create_pid ($) {
    my $pidfile = shift;
    return if ($OS eq 'NT' );
    return if -e $pidfile;
    if ( open(PIDFILE,">$pidfile")) {
         close PIDFILE;
    } else {
         warn "cannot write to $pidfile: $!\n";
    }
}

sub demonize_me ($) {
    my $pidfile = shift;
    my $cfgfile = shift;
    print "Daemonizing MRTG ...\n";
    if ( $OS eq 'NT' ) {
        print "Do Not close this window. Or MRTG will die\n";
#            require Win32::Console;
#            my $CONSOLE = new Win32::Console;
        #    detach process from Console
#            $CONSOLE->Flush();
#            $CONSOLE->Free();
#            $CONSOLE->Alloc();
#            $CONSOLE->Mode()
    }
    elsif( $OS eq 'OS2')
    {
     require OS2::Process;
     if (my_type() eq 'VIO'){
        $main::Cleanfile3 = $pidfile;

        print "MRTG detached. PID=".system(P_DETACH,$^X." ".$0." ".$cfgfile);
        exit;
     }
    } else {
           # Check out if there is another mrtg running before forking
           if (defined $pidfile && open(READPID, "<$pidfile")){
               if (not eof READPID) {
                   chomp(my $input = <READPID>);    # read process id in pidfile
                   if ($input && kill 0 => $input) {# oops - the pid actually exists
                        die "ERROR: I Quit! Another copy of mrtg seems to be running. Check $pidfile\n";
                   }
               }
               close READPID;
           }

           defined (my $pid = fork) or die "Can't fork: $!";
           if ($pid) {
              exit;
            } else {
                if (defined $pidfile){
                   $main::Cleanfile3 = $pidfile;
                   if (open(PIDFILE,">$pidfile")) {
                        print PIDFILE "$$\n";
                        close PIDFILE;
                   } else {
                        warn "cannot write to $pidfile: $!\n";
                   }
              }
              require 'POSIX.pm';
              POSIX::setsid() or die "Can't start a new session: $!";
              open STDOUT,'>/dev/null' or die "ERROR: Redirecting STDOUT to /dev/null: $!";
              open STDERR,'>/dev/null' or die "ERROR: Redirecting STDERR to /dev/null: $!";
              open STDIN, '</dev/null' or die "ERROR: Redirecting STDIN from /dev/null: $!";
      }
   }
}

# Create a new SNMP target entry for the @$target array and return a
# reference to it
sub newSnmpTarg( $$ ) {
	my $t = shift;		# target string
	my $if = shift;		# interface match strings
	my $targ = { };		# New target closure
	$targ->{ Methode }		= 'SNMP';
	$targ->{ Community }	= $if->{ComStr};
	$targ->{ Host }			= ( defined $if->{HostIPv6} ) ? $if->{HostIPv6} : $if->{HostName};
	$targ->{ SnmpOpt }		= $if->{SnmpInfo};
	$targ->{ snmpoptions} 		= $if->{snmpoptions};
	$targ->{ Conversion }	= ( defined $if->{ConvSub} ) ? $if->{ConvSub} : '';
	for my $i( 0..1 ) {
		die 'ERROR: Malformed ', $i ? 'output ' : 'input ', "ifSpec in '$t'\n"
			if not defined $if->{OID}[$i] and not defined $if->{Alt}[$i];
		$targ->{OID}[$i]				= $if->{OID}[$i];
		if( defined $if->{Alt}[$i] ) {
			if( defined $if->{Num}[$i] ) {
				$targ->{IfSel}[$i]		= 'If';
				$targ->{Key}[$i]		= $if->{Num}[$i];
			} elsif( defined $if->{IP}[$i] ) {
				$targ->{IfSel}[$i]		= 'Ip';
				$targ->{Key}[$i]		= $if->{IP}[$i];
			} elsif( defined $if->{Desc}[$i] ) {
				$targ->{IfSel}[$i]		= 'Descr';
				$targ->{Key}[$i]		= $if->{Desc}[$i];
			} elsif( defined $if->{Name}[$i] ) {
				$targ->{IfSel}[$i]		= 'Name';
				$targ->{Key}[$i]		= $if->{Name}[$i];
			} elsif( defined $if->{Eth}[$i] ) {
				$targ->{IfSel}[$i]		= 'Eth';
				$targ->{Key}[$i]		= join( '-', map( { sprintf '%02x', hex $_ } split( /-/, $if->{Eth}[$i] ) ) );
			} elsif( defined $if->{Type}[$i] ) {
				$targ->{IfSel}[$i]		= 'Type';
				$targ->{Key}[$i]		= $if->{Type}[$i];
			} else {
				die "ERROR: Internal error parsing ifSpec in '$t'\n";
			}
		} else {
			$targ->{IfSel}[$i]			= 'None';
			$targ->{Key}[$i]			= '';
		}
		# Remove escaped characters and trailing space from Descr or Name Key
		$targ->{Key}[$i] =~ s/\\([\s:&@])/$1/g
			if $targ->{IfSel}[$i] eq 'Descr' or $targ->{IfSel}[$i] eq 'Name';
		$targ->{Key}[$i] =~ s/[\0- ]+$//;
	}
	# Remove escaped characters from community
	$targ->{ Community } =~ s/\\([ @])/$1/g;
	return $targ;	# Return new target closure
}

# ( $string, $unique ) = targparser( $string, $target, $targIndex, $ipv4only )
# Walk amd analyze the target string $string. $target is a reference to the
# array of targets being built. $targIndex is a reference to a hash of targets
# previously encountered indexed by target string. When $ipv4only is nonzero,
# only IPv4 is in use. Returns the modifed target string and the index of the
# @$target array to which the target refers if that index is unique. If the
# index is not unique, i.e. the target definition is a calculation involving
# two or more different targets, then the value -1 is returned for $unique.
# Targparser updates the target array avoiding duplicate targets. The goal is
# to substitute all target definitions with strings of the form
# "$t1$thisTarg$t2", where $thisTarg is the target index, and $t1 and $t2 are
# as defined below. The intended result is a target string that can be eval'ed
# in its entirety later on when monitoring data has been collected. This
# evaluation occurs in sub getcurrent in the main mrtg script.

# Note: In the regular expressions in &targparser, we have avoided m/.../i
# and the variables &`, $&, and $'. Use of these makes regex processing less
# efficient. See Friedl, J.E.F. Mastering Regular Expressions. O'Reilly.
# p. 273

sub targparser( $$$$$$ ) {
	# Target string (int:community@router, etc.)
	my $string = shift;
	# Reference to target array
	my $target = shift;
	# Reference to target index hash
	my $targIndex = shift;
	# Nonzero if only IPv4 is in use
	my $ipv4only = shift;
	# options passed per target.
	my $snmpoptions = shift;
	# Highspeed Counter test
	my $nohc = shift;
	
	# Next available index in the @$target array
	my $idx = @$target;
	# Common match strings: pre-target, target, post-target
	my( $pre, $t, $post );
	# Portion of string already parsed
	my $parsed = '';
	# Initialize $unique to undefined. It will take on the $targIndex value
	# of the first target encountered. $otherTargCount will count the
	# number of other targets (targets with different values of $targIndex)
	# encountered during the parse. $unique will be returned as undef
	# unless $otherTargCount remains 0.
	my $unique = -1;
	my $otherTargCount = 0;

	# Components of the target expression that are substituted into the
	# target string each time a target is identified. The substitution
	# string is the interpolated value of "$t1$targIndex$t2". At present
	# $t1 and $t2 are set to create a new BigFloat object.
#	my $t1 = ' Math::BigFloat->new($target->[';
#	my $t2 = ']{$mode}) ';
        # this gives problems with perl 5.005 so bigfloat is introduces in mrtg itself
	my $t1 = ' $target->[';
	my $t2 = ']{$mode} ';

	# Find and substitute all external program targets
	while( ( $pre, $t, $post ) = $string =~ m<
		^(.*?)					# capture pre-target string
		`						# beginning of program target
		((?:\\`|[^`])+)			# capture target contents (\` allowed)
		`						# end of program target
		(.*)$					# capture post-target string
	>x ) {						# Total of 3 captures
		my $thisTarg;
		if( exists $targIndex->{ $t } ) {
			# This program target has been encountered previously
			$thisTarg = $targIndex->{ $t };
			debug( 'tarp', "Existing program target [$thisTarg]" );
		} else {
			# A new program target is needed
			my $targ = { };
			$targ->{ Methode } = 'EXEC';
			$targ->{ Command } = $t;
			# Remove escaped backticks
			$targ->{ Command } =~ s/\\\`/\`/g;
			$target->[ $idx ] = $targ;
			$thisTarg = $idx++;
			$targIndex->{ $t } = $thisTarg;
			debug( 'tarp', "New program target [$thisTarg] '$t'" );
		}
		$parsed .= "$pre$t1$thisTarg$t2";
		$string = $post;
		if( $unique < 0 ) {
			$unique = $thisTarg;
		} else {
			$otherTargCount++ unless $thisTarg == $unique;
		}
	};
	# Reset $string for new target type search
	$string = $parsed . $string;
	$parsed = '';
	debug( 'tarp', "&targparser external done: '$string'" );

	# Common interface specification regex components

	# Simple interface specification regex component. Matches interface
	# specification by IPv4 address, description, name, Ethernet address, or
	# type.
	my $ifSimple =
		'       (\d+)|' .				# by number ($if->{Num})
		'  /    (\d+(?:\.\d+)+)|' .		# by IPv4 address ($if->{IP})
		'  \\\\ ((?:\\\\[\s:&@]|[^\s:&@])+)|' . # by description (allow \  \: \& \@) ($if->{Desc})
		'  \#   ((?:\\\\[\s:&@]|[^\s:&@])+)|' . # by name (allow \  \: \& \@) ($if->{Name})
		'  !    ([a-fA-F0-9]+(?:-[a-fA-F0-9]+)+)|' . # by Ethernet address ($if->{Eth})
		'  %    (\d+)'; 				# by type ($if->{Type})

	# Complex interface specification regex component. Note that a null string
	# will match. Therefore the match must be postprocessed to check that
	# $ifOID and $ifAlt are not both null.
	my $ifComplex =
		'((?:\.\d+)*?\.?[-a-zA-Z0-9]*(?:\.\d+)*?)' .	# OID possibly starting with a MIB name ($if->{OID})
		'(' .							# Interface specification alternatives: ($if->{Alt})
			'\.' .						#  separator
			$ifSimple .					#  simple alternatives (6 variables)
		')?';							#  maybe none of the above

	# Community-host interface specification regex component.
	my $ifComHost =
		'((?:\\\\[@ ]|[^\s@])+)' .		# community string ('\@' and '\ ' allowed) ($if->{ComStr})
			'@' .						# separator
		'(?:(\[[a-fA-F0-9:]*\])|' .		# hostname as IPv6 address ($if->{HostIPv6})
		'([-\w]+(?:\.[-\w]+)*))' .		# or DNS name ($if->{HostName})
		'((?::[\d.!]*)*)' .				# SNMP session configuration ($if->{SnmpInfo})
		'(?:\|([a-zA-Z_][\w]*))?';		# numeric conversion subroutine ($if->{ConvSub})

	# Match strings for simple and complex interface specifications. Entries
	# are of the form $if->{k1}[i], where k1 is OID, Alt, Num, IP, Desc,
	# Name, Eth, or Type, and i is 0 or 1 (input or output). Entries may also
	# have the form $if->{k1}, where k1 is Rev, ComStr, HostIPv6, HostName,
	# SnmpInfo, or ConvSub, with no [i] in these cases.
	my $if;

	# Find and substitute all complex OID targets

	while( ( $pre, $t, $if->{OID}[0], $if->{Alt}[0], $if->{Num}[0],
	$if->{IP}[0], $if->{Desc}[0], $if->{Name}[0], $if->{Eth}[0],
	$if->{Type}[0], $if->{OID}[1], $if->{Alt}[1], $if->{Num}[1],
	$if->{IP}[1], $if->{Desc}[1], $if->{Name}[1], $if->{Eth}[1],
	$if->{Type}[1], $if->{ComStr}, $if->{HostIPv6}, $if->{HostName},
	$if->{SnmpInfo}, $if->{ConvSub}, $post ) = $string =~ m<
		^(.*?)					# capture pre-target string
		(						# capture entire target
			${ifComplex}		# input interface specification (8 captures)
				&				# separator
			${ifComplex}		# output interface specification (8 captures)
				:				# separator
			${ifComHost}		# community-host specification (5 captures)
		)						# end of entire target capture
		(.*)$					# capture post-target string
	>x ) {						# Total of 24 captures
		my $thisTarg;
		# Exception: skip and try to parse later as a simple target if
		# $if->{Desc}[0], $if->{Name}[0], $if->{Desc}[1], or $if->{Name}[1]
		# ends with a backslash character
		if( ( defined $if->{Desc}[0] and $if->{Desc}[0] =~ m<\\$> ) or
			( defined $if->{Name}[0] and $if->{Name}[0] =~ m<\\$> ) or
			( defined $if->{Desc}[1] and $if->{Desc}[1] =~ m<\\$> ) or
			( defined $if->{Name}[1] and $if->{Name}[1] =~ m<\\$> ) ) {
			$parsed .= "$pre$t";
			$string = $post;
			next;
		}
		if( exists $targIndex->{ $t } ) {
			# This complex target has been encountered previously
			$thisTarg = $targIndex->{ $t };
			debug( 'tarp', "Existing complex target [$thisTarg]" );
		} else {
			# A new complex target is needed
			my $targ = newSnmpTarg( $t, $if );
			$targ->{ ipv4only } = $ipv4only;
			$targ->{ snmpoptions } = $snmpoptions;
			$target->[ $idx ] = $targ;
			$thisTarg = $idx++;
			$targIndex->{ $t } = $thisTarg;
			debug( 'tarp', "New complex target [$thisTarg] '$t':\n" .
				"  Comu:  $targ->{Community}, Host: $targ->{Host}\n" .
				"  Opt:   $targ->{SnmpOpt}, IPv4: $targ->{ipv4only}\n" .
				"  Conv:  $targ->{Conversion}\n" .
				"  OID:   $targ->{OID}[0], $targ->{OID}[1]\n" .
				"  IfSel: $targ->{IfSel}[0], $targ->{IfSel}[1]\n" .
				"  Key:   $targ->{Key}[0], $targ->{Key}[1]" );
		}
		$parsed .= "$pre$t1$thisTarg$t2";
		$string = $post;
		if( $unique < 0 ) {
			$unique = $thisTarg;
		} else {
			$otherTargCount++ unless $thisTarg == $unique;
		}
	}
	# Reset $string and $parsedfor new target type search
	$string = $parsed . $string;
	$parsed = '';
	debug( 'tarp', "&targparser complex done: '$string'" );

	# Find and substitute all simple targets

	while( ( $pre, $t, $if->{Rev}, $if->{Num}[0], $if->{IP}[0],
	$if->{Desc}[0], $if->{Name}[0], $if->{Eth}[0], $if->{Type}[0],
	$if->{ComStr}, $if->{HostIPv6}, $if->{HostName}, $if->{SnmpInfo},
	$if->{ConvSub}, $post ) = $string =~ m<
		^(.*?)					# capture pre-target string
		(						# capture entire target
			(-)?				# capture direction reversal
			(?: ${ifSimple} )	# simple interface specification (6 captures)
				:				# separator
			${ifComHost}		# community-host specification (5 captures)
		)						# end of entire target capture
		(.*)$					# capture post-target string
	>x ) {						# Total of 15 captures
		my $thisTarg;
		if( exists $targIndex->{ $t } ) {
			# This simple target has been encountered previously
			$thisTarg = $targIndex->{ $t };
			debug( 'tarp', "Existing simple target [$thisTarg]" );
		} else {
			# A new simple target is needed
			# Reverse interface directions if indicated by $if->{Rev}.
			# The sense of $d1 and $d2 is 0 for input and 1 for output
			my $d1 = ( defined $if->{Rev} and $if->{Rev} eq '-' ) ? 1 : 0;
			my $d2 = 1 - $d1;
			# Set the OIDs depending on whether SNMPv2 has been specified
			# and on the direction
			if( $if->{SnmpInfo} =~ m/(?::[^:]*){4}:[32][Cc]?/ and $nohc == 0 ) {
				$if->{OID}[$d1] = 'ifHCInOctets';
				$if->{OID}[$d2] = 'ifHCOutOctets';
			} else {
				$if->{OID}[$d1] = 'ifInOctets';
				$if->{OID}[$d2] = 'ifOutOctets';
			}
			# Give $if->{Alt}[i] an arbitrary defined value so that
			# &newSnmpTarg works correctly
			$if->{Alt}[0]	= 1;
			$if->{Alt}[1]	= 1;
			# Copy input specification to output
			$if->{Num}[1]	= $if->{Num}[0];
			$if->{IP}[1]	= $if->{IP}[0];
			$if->{Desc}[1]	= $if->{Desc}[0];
			$if->{Name}[1]	= $if->{Name}[0];
			$if->{Eth}[1]	= $if->{Eth}[0];
			$if->{Type}[1]	= $if->{Type}[0];
			my $targ = newSnmpTarg( $t, $if );
			$targ->{ snmpoptions} = $snmpoptions;
			$targ->{ ipv4only } = $ipv4only;
			$target->[ $idx ] = $targ;
			$thisTarg = $idx++;
			$targIndex->{ $t } = $thisTarg;
			debug( 'tarp', "New simple target [$thisTarg] '$t':\n" .
				"  Comu:  $targ->{Community}, Host: $targ->{Host}\n" .
				"  Opt:   $targ->{SnmpOpt}, IPv4: $targ->{ipv4only}\n" .
				"  Conv:  $targ->{Conversion}\n" .
				"  OID:   $targ->{OID}[0], $targ->{OID}[1]\n" .
				"  IfSel: $targ->{IfSel}[0], $targ->{IfSel}[1]\n" .
				"  Key:   $targ->{Key}[0], $targ->{Key}[1]" );
		}
		$parsed .= "$pre$t1$thisTarg$t2";
		$string = $post;
		if( $unique < 0 ) {
			$unique = $thisTarg;
		} else {
			$otherTargCount++ unless $thisTarg == $unique;
		}
	}
	# Assemble string to be returned
	$string = $parsed . $string;
	# Set $unique undefined if more than one target is referred to in the
	# target string
	$unique = -1 if $otherTargCount;
	debug( 'tarp', "&targparser simple done: '$string'" );
	debug( 'tarp', "&targparser returning: unique = $unique" );
	return ( $string, $unique );
}

# Display of &targparser intermediate values for debugging purposes. Call as
# showMatch( $string, $pre, $t, $post, $if ) from within &targparser.
sub showMatch( $$$$$ ) {
	my( $string, $pre, $t, $post, $if ) = @_;
	warn "# Matching on string '$string'\n";
	warn "# Prematch:  '$pre'\n";
	warn "# Target:    '$t'\n";
	warn "# Postmatch: '$post'\n";
	warn "# Captured:\n";
	foreach my $k( keys %$if ) {
		if( ref( $if->{$k} ) eq 'ARRAY' ) {
			warn "#  \$if->{$k}[0,1]: '",
				( defined $if->{$k}[0] ) ? $if->{$k}[0] : 'undef', "', '",
				( defined $if->{$k}[1] ) ? $if->{$k}[1] : 'undef', "'\n";
		} else {
			warn "#  \$if->{$k}:      '",
				( defined $if->{$k} ) ? $if->{$k} : 'undef', "'\n";
		}
	}
}

sub readconfcache ($) {
    my $cfgfile = shift;
    my %confcache;
    if (open (CFGOK,"<$cfgfile")) {
        while (<CFGOK>) {
            chomp;
            next unless /\t/; #ignore odd lines
	    next if /^\S+:/; #ignore legacy lines
            my ($host,$method,$key,$if) = split (/\t/, $_);
            $key =~ s/[\0- ]+$//; # no trailing whitespace in keys realy !
            $key =~ s/[\0- ]/ /g; # all else becomes a normal space ... get a life
            $confcache{$host}{$method}{$key} = $if;
        }
        close CFGOK;
    }
    return \%confcache;
}

sub writeconfcache ($$) {
    my $confcache = shift;
    my $cfgfile = shift;
    if ($cfgfile ne '&STDOUT'){
      open (CFGOK,">$cfgfile") or die "ERROR: writing $cfgfile.ok: $!";
    }
    my @hosts;
    if (defined $$confcache{___updated}) {
        @hosts = @{$$confcache{___updated}} ;
        delete $$confcache{___updated};
    } else {
        @hosts = grep !/^___/, keys %{$confcache}
    }
    foreach my $host (sort @hosts) {	
        foreach my $method (sort keys %{$$confcache{$host}}) {
            foreach my $key (sort keys %{$$confcache{$host}{$method}}) {
                if ($cfgfile ne '&STDOUT'){
                        print CFGOK "$host\t$method\t$key\t".
                            $$confcache{$host}{$method}{$key},"\n";
                } else {
                         print "$host\t$method\t$key\t".
                            $$confcache{$host}{$method}{$key},"\n";
                }
            }
        }
    }
    close CFGOK;
}

sub cleanhostkey ($){
    my $host = shift;
    return undef unless defined $host;
    $host =~ s/(:\d*)(?:(:\d*)(?:(:\d*)(?:(:\d*)(?:(:\d*)))))$/$1$5/
        or
    $host =~ s/(:\d*)(?:(:\d*)(?:(:\d*)(?:(:\d*)?)?)?)$/$1/;
    $host =~ s/:/_/g; # make sure that double invocations do not kill us
    return $host;
}

sub storeincache ($$$$$){
    my($confcache,$host,$method,$key,$value) = @_;
    $host = cleanhostkey $host;
    if (not defined $value ){
	 $$confcache{$host}{$method}{$key} = undef;
	 return;
    }
    $value =~ s/[\0- ]/ /g; # all else becomes a normal space ... get a life
    $value =~ s/ +$//; # no trailing spaces
    if (defined $$confcache{$host}{$method}{$key} and 
	$$confcache{$host}{$method}{$key} ne $value) {
        $$confcache{$host}{$method}{$key} = "Dup";
	debug('coca',"store in confcache $host $method $key --> $value (duplicate)");
    } else {
        $$confcache{$host}{$method}{$key} = $value;
	debug('coca',"store in confcache $host $method $key --> $value");
    }

}

sub readfromcache ($$$$){
    my($confcache,$host,$method,$key) = @_;
    $host = cleanhostkey $host;
    return $$confcache{$host}{$method}{$key};
}


sub clearfromcache ($$){
    my($confcache,$host) = @_;
    $host = cleanhostkey $host;
    delete $$confcache{$host};
    debug('coca',"clear confcache $host");
}


sub populateconfcache ($$$$$) {
    my $confcache = shift;
    my $host = shift;
    my $ipv4only = shift;
    my $reread = shift;
    my $snmpoptions = shift || {};
    my $hostkey = cleanhostkey $host;    
    return if defined $$confcache{$hostkey} and not $reread;
    my $snmp_errlevel = $SNMP_Session::suppress_warnings;
    my $net_snmp_errlevel = $Net_SNMP_util::suppress_warnings;
    $SNMP_Session::suppress_warnings = 3;   
    $Net_SNMP_util::suppress_warnings = 3;   
    debug('coca',"populate confcache $host");

    # clear confcache for host;
    delete $$confcache{$hostkey};

    my @ret;
    my %tables = ( ifDescr => 'Descr',
		   ifName  => 'Name',
		   ifType  => 'Type',
		   ipAdEntIfIndex => 'Ip' );
    my @nodes = qw (ifName ifDescr ifType ipAdEntIfIndex);
    # it seems that some devices only give back sensible data if their tables
    # are walked in the right ordere ....
    foreach my $node (@nodes) {
	next if $confcache->{___deadhosts}{$hostkey} and time - $confcache->{___deadhosts}{$hostkey} < 300;
	$SNMP_Session::errmsg = undef;
	$Net_SNMP_util::ErrorMessage = undef;
	@ret = snmpwalk(v4onlyifnecessary($host, $ipv4only), $snmpoptions, $node);
	unless ( $SNMP_Session::errmsg or $Net_SNMP_util::ErrorMessage){
	    foreach my $ret (@ret)
	      {
		  my ($oid, $desc) = split(':', $ret, 2);
		  if ($tables{$node} eq 'Ip') {
		      storeincache($confcache,$host,$tables{$node},$oid,$desc);
		  } else {
                      $desc =~ s/[\0- ]+$//; #trailing whitespace is too sick for us
                      $desc =~ s/[\0- ]/ /g; #whitespace is just whitespace
		      storeincache($confcache,$host,$tables{$node},$desc,$oid);
		  }
	      };
	} else {
  	    $confcache->{___deadhosts}{$hostkey} = time
		if defined($SNMP_Session::errmsg) and $SNMP_Session::errmsg =~ /no response received/;
  	    $confcache->{___deadhosts}{$hostkey} = time
		if defined($Net_SNMP_util::ErrorMessage) and $Net_SNMP_util::ErrorMessage =~ /No response from remote/;
	    debug('coca',"Skipping $node scanning because $host does not seem to support it");
	}
    }
    if ($confcache->{___deadhosts}{$hostkey} and time - $confcache->{___deadhosts}{$hostkey} < 300){
	$SNMP_Session::suppress_warnings = $snmp_errlevel;
	$Net_SNMP_util::suppress_warnings = $snmp_errlevel;
	return;
    }
    $SNMP_Session::errmsg = undef;
    $Net_SNMP_util::ErrorMessage = undef;
    @ret = snmpwalk(v4onlyifnecessary($host, $ipv4only), $snmpoptions, "ifPhysAddress");
    unless ( $SNMP_Session::errmsg or $Net_SNMP_util::ErrorMessage){
	foreach my $ret (@ret)
	  {
	      my ($oid, $bin) = split(':', $ret, 2);
	      my $eth = unpack 'H*', $bin; 
 	      my @eth;
	      while ($eth =~ s/^..//){
	        push @eth, $&;
	      }
	      my $phys=join '-', @eth;
	      storeincache($confcache,$host,"Eth",$phys,$oid);
           }
     } else {
            debug('coca',"Skipping ifPhysAddress scanning because $host does not seem to support it");
     }

     if (ref $$confcache{___updated} ne 'ARRAY') {
        $$confcache{___updated} = []; #init to empty array
     }
     push @{$$confcache{___updated}}, $hostkey;

    $SNMP_Session::suppress_warnings = $snmp_errlevel;    
    $Net_SNMP_util::supress_warnings = $net_snmp_errlevel;
}

sub log2rrd ($$$) {
    my $router = shift;
    my $cfg = shift;
    my $rcfg = shift;
    my %mark;
    my %incomp;
    my %elapsed_time;
    my %rate;
    my %store;
    my %first_step;
    my %cur;
    my %next;
    my $rrd;    
    my @steps = qw(300 1800 7200 86400);
    my %sizes = ( 300 => 600, 1800 => 700, 7200 => 775, 86400 => 797);

    open R, "<$$cfg{logdir}$$rcfg{'directory'}{$router}$router.log" or 
	die "ERROR: opening $$cfg{logdir}$$rcfg{'directory'}{$router}$router.log: $!";
    debug('rrd',"converting $$cfg{logdir}$$rcfg{'directory'}{$router}$router.log");
    my $latest_timestamp;
    my %latest_counter;
    chomp($_ = <R>);
    my $time;
    my $next_time;
    ($latest_timestamp,$latest_counter{in},$latest_counter{out}) = split /\s+/;
    chomp($_ = <R>);	 
    ($time,$cur{in},$cur{out},$cur{maxin},$cur{maxout}) = split /\s+/;

    foreach my $s (@steps) {
	$mark{$s} = $latest_timestamp - ($latest_timestamp % $s) + $s;
	$first_step{$s} = $latest_timestamp - ($mark{$s} - $s);
	$elapsed_time{$s} = $s - $first_step{$s};
	$rate{in}{$s}=$cur{in};
	$rate{out}{$s}=$cur{out};
	$rate{maxin}{$s}=$cur{maxin};
	$rate{maxout}{$s}=$cur{maxout};
    }

    while(<R>){
	chomp;
	($next_time,$next{in},$next{out},$next{maxin},$next{maxout}) =
	    split /\s+/;
        foreach my $s (@steps) {
	    # bail if we have enough entries
	    next if ref $store{in}{$s} and
		scalar @{$store{in}{$s}} > $sizes{$s};
	   
	    # ok we are still here. If next mark is before the next time
            # we take a short step, else we gobble up
	    my $next_stop;
	    do {
		if ($elapsed_time{$s} + $time - $next_time > $s) {
		    $next_stop = $mark{$s}-$s;
		} else {
		    $next_stop = $next_time;
		}
		my $time_diff = $time-$next_stop;
		foreach my $d (qw(in out)) {		    
		    $rate{$d}{$s} = ($rate{$d}{$s} * $elapsed_time{$s}
				     + $cur{$d} * $time_diff) /
			       ($elapsed_time{$s} + $time_diff);
		}
		foreach my $d (qw(maxin maxout)){
		    $rate{$d}{$s} = $cur{$d} if $rate{$d}{$s} < $cur{$d};
		}
		$elapsed_time{$s} += $time_diff;
#		print "$time $next_stop\n" if $s == 300;
		if ($next_stop == $mark{$s}-$s) {
		    foreach my $t (qw(in out maxin maxout)){
                       $rate{$t}{$s}/=3600
                           if (defined $$rcfg{'options'}{'perhour'}{$router});    
                       $rate{$t}{$s}/=60
                           if (defined $$rcfg{'options'}{'perminute'}{$router});
 	  	       push @{$store{$t}{$s}}, int($rate{$t}{$s});
		    }
		    $mark{$s} -= $s;
		    $rate{maxin}{$s} = 0;
		    $rate{maxout}{$s} = 0;
		    $elapsed_time{$s} = 0;
		}
            } while ($next_stop > $next_time );
	}
        ($time,$cur{in},$cur{out},$cur{maxin},$cur{maxout}) = 
	    ($next_time,$next{in},$next{out},$next{maxin},$next{maxout});
    }
    close R;
    # lets see if we have rrdtool 1.2 at our hands
    my $VERSION = '0001';
    if ($RRDs::VERSION >= 1.2){
	$VERSION = '0003';
    }
    my $DST;
    my $pdprepin = (shift @{$store{in}{300}})*($first_step{300});
    my $pdprepout = (shift @{$store{out}{300}})*($first_step{300});

    if (defined $$rcfg{'options'}{'absolute'}{$router}) {
	$DST = 'ABSOLUTE'
    } elsif (defined $$rcfg{'options'}{'gauge'}{$router}) {
	$DST = 'GAUGE'
    } else {
	$DST = 'COUNTER'
    }

    my $MHB = int($$cfg{interval} * 60 * 2);

    my $MAX1 =
      $$rcfg{'absmax'}{$router}
	|| $$rcfg{'maxbytes1'}{$router} 
	  || 'U';

    my $MAX2 =
      $$rcfg{'absmax'}{$router}
	|| $$rcfg{'maxbytes2'}{$router} 
	  || 'U';
    
    $rrd = <<RRD;
<!-- MRTG Log converted to RRD -->
<rrd>
	<version> $VERSION </version>
	<step> 300 </step>
	<lastupdate> $latest_timestamp </lastupdate>

	<ds>
		<name> ds0 </name>
		<type> $DST </type>
		<minimal_heartbeat> $MHB </minimal_heartbeat>
		<min> 0 </min>
		<max> $MAX1 </max>

		<!-- PDP Status -->
		<last_ds> $latest_counter{in} </last_ds>
		<value> $pdprepin </value>
		<unknown_sec> 0 </unknown_sec>
	</ds>

	<ds>
		<name> ds1 </name>
		<type> $DST </type>
		<minimal_heartbeat> $MHB </minimal_heartbeat>
		<min> 0 </min>
		<max> $MAX2 </max>

		<!-- PDP Status -->
		<last_ds> $latest_counter{out} </last_ds>
		<value> $pdprepout </value>
		<unknown_sec> 0 </unknown_sec>
	</ds>
RRD
    $first_step{300} = 0; # invalidate
    addarch(1,'AVERAGE','in','out',\%store,\%first_step,\$rrd);
    addarch(6,'AVERAGE','in','out',\%store,\%first_step,\$rrd);
    addarch(24,'AVERAGE','in','out',\%store,\%first_step,\$rrd);
    addarch(288,'AVERAGE','in','out',\%store,\%first_step,\$rrd);
    addarch(1,'MAX','maxin','maxout',\%store,\%first_step,\$rrd);
    addarch(6,'MAX','maxin','maxout',\%store,\%first_step,\$rrd);
    addarch(24,'MAX','maxin','maxout',\%store,\%first_step,\$rrd);
    addarch(288,'MAX','maxin','maxout',\%store,\%first_step,\$rrd);
    $rrd .= <<RRD;
</rrd>
RRD
        
    if ( $OS eq 'NT'  or $OS eq 'OS2') {
       open (R, "|$$cfg{rrdtool} restore - $$cfg{logdir}$$rcfg{'directory'}{$router}$router.rrd");
    } else {
       open (R, "|-") or exec "$$cfg{rrdtool}","restore","-","$$cfg{logdir}$$rcfg{'directory'}{$router}$router.rrd";
    }
    print R $rrd;
    close R;
}


sub addarch($$$$$$$){
    my $steps = shift;
    my $cons = shift;
    my $in = shift;
    my $out = shift;
    my $store = shift;
    my $first_step = shift;
    my $rrd = shift;
    my $cdpin = 'NaN';
    my $cdpout = 'NaN';

    my $param_start = '';
    my $param_end = '';
    my $extra_ds = '';
    if ($RRDs::VERSION >= 1.2){
        $param_start = '<params>';
        $param_end = '</params>';
        $extra_ds = '<primary_value> 0.0000000000e+00 </primary_value> <secondary_value> 0.0000000000e+00 </secondary_value>';
    }

    if ($steps != 300) {
	$cdpin = shift @{$$store{$in}{300*$steps}};
	$cdpout = shift @{$$store{$out}{300*$steps}};
    };
    $$rrd .= <<RRD;
<!-- Round Robin Archive -->
	<rra>
		<cf> $cons </cf>
		<pdp_per_row> $steps </pdp_per_row>
		$param_start <xff> 0.5 </xff> $param_end
		<cdp_prep>
			<ds>$extra_ds <value> $cdpin </value>  <unknown_datapoints> 0 </unknown_datapoints></ds>
			<ds>$extra_ds <value> $cdpout </value>  <unknown_datapoints> 0 </unknown_datapoints></ds>
		</cdp_prep>

		<database>
RRD
    while (@{$$store{$in}{$steps*300}}){
        # we take zero as UNKNOWN
	my $inr = pop @{$$store{$in}{$steps*300}} || 'NaN';
	my $outr = pop @{$$store{$out}{$steps*300}} || 'NaN';
	$$rrd .= <<RRD;
	             <row><v> $inr </v><v> $outr </v></row>
RRD
    }
    $$rrd .= <<RRD;
		</database>
	</rra>
RRD
}




# debug if the relevant debug tag is active print the debug message
sub debug ($$) {
    return unless scalar @main::DEBUG;
    my $tag = shift;
    my $msg = shift;
    return unless grep {$_ eq $tag} @main::DEBUG;
    warn "--".$tag.": ".$msg."\n";
    return;
}

# timestamp
sub timestamp () {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                                localtime(time);
    $year += 1900;
    $mon += 1;
    return sprintf "%4d-%02d-%02d %02d:%02d:%02d", $year,$mon,$mday,$hour,$min,$sec;
}

# configure __DIE__ and __WARN__
       
sub setup_loghandlers ($){
    $::global_logfile = $_[0];
    for($_[0]){
	/^eventlog$/i && do {
	    require Win32::EventLog;
	    $SIG{__WARN__} = sub {
		my $EventLog = Win32::EventLog->new('MRTG');
		my $Type = ($_[0] =~ /warning/) ? 
		  &Win32::EventLog::EVENTLOG_WARNING_TYPE : 
		  &Win32::EventLog::EVENTLOG_INFORMATION_TYPE;
		my $Msg = $_[0];
		$Msg =~ s/\n/\r\n/g;
                $Msg =~ s/[\n\r]$//g;
		$EventLog->Report({
 		      EventID => 1000,
                      Category => "WARN",
		      EventType => $Type,
                      Data => '',                       
		      Strings => $Msg });
		$EventLog->Close;
	    };
	    $SIG{__DIE__} = sub {
                return if $^S ; # no handler in eval
		my $EventLog = Win32::EventLog->new('MRTG');
		my $Msg = $_[0];
		$Msg =~ s/\n/\r\n/g;
                $Msg =~ s/[\n\r]$//g;
		$EventLog->Report({
		      EventID => 1000,
                      Category => "ERROR",
		      EventType => &Win32::EventLog::EVENTLOG_ERROR_TYPE,
                      Data => '',
		      Strings => $Msg });
		$EventLog->Close;
		exit 1;
	    };
	    last;
	};
	$SIG{__WARN__} = sub {
	    if (open DEB, ">>$::global_logfile") {
		print DEB timestamp." -- $_[0]";
		close DEB;
	    } else {
		print STDERR timestamp." -- $_[0]" 
	    }
	};
	
	
	$SIG{__DIE__} = sub {
            return if $^S ; # no handler in eval	    	    
	    if ( open DEB, ">>$::global_logfile") {
		print DEB timestamp." -- $_[0]";
		close DEB;
	    } else {
		print STDERR timestamp." -- $_[0]" 
	    }
	    exit 1
	};
	
    }
}    

# Adds the v4only attribute to a target if the caller requests it.
# (this includes targets specified using numeric IPv6 addresses...)
sub v4onlyifnecessary ($$) {
    my $target = shift;
    my $add = shift;
    my ($v6addr, $temptarget);

    if($add) {
	# Catch numeric IPv6 addresses
	if ( $target =~ /(\[[\w:]*\])(.*)/) {
	    ($v6addr, $temptarget) = ($1,$2);
	} else {
	    $temptarget = $target;
	}
	return $target.(":" x (5 - ($temptarget =~ tr/://))).":v4only";
    } else {
	return $target;
    }
}
__END__

=pod

=head1 NAME

MRTG_lib.pm - Library for MRTG and support scripts

=head1 SYNOPSIS

 use MRTG_lib;
 my ($configfile, @target_names, %globalcfg, %targetcfg);
 readcfg($configfile, \@target_names, \%globalcfg, \%targetcfg);
 my (@parsed_targets);
 cfgcheck(\@target_names, \%globalcfg, \%targetcfg, \@parsed_targets);

=head1 DESCRIPTION

MRTG_lib is part of MRTG, the Multi Router Traffic Grapher. It was separated
from MRTG to allow other programs to easily use the same config files. The
main part of MRTG_lib is the config file parser but some other funcions are
there too.

=over 4

=item C<$MRTG_lib::OS>

Type of OS: WIN, UNIX, VMS

=item C<$MRTG_lib::SL>

I<Slash> in the current OS.

=item C<$MRTG_lib::PS>

Path separator in PATH variable

=item C<readcfg>

C<readcfg($file, \@targets, \%globalcfg, \%targetcfg [, $prefix, \%extrules])>

Reads a config file, parses it and fills some arrays and hashes. The
mandatory arguments are: the name of the config file, a ref to an array which
will be filled with a list of the target names, a hashref for the global
configuration, a hashref for the target configuration.

The configuration file syntax is:

 globaloption: value
 targetoption[targetname]: value
 aprefix*extglobal: value
 aprefix*exttarget[target2]: value

E.g.

 workdir: /var/stat/mrtg
 target[router1]: 2:public@router1.local.net
 14all*columns: 2

The global config hash has the structure

 $globalcfg{configoption} = 'value'

The target config hash has the structure

 $targetcfg{configoption}{targetname} = 'value'

See L<mrtg-reference> for more information about the MRTG configuration syntax.

C<readcfg> can take two additional arguments to extend the config file
syntax. This allows programs to put their configuration into the mrtg config
file. The fifth argument is the prefix of the extension, the sixth argument
is a hash with the checkrules for these extension settings. E.g. if the
prefix is "14all" C<readcfg> will check config lines that begin with
"14all*", i.e. all lines like

 14all*columns: 2
 14all*graphsize[target3]: 500 200

against the rules in %extrules. The format of this hash is:

 $extrules{option} = [sub{$_[0] =~ m/^\d+$/}, sub{"Error message for $_[0]"}]
     i.e.
 $extrules{option}[0] -> a test expression
 $extrules{option}[1] -> error message if test fails

The first part of the array is a perl expression to test the value of the
option. The test can access this value in the variable "$arg". The second
part of the array is an error message to display when the test fails. The
failed value can be integrated by using the variable "$arg".

Config settings with an different prefix than the one given in the C<readcfg>
call are not checked but inserted into I<%globalcfg> and I<%targetcfg>.
Prefixed settings keep their prefix in the config hashes:

 $targetcfg{'14all*graphsize'}{'target3'} = '500 200'

=item C<cfgcheck>

C<cfgcheck(\@target_names, \%globalcfg, \%targetcfg, \@parsed_targets)>

Checks the configuration read by C<readcfg>. Checks the values in the config
for syntactical and/or semantical errors. Sets defaults for some options.
Parses the "target[...]" options and filles the array @parsed_targets ready
for mrtg functions.

The first three arguments are the same as for C<readcfg>. The fourth argument
is an arrayref which will be filled with the parsed target defs.

C<cfgcheck> converts the values of target settings I<options>, e.g.

 options[router1]: bits, growright

to a hash:

 $targetcfg{'option'}{'bits'}{'router1'} = 1
 $targetcfg{'option'}{'growright'}{'router1'} = 1

This is not done by C<readcfg> so if you don't use C<cfgcheck> you have to
check the scalar variable I<$targetcfg{'option'}{'router1'}> (MRTG allows
options to be separated by space or ',').

=item C<ensureSL>

C<ensureSL(\$pathname)>

Checks that the I<pathname> does not contain double path separators and ends
with a path separator. It uses $MRTG_lib::SL as path separator which will be /
or \ depending on the OS.

=item C<log2rrd>

C<log2rrd ($router,\%globalcfg,\%targetcfg)>

Convert log file to rrd format. Needs rrdtool.

=item C<datestr>

C<datestr(time)>

Returns the time given in the argument as a nicely formated date string.
The argument has to be in UNIX time format (seconds since 1970-1-1).

=item C<timestamp>

C<timestamp()>

Return a string representing the current time.

=item C<setup_loghandlers>

C<setup_loghandlers(filename)>

Install signalhandlers for __DIE__ and __WARN__ making the errors
go the the specified destination. If filename is 'eventlog'
mrtg will log to the windows event logger.

=item C<expistr>

C<expistr(time)>

Returns the time given in the argument formatted suitable for HTTP
Expire-Headers.

=item C<create_pid> 

C<create_pid()> 

Creates a pid file for the mrtg daemon       

=item C<demonize_me>

C<demonize_me()>

Puts the running program into background, detaching it from the terminal.

=item C<populatecache>

C<populatecache(\%confcache, $host, $reread, $snmpoptshash)>

Reads the SNMP variables I<ifDescr>, I<ipAdEntIfIndex>, I<ifPhysAddress>, I<ifName> from
the I<host> and stores the values in I<%confcache> as follows:

 $confcache{$host}{'Descr'}{ifDescr}{oid} = (ifDescr or 'Dup')
 $confcache{$host}{'IP'}{ipAdEntIfIndex}{oid} = (ipAdEntIfIndex or 'Dup')
 $confcache{$host}{'Eth'}{ifPhysAddress}{oid} = (ifPhysAddress or 'Dup')
 $confcache{$host}{'Name'}{ifName}{oid} = (ifName or 'Dup')
 $confcache{$host}{'Type'}{ifType}{oid} = (ifType or 'Dup')

The value (at the right side of =) is 'Dup' if a value was retrieved
muliple times, the retrieved value else.

=item C<readconfcache>

C<my $confcache = readconfcache($file)>

Preload the confcache from a file.

=item C<readfromconfcache>

C<writeconfcache($confcache,$file)>

Store the current confcache into a file.

=item C<writeconfcache>

C<writeconfcache($confcache,$file)>

Store the current confcache into a file.

=item C<storeincache>

C<storeincache($confcache,$host,$method,$key,$value)>

=item C<readfromcache>

C<readfromcache($confcache,$host,$method,$key)>

=item C<clearfromcache>

C<clearfromcache($confcache,$host)>

=item C<debug>

C<debug($type, $message)>

Prints the I<message> on STDERR if debugging is enabled for type I<type>.
A debug type is enabled if I<type> is in array @main::DEBUG.

=back

=head1 AUTHORS

Rainer Bawidamann E<lt>Rainer.Bawidamann@rz.uni-ulm.deE<gt>

(This Manpage)

=cut
