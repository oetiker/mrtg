# -*- mode: Perl -*-
package MRTG_lib;

###################################################################
# MRTG 2.9.29  Support library MRTG_lib.pm
###################################################################
# Created by Tobias Oetiker <oetiker@ee.ethz.ch>
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
use SNMP_util "0.93";
use vars qw($OS $SL $PS @EXPORT @ISA $VERSION %mrtgrules);

BEGIN {
    # Automatic OS detection ... do NOT touch
    if ( $^O =~ /^(?:(ms)?(dos|win(32|nt)?))/i ) {
        $OS = 'NT';
        $SL = '\\';
        $PS = ';';
    } elsif ( $^O =~ /^VMS$/i ) {
        $OS = 'VMS';
        $SL = '.';
        $PS = ':';
    } else {
        $OS = 'UNIX';
        $SL = '/';
        $PS = ':';
    }
}

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(readcfg cfgcheck setup_loghandlers
	     datestr expistr ensureSL timestamp
             create_pid demonize_me debug log2rrd storeincache
	     populateconfcache readconfcache writeconfcache);

$VERSION = 2.090026;


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
       [sub{$_[0] && (int($_[0]) > 0 && $MRTG_lib::OS eq 'UNIX')},
        sub{"Less than 1 fork or not running on Unix/Linux"}],

       'refresh' => 
       [sub{int($_[0]) >= 300}, sub{"$_[0] should be 300 seconds or more"}],

       'interval' => 
       [sub{int($_[0]) >= 1 && int($_[0]) <= 60}, sub{"$_[0] should be at least 1 Minute and no more than 60 Minutes"}], 

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

       'nospacechar' =>
       [sub{length($_[0]) == 1}, sub{"$_[0] must be one character long"}],

       'snmpoptions' =>
       [sub{ eval( '{'.$_[0].'}' ); return not $@},
        sub{"Must have the format \"OptA => Number, OptB => 'String', ... \""}],

       # Per Router CFG
       'target[]' => 
       [sub{1}, sub{"Internal Error"}], #will test this later

       'routeruptime[]' => 
       [sub{1}, sub{"Internal Error"}], #will test this later

       'maxbytes[]' => 
       [sub{(($_[0] =~ /^[0-9]+$/) && ($_[0] > 0)) },
        sub{"$_[0] must be a Number bigger than 0"}],

       'maxbytes1[]' =>
       [sub{(($_[0] =~ /^[0-9]+$/) && ($_[0] > 0))},
        sub{"$_[0] must be numerical and larger than 0"}],

       'maxbytes2[]' =>
       [sub{(($_[0] =~ /^[0-9]+$/) && ($_[0] > 0))},
        sub{"$_[0] must a number bigger than 0"}],

       'absmax[]' => 
       [sub{($_[0] =~ /^[0-9]+$/)}, sub{"$_[0] must be a Number"}],

       'title[]' => 
       [sub{1}, sub{"Internal Error"}], #what ever the user chooses.

       'directory[]' => 
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
       [sub{$_[0] && (-e $_[0])}, sub{"Threshold program $_[0] cannot be executed"}]
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
                $$rcfg{$first}{$second} .= ( defined $$cfg{nospacechar} && $post{$first} =~ /(.*)\Q$$cfg{nospacechar}\E$/) ? $1 : " ".$post{$first} ;
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

