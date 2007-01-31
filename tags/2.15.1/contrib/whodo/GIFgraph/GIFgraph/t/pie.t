use lib './t';
use strict;
use GIFgraph::pie;

$::WRITE = 0;
require 'ff.pl';

my @data = ( 
	["1st","2nd","3rd","4th","5th","6th"],
	[    1,    2,    5,    6,    3,  1.5],
);

my @opts = (
	{},
	{
		 'start_angle'	=> 90,
		'title' 		=> 'A pie chart',
		'label'			=> 'Just data',
	},
);

print "1..1\n";
($::WARN) && warn "\n";

foreach my $i (1)
{
	my $fn = 't/pie' . $i . '.gif';

	my $checkImage = get_test_data($fn);
	my $opts = $opts[$i];

	my $g = new GIFgraph::pie( );
	$g->set( %$opts );
	my $Image = $g->plot( \@data );

	print (($checkImage eq $Image ? "ok" : "not ok"). " $i\n");
	($::WARN) && warn (($checkImage eq $Image ? "ok" : "not ok"). " $i\n");

	write_file($fn, $Image) if ($::WRITE);
}

