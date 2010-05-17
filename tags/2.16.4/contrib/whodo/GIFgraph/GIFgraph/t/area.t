use lib './t';
use strict;
use GIFgraph::area;

$::WRITE = 0;
require 'ff.pl';

my @data = ( 
	["1st","2nd","3rd","4th","5th","6th","7th", "8th", "9th"],
	[    3,    7,    8,    2,    4,  8.5,    2,     5,     9],
	[    4,    2,    5,    6,    3,  2.5,    3,     3,     4],
);

my @opts = (
	{},
	{
		'x_label' 		=> 'X Label',
		'y_label' 		=> 'Y label',
		'title' 		=> 'An area chart',
		'transparent'	=> 1,
		'interlaced'	=> 1,
	},
	{
		'x_label' 		=> 'X Label',
		'y_label' 		=> 'Y label',
		'title' 		=> 'An area chart',
		'y_max_value'	=> 10,
		'transparent'	=> 1,
		'interlaced'	=> 1,
	},
);

print "1..2\n";
($::WARN) && warn "\n";

foreach my $i (1..2)
{
	my $fn = 't/area' . $i . '.gif';

	my $checkImage = get_test_data($fn);
	my $opts = $opts[$i];

	if ($i == 2)
	{
		foreach (@{$data[1]})
		{
			$_ *= -1;
		}
	}

	my $g = new GIFgraph::area( );
	$g->set( %$opts );
	my $Image = $g->plot( \@data );

	print (($checkImage eq $Image ? "ok" : "not ok"). " $i\n");
	($::WARN) && warn (($checkImage eq $Image ? "ok" : "not ok"). " $i\n");

	write_file($fn, $Image) if ($::WRITE);
}

