use GIFgraph::pie;

print STDERR "Processing sample 9-2\n";

@data = ( 
    ["1st","2nd","3rd","4th","5th","6th"],
    [    4,    2,    3,    4,    3,  3.5]
);

$my_graph = new GIFgraph::pie( 250, 200 );

$my_graph->set( 
	title => 'A Pie Chart',
	label => 'Label',
	axislabelclr => 'white',
	dclrs => [ 'lblue' ],
	accentclr => 'lgray',
);

$my_graph->plot_to_gif( "sample92.gif", \@data );

exit;

