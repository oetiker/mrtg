#!/usr/bin/perl
#
# Miroslaw M. Maczka: Miroslaw_Maczka@hotmail.com, mmm@bze.com.pl
# Date 2000-1-6
#
open(FI,"/usr/informix/bin/tbstat -p |") or die "";

while(<FI>){
#if(/RSAM Version 5.04.UC3   -- On-Line -- Up 1 days 21:56:47 -- 10960 Kbytes/){
if(/.+Version\s+(.+)   --\s+(.+)\s+-- Up\s+(.+)\s+--.*/){
#print "[$1|$2|$3]\n";
$db="$2 $1";
$uptime=$3;
}


if(/dskreads pagreads bufreads %cached dskwrits pagwrits bufwrits \%cached/){
$_=<FI>;
($dskreads,$pagreads,$bufreads,$cached1,$dskwrits,$pagwrits,$bufwrits,$cached2)=split();
#print "[$dskreads,$pagreads,$bufreads,$cached1,$dskwrits,$pagwrits,$bufwrits,$cached2]\n";
#
#$uname = `/bin/uname -n`;
print "$dskreads\n$dskwrits\n$uptime\n$db";
#
}#if

}#while
close(FI);
#-=EOF=-

