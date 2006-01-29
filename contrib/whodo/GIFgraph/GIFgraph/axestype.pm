#==========================================================================
#			   Copyright (c) 1995-1998 Martien Verbruggen
#--------------------------------------------------------------------------
#
#	Name:
#		GIFgraph::axestype.pm
#
# $Id: axestype.pm,v 1.1.1.1 2002/02/26 10:16:37 oetiker Exp $
#
#==========================================================================

package GIFgraph::axestype;

use strict;
 
use GIFgraph;
use GIFgraph::legend;
use GIFgraph::utils qw(:all);

@GIFgraph::axestype::ISA = qw( GIFgraph::legend GIFgraph );

my %Defaults = (
 
	# Set the length for the 'short' ticks on the axes.
 
	tick_length			=> 4,
 
	# Do you want ticks to span the entire width of the graph?
 
	long_ticks			=> 0,
 
	# Number of ticks for the y axis
 
	y_tick_number		=> 5,
	x_tick_number		=> undef,		# CONTRIB Scott Prahl
 
	# Skip every nth label. if 1 will print every label on the axes,
	# if 2 will print every second, etc..
 
	x_label_skip		=> 1,
	y_label_skip		=> 1,

	# Do we want ticks on the x axis?

	x_ticks				=> 1,
	x_all_ticks			=> 0,

	# Where to place the x and y labels

	x_label_position	=> 3/4,
	y_label_position	=> 1/2,

	# vertical printing of x labels

	x_labels_vertical	=> 0,
 
	# Draw axes as a box? (otherwise just left and bottom)
 
	box_axis			=> 1,
 
	# Use two different axes for the first and second dataset. The first
	# will be displayed using the left axis, the second using the right
	# axis. You cannot use more than two datasets when this option is on.
 
	two_axes			=> 0,
 
	# Print values on the axes?
 
	x_plot_values 		=> 1,
	y_plot_values 		=> 1,
 
	# Space between axis and text
 
	axis_space			=> 4,
 
	# Do you want bars to be drawn on top of each other, or side by side?
 
	overwrite 			=> 0,

	# Draw the zero axis in the graph in case there are negative values

	zero_axis			=>	0,

	# Draw the zero axis, but do not draw the bottom axis, in case
	# box-axis == 0
	# This also moves the x axis labels to the zero axis
	zero_axis_only		=>	0,

	# Format of the numbers on the x and y axis

	y_number_format			=> undef,
	x_number_format			=> undef,		# CONTRIB Scott Prahl
);

