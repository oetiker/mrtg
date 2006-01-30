use GIFgraph::bars;

print STDERR "Processing sample 1-4\n";

@data = ( 
    ["1st","2nd","3rd","4th","5th","6th","7th", "8th", "9th"],
    [    5,   12,   24,   33,   19,    8,    6,    15,    21],
    [    1,    2,    5,    6,    3,  1.5,    1,     3,     4]
);

$my_graph = new GIFgraph::bars( );

$my_graph->set( 
	x_label => 'X Label',
	y1_label => 'Y1 label',
	y2_label => 'Y2 label',
	title => 'Using two axes',
	y1_max_value => 40,
	y2_max_value => 8,
	y_tick_number => 8,
	y_label_skip => 2,
	long_ticks => 1,
	two_axes => 1,
	legend_placement => 'RT',
	x_labels_vertical => 1,
	x_label_position => 1/2,

	bar_spacing => 2,

	logo => 'logo.gif',
	logo_position => 'BR',
);

$my_graph->set_legend( 'left axis', 'right axis');

$my_graph->plot_to_gif( "sample14.gif", \@data );

exit;

