use strict;

$::WRITE = 1 if (defined($ARGV[0]) and $ARGV[0] eq '--write');
$::WARN = 0;

sub get_test_data
{
	my $fn = shift;

	local($/);
	undef $/;

	open(GIF, $fn) or die "Cannot open $fn: $!\n";
	binmode(GIF);
	my $im = <GIF>;
	close (GIF);

	return defined($im) ? $im : "";
}

sub write_file
{
	my $fn = shift;
	my $im = shift;
	
	local($/);
	undef $/;

	print "writing\n";
	open(GIF, '>' . $fn) or die "Cannot open $fn: $!\n";
	binmode(GIF);
	print GIF $im;
	close (GIF);
}

1;

