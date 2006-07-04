use lib './t';
use strict;
use GIFgraph::bars;
use GIFgraph::area;
use GIFgraph::linespoints;

$::WRITE = 0;
require 'ff.pl';

my @data = ( 
	["1st","2nd","3rd","4th","5th","6th","7th", "8th", "9th"],
	[    6,    7,   -8,   -2,   -4,  8.5,   -1,     5,     9],
	[    4,    2,    5,   -6,    3, -3.5,    3,    -3,    -4],
	[   -3,   -7,    undef, 2,   -4,  8.5,    2,     5,    -9],
	[    4,    2,   -5,    6,   -3, -2.5,   -3,    -3,     4],
);

my @opts = (
	{},
	{
		'legend_placement'		=> 'RT',
		'legend'				=> [ qw( one two three four five six ) ],
	},
	{
		'legend_placement'		=> 'BL',
		'legend_marker_width'	=> 16,
		'legend_marker_height'	=> 16,
		'legend'				=> [ 'One is a long one', undef, "Three is here" ],
	},
	{
		'lg_cols'				=> 2,
		'marker_size'			=> 10,
		'legend'				=> [ qw( one two three four five six ) ],
	},
);

print "1..3\n";
($::WARN) && warn "\n";

foreach my $i (1..3)
{
	my $fn = 't/legend' . $i . '.gif';

	my $checkImage = get_test_data($fn);
	my $opts = $opts[$i];

	if ($i == 2)
	{
		foreach (@{$data[1]})
		{
			$_ *= -1;
		}
	}

	my $g = undef;
	if ($i == 1) { $g = new GIFgraph::bars(); }
	elsif ($i == 2) { $g = new GIFgraph::area(); }
	else { $g = new GIFgraph::linespoints(); }
	$g->set( %$opts );
	my $Image = $g->plot( \@data );

	print (($checkImage eq $Image ? "ok" : "not ok"). " $i\n");
	($::WARN) && warn (($checkImage eq $Image ? "ok" : "not ok"). " $i\n");

	write_file($fn, $Image) if ($::WRITE);
}