sub cfgcheck ($$$$) {
    my ($routers, $cfg, $rcfg, $target) = @_;
    my ($rou, $confname, $one_option);
    my $error="no";
    my(@known_options) = qw(growright bits noinfo absolute gauge nopercent avgpeak
			    integer perhour perminute transparent dorelpercent 
			    unknaszero withzeroes noborder noarrow noi noo
			    nobanner nolegend);

    snmpmapOID('hrSystemUptime' => '1.3.6.1.2.1.25.1.1');

    if (defined $$cfg{workdir}) {
        die ("ERROR: WorkDir must not contain spaces when running on Windows. (Yeat another reason to get Linux)\n")
                if $OS eq 'NT' and $$cfg{workdir} =~ /\s/;
        ensureSL(\$$cfg{workdir});
        $$cfg{logdir}=$$cfg{htmldir}=$$cfg{imagedir}=$$cfg{workdir};
        if (not -d $$cfg{workdir}){
           mkdir "$$cfg{workdir}", 0777  or
            die ("ERROR: mkdir $$cfg{workdir}: $!\n");
        }
        
    } elsif ( not (defined $$cfg{logdir} or defined $$cfg{htmldir} or defined $$cfg{imagedir})) {
          die ("ERROR: \"WorkDir\" not specified in mrtg config file\n");
	  $error = "yes";
    } else {
        if (! defined $$cfg{logdir}) {
            warn ("WARNING: \"LogDir\" not specified\n");
            $error = "yes";
        } else {
          ensureSL(\$$cfg{logdir});
          if (not -d $$cfg{logdir}){
               mkdir "$$cfg{logdir}", 0777  or
               die ("ERROR: mkdir $$cfg{logdir}: $!\n");
          }
        }
        if (! defined $$cfg{htmldir}) {
            warn ("WARNING: \"HtmlDir\" not specified\n");
            $error = "yes";
        } else {
          ensureSL(\$$cfg{htmldir});
          if (not -d $$cfg{htmldir}){
               mkdir "$$cfg{htmldir}", 0777  or
               die ("ERROR: mkdir $$cfg{htmldir}: $!\n");
          }
        }
        if (! defined $$cfg{imagedir}) {
            warn ("WARNING: \"ImageDir\" not specified\n");
            $error = "yes";
        } else {
          ensureSL(\$$cfg{imagedir});
          if (not -d $$cfg{imagedir}){
               mkdir "$$cfg{imagedir}", 0777  or
               die ("ERROR: mkdir $$cfg{imagedir}: $!\n");
          }
        }
    }
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
        unshift @INC, $$cfg{libadd};
    }
     $$cfg{logformat} = 'rateup' unless defined $$cfg{logformat};

    if($$cfg{logformat} eq 'rrdtool') {
        my $name = $MRTG_lib::OS eq 'NT'? 'rrdtool.exe':'rrdtool';
        foreach my $path (split /\Q${MRTG_lib::PS}\E/, $ENV{PATH}) {
            ensureSL(\$path);
            -f "$path$name" && do { 
                $$cfg{'rrdtool'} = "$path$name";
                last;}
        };
        die "ERROR: could not find $name. Use PathAdd: im mrtg.cfg to help mrtg find rrdtool\n" 
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
           $cfg->{snmpoptions} = eval('{'.$cfg->{snmpoptions}.'}');
           $cfg->{snmpoptions}{avoid_negative_request_ids} = 1;
    } else {
           $cfg->{snmpoptions} = {avoid_negative_request_ids => 1};
    }

    # default interval is 5 minutes
    $$cfg{interval} = 5 unless defined $$cfg{interval};
    unless ($$cfg{logformat} eq 'rrdtool') {
        # interval has to be 5 minutes at least without userrdtool
        if ($$cfg{interval} < 5) {
            die "ERROR: CFG Error in \"Interval\": should be at least 5 Minutes (unless you use rrdtool)";
        }
    }

    foreach $rou (@$routers) {
        # and now for the testing
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
                if (not -d "$$cfg{$x}$$rcfg{directory}{$rou}"){
                        warn ("WARNING: $$cfg{$x}$$rcfg{directory}{$rou} did not exist I will create it now\n");
                        mkdir "$$cfg{$x}$$rcfg{directory}{$rou}", 0777 or
                           die ("ERROR: mkdir $$cfg{$x}$$rcfg{directory}{$rou}: $!\n");
                }
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
	    $$rcfg{target}{$rou} = targparser($$rcfg{target}{$rou},$target)
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
            $$rcfg{'backgc'}{$rou} = "BGCOLOR=\"$1\"";
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
        if ($error eq "yes") {
            die "ERROR: Please fix the error(s) in your config file\n";
        }
    }
}

