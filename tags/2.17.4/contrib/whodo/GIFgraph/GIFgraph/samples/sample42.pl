use GIFgraph::linespoints;

print STDERR "Processing sample 4-2\n";

@data =  read_data_from_csv("sample42.dat")
	or die "Cannot read data from sample42.dat";

$my_graph = new GIFgraph::linespoints( );

$my_graph->set( 
	x_label => 'X Label',
	y_label => 'Y label',
	title => 'A Lines and Points Graph, reading a CSV file',
	y_max_value => 80,
	y_tick_number => 6,
	y_label_skip => 2,
	markers => [ 1, 5 ],
);

$my_graph->set_legend( 'data set 1', 'data set 2' );

$my_graph->plot_to_gif( "sample42.gif", \@data );

exit;

sub read_data_from_csv
{
	my $fn = shift;
	my @d = ();

	open(ZZZ, $fn) || return ();

	while (<ZZZ>)
	{
		chomp;
		# you might want Text::CSV here
		my @row = split /,/;

		for (my $i = 0; $i <= $#row; $i++)
		{
			undef $row[$i] if ($row[$i] eq 'undef');
			push @{$d[$i]}, $row[$i];
		}
	}

	close (ZZZ);

	return @d;
}

