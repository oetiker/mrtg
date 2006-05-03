use GIFgraph::mixed;

print STDERR "Processing sample 6-1 (The error message is intended)\n";

@data = ( 
    ["1st","2nd","3rd","4th","5th","6th","7th", "8th", "9th"],
    [    1,    2,    5,    6,    3,  1.5,   -1,    -3,    -4],
    [   -4,   -3,    1,    1,   -3, -1.5,   -2,    -1,     0],
    [    9,    8,    9,  8.4,  7.1,  7.5,    8,     3,    -3],
	[  0.1,  0.2,  0.5,  0.4,  0.3,  0.5,  0.1,     0,   0.4],
	[ -0.1,    2,    5,    4,   -3,  2.5,  3.2,     4,    -4],
	[ -0.1,    2,    5,    4,   -3,  2.5,  3.2,     4,    -4],
);

$my_graph = new GIFgraph::mixed();

$my_graph->set( 
	types => [ qw( lines bars points area linespoints wrong_type ) ],
	default_type => 'points',
);

$my_graph->set( 

	x_label => 'X Label',
	y_label => 'Y label',
	title => 'A Mixed Type Graph',

	y_max_value => 10,
	y_min_value => -5,
	y_tick_number => 3,
	y_label_skip => 1,
	x_plot_values => 0,
	y_plot_values => 0,

	long_ticks => 1,
	x_ticks => 0,

	legend_marker_width => 24,
	line_width => 3,
	marker_size => 5,

	bar_spacing => 8,
);

$my_graph->set_legend( qw( one two three four five six ) );

$my_graph->plot_to_gif( "sample61.gif", \@data );

exit;

