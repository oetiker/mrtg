use GIFgraph::linespoints;

print STDERR "Processing sample 4-1\n";

@data = ( 
    ["1st","2nd","3rd","4th","5th","6th","7th", "8th", "9th"],
    [undef,  52,  53,  54,  55,  56,  undef,  58,  59],
    [60,  61,  61,  undef,  68,  66,  65,  61, undef],
);

$my_graph = new GIFgraph::linespoints( );

$my_graph->set( 
	x_label => 'X Label',
	y_label => 'Y label',
	title => 'A Lines and Points Graph',
	y_max_value => 80,
	y_tick_number => 6,
	y_label_skip => 2,
	markers => [ 1, 5 ],
);

$my_graph->set_legend( 'data set 1', 'data set 2' );

$my_graph->plot_to_gif( "sample41.gif", \@data );

exit;

