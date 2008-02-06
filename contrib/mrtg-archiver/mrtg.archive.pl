#!/usr/bin/perl -w
#
# Filename: mrtg.archive.pl
# Archive mrtg gifs and summary files
# Original author: Emanuele Leonardi <Emanuele.Leonardi@roma1.infn.it>
# Modified by: Rawlin Blake <blake@nevada.edu>
#
# Default placement of mrtg.archive.* is in /usr/local/sbin
# If you place them elsewhere, change the $Conf_File setting later in this file.
#
# The cron entry I use is:
# 57 23 * * * /usr/local/sbin/mrtg.archive.pl 1>> /var/log/mrtg.archive.log 2>&1
#
# At 23:57 every night it copies the current gifs for the given list of router
# interfaces to a directory named with the current date (e.g. 970717).
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.#
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
#    USA.
#
# revision 1.1  09/10/1999
#   Improved error handling
#   Most configurations moved to separate file
#
# revision 1.0  07/01/1999
#   Named my version mrtg.archive.pl, allowing Emanuele to update his
#     software without confusion resulting :-)
#   Weekly archiving of week gifs, monthly archiving of month gifs, yearly
#     archiving of year gifs. 
#   Specification of which interfaces summary files are saved for.
#   Terse log messages.
#   Creation of the archive directory if it doesn't exist.
#   Symlinking of the mrtg gifs instead of copying (I have limited disk space).
#
# backup.pl 07/17/97
#  Author: Emanuele Leonardi <Emanuele.Leonardi@roma1.infn.it>
#

use strict

#
# User configuration
#
# Change this setting if the mrtg.archive files are
# not placed in /usr/local/sbin/
#

$Conf_File = "/usr/local/sbin/mrtg.archive.conf";

#
# End user configuration
#

# Check for configuration file
open(CONF,"$Conf_File") ||
    die "Error opening configuration file $Conf_File: $!\n";
close(CONF);

# Get date and time of execution
chomp ($date = `date +%y%m%d`);
chomp ($time = `date +%H:%M:%S`);
chomp ($week = `date +%w`);
chomp ($month = `date +%d`);
chomp ($year = `date +%m%d`);

require "$Conf_File";

print "===\nArchive $date at $time\n";

# Create daily directory and copy default GIF files
if (!-e $ARCHIVE_DIR) {
   mkdir($ARCHIVE_DIR, 0755) || die "Error creating $ARCHIVE_DIR: $!\n";
   chmod(0755, $ARCHIVE_DIR);
   print "Create $ARCHIVE_DIR\n";
}
mkdir($TO_DIR, 0755) || die "Error creating $TO_DIR: $!\n";
chmod(0755, $TO_DIR);
print "Create $TO_DIR\n";
foreach $mgif ( @common_gifs ) {
    symlink("$MRTG_DIR" . "\/" . "$mgif", "$TO_DIR" . "\/" . "$mgif");
}

# For each node copy the daily gifs
foreach $node ( @nodes_to_archive ) {
    system(sprintf("cp -a %s/%s.*-day.gif %s",$MRTG_DIR,$node,$TO_DIR));
}
# For each node copy the weekly gifs on Sunday
if ($week == "0") {
    foreach $node ( @nodes_to_archive ) {
        system(sprintf("cp -a %s/%s.*-week.gif %s",$MRTG_DIR,$node,$TO_DIR));
    }
}
# For each node copy the monthly gifs on the first
if ($month == "01") {
    foreach $node ( @nodes_to_archive ) {
        system(sprintf("cp -a %s/%s.*-month.gif %s",$MRTG_DIR,$node,$TO_DIR));
    }
}
# For each node copy the yearly gifs on January first
if ($year == "0101") {
    foreach $node ( @nodes_to_archive ) {
        system(sprintf("cp -a %s/%s.*-year.gif %s",$MRTG_DIR,$node,$TO_DIR));
    }
}

# For each node copy the daily summary file and create the index file
foreach $summary ( @nodes_to_summary ) {
    printf("%s\n",$summary);
    $Summary_Source = "$MRTG_DIR/$summary.html";
    $Summary_Destination = "$TO_DIR/$summary.html";
    open(SRC,"<$Summary_Source") || die "Error opening $Summary_Source: $!\n";
    open(DST,">$Summary_Destination") ||
		die "Error opening $Summary_Destination: $!\n";
    while (<SRC>) {
	s/<A HREF[^>]*>//g;
	s/<\/A>//g;
	s/Router Overview/Router Overview of $date/;
	s/<META HTTP-EQUIV=\"Refresh\" CONTENT=300 >//;
	print DST; }
    close(SRC);
    close(DST);
    chmod(0644, $Summary_Destination);
}

# Create the general index file
$INDEX = "$TO_DIR/index.html";
print "Create $INDEX\n";
open(IDX,">$INDEX") || die "Could not open $INDEX: $!\n";
printf IDX
"<HTML>
<HEAD>
<TITLE>Router Summary for %s</TITLE>
</HEAD>
<BODY BGCOLOR=\"#FFFFFF\">
<CENTER><H1>Router Summary for %s</H1></CENTER>
<P>
<UL TYPE=SQUARE>
",$date,$date;
foreach $summary ( @nodes_to_summary ) {
    printf IDX "<LI><A HREF=\"%s.html\">%s</A></LI>\n",$summary,$summary;
}

print IDX
"</UL>
</P>
</BODY>
</HTML>";
close(IDX);
chmod(0644, $INDEX);

@common_gifs = "";
chomp ($time = `date +%H:%M:%S`);
print "Archive $date done at $time\n";
exit(0);

# Eof mrtg.archive.pl
