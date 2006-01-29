use GIFgraph::bars;

print STDERR "Processing sample 1-5\n";

@data = ( 
    ["1st","2nd","3rd","4th","5th","6th","7th", "8th", "9th"],
    [   11,   12,   15,   16,    3,  1.5,    1,     3,     4],
    [    5,   12,   24,   15,   19,    8,    6,    15,    21],
    [    12,   3,    1,   5,    12,    9,   16,    25,    11],
);

$my_graph = new GIFgraph::bars();

$my_graph->set( 
	x_label => 'X Label',
	y_label => 'Y label',
	title => 'Stacked Bars (incremental)',
	y_max_value => 50,
	y_tick_number => 10,
	y_label_skip => 2,
	overwrite => 2,
);

$my_graph->set_legend( qw(offset increment more));

$my_graph->plot_to_gif( "sample15.gif", \@data );

exit;

