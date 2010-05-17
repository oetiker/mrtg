#	analyse.pl
#
# CGI script to generate an HTML page showing WAN traffic broken down by source
# or destination. Most of the work is done by another script "pie.pl".
# This script is invoked by http://netmanager/whodo/analyse.html
#
# Modification History
######################
# 17 Nov 98	Tony Farr	Original coding
##############################################################################

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

my $q = new CGI;

my $title= "WAN Traffic by ".( defined($q->param('src')) ? "Destination" : "Source" );
print $q->header,
	$q->start_html($title),
	$q->h1($title),
	$q->hr;

my $gifurl= $q->url(-query=>1);
$gifurl =~ s/analyse\.pl/pie.pl/i;		# pie.pl uses same path & arguments
print $q->img({-src=>$gifurl, -align=>'CENTER', -alt=>'Generating pie graph...'});

print $q->hr,
	$q->small,
	$q->ul(
		$q->li("This page was produced at ".localtime(time)." (aest)." ),
		$q->li( $q->param("src") ?
					"Only sources matching the expression \"".$q->param("src")."\" have been included."
				:
					$q->param("dest") ?
						"Only destinations matching the expression \"".$q->param("dest")."\" have been included."
					:
						"All WAN traffic is included."
			)
	);
	
print $q->end_html;
exit 0;
