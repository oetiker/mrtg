#!/usr/local/bin/perl

# mrtgindex.cgi v 1.1
# (c) 1997, Mick Ghazey mick@lowdown.com
# Thanks to Dave Rand, Peter W. Osel and Tobias Oetiker.

# Why CGI?
# Mrtgindx.cgi has features that only CGI can provide. 

# Runtime index:
# The index page is built every time the page is requested.
# Changes to config files are visible on the next update.

# Clickable graphs:
# Each graph is a clickable hyperlink to more information.

# Automatic updates:
# The index page automatically updates every 5 minutes.
# Modify $interval to adjust this period.

# Timely updates:
# Mrtgindx.cgi predicts when to update based on when the
# current graphs were completed.
# Updates occurs shortly after the graphs are completed
# regardless of when the page was initially requested.
# Modify $guardband to adjust this period.
# If the guardband is too small you run the risk of attempting
# an update while a graph is under construction. 

# Predictable graph order:
# Graphs appear in the same order as Titles in the config files.
# If there are multiple config files graphs from the first config
# file appear before those from the second, etc.

# Customizable graph order:
# If you want your index ordered differently than your
# config files you can use a dummy config file. Mrtgindex.cgi is
# only interested in "Title" statements. You could, for example,
# have different dummy config files for different arangements
# of graphs.

# Web based graph order selection:
# Click Top, Up, Down, or Bot to change the position of a graph.

# Multiple config files:
# Mrtgindex.cgi supports multiple config files. Some users
# run mrtg with more than one config file. The reason may be
# because certain events are run on a different schedules, 
# 5 and 10 minute intervals for example.
# Or perhaps multiple instances of mrtg are run
# to assure completion within a 5 minute interval.
# Ping-probes have longer run times than measuring traffic
# on local routers, for example. However, CPU load is similar.
# Modify the @config_files array below to suit your environment.

# Runs fast:
# Mrtgindx.cgi is fast because it doesn't create graph files or
# maintain log files. In addition, web based graph order changes
# benefit from browser cacheing of graphs.

# Index.cgi:
# You might want to rename this file "index.cgi". Then it
# will load automatically when when the directory is browsed -
# much as index.html loads automatically. You might have to
# modify "DirectoryIndex" in srm.conf if you're using Apache
# to allow CGI programs to be index files.

# CGI.pm required:
# Mrtgindex.cgi requires CGI.pm by Lincoln Stein
# http://www-genome.wi.mit.edu/ftp/pub/software/WWW/cgi_docs.html

#-------------------------------------------------------
# Modify this statement to match your configuration
@config_files = ('mrtg.cfg'); # Single config file

#@config_files = ('mrtg.cfg', 'mrtg-ping.cfg'); # Two config files
#@config_files = ('mrtg.cfg', 'yahoo.ping', 'netscape.ping', 'msn..ping', 
                   'att.ping'); # anal retentive

#-------------------------------------------------------

require 'stat.pl';
use CGI ':all';
use CGI::Carp qw(fatalsToBrowser);
#use diagnostics;

$gifdone = 0; # Scan for newest graph and save info for later
while(@config_files > 0){
    open(In, $cfg = shift @config_files) ||
	die "Can't open $cfg. Check \@config_files array.\n";
    while(<In>){
	next unless /^Title\[(.*)\]:\s*(.+)$/; # Look for a title keyword

	$router = lc $1;
	Stat("$router-day.png");
	@$router = ($st_mtime, $2); # Save the mod date and title
	push @routers, $router; # Remember the router name so we can find above info
	$gifdone = $st_mtime if $st_mtime > $gifdone; # Find the newest file
    }
    close In;
}

# Time the next update to occur a little while after the next interval completes
$interval = 300; # 5 min update interval
$guardband = 15; # updates occur this many seconds after predicted gif completion
$refresh = $interval + $guardband + $gifdone - time; # predict how long until next update
$refresh = $interval if $refresh <= $guardband;
$expires = gmtime (time + $interval * 2 + $guardband);

print header, start_html(-TITLE=>'Daily Stats', -BGCOLOR=>'#e6e6e6'),
    "\n",
    "<meta http-equiv=\"expires\" content=\"$expires GMT\">\n",
    "<meta http-equiv=\"refresh\" content=$refresh>\n",

    table({-width=>"100\%"}, TR(
#-------------------------------------------------------
    # Uncomment the following line if you have Count.cgi installed.
    td({-align=>left, width=>"25\%"}, img({-src=>"/cgi-bin/Count.cgi?display=clock"})),
#-------------------------------------------------------

    td("Click graph for more info")));

@router_order = (0..$#routers);
@router_order = split /:/, param('ord') if defined param('ord');
$selfurl = url;
$selfurl =~ s/\?.*//; # Remove arguments

for $index (0..$#routers){
    @spliced = @router_order;
    $router_num = splice @spliced, $index, 1; # Router removed
    $router = $routers[$router_num];
    $time = localtime $$router[0]; # $st_mtime saved in above loop
    ($time) = $time =~ /(\d+:\d+:\d+)/; # Just the time
    print hr, "\n";

    print a({-name=>$index});
    # Print re-ordering links top, bot, up, dn
    $mv_dn = $mv_up = "";
    $" = ':';
    if($index > 0){
	@top = ($router_num, @spliced);
	@up = @spliced;
	$indxup = $index - 1;
	splice @up, $indxup, 0, $router_num;

	$mv_up = sprintf "%s %s ", a({-href=>"$selfurl?ord=@top#0"}, "Top"), # move to top
	a({-href=>"$selfurl?ord=@up#$indxup"}, "Up"); # move up
    }
    if($index < $#routers){
	@bot = (@spliced, $router_num);
	@down = @spliced;
	$indxdn = $index + 1;
	splice @down, $indxdn, 0, $router_num;

	$indxbot = @routers - 3;
	while($indxbot < 0){$indxbot += 1}
	$mv_dn = sprintf "%s %s ", a({-href=>"$selfurl?ord=@down#$indxdn"}, "Down"), # move down
	a({-href=>"$selfurl?ord=@bot#$indxbot"}, "Bot"); # move to bottom
    }
    undef $";

    print table({-width=>"100\%"}, 
		TR(td({-align=>"left",-width=>"20\%"}, "$mv_up $mv_dn"),
		   td({-align=>"left"}, b($$router[1]), " $time")));

    print a({-href=>"$router.html"}, img{-src=>"$router-day.png"});

}

print "\n",hr,"Direct questions and feedback to Mick Ghazey: ",
    a({-href=>"mailto:mick\@lowdown.com"}, "mick\@lowdown.com"),
    end_html;
