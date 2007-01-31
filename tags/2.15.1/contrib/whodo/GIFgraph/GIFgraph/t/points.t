use lib './t';
use strict;
use GIFgraph::points;

$::WRITE = 0;
require 'ff.pl';

my @data = ( 
	["1st","2nd","3rd","4th","5th","6th","7th", "8th", "9th"],
	[    3,    7,    8,    2,    4,  1.5,    2,     5,     1],
	[    1,    2,    5,    6,    3,  1.5,    1,     3,     4],
);

my @opts = (
	{},
	{
		'x_label' 		=> 'X Label',
		'y_label' 		=> 'Y label',
		'title' 		=> 'A points chart with default markers',
		'y_max_value' 	=> 10,
		'y_tick_number'	=> 5,
		'y_label_skip' 	=> 2,
		'x_ticks'		=> 1,
	},
	{
		'x_label' 		=> 'X Label',
		'y_label' 		=> 'Y label',
		'title' 		=> 'A points chart with big markers',
		'y_max_value' 	=> 10,
		'y_tick_number'	=> 5,
		'y_label_skip' 	=> 2,
		'x_ticks'		=> 1,
		'marker_size'	=> 16,
		'long_ticks'	=> 1,
		'markers'		=> [ 7, 5 ],
	},
);

print "1..2\n";
($::WARN) && warn "\n";

foreach my $i (1..2)
{
	my $fn = 't/points' . $i . '.gif';

	my $checkImage = get_test_data($fn);
	my $opts = $opts[$i];

	my $g = new GIFgraph::points( );
	$g->set( %$opts );
	my $Image = $g->plot( \@data );

	print (($checkImage eq $Image ? "ok" : "not ok"). " $i\n");
	($::WARN) && warn (($checkImage eq $Image ? "ok" : "not ok"). " $i\n");

	write_file($fn, $Image) if ($::WRITE);
}

