#!/usr/local/bin/perl

# This was taken from a PERL script Chris Behrens wrote to monitor
# resource usage for his IRC servers and was trimmed down to
# report only cpu usage.  This has been tweaked to work well with
# MRTG (Multi Router Traffic Grapher) and will work fine with
# anything that has a pid file (ie: named)
#
# Matthew Ramsey <mjr@blackened.com>
# Last Modified 31 OCT 1997

$DEBUG = 0;

# Which ps do you want to use ? If you use a non-berkeley based ps,
# you will need to change the args used in the findcpu function.
# Uncomment the line you want or modify one to suit your needs.

#$ps = "/usr/ucb/ps";	# Solaris with UCB
$ps = "/bin/ps";	# most systems

# The ps arguments.  For a UCB-based (BSD) ps, -aux will probably
# work just fine for you.  For SysV-based ps, -eaf works best for
# me.

$psargs = "-aux";	# UCB-based
#$psargs = "-eaf";	# sysV-based

if ($ARGV[0]) {
   $pidfile = $ARGV[0] ;
} else {
   print STDERR "Usage: $0 <pidfile>\n" ;
   exit 1 ;
}

open(PID, "< $pidfile");
chomp($pid = <PID>);
close(PID);

$cpu = findcpu($pid);

print "$cpu\n";
print "$cpu\n";
print "$time\n";
print "";

exit; # We're done!

sub findcpu
{
	local($pid) = @_;

	local($cpu, $psline, @ps);
	open(PS, "$ps $psargs |") || die "Couldn't run a ps: $!";
	chomp(@ps = <PS>);
	close(PS);
	foreach $psline (@ps)
	{
		@blah = split(' ', $psline);
		print "$pid $blah[1]\n" if ($DEBUG);
		return $blah[2] if ($blah[1] == $pid);
	}
	return -1;
}
