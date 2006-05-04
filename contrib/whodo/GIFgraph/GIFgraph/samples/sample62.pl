use GIFgraph::mixed;

print STDERR "Processing sample 6-2\n";

@data = ( 
    ["1st","2nd","3rd","4th","5th","6th","7th", "8th", "9th"],
    [    9,    8,    9,  8.4,  7.1,  7.5,    8,     3,     3],
    [   .4,   .3,    1,    1,   .3,  1.5,    2,     1,     0],
);

$my_graph = new GIFgraph::mixed();

$my_graph->set( 
	x_label => 'X Label',
	y1_label => 'Y1 label',
	y2_label => 'Y2 label',
	title => 'A Mixed Type Graph with Two Axes',
	two_axes => 1,
	y1_max_value => 10,
	y2_max_value => 2.5,
	y_min_value => 0,
	y_tick_number => 5,
	long_ticks => 1,
	x_ticks => 0,
	legend_marker_width => 24,
	line_width => 5,

	bar_spacing => 4,

	types => [ qw( bars lines ) ],
);

$my_graph->set_legend( qw( one two three four five six ) );

$my_graph->plot_to_gif( "sample62.gif", \@data );

exit;

