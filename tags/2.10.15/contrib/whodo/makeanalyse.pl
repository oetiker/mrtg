#	makeanalyse.pl
#
# Generate an HTML page containing a list of networks and a list of traffic
# sources. This page invokes the CGI script analyse.pl. The page is written to
# STDOUT.
#
# Modification History
######################
# 23 Dec 98	Tony Farr	Original coding
##############################################################################

use strict;

my(@sources, @dests);					# Globals
my $LOGPATH= "D:\\logs\\whodo\\";		# Directory where csv/logs are stored.

get_sources_and_dests();
write_html();
exit(0);



sub get_sources_and_dests {
# Initialises @sources & @dests with yesterday's traffic sources and destinations
	my(%srchash, %dsthash, $src, $dst);
	my $fname= get_input_file();
	open(LOG,"<$fname") || die "$0: unable to open input file $fname; $!";

	# First 2 lines are headers
	<LOG> || die "$0: $fname is empty\n";
	<LOG> || die "$0: $fname lacks second header line\n";
	# The rest of the file has traffic for particular sources & destinations
	while (<LOG>) {
		($src, $dst)= split/,/;
		$srchash{$src}= 1;
		$dsthash{$dst}= 1;
	}
	close(LOG);
	# Transfer them from the hashes to the arrays
	@sources= sort( keys(%srchash) );
	@dests= sort( keys(%dsthash) );
}



sub get_input_file {
# Returns the file name of yesterday's whodo log
	my $t = time() - 24*60*60;
	my ($mday,$mon,$year) = ( localtime($t) )[3..5];
	$LOGPATH . sprintf("%d%02d%02d.csv",$year+1900,$mon+1,$mday);
}



sub write_html {

	print <<HEAD;
<HTML><head><title>Analyse traffic sources or destinations</title></head>
<BODY><H1>Analyse traffic sources or destinations</H1><HR>
<FORM METHOD="POST" ACTION="../scripts/analyse.pl">
<P>Show sources sending traffic to: 
<SELECT NAME="dest"><OPTION></OPTION>
HEAD

	foreach my $dst (@dests) {
		print "<OPTION>$dst</OPTION>\n";
	}

	print <<MIDDLE;
</SELECT>(Leave blank to include all destinations.)</P>
<P>During last: 
<INPUT TYPE="radio" NAME="src_duration" VALUE="30 minutes" checked>30 minutes
<INPUT TYPE="radio" NAME="src_duration" VALUE="day">day
<INPUT TYPE="radio" NAME="src_duration" VALUE="week">week
<INPUT TYPE="radio" NAME="src_duration" VALUE="month">month</P>
<P>Summarise minor sources: <INPUT TYPE="checkbox" NAME="summarise" checked></P>
<INPUT TYPE="Submit" NAME="submit" VALUE="Get sources">
</FORM><H3>OR</H3><FORM METHOD="POST" ACTION="../scripts/analyse.pl">
<P>Show destinations receiving traffic from: 
<SELECT NAME="src"><OPTION></OPTION>
MIDDLE

	foreach my $src (@sources) {
		print "<OPTION>$src</OPTION>\n";
	}

	print <<TAIL;
</SELECT>(Leave blank to include all sources.)</P>
<P>During last: 
<INPUT TYPE="radio" NAME="dest_duration" VALUE="30 minutes" checked>30 minutes
<INPUT TYPE="radio" NAME="dest_duration" VALUE="day">day
<INPUT TYPE="radio" NAME="dest_duration" VALUE="week">week
<INPUT TYPE="radio" NAME="dest_duration" VALUE="month">month</P>
<P>Summarise minor destinations: <INPUT TYPE="checkbox" NAME="summarise" checked></P>
<INPUT TYPE="Submit" NAME="submit" VALUE="Get destinations">
</FORM><HR>
</BODY></HTML>
TAIL

}