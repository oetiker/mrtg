#!/usr/bin/perl

# Define list of nodes to backup
@nodes_to_backup = ('router1','router2','router3','etc');

# Get date and time of execution
chop ($date = `date +%y%m%d`);
chop ($time = `date +%H:%M:%S`);

# Define working directories
$MRTG_DIR = "/home/httpd/html/mrtg";
$BACKUP_DIR = "$MRTG_DIR/backup";
$TO_DIR = "$BACKUP_DIR/$date";

print "==================================================
Starting backup for day $date at $time.\n";

# Create daily directory and copy default GIF files
print "Creating directory $TO_DIR.\n";
mkdir($TO_DIR,"755") || die "Error creating directory $TO_DIR.\n";
chmod(0755,$TO_DIR);
system(sprintf("cp -a %s/mrtg-*.gif %s",$MRTG_DIR,$TO_DIR));

# For each node copy the daily summary file and create the index file
foreach $node ( @nodes_to_backup ) {
    printf("Executing backup for node %s.\n",$node);
    system(sprintf("cp -a %s/%s.*-day.gif %s",$MRTG_DIR,$node,$TO_DIR));
    $Summary_Source = "$MRTG_DIR/$node.html";
    $Summary_Destination = "$TO_DIR/$node.html";
    open(SRC,"<$Summary_Source");
    open(DST,">$Summary_Destination");
    while (<SRC>) {
	s/<A HREF[^>]*>//g;
	s/<\/A>//g;
	s/Router Overview/Router Overview of $date/;
	s/<META HTTP-EQUIV=\"Refresh\" CONTENT=300 >//;
	print DST; }
    close(SRC);
    close(DST);
    chmod(0644,$Summary_Destination);
}

# Create the general index file
$INDEX = "$TO_DIR/index.html";
print "Creating index file $INDEX.\n";
open(IDX,">$INDEX") || die "Could not open index file $INDEX.\n";
printf IDX "
<HTML>
<HEAD><TITLE>Server Summary for %s</TITLE></HEAD>
<BODY BGCOLOR=\"#FFFFFF\">
<CENTER><H1>Server Summary for %s</H1></CENTER>
<P><UL type=square>
",$date,$date;
foreach $node ( @nodes_to_backup ) {
    printf IDX "<LI><A HREF=\"%s.html\">%s</A></LI>\n",$node,$node;
}
print IDX "</UL></P></BODY></HTML>";
close(IDX);
chmod(0644,$INDEX);

chop ($time = `date +%H:%M:%S`);
print "Backup for day $date finished at $time.\n";
