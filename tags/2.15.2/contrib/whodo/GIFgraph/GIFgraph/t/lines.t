use lib './t';
use strict;
use GIFgraph::lines;

$::WRITE = 0;
require 'ff.pl';

my @data = ( 
	["1st","2nd","3rd","4th","5th","6th","7th", "8th", "9th"],
	[    9,    2,    5,    6,    3,  1.5,    9,     3,     4],
	[    3,    7,    8,    2,    4,  1.5,    2,     5,     1]
);

my @opts = (
	{},
	{
		'x_label' 		=> 'X Label',
		'y_label' 		=> 'Y label',
		'title' 		=> 'A line chart',
		'y_max_value' 	=> 11,
		'y_min_value'	=> 1,
		'y_tick_number'	=> 5,
		'y_label_skip' 	=> 2,
		'x_ticks'		=> 1,
		'axis_space'	=> 8,
		'transparent'	=> 1,
		'interlaced'	=> 1,
		'line_types'	=> [3,4,1,2],
	},
);

print "1..1\n";
($::WARN) && warn "\n";

foreach my $i (1)
{
	my $fn = 't/lines' . $i . '.gif';

	my $checkImage = get_test_data($fn);
	my $opts = $opts[$i];

	my $g = new GIFgraph::lines( );
	$g->set( %$opts );
	my $Image = $g->plot( \@data );

	print (($checkImage eq $Image ? "ok" : "not ok"). " $i\n");
	($::WARN) && warn (($checkImage eq $Image ? "ok" : "not ok"). " $i\n");

	write_file($fn, $Image) if ($::WRITE);
}

