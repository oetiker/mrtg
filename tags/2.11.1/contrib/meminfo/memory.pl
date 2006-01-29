#!/usr/bin/perl
# This small utility is used to collect the available memory and
# used memory. For free memory, it sums the free, cached and buffers.

# You must enable the "gauge" feature to have a proper graph
# as those numbers do not grow
#
# Colin Tinker
# g1gsw@titanic.demon.co.uk

# setup local vars

my($machine);

# Enter default macine name here

$machine = "g1gsw.ampr.org";

# This allows command args to override defaults listed above

if  (scalar(@ARGV) > 1 ) 
    {
    print("USAGE: memory.pl {machine}\n");
    exit(-1);
    }     

    if  ($ARGV[0] ne '' && $ARGV[0] ne '#')
	{

        $machine = $ARGV[0];
        }

# Calculate free memory

    $getfree = `cat /proc/meminfo | grep Mem:`;
    $getfree =~ /^Mem:\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/;

# Each (\D+) = $1 or $2 or $3 etc

    $outfree = $3;
    $outbuffers = $5;
    $outcached = $6;

# Total free memory

    $gettotal = $outfree+$outcached+$outbuffers;
    print $gettotal."\n";

# Get used memory free

    $getused = `cat /proc/meminfo | grep Swap:`;
    $outused = $1-$gettotal;
    print $outused."\n";

# Get uptime

    $getuptime = `/usr/bin/uptime`;

# Parse though getuptime and get data
    $getuptime =~ /^\s+(\d{1,2}:\d{2}..)\s+up\s+(\d+)\s+(\w+),/;

#Print getuptime data for mrtg

    print $2." ".$3."\n";
   
# Print machine name for mrtg

    print $machine."\n";