# make sure string ends with a slash.
sub ensureSL($) {
  my $ref = shift;
  return if $$ref eq "";
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
    my ($time) = time+$_[0]*60+5;
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
    return if $OS eq 'NT';
    return if -e $pidfile;
    if ( open(PIDFILE,">$pidfile")) {
         close PIDFILE;
    } else {
         warn "cannot write to $pidfile: $!\n";
    }
}

sub demonize_me ($) {
    my $pidfile = shift;
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
    } else {
           # Check out if there is another mrtg running before forking
           if (defined $pidfile && open(READPID, "<$pidfile")) {
               chomp(my $input = <READPID>);    # read process id in pidfile
               if ($input && kill 0 => $input) {# oops - the pid actually exists
                   die "ERROR: I Quit! Another copy of mrtg seems to be running. Check $pidfile\n";
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
              &POSIX::setsid or die "Can't start a new session: $!";
              open STDOUT,'>/dev/null' or die "ERROR: Redirecting STDOUT to /dev/null: $!";
              open STDIN, '</dev/null' or die "ERROR: Redirecting STDIN from /dev/null: $!";
      }
   }
}

# walk amd analyze the target string.
# return modifed target string, update target array
sub targparser ($$) {
    my $string = shift;
    my $target = shift;
    my $idx=scalar @$target;

    my $ifsel =  '([a-z0-9]+|'.                 # alphanumeric MIB names
                 ' [a-z0-9]*(?:\.\d+)*?'.       # or some combination 
	         ')'.
                 '(?:     ()   |'.              # just a name maybe
                 '   \.   (\d+)|'.              # interface number
	         '   /    (\d+(?:\.\d+)+)|'.    # ip interface sclector
	         '   !    ([0-9a-f]+(?:-[0-9a-f]+)+)|'. # ethernet interface
	         '   \\\\ ((?:\\\\[:& ]|[^\s:&])+)|'. # if description (perm \: \& \ )
	         '   %    (\d+)|'.                # if Type
	         '   \#   ((?:\\\\[:& ]|[^\s:&])+)'. # if name (perm \: \& \ )
	         ')';
    # programm targets
    while (
	   $string =~ s< `               # initiate program target
  	              ((?:\\`|[^`])+)    # contents (\` allowed)
	                 `               # end program target
	               >< \$\$target[$idx]{\$mode} >ix ) {
	my %targ;
	$targ{Methode} = 'EXEC';
	$targ{Command} = $1;
	# dequote
	$targ{Command} =~ s/\\(`)/$1/g;
	debug ('tarp',"Found ($idx) EXEC: '$targ{Command}'");
	$$target[$idx++]=\%targ;
    };

    # complex OID targets
    while (
        $string =~ s< ${ifsel}
       	                 &              # separator
	                 ${ifsel}
         	         :               # separator
 	                 ((?:\\[@ ]|[^\s@])+) # community string ('\@' and '\ ' allowed)
                 	 @              # separator
	                 ([-a-z0-9_]+(?:\.[-a-z0-9_]+)*) # hostname
                         ((?::[\da-z]*)*) # SNMP session configuration
	               >< \$\$target[$idx]{\$mode} >ix ) {
	my %targ;
        $targ{Methode}   = 'SNMP';
	$targ{OID}[0]      = $1;
	$targ{OID}[1]      = $9;
	$targ{Community} = $17;
	$targ{Host}      = $18;
	$targ{SnmpOpt}      = $19;

	if (defined $2) {
	    $targ{IfSel}[0] = 'None';
	    $targ{Key}[0]    = '';
	} elsif (defined $3) {
	    $targ{IfSel}[0] = 'If';
	    $targ{Key}[0]    = $3;
	} elsif (defined $4) {
	    $targ{IfSel}[0] = 'Ip';
	    $targ{Key}[0]    = $4;
	} elsif (defined $5) {
	    $targ{IfSel}[0] = 'Eth';
	    $targ{Key}[0]    = join "-", map {sprintf "%02x", hex $_} split /-/, $5;
	} elsif (defined $6) {
	    $targ{IfSel}[0] = 'Descr';
	    $targ{Key}[0]    = $6;
	} elsif (defined $7) {
	    $targ{IfSel}[0] = 'Type';
	    $targ{Key}[0]    = $7;
	} elsif (defined $8) {
	    $targ{IfSel}[0] = 'Name';
	    $targ{Key}[0]    = $8;
	} else {
            die "ERROR: Could not properly parse '$&'. ($2,$3,$4,$5,$6,$7)\n";
        }

	if (defined $10) {
	    $targ{IfSel}[1] = 'None';
	    $targ{Key}[1]    = '';
	} elsif (defined $11) {
	     $targ{IfSel}[1] = 'If';
	    $targ{Key}[1]    = $11;
	} elsif (defined $12) {
	    $targ{IfSel}[1] = 'Ip';
	    $targ{Key}[1]    = $12;
	} elsif (defined $13) {
	    $targ{IfSel}[1] = 'Eth';
	    $targ{Key}[1]    = join "-", map {sprintf "%02x", hex $_} split /-/, $13;
	} elsif (defined $14) {
	    $targ{IfSel}[1] = 'Descr';
	    $targ{Key}[1]    = $14;
	} elsif (defined $15) {
	    $targ{IfSel}[1] = 'Type';
	    $targ{Key}[1]    = $15;
	} elsif (defined $16) {
	    $targ{IfSel}[1] = 'Name';
	    $targ{Key}[1]    = $16;
	}  else {
            die "ERROR: Could not properly parse '$&'. ($9,$10,$11,$12,$13,$14)\n";
        }

        # dequote
	$targ{Community} =~ s/\\([ @])/$1/g;
        $targ{Key}[0] =~ s/\\([ :&])/$1/g if $targ{IfSel}[0] eq 'Descr' or $targ{IfSel}[0] eq 'Name';
	$targ{Key}[1] =~ s/\\([ :&])/$1/g if $targ{IfSel}[1] eq 'Descr' or $targ{IfSel}[1] eq 'Name';
        $targ{Key}[0] =~ s/[\0- ]+$//; # no trailing space
        $targ{Key}[1] =~ s/[\0- ]+$//; # no trailing space
	debug ('tarp',"Found ($idx) Complex:".
	       " Comu:".$targ{Community}.
	       " Host:".$targ{Host}.
	       " Opt:".$targ{SnmpOpt}."\n               ".
	       " IfS0:".$targ{IfSel}[0].
	       " Key0:".$targ{Key}[0].
	       " OID0:".$targ{OID}[0]."\n               ".
	       " IfS1:".$targ{IfSel}[1].
	       " Key1:".$targ{Key}[1].
	       " OID1:".$targ{OID}[1]);
	$$target[$idx++]=\%targ
    };
    # simple targets
    while (
        $string =~ s< (-?)               # should In and Out get swapped ?
                      (?:   (\d+)|       # interface number
	                 /  (\d+(?:\.\d+)+)|  # ip interface sclector
	                 !  ([0-9a-f]+(?:-[0-9a-f]+)+)|   # ethernet interface selector
	                 \\ ((?:\\[&: ]|[^\s:&])+)| # description if selector ('\:' and '\ ' allowed)
           	         %  (\d+)|                 # if Type
	                 \# ((?:\\[&: ]|[^\s:&])+)  # name if selector ('\:' and '\ ' allowed)
                       )
	               :               # separator
	               ((?:\\[@ ]|[^\s@])+) # community string ('\@' and '\ ' allowed)
	               @              # separator
	               ([-a-z0-9_]+(?:\.[-a-z0-9_]+)*) # hostname
	               ((?::[\da-z]*)*) # SNMP session configuration
	             >< \$\$target[$idx]{\$mode} >ix )
    {
	my %targ;
        $targ{Methode}   = 'SNMP';
	$targ{Community} = $8;
	$targ{Host}      = $9;
	$targ{SnmpOpt}      = $10;
	my $snmpv = $10;
	my $i0 = 0;
	my $i1 = 1;
        if ($1 eq '-') {
	    $i1 = 0; $i0 =1;
	}
	if ($2) {
	    $targ{IfSel}[$i0] = 'If';
	    $targ{Key}[$i0]    = $2;
	    $targ{IfSel}[$i1] = 'If';
	    $targ{Key}[$i1]    = $2;
	} elsif ($3) {
	    $targ{IfSel}[$i0] = 'Ip';
	    $targ{Key}[$i0]    = $3;
	    $targ{IfSel}[$i1] = 'Ip';
	    $targ{Key}[$i1]    = $3;
	} elsif ($4) {
	    $targ{IfSel}[$i0] = 'Eth';
	    $targ{Key}[$i0]    = join "-", map {sprintf "%02x", hex $_} split /-/, $4;
	    $targ{IfSel}[$i1] = 'Eth';
	    $targ{Key}[$i1]    = join "-", map {sprintf "%02x", hex $_} split /-/, $4;
	} elsif ($5) {
	    $targ{IfSel}[$i0] = 'Descr';
	    $targ{Key}[$i0]    = $5;
	    $targ{IfSel}[$i1] = 'Descr';
	    $targ{Key}[$i1]    = $5;
	} elsif ($6) {
	    $targ{IfSel}[$i0] = 'Type';
	    $targ{Key}[$i0]    = $6;
	    $targ{IfSel}[$i1] = 'Type';
	    $targ{Key}[$i1]    = $6;
	} elsif ($7) {
	    $targ{IfSel}[$i0] = 'Name';
	    $targ{Key}[$i0]    = $7;
	    $targ{IfSel}[$i1] = 'Name';
	    $targ{Key}[$i1]    = $7;
	}
	$targ{Community} =~ s/\\([ \@])/$1/g;
        $targ{Key}[0] =~ s/\\([ :&])/$1/g if $targ{IfSel}[0] eq 'Descr' or $targ{IfSel}[0] eq 'Name';
	$targ{Key}[1] =~ s/\\([ :&])/$1/g if $targ{IfSel}[1] eq 'Descr' or $targ{IfSel}[1] eq 'Name';
        $targ{Key}[0] =~ s/[\0- ]+$//; # no trailing space
        $targ{Key}[1] =~ s/[\0- ]+$//; # no trailing space
        if ($snmpv && $snmpv =~ m/(?::[^:]*){4}:2c?/i) {
	    $targ{OID}[$i0]      = "ifHCInOctets";
	    $targ{OID}[$i1]      = "ifHCOutOctets";
        } else {
	    $targ{OID}[$i0]      = "ifInOctets";
	    $targ{OID}[$i1]      = "ifOutOctets";
	}
	debug ('tarp',"Found ($idx) Simple:".
	       " Comu:".$targ{Community}.
	       " Host:".$targ{Host}.
	       " Opt:".$targ{SnmpOpt}.
	       " IfS:".$targ{IfSel}[0].
	       " Key:".$targ{Key}[0]."\n              ".
	       " InOID:".$targ{OID}[0].
	       " OutOID:".$targ{OID}[1]);
	$$target[$idx++]=\%targ;
    }


    return $string;
}

sub readconfcache ($) {
    my $cfgfile = shift;
    my %confcache;
    if (open (CFGOK,"<$cfgfile")) {
        while (<CFGOK>) {
            chomp;
            next unless /\t/; #ignore odd lines
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
        @hosts = keys %{$confcache}
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

sub storeincache ($$$$$){
    my($confcache,$host,$method,$key,$value) = @_;
    $value =~ s/[\0- ]/ /g; # all else becomes a normal space ... get a life
    $value =~ s/ +$//; # no trailing spaces
    if (defined $$confcache{$host}{$method}{$key} and 
	$$confcache{$host}{$method}{$key} ne $value) {
        $$confcache{$host}{$method}{$key} = "Dup";
	debug('snpo',"confcache $host $method $key --> $value (duplicate)");
    } else {
        $$confcache{$host}{$method}{$key} = $value;
	debug('snpo',"confcache $host $method $key --> $value");
    }

}

sub populateconfcache ($$$$) {
    my $confcache = shift;
    my $host = shift;
    my $reread = shift;
    my $snmpoptions = shift || {};
    return if defined $$confcache{$host} and not $reread;

    my $snmp_errlevel = $SNMP_Session::suppress_warnings;
    $SNMP_Session::suppress_warnings = 3;    

    # clear confcache for host;
    delete $$confcache{$host};

    my @ret;
    my %tables = ( ifDescr => 'Descr',
		   ifName  => 'Name',
		   ifType  => 'Type',
		   ipAdEntIfIndex => 'Ip' );

    foreach my $node ( keys %tables ) {
	$SNMP_Session::errmsg = undef;
	@ret = snmpwalk($host, $snmpoptions, $node);
	unless ( $SNMP_Session::errmsg){
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
	    debug('snpo',"Skipping $node scanning because $host does not seem to support it");
	}
    }
    $SNMP_Session::errmsg = undef;
    @ret = snmpwalk($host, $snmpoptions, "ifPhysAddress");
    unless ( $SNMP_Session::errmsg){
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
            debug('snpo',"Skipping ifPhysAddress scanning because $host does not seem to support it");
     }

     if (ref $$confcache{___updated} ne 'ARRAY') {
        $$confcache{___updated} = []; #init to empty array
     }
     push @{$$confcache{___updated}}, $host;

    $SNMP_Session::suppress_warnings = $snmp_errlevel;    
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

    my $MHB = $$cfg{interval} * 60 * 2;

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
	<version> 0001 </version>
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
    addarch(6,'MAX','maxin','maxout',\%store,\%first_step,\$rrd);
    addarch(24,'MAX','maxin','maxout',\%store,\%first_step,\$rrd);
    addarch(288,'MAX','maxin','maxout',\%store,\%first_step,\$rrd);
    $rrd .= <<RRD;
</rrd>
RRD
        
    if ( $OS eq 'NT' ) {
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
    if ($steps != 300) {
	$cdpin = shift @{$$store{$in}{300*$steps}};
	$cdpout = shift @{$$store{$out}{300*$steps}};
    };
    $$rrd .= <<RRD;
<!-- Round Robin Archive -->
	<rra>
		<cf> $cons </cf>
		<pdp_per_row> $steps </pdp_per_row>
                <xff> 0.5 </xff>

		<cdp_prep>
			<ds><value> $cdpin </value>  <unknown_datapoints> 0 </unknown_datapoints></ds>
			<ds><value> $cdpout </value>  <unknown_datapoints> 0 </unknown_datapoints></ds>
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
    warn "--",$tag,": ",$msg,"\n";
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

See L<reference> for more information about the MRTG configuration syntax.

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

=item C<writeconfcache>

C<writeconfcache($confcache,$file)>

Store the current confcache into a file.

=item C<debug>

C<debug($type, $message)>

Prints the I<message> on STDERR if debugging is enabled for type I<type>.
A debug type is enabled if I<type> is in array @main::DEBUG.

=back

=head1 AUTHORS

Tobias Oetiker E<lt>tobi@oetiker.chE<gt>, Dave Rand E<lt>dlr@bungi.comE<gt>
and other contributors, mentioned in the file C<CHANGES>

Documentation by Rainer Bawidamann E<lt>Rainer.Bawidamann@rz.uni-ulm.deE<gt>

=cut
