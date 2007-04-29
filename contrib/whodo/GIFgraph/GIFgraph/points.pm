#==========================================================================
#			   Copyright (c) 1995-1998 Martien Verbruggen
#--------------------------------------------------------------------------
#
#	Name:
#		GIFgraph::points.pm
#
# $Id: points.pm,v 1.1.1.1 2002/02/26 10:16:37 oetiker Exp $
#
#==========================================================================

package GIFgraph::points;

use strict qw(vars refs subs);
 
use GIFgraph::axestype;
use GIFgraph::utils qw(:all);

@GIFgraph::points::ISA = qw( GIFgraph::axestype );

my %Defaults = (

	# The size of the marker to use in the points and linespoints graphs
	# in pixels
 
	marker_size	=> 4,
);
 
{
	sub initialise()
	{
		my $s = shift;

		$s->SUPER::initialise();

		my $key;
		foreach $key (keys %Defaults)
		{
			$s->set( $key => $Defaults{$key} );
		}
	}
	
	# PRIVATE
	sub draw_data_set($$$) # GD::Image, \@data
	{
		my $s = shift;
		my $g = shift;
		my $d = shift;
		my $ds = shift;

		# Pick a colour
		my $dsci = $s->set_clr( $g, $s->pick_data_clr($ds) );
		my $type = $s->pick_marker($ds);

		my $i;
		for $i (0 .. $s->{numpoints}) 
		{
			next unless (defined $d->[$i]);
			my ($xp, $yp) = $s->val_to_pixel($i+1, $d->[$i], $ds);
			$s->marker( $g, $xp, $yp, $type, $dsci );
		}
	}

	# Pick a marker type
 
	sub pick_marker($) # number
	{
		my $s = shift;
		my $num = shift;

		if ( exists $s->{markers} ) 
		{
			return $s->{markers}[ $num % (1 + $#{$s->{markers}}) - 1 ];
		}

		return ($num % 8) || 8;
	}
 
	# Draw a marker
 
	sub marker($$$$$) # $graph, $xp, $yp, type (1-7), $colourindex
	{
		my $self = shift;

		my ($graph, $xp, $yp, $mtype, $mclr) = @_;

		my $l = $xp - $self->{marker_size};
		my $r = $xp + $self->{marker_size};
		my $b = $yp + $self->{marker_size};
		my $t = $yp - $self->{marker_size};

		MARKER: {

			($mtype == 1) && do 
			{ # Square, filled
				$graph->filledRectangle( $l, $t, $r, $b, $mclr );
				last MARKER;
			};
			($mtype == 2) && do 
			{ # Square, open
				$graph->rectangle( $l, $t, $r, $b, $mclr );
				last MARKER;
			};
			($mtype == 3) && do 
			{ # Cross, horizontal
				$graph->line( $l, $yp, $r, $yp, $mclr );
				$graph->line( $xp, $t, $xp, $b, $mclr );
				last MARKER;
			};
			($mtype == 4) && do 
			{ # Cross, diagonal
				$graph->line( $l, $b, $r, $t, $mclr );
				$graph->line( $l, $t, $r, $b, $mclr );
				last MARKER;
			};
			($mtype == 5) && do 
			{ # Diamond, filled
				$graph->line( $l, $yp, $xp, $t, $mclr );
				$graph->line( $xp, $t, $r, $yp, $mclr );
				$graph->line( $r, $yp, $xp, $b, $mclr );
				$graph->line( $xp, $b, $l, $yp, $mclr );
				$graph->fillToBorder( $xp, $yp, $mclr, $mclr );
				last MARKER;
			};
			($mtype == 6) && do 
			{ # Diamond, open
				$graph->line( $l, $yp, $xp, $t, $mclr );
				$graph->line( $xp, $t, $r, $yp, $mclr );
				$graph->line( $r, $yp, $xp, $b, $mclr );
				$graph->line( $xp, $b, $l, $yp, $mclr );
				last MARKER;
			};
			($mtype == 7) && do 
			{ # Circle, filled
				$graph->arc( $xp, $yp, 2 * $self->{marker_size},
							 2 * $self->{marker_size}, 0, 360, $mclr );
				$graph->fillToBorder( $xp, $yp, $mclr, $mclr );
				last MARKER;
			};
			($mtype == 8) && do 
			{ # Circle, open
				$graph->arc( $xp, $yp, 2 * $self->{marker_size},
							 2 * $self->{marker_size}, 0, 360, $mclr );
				last MARKER;
			};
		}
	}
 
 
	sub draw_legend_marker($$$$) # (GD::Image, data_set_number, x, y)
	{
		my $s = shift;
		my $g = shift;
		my $n = shift;
		my $x = shift;
		my $y = shift;

		my $ci = $s->set_clr( $g, $s->pick_data_clr($n) );

		my $old_ms = $s->{marker_size};
		my $ms = _min($s->{legend_marker_height}, $s->{legend_marker_width});

		($s->{marker_size} > $ms/2) and $s->{marker_size} = $ms/2;
		
		$x += int($s->{legend_marker_width}/2);
		$y += int($s->{lg_el_height}/2);

		$n = $s->pick_marker($n);

		$s->marker($g, $x, $y, $n, $ci);

		$s->{marker_size} = $old_ms;
	}

} # End of package GIFgraph::Points

1;
