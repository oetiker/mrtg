#==========================================================================
#			   Copyright (c) 1995-1998 Martien Verbruggen
#--------------------------------------------------------------------------
#
#	Name:
#		GIFgraph::linespoints.pm
#
# $Id: linespoints.pm,v 1.1.1.1 2002/02/26 10:16:37 oetiker Exp $
#
#==========================================================================

package GIFgraph::linespoints;
 
use strict qw(vars refs subs);
 
use GIFgraph::axestype;
use GIFgraph::lines;
use GIFgraph::points;
 
# Even though multiple inheritance is not really a good idea,
# since lines and points have the same parent class, I will do it here,
# because I need the functionality of the markers and the line types

@GIFgraph::linespoints::ISA = qw( GIFgraph::lines GIFgraph::points );

{
	sub initialise()
	{
		my $s = shift;

		$s->GIFgraph::lines::initialise();
		$s->GIFgraph::points::initialise();
	}

	# PRIVATE

	sub draw_data_set($$$) # GD::Image, \@data, $ds
	{
		my $s = shift;
		my $g = shift;
		my $d = shift;
		my $ds = shift;

		$s->GIFgraph::points::draw_data_set( $g, $d, $ds );
		$s->GIFgraph::lines::draw_data_set( $g, $d, $ds );
	}

	sub draw_legend_marker($$$$) # (GD::Image, data_set_number, x, y)
	{
		my $s = shift;
		my $g = shift;
		my $n = shift;
		my $x = shift;
		my $y = shift;

		$s->GIFgraph::points::draw_legend_marker($g, $n, $x, $y);
		$s->GIFgraph::lines::draw_legend_marker($g, $n, $x, $y);
	}

} # End of package GIFgraph::linesPoints

1;
