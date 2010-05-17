#!/usr/bin/perl
#
# Script to convert runtime MIB variable for UPS into minutes

$a=`/usr/bin/snmpget <SERVERNAME> <COMMUNITY> .1.3.6.1.4.1.318.1.1.1.2.2.3.0`;
chomp $a;
@b=split(/ /,$a);
@c=split(/:/,$b[4]);
@d=split(/ /,`/usr/bin/snmpget <SERVERNAME> <COMMUNITY> .1.3.6.1.4.1.318.1.1.1.4.2.3.0`);
chomp $d;
print eval($c[0] * 60 + $c[1]),"\n";
print $d[3];