{
 
	# PUBLIC
	sub plot($) # (\@data)
	{
		my $self = shift;
		my $data = shift;
 
		$self->check_data($data);
		$self->init_graph($self->{graph});
		$self->plot_legend($self->{graph});
		$self->setup_coords($data);
		$self->draw_text($self->{graph});
		$self->draw_axes($self->{graph}, $data);
		$self->draw_ticks($self->{graph}, $data);
		$self->draw_data($self->{graph}, $data);

		return $self->{graph}->gif
	}

	sub set_x_label_font($) # (fontname)
	{
		my $self = shift;
		$self->{xlf} = shift;
		$self->set( 
			xlfw => $self->{xlf}->width,
			xlfh => $self->{xlf}->height,
		);
	}
	sub set_y_label_font($) # (fontname)
	{
		my $self = shift;
		$self->{ylf} = shift;
		$self->set( 
			ylfw => $self->{ylf}->width,
			ylfh => $self->{ylf}->height,
		);
	}
	sub set_x_axis_font($) # (fontname)
	{
		my $self = shift;
		$self->{xaf} = shift;
		$self->set( 
			xafw => $self->{xaf}->width,
			xafh => $self->{xaf}->height,
		);
	}
	sub set_y_axis_font($) # (fontname)
	{
		my $self = shift;
		$self->{yaf} = shift;
		$self->set( 
			yafw => $self->{yaf}->width,
			yafh => $self->{yaf}->height,
		);
	}

	# PRIVATE
	# called on construction, by new
	# use inherited defaults
 
	sub initialise()
	{
		my $self = shift;
 
		$self->SUPER::initialise();
 
		my $key;
		foreach $key (keys %Defaults) 
		{
			$self->set( $key => $Defaults{$key} );
		}
 
		$self->set_x_label_font(GD::gdSmallFont);
		$self->set_y_label_font(GD::gdSmallFont);
		$self->set_x_axis_font(GD::gdTinyFont);
		$self->set_y_axis_font(GD::gdTinyFont);
	}
 
	# inherit check_data from GIFgraph
 
	sub setup_coords($)
	{
		my $s = shift;
		my $data = shift;

		# Do some sanity checks
		$s->{two_axes} = 0 if ( $s->{numsets} != 2 || $s->{two_axes} < 0 );
		$s->{two_axes} = 1 if ( $s->{two_axes} > 1 );

		delete $s->{y_label2} unless ($s->{two_axes});

		# Set some heights for text
		$s->set( tfh => 0 ) unless ( $s->{title} );
		$s->set( xlfh => 0 ) unless ( $s->{x_label} );

		if ( ! $s->{y1_label} && $s->{y_label} ) 
		{
			$s->{y1_label} = $s->{y_label};
		}

		$s->set( ylfh1 => $s->{y1_label} ? 1 : 0 );
		$s->set( ylfh2 => $s->{y2_label} ? 1 : 0 );

		$s->set( xafh => 0, xafw => 0 ) unless ($s->{x_plot_values}); 
		$s->set( yafh => 0, yafw => 0 ) unless ($s->{y_plot_values});

		$s->{x_axis_label_height} = $s->get_x_axis_label_height($data);

		my $lbl = ($s->{xlfh} ? 1 : 0) + ($s->{xafh} ? 1 : 0);

		# calculate the top and bottom of the bounding box for the graph
		$s->{bottom} = 
			$s->{gify} - $s->{b_margin} - 1 -
			( $s->{xlfh} ? $s->{xlfh} : 0 ) -
			( $s->{x_axis_label_height} ? $s->{x_axis_label_height} : 0) -
			( $lbl ? $lbl * $s->{text_space} : 0 );

		$s->{top} = $s->{t_margin} +
					( $s->{tfh} ? $s->{tfh} + $s->{text_space} : 0 );
		$s->{top} = $s->{yafh}/2 if ( $s->{top} == 0 );
 
		$s->set_max_min($data);

		# Create the labels for the y_axes, and calculate the max length

		$s->create_y_labels();
		$s->create_x_labels(); # CONTRIB Scott Prahl

		# calculate the left and right of the bounding box for the graph
		my $ls = $s->{yafw} * $s->{y_label_len}[1];
		$s->{left} = $s->{l_margin} +
					 ( $ls ? $ls + $s->{axis_space} : 0 ) +
					 ( $s->{ylfh1} ? $s->{ylfh} + $s->{text_space} : 0 );

		$ls = $s->{yafw} * $s->{y_label_len}[2] if $s->{two_axes};
		$s->{right} = $s->{gifx} - $s->{r_margin} - 1 -
					  $s->{two_axes} * (
						  ( $ls ? $ls + $s->{axis_space} : 0 ) +
						  ( $s->{ylfh2} ? $s->{ylfh} + $s->{text_space} : 0 )
					  );

		# CONTRIB Scott Prahl
		# make sure that we can generate valid x tick marks
		undef($s->{x_tick_number}) if $s->{numpoints} < 2;
		undef($s->{x_tick_number}) if (
				!defined $s->{x_max} || 
				!defined $s->{x_min} ||
				$s->{x_max} == $s->{x_min}
			);
 
		# calculate the step size for x data
		# CONTRIB Changes by Scott Prahl
		if (defined $s->{x_tick_number})
		{
			my $delta = ($s->{right}-$s->{left})/($s->{x_max}-$s->{x_min});
			$s->{x_offset} = 
				($s->{true_x_min} - $s->{x_min}) * $delta + $s->{left};
			$s->{x_step} = 
				($s->{true_x_max} - $s->{true_x_min}) * $delta/$s->{numpoints};
		}
		else
		{
			$s->{x_step} = ($s->{right} - $s->{left})/($s->{numpoints} + 2);
			$s->{x_offset} = $s->{left};
		}
 
		# get the zero axis level
		my $dum;
		($dum, $s->{zeropoint}) = $s->val_to_pixel(0, 0, 1);

		# Check the size
		die "Vertical Gif size too small"
			if ( ($s->{bottom} - $s->{top}) <= 0 );

		die "Horizontal Gif size too small"	
			if ( ($s->{right} - $s->{left}) <= 0 );
 
		# More sanity checks
		$s->{x_label_skip} = 1 		if ( $s->{x_label_skip} < 1 );
		$s->{y_label_skip} = 1 		if ( $s->{y_label_skip} < 1 );
		$s->{y_tick_number} = 1		if ( $s->{y_tick_number} < 1 );
	}

	sub create_y_labels
	{
		my $s = shift;

		$s->{y_label_len}[1] = 0;
		$s->{y_label_len}[2] = 0;

		my $t;
		foreach $t (0 .. $s->{y_tick_number})
		{
			my $a;
			foreach $a (1 .. ($s->{two_axes} + 1))
			{
				my $label = 
					$s->{y_min}[$a] +
					$t *
					($s->{y_max}[$a] - $s->{y_min}[$a])/$s->{y_tick_number};
				
				$s->{y_values}[$a][$t] = $label;

				if (defined $s->{y_number_format})
				{
					if (ref $s->{y_number_format} eq 'CODE')
					{
						$label = &{$s->{y_number_format}}($label);
					}
					else
					{
						$label = sprintf($s->{y_number_format}, $label);
					}
				}
				
				my $len = length($label);

				$s->{y_labels}[$a][$t] = $label;

				($len > $s->{y_label_len}[$a]) and 
					$s->{y_label_len}[$a] = $len;
			}
		}
	}

	# CONTRIB Scott Prahl
	sub create_x_labels
	{
		my $s = shift;
		return unless defined($s->{x_tick_number});

		$s->{x_label_len} = 0;

		my $t;
		foreach $t (0..$s->{x_tick_number})
		{
			my $label =
				$s->{x_min} +
				$t * ($s->{x_max} - $s->{x_min})/$s->{x_tick_number};

			$s->{x_values}[$t] = $label;

			if (defined $s->{x_number_format})
			{
				if (ref $s->{x_number_format} eq 'CODE')
				{
					$label = &{$s->{x_number_format}}($label);
				}
				else
				{
					$label = sprintf($s->{x_number_format}, $label);
				}
			}

			my $len = length($label);

			$s->{x_labels}[$t] = $label;

			($len > $s->{x_label_len}) and $s->{x_label_len} = $len;
		}
	}


	sub get_x_axis_label_height
	{
		my $s = shift;
		my $data = shift;

		return $s->{xafh} unless $s->{x_labels_vertical};

		my $len = 0;
		my $labels = $data->[0];
		my $label;
		foreach $label (@$labels)
		{
			my $llen = length($label);
			($llen > $len) and $len = $llen;
		}

		return $len * $s->{xafw}
	}
 
	# inherit open_graph from GIFgraph
 
	sub draw_text($) # GD::Image
	{
		my $s = shift;
		my $g = shift;
 
		# Title
		if ($s->{tfh}) 
		{
			my $tx = 
				$s->{left} + 
				($s->{right} - $s->{left})/2 - 
				length($s->{title}) * $s->{tfw}/2;
			my $ty = $s->{top} - $s->{text_space} - $s->{tfh};

			$g->string($s->{tf}, $tx, $ty, $s->{title}, $s->{tci});
		}

		# X label
		if ($s->{xlfh}) 
		{
			my $tx = 
				$s->{left} +
				$s->{x_label_position} * ($s->{right} - $s->{left}) - 
				$s->{x_label_position} * length($s->{x_label}) * $s->{xlfw};
			my $ty = $s->{gify} - $s->{xlfh} - $s->{b_margin};

			$g->string($s->{xlf}, $tx, $ty, $s->{x_label}, $s->{lci});
		}

		# Y labels
		if ($s->{ylfh1}) 
		{
			my $tx = $s->{l_margin};
			my $ty = 
				$s->{bottom} -
				$s->{y_label_position} * ($s->{bottom} - $s->{top}) +
				$s->{y_label_position} * length($s->{y1_label}) * $s->{ylfw};

			$g->stringUp($s->{ylf}, $tx, $ty, $s->{y1_label}, $s->{lci});
		}
		if ( $s->{two_axes} && $s->{ylfh2} ) 
		{
			my $tx = $s->{gifx} - $s->{ylfh} - $s->{r_margin};
			my $ty = 
				$s->{bottom} -
				$s->{y_label_position} * ($s->{bottom} - $s->{top}) +
				$s->{y_label_position} * length($s->{y2_label}) * $s->{ylfw};

			$g->stringUp($s->{ylf}, $tx, $ty, $s->{y2_label}, $s->{lci});
		}
	}
 
	sub draw_axes($) # GD::Image
	{
		my $s = shift;
		my $g = shift;
		my $d = shift;

		my ($l, $r, $b, $t) = 
			( $s->{left}, $s->{right}, $s->{bottom}, $s->{top} );
 
		if ( $s->{box_axis} ) 
		{
			$g->rectangle($l, $t, $r, $b, $s->{fgci});
		}
		else
		{
			$g->line($l, $t, $l, $b, $s->{fgci});
			$g->line($l, $b, $r, $b, $s->{fgci}) 
				unless ($s->{zero_axis_only});
			$g->line($r, $b, $r, $t, $s->{fgci}) 
				if ($s->{two_axes});
		}

		if ($s->{zero_axis} or $s->{zero_axis_only})
		{
			my ($x, $y) = $s->val_to_pixel(0, 0, 1);
			$g->line($l, $y, $r, $y, $s->{fgci});
		}
	}

	#
	# Ticks and values for y axes
	#
	sub draw_y_ticks($$) # GD::Image, \@data
	{
		my $s = shift;
		my $g = shift;
		my $d = shift;

		#
		# Ticks and values for y axes
		#
		my $t;
		foreach $t (0 .. $s->{y_tick_number}) 
		{
			my $a;
			foreach $a (1 .. ($s->{two_axes} + 1)) 
			{
				my $value = $s->{y_values}[$a][$t];
				my $label = $s->{y_labels}[$a][$t];
				
				my ($x, $y) = $s->val_to_pixel(0, $value, $a);
				#my ($x, $y) = $s->val_to_pixel( 
				#	($a-1) * ($s->{numpoints} + 2), 
				#	$value, 
				#	$a 
				#);

				$x = ($a == 1) ? $s->{left} : $s->{right};

				if ($s->{long_ticks}) 
				{
					$g->line( 
						$x, $y, 
						$x + $s->{right} - $s->{left}, $y, 
						$s->{fgci} 
					) unless ($a-1);
				} 
				else 
				{
					$g->line( 
						$x, $y, 
						$x + (3 - 2 * $a) * $s->{tick_length}, $y, 
						$s->{fgci} 
					);
				}

				next 
					if ( $t % ($s->{y_label_skip}) || ! $s->{y_plot_values} );

				$x -=
					(2-$a) * length($label) * $s->{yafw} + 
					(3 - 2 * $a) * $s->{axis_space};
				$y -= $s->{yafh}/2;
				$g->string($s->{yaf}, $x, $y, $label, $s->{alci});
			}
		}
	}

	#
	# Ticks and values for x axes
	#
	sub draw_x_ticks($$) # GD::Image, \@data
	{
		my $s = shift;
		my $g = shift;
		my $d = shift;

		#
		# Ticks and values for X axis
		#
		my $i;
		for $i (0 .. $s->{numpoints}) 
		{
			my ($x, $y) = $s->val_to_pixel($i + 1, 0, 1);

			$y = $s->{bottom} unless $s->{zero_axis_only};

			next 
				if ( !$s->{x_all_ticks} and 
						$i%($s->{x_label_skip}) and $i != $s->{numpoints} );

			if ($s->{x_ticks})
			{
				if ($s->{long_ticks})
				{
					$g->line( 
						$x, $s->{bottom}, $x, 
						$s->{top},
						$s->{fgci} 
					);
				}
				else
				{
					$g->line( $x, $y, $x, $y - $s->{tick_length},
							  $s->{fgci} );
				}
			}

			next 
				if ( $i%($s->{x_label_skip}) and $i != $s->{numpoints} );

			if ($s->{x_labels_vertical})
			{
				$x -= $s->{xafw};
				my $yt = 
					$y + $s->{text_space}/2 + $s->{xafw} * length($d->[0][$i]);
				$g->stringUp($s->{xaf}, $x, $yt, $d->[0][$i], $s->{alci});
			}
			else
			{
				$x -= $s->{xafw} * length($d->[0][$i])/2;
				my $yt = $y + $s->{text_space}/2;
				$g->string($s->{xaf}, $x, $yt, $d->[0][$i], $s->{alci});
			}
		}
	}

	
	# CONTRIB Scott Prahl
	# Assume x array contains equally spaced x-values
	# and generate an appropriate axis
	#
	sub draw_x_ticks_number($$) # GD::Image, \@data
	{
		my $s = shift;
		my $g = shift;
		my $d = shift;

		my $i;
		for $i (0 .. $s->{x_tick_number})
		{
			my $value = $s->{numpoints}
						* ($s->{x_values}[$i] - $s->{true_x_min})
			            / ($s->{true_x_max} - $s->{true_x_min});

			my $label = $s->{x_values}[$i];

			my ($x, $y) = $s->val_to_pixel($value + 1, 0, 1);

			$y = $s->{bottom} unless $s->{zero_axis_only};

			if ($s->{x_ticks})
			{
				if ($s->{long_ticks})
				{
					$g->line($x, $s->{bottom}, $x, $s->{top},$s->{fgci});
				}
				else
				{
					$g->line( $x, $y, $x, $y - $s->{tick_length}, $s->{fgci} );
				}
			}

			next
				if ( $i%($s->{x_label_skip}) and $i != $s->{x_tick_number} );

			if ($s->{x_labels_vertical})
			{
				$x -= $s->{xafw};
				my $yt =
					$y + $s->{text_space}/2 + $s->{xafw} * length($d->[0][$i]);
				$g->stringUp($s->{xaf}, $x, $yt, $label, $s->{alci});
			}
			else
			{
#				$x -= $s->{xafw} * length($$d[0][$i])/2;
				$x -=  length($d->[0][$i])/2;
				my $yt = $y + $s->{text_space}/2;
				$g->string($s->{xaf}, $x, $yt, $label, $s->{alci});
			}
		}
	}

	sub draw_ticks($$) # GD::Image, \@data
	{
		my $s = shift;
		my $g = shift;
		my $d = shift;

		$s->draw_y_ticks($g, $d);

		return unless ( $s->{x_plot_values} );

		if (defined $s->{x_tick_number})
		{
			$s->draw_x_ticks_number($g, $d);
		}
		else
		{
			$s->draw_x_ticks($g, $d);
		}
	}
 
	sub draw_data($$) # GD::Image, \@data
	{
		my $s = shift;
		my $g = shift;
		my $d = shift;

		my $ds;
		foreach $ds (1 .. $s->{numsets}) 
		{
			$s->draw_data_set($g, $d->[$ds], $ds);
		}
	}

	# draw_data_set is in sub classes

	sub draw_data_set()
	{
		# ABSTRACT
		my $s = shift;
		$s->die_abstract( "sub draw_data missing, ")
	}
 
	# Figure out the maximum values for the vertical exes, and calculate
	# a more or less sensible number for the tops.

	sub set_max_min($)
	{
		my $s = shift;
		my $d = shift;

		my @max_min;

		# First, calculate some decent values

		if ( $s->{two_axes} ) 
		{
			my $i;
			for $i (1 .. 2) 
			{
				my $true_y_min = get_min_y(@{$$d[$i]});
				my $true_y_max = get_max_y(@{$$d[$i]});
				($s->{y_min}[$i], $s->{y_max}[$i], $s->{y_tick_number}) =
					_best_ends($true_y_min, $true_y_max, $s->{y_tick_number});
			}
		} 
		else 
		{
			my ($true_y_min, $true_y_max) = $s->get_max_min_y_all($d);
			($s->{y_min}[1], $s->{y_max}[1], $s->{y_tick_number}) =
				_best_ends($true_y_min, $true_y_max, $s->{y_tick_number});
		}

		if (defined( $s->{x_tick_number} ))
		{
			$s->{true_x_min} = get_min_y(@{$d->[0]});
			$s->{true_x_max} = get_max_y(@{$d->[0]});

			($s->{x_min}, $s->{x_max}, $s->{x_tick_number}) =
				_best_ends( $s->{true_x_min}, $s->{true_x_max}, 
							$s->{x_tick_number});
		}

		# Make sure bars and area always have a zero offset

		if (ref($s) eq 'GIFgraph::bars' or ref($s) eq 'GIFgraph::area')
		{
			$s->{y_min}[1] = 0 if $s->{y_min}[1] > 0;
			$s->{y_min}[2] = 0 if $s->{y_min}[2] && $s->{y_min}[2] > 0;
		}

		# Overwrite these with any user supplied ones

		$s->{y_min}[1] = $s->{y_min_value}  if defined $s->{y_min_value};
		$s->{y_min}[2] = $s->{y_min_value}  if defined $s->{y_min_value};

		$s->{y_max}[1] = $s->{y_max_value}  if defined $s->{y_max_value};
		$s->{y_max}[2] = $s->{y_max_value}  if defined $s->{y_max_value};

		$s->{y_min}[1] = $s->{y1_min_value} if defined $s->{y1_min_value};
		$s->{y_max}[1] = $s->{y1_max_value} if defined $s->{y1_max_value};

		$s->{y_min}[2] = $s->{y2_min_value} if defined $s->{y2_min_value};
		$s->{y_max}[2] = $s->{y2_max_value} if defined $s->{y2_max_value};

		$s->{x_min}    = $s->{x_min_value}  if defined $s->{x_min_value};
		$s->{x_max}    = $s->{x_max_value}  if defined $s->{x_max_value};

		# Check to see if we have sensible values

		if ( $s->{two_axes} ) 
		{
			my $i;
			for $i (1 .. 2)
			{
				die "Minimum for y" . $i . " too large\n"
					if ( $s->{y_min}[$i] > get_min_y(@{$d->[$i]}) );
				die "Maximum for y" . $i . " too small\n"
					if ( $s->{y_max}[$i] < get_max_y(@{$d->[$i]}) );
			}
		} 
#		else 
#		{
#			die "Minimum for y too large\n"
#				if ( $s->{y_min}[1] > $max_min[1] );
#			die "Maximum for y too small\n"
#				if ( $s->{y_max}[1] < $max_min[0] );
#		}
	}
 
	# return maximum value from an array
 
	sub get_max_y(@) # array
	{
		my $max = undef;

		my $i;
		foreach $i (@_) 
		{ 
			next unless defined $i;
			$max = (defined($max) && $max >= $i) ? $max : $i; 
		}

		return $max
	}

	sub get_min_y(@) # array
	{
		my $min = undef;

		my $i;
		foreach $i (@_) 
		{ 
			next unless defined $i;
			$min = ( defined($min) and $min <= $i) ? $min : $i;
		}

		return $min
	}
 
	# get maximum y value from the whole data set
 
	sub get_max_min_y_all($) # \@data
	{
		my $s = shift;
		my $d = shift;

		my $max = undef;
		my $min = undef;

		if ($s->{overwrite} == 2) 
		{
			my $i;
			for $i (0 .. $s->{numpoints}) 
			{
				my $sum = 0;

				my $j;
				for $j (1 .. $s->{numsets}) 
				{ 
					$sum += $d->[$j][$i]; 
				}

				$max = _max( $max, $sum );
				$min = _min( $min, $sum );
			}
		}
		else 
		{
			my $i;
			for $i ( 1 .. $s->{numsets} ) 
			{
				$max = _max( $max, get_max_y(@{$d->[$i]}) );
				$min = _min( $min, get_min_y(@{$d->[$i]}) );
			}
		}

		return ($max, $min)
	}

	
	# CONTRIB Scott Prahl
	#
	# Calculate best endpoints and number of intervals for an axis and
	# returns ($nice_min, $nice_max, $n), where $n is the number of
	# intervals and
	#
	#    $nice_min <= $min < $max <= $nice_max
	#
	# Usage:
	#		($nmin,$nmax,$nint) = _best_ends(247, 508);
	#		($nmin,$nmax) = _best_ends(247, 508, 5); 
	# 			use 5 intervals
	#		($nmin,$nmax,$nint) = _best_ends(247, 508, 4..7);	
	# 			best of 4,5,6,7 intervals

	sub _best_ends {
		my ($min, $max, @n) = @_;
		my ($best_min, $best_max, $best_num) = ($min, $max, 1);

		# fix endpoints, fix intervals, set defaults
		($min, $max) = ($max, $min) if ($min > $max);
		($min, $max) = ($min) ? ($min * 0.5, $min * 1.5) : (-1,1) 
			if ($max == $min);

		@n = (3..6) if (@n <= 0 || $n[0] =~ /auto/i);

		my $best_fit = 1e30;
		my $range = $max - $min;

		# create array of interval sizes
		my $s = 1;
		while ($s < $range) { $s *= 10 }
		while ($s > $range) { $s /= 10 }
		my @step = map {$_ * $s} (0.2, 0.5, 1, 2, 5);

		for (@n) 
		{								
			# Try all numbers of intervals
			my $n = $_;
			next if ($n < 1);

			for (@step) 
			{
				next if ($n != 1) && ($_ < $range/$n); # $step too small

				my $nice_min   = $_ * int($min/$_);
				$nice_min  -= $_ if ($nice_min > $min);
				my $nice_max   = ($n == 1) 
					? $_ * int($max/$_ + 1) 
					: $nice_min + $n * $_;
				my $nice_range = $nice_max - $nice_min;

				next if ($nice_max < $max);	# $nice_min too small
				next if ($best_fit <= $nice_range - $range); # not closer fit

				$best_min = $nice_min;
				$best_max = $nice_max;
				$best_fit = $nice_range - $range;
				$best_num = $n;
			}
		}
		return ($best_min, $best_max, $best_num)
	}

	# Convert value coordinates to pixel coordinates on the canvas.
 
	sub val_to_pixel($$$)	# ($x, $y, $i) in real coords ($Dataspace), 
	{						# return [x, y] in pixel coords
		my $s = shift;
		my ($x, $y, $i) = @_;

		my $y_min = 
			($s->{two_axes} && $i == 2) ? $s->{y_min}[2] : $s->{y_min}[1];

		my $y_max = 
			($s->{two_axes} && $i == 2) ? $s->{y_max}[2] : $s->{y_max}[1];

		my $y_step = abs(($s->{bottom} - $s->{top})/($y_max - $y_min));

		return ( 
			_round( ($s->{x_tick_number} ? $s->{x_offset} : $s->{left}) 
						+ $x * $s->{x_step} ),
			_round( $s->{bottom} - ($y - $y_min) * $y_step )
		)
	}

} # End of package GIFgraph::axestype
 
1;
