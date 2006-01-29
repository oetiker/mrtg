use GIFgraph::lines;

print STDERR "Processing sample 5-4\n";

# The reverse is in here, because I thought the falling line was 
# depressing, but I was too lazy to retype the data set

@data = read_data("sample54.dat") 
	or die "Cannot read data from sample54.dat";

$my_graph = new GIFgraph::lines();

$my_graph->set( 
	x_label => 'Wavelength (nm)',
	y_label => 'Absorbance',
	title => 'Numerical X axis',

	y_min_value => 0,
	y_max_value => 2,
	y_tick_number => 8,
	y_label_skip => 4,

	x_tick_number => 'auto',

	box_axis => 0,
	line_width => 2,
	x_label_position => 1/2,
	r_margin => 15,
);

$my_graph->set_legend('Thanks to Scott Prahl');

$my_graph->plot_to_gif( "sample54.gif", \@data );

exit;

sub read_data
{
	my $fn = shift;
	my @d = ();

	open(ZZZ, $fn) || return ();

	while (<ZZZ>)
	{
		chomp;
		my @row = split;

		for (my $i = 0; $i <= $#row; $i++)
		{
			undef $row[$i] if ($row[$i] eq 'undef');
			push @{$d[$i]}, $row[$i];
		}
	}

	close (ZZZ);

	return @d;
}

