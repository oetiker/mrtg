use lib './t';
use strict;
use GIFgraph::bars;

$::WRITE = 0;
require 'ff.pl';

my @data = ( 
	["1st","2nd","3rd","4th","5th","6th","7th", "8th", "9th"],
	[    1,    2,    5,    6,    3,  1.5,    1,     3,     4],
	[    3,    7,    8,    2,    4,  1.5,    2,     5,     1]
);

my @opts = (
	{},
	{
		'x_label' 		=> 'X2 Label',
		'y_label' 		=> 'Y2 label',
		'title' 		=> 'A Double axis Bar Chart',
		'y_max_value' 	=> 20,
		'y_tick_number'	=> 5,
		'y_label_skip' 	=> 2,
		'logo'			=> 't/logo.gif',
		'logo_resize'	=> 0.5,
		'logo_position'	=> 'UR',
		't_margin'		=> 20,
		'r_margin'		=> 20,
		'l_margin'		=> 20,
		'b_margin'		=> 20,
		'long_ticks'	=> 1,
		'x_ticks'		=> 1,
		'two_axes'		=> 1,
		'axis_space'	=> 8,
	},
	{
		'x_label' 		=> 'X Label',
		'y_label' 		=> 'Y label',
		'title' 		=> 'A Simple Bar Chart',
		'y_max_value' 	=> 8,
		'y_tick_number' => 8,
		'y_label_skip' 	=> 2,
		'transparent'	=> 1,
		'interlaced'	=> 1,
		'bgclr'			=> 'blue',
		'fgclr'			=> 'lyellow',
		'textclr'		=> 'lred',
		'labelclr'		=> 'lblue',
		'axislabelclr'	=> 'lgreen',
		'accentclr'		=> 'lgray',
	},
);

print "1..2\n";
($::WARN) && warn "\n";

foreach my $i (1..2)
{
	my $fn = 't/bars' . $i . '.gif';

	my $checkImage = get_test_data($fn);
	my $opts = $opts[$i];

	my $g = new GIFgraph::bars( );
	$g->set( %$opts );
	my $Image = $g->plot( \@data );

	print (($checkImage eq $Image ? "ok" : "not ok"). " $i\n");
	($::WARN) && warn (($checkImage eq $Image ? "ok" : "not ok"). " $i\n");

	write_file($fn, $Image) if ($::WRITE);
}

