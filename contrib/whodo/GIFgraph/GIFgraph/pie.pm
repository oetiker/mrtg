#==========================================================================
#			   Copyright (c) 1995-1998 Martien Verbruggen
#--------------------------------------------------------------------------
#
#	Name:
#		GIFgraph::pie.pm
#
# $Id: pie.pm,v 1.1.1.1 2002/02/26 10:16:37 oetiker Exp $
#
#==========================================================================

package GIFgraph::pie;

use strict qw(vars refs subs);

use GIFgraph;
use GIFgraph::legend;
use GIFgraph::utils qw(:all);
use GIFgraph::colour qw(:colours :lists);

@GIFgraph::pie::ISA = qw( GIFgraph::legend GIFgraph );

my $ANGLE_OFFSET = 90;

my %Defaults = (
 
	# Set the height of the pie.
	# Because of the dependency of this on runtime information, this
	# is being set in GIFgraph::pie::initialise
 
	#   pie_height => _round(0.1*${'gifx'}),
 
	# Do you want a 3D pie?
 
	'3d'         => 1,
 
	# The angle at which to start the first data set
	# 0 is at the front/bottom
 
	start_angle => 0,
);

{
	# PUBLIC methods, documented in pod
	sub plot($) # (\@data)
	{
		my $self = shift;
		my $data = shift;

		$self->check_data($data);
		$self->init_graph($self->{graph});
		$self->plot_legend($self->{graph});
		$self->setup_coords();
		$self->draw_text($self->{graph});
		$self->draw_pie($self->{graph});
		$self->draw_data($data, $self->{graph});

		return $self->{graph}->gif;
	}
 
	sub set_label_font($) # (fontname)
	{
		my $self = shift;

		$self->{lf} = shift;
		$self->set( 
			lfw => $self->{lf}->width,
			lfh => $self->{lf}->height,
		);
	}
 
	sub set_value_font($) # (fontname)
	{
		my $self = shift;

		$self->{vf} = shift;
		$self->set( 
			vfw => $self->{vf}->width,
			vfh => $self->{vf}->height,
		);
	}
 
	# Inherit defaults() from GIFgraph
 
	# PRIVATE
	# called on construction by new.
	sub initialise()
	{
		my $self = shift;
 
		$self->SUPER::initialise();
 
		my $key;
		foreach $key (keys %Defaults) 
		{
			$self->set( $key => $Defaults{$key} );
		}
 
		$self->set( pie_height => _round(0.1 * $self->{gify}) );
 
		$self->set_value_font(GD::gdTinyFont);
		$self->set_label_font(GD::gdSmallFont);
	}

	# inherit checkdata from GIFgraph
 
	# Setup the coordinate system and colours, calculate the
	# relative axis coordinates in respect to the gif size.
 
	sub setup_coords()
	{
		my $s = shift;
 
		# Make sure we're not reserving space we don't need.
		$s->set(tfh => 0) 			unless ( $s->{title} );
		$s->set(lfh => 0) 			unless ( $s->{label} );
		$s->set('3d' => 0) 			if     ( $s->{pie_height} <= 0 );
		$s->set(pie_height => 0)	unless ( $s->{'3d'} );
 
		# Calculate the bounding box for the pie, and
		# some width, height, and centre parameters
		$s->{bottom} = 
			$s->{gify} - $s->{pie_height} - $s->{b_margin} -
			( $s->{lfh} ? $s->{lfh} + $s->{text_space} : 0 );

		$s->{top} = 
			$s->{t_margin} + ( $s->{tfh} ? $s->{tfh} + $s->{text_space} : 0 );

		$s->{left} = $s->{l_margin};

		$s->{right} = $s->{gifx} - $s->{r_margin};

		( $s->{w}, $s->{h} ) = 
			( $s->{right}-$s->{left}, $s->{bottom}-$s->{top} );

		( $s->{xc}, $s->{yc} ) = 
			( ($s->{right}+$s->{left})/2, ($s->{bottom}+$s->{top})/2 );
 
		die "Vertical Gif size too small" 
			if ( ($s->{bottom} - $s->{top}) <= 0 );
		die "Horizontal Gif size too small"
			if ( ($s->{right} - $s->{left}) <= 0 );
	}
 
	# inherit open_graph from GIFgraph
 
	# Put the text on the canvas.
	sub draw_text($) # (GD::Image)
	{
		my $s = shift;
		my $g = shift;
 
		if ( $s->{tfh} ) 
		{
			my $tx = $s->{xc} - length($s->{title}) * $s->{tfw}/2;
			$g->string($s->{tf}, $tx, $s->{t_margin}, $s->{title}, $s->{tci});
		}

		if ( $s->{lfh} ) 
		{
			my $tx = $s->{xc} - length($s->{label}) * $s->{lfw}/2;
			my $ty = $s->{gify} - $s->{b_margin} - $s->{lfh};
			$g->string($s->{lf}, $tx, $ty, $s->{label}, $s->{lci});
		}
	}
 
	# draw the pie, without the data slices
 
	sub draw_pie($) # (GD::Image)
	{
		my $s = shift;
		my $g = shift;

		my $left = $s->{xc} - $s->{w}/2;

		$g->arc(
			$s->{xc}, $s->{yc}, 
			$s->{w}, $s->{h},
			0, 360, $s->{acci}
		);

		$g->arc(
			$s->{xc}, $s->{yc} + $s->{pie_height}, 
			$s->{w}, $s->{h},
			0, 180, $s->{acci}
		) if ( $s->{'3d'} );

		$g->line(
			$left, $s->{yc},
			$left, $s->{yc} + $s->{pie_height}, 
			$s->{acci}
		);

		$g->line(
			$left + $s->{w}, $s->{yc},
			$left + $s->{w}, $s->{yc} + $s->{pie_height}, 
			$s->{acci}
		);
	}
 
	# Draw the data slices
 
	sub draw_data($$) # (\@data, GD::Image)
	{
		my $s = shift;
		my $data = shift;
		my $g = shift;

		my $total = 0;
		my $j = 1; 						# for now, only one pie..
 
		my $i;
		for $i ( 0 .. $s->{numpoints} ) 
		{ 
			$total += $data->[$j][$i]; 
		}
		die "no Total" unless $total;
 
		my $ac = $s->{acci};			# Accent colour
		my $pb = $s->{start_angle};

		my $val = 0;

		for $i ( 0..$s->{numpoints} ) 
		{
			# Set the data colour. Colours index from 1 not 0.
			my $dc = $s->set_clr( $g, $s->pick_data_clr($i+1) );

			# Set the angles of the pie slice
			my $pa = $pb;
			$pb += 360 * $data->[1][$i]/$total;

			# Calculate the end points of the lines at the boundaries of
			# the pie slice
			my ($xe, $ye) = 
				cartesian(
					$s->{w}/2, $pa, 
					$s->{xc}, $s->{yc}, $s->{h}/$s->{w}
				);

			$g->line($s->{xc}, $s->{yc}, $xe, $ye, $ac);

			# Draw the lines on the front of the pie
			$g->line($xe, $ye, $xe, $ye + $s->{pie_height}, $ac)
				if ( in_front($pa) && $s->{'3d'} );

			# Make an estimate of a point in the middle of the pie slice
			# And fill it
			($xe, $ye) = 
				cartesian(
					3 * $s->{w}/8, ($pa+$pb)/2,
					$s->{xc}, $s->{yc}, $s->{h}/$s->{w}
				);

			$g->fillToBorder($xe, $ye, $ac, $dc);

			# Horrible kludge by AF # $s->put_label($g, $xe, $ye, $data->[0][$i]);

			# If it's 3d, colour the front ones as well
			if ( $s->{'3d'} ) 
			{
				my ($xe, $ye) = $s->_get_pie_front_coords($pa, $pb);

				$g->fillToBorder($xe, $ye + $s->{pie_height}/2, $ac, $dc)
					if (defined($xe) && defined($ye));
			}
		}

		# More horrible kludge by AF
		$pb = $s->{start_angle};
		for $i ( 0..$s->{numpoints} ) 
		{
			my $pa = $pb;
			$pb += 360*$data->[1][$i]/$total;
			my ($xe, $ye) = 
				cartesian(
					3 * $s->{w}/8, ($pa+$pb)/2,
					$s->{xc}, $s->{yc}, $s->{h}/$s->{w}
				);
			$s->put_label($g, $xe, $ye, $$data[0][$i]);
		}
	} #GIFgraph::pie::draw_data

	sub _get_pie_front_coords($$) # (angle 1, angle 2)
	{
		my $s = shift;
		my $pa = level_angle(shift);
		my $pb = level_angle(shift);

		if (in_front($pa))
		{
			if (in_front($pb))
			{
				# both in front
				# don't do anything
			}
			else
			{
				# start in front, end in back
				$pb = $ANGLE_OFFSET;
			}
		}
		else
		{
			if (in_front($pb))
			{
				# start in back, end in front
				$pa = $ANGLE_OFFSET - 180;
			}
			else
			{
				# both in back
				return;
			}
		}

		my ($x, $y) = 
			cartesian(
				$s->{w}/2, ($pa+$pb)/2,
				$s->{xc}, $s->{yc}, $s->{h}/$s->{w}
			);

		return ($x, $y);
	}
 
	# return true if this angle is on the front of the pie

	sub in_front($) # (angle)
	{
		my $a = level_angle( shift );
		( $a > ($ANGLE_OFFSET - 180) && $a < $ANGLE_OFFSET ) ? 1 : 0;
	}
 
	# return a value for angle between -180 and 180
 
	sub level_angle($) # (angle)
	{
		my $a = shift;
		return level_angle($a-360) if ( $a > 180 );
		return level_angle($a+360) if ( $a <= -180 );
		return $a;
	}
 
	# put the label on the pie
 
	sub put_label($) # (GD:Image)
	{
		my $s = shift;
		my $g = shift;

		my ($x, $y, $label) = @_;

		$x -= length($label) * $s->{vfw}/2;
		$y -= $s->{vfw}/2;
		$g->string($s->{vf}, $x, $y, $label, $s->{alci});
	}
 
	# return x, y coordinates from input
	# radius, angle, center x and y and a scaling factor (height/width)
	#
	# $ANGLE_OFFSET is used to define where 0 is meant to be
	sub cartesian($$$$$) 
	{
		my ($r, $phi, $xi, $yi, $cr) = @_; 
		my $PI=4*atan2(1, 1);

		return (
			$xi + $r * cos($PI * ($phi + $ANGLE_OFFSET)/180), 
			$yi + $cr * $r * sin($PI * ($phi + $ANGLE_OFFSET)/180)
		);
	}

} # End of package GIFgraph::pie
 
1;
