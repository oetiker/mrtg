use GIFgraph::lines;

print STDERR "Processing sample 5-1\n";

# The reverse is in here, because I thought the falling line was 
# depressing, but I was too lazy to retype the data set

@data = ( 
    [ qw( Jan Feb Mar Apr May Jun Jul Aug Sep ) ],
    [ reverse(4, 3, 5, 6, 3,  1.5, -1, -3, -4)],
);

$my_graph = new GIFgraph::lines();

$my_graph->set( 
	x_label => 'Month',
	y_label => 'Measure of success',
	title => 'A Simple Line Graph',
	y_max_value => 8,
	y_min_value => -6,
	y_tick_number => 14,
	y_label_skip => 2,
	box_axis => 0,
	line_width => 3,
);

$my_graph->plot_to_gif( "sample51.gif", \@data );

exit;

