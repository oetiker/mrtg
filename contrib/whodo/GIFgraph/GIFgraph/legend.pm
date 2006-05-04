#==========================================================================
#			   Copyright (c) 1995-1998 Martien Verbruggen
#--------------------------------------------------------------------------
#
#	Name:
#		GIFgraph::legend.pm
#
# $Id: legend.pm,v 1.0 1999/02/18
#
#==========================================================================

package GIFgraph::legend;

use strict qw(vars refs subs);
 
use GIFgraph;
use GIFgraph::utils qw(:all);

@GIFgraph::legend::ISA = qw( GIFgraph );

my %Defaults = (
 
	# Size of the legend markers

	legend_marker_height	=> 8,
	legend_marker_width		=> 12,
	legend_spacing			=> 4,
	legend_placement		=> 'BC',		# '[B][LCR]'

);

{
 
	# PUBLIC
	sub plot_legend($)	# GD::Image
	{
		my $s = shift;
		my $g = shift;

		$s->setup_legend();
		$s->draw_legend($g);
	}

	sub set_legend(@) # List of legend keys
	{
		my $self = shift;
		$self->set( legend => [@_]);
	}

	sub set_legend_font($) # (font name)
	{
		my $self = shift;
		$self->{lgf} = shift;
		$self->set( 
			lgfw => $self->{lgf}->width,
			lgfh => $self->{lgf}->height,
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
 
		$self->set_legend_font(GD::gdTinyFont);
	}
 
	#
	# Legend
	#

	sub setup_legend()
	{
		my $s = shift;

		return unless defined($s->{legend});

		my $maxlen = 0;
		my $num = 0;

		# Save some variables
		$s->{r_margin_abs} = $s->{r_margin};
		$s->{b_margin_abs} = $s->{b_margin};

		my $legend;
		foreach $legend (@{$s->{legend}})
		{
			if (defined($legend) and $legend ne "")
			{
				my $len = length($legend);
				$maxlen = ($maxlen > $len) ? $maxlen : $len;
				$num++;
			}
		}

		$s->{lg_num} = $num;

		# calculate the height and width of each element

		my $text_width = $maxlen * $s->{lgfw};
		my $legend_height = _max($s->{lgfh}, $s->{legend_marker_height});

		$s->{lg_el_width} = 
			$text_width + $s->{legend_marker_width} + 
			3 * $s->{legend_spacing};
		$s->{lg_el_height} = $legend_height + 2 * $s->{legend_spacing};

		my ($lg_pos, $lg_align) = split(//, $s->{legend_placement});

		if ($lg_pos eq 'R')
		{
			# Always work in one column
			$s->{lg_cols} = 1;
			$s->{lg_rows} = $num;

			# Just for completeness, might use this in later versions
			$s->{lg_x_size} = $s->{lg_cols} * $s->{lg_el_width};
			$s->{lg_y_size} = $s->{lg_rows} * $s->{lg_el_height};

			# Adjust the right margin for the rest of the graph
			$s->{r_margin} += $s->{lg_x_size};

			# Set the x starting point
			$s->{lg_xs} = $s->{gifx} - $s->{r_margin};

			# Set the y starting point, depending on alignment
			if ($lg_align eq 'T')
			{
				$s->{lg_ys} = $s->{t_margin};
			}
			elsif ($lg_align eq 'B')
			{
				$s->{lg_ys} = $s->{gify} - $s->{b_margin} - $s->{lg_y_size};
			}
			else # default 'C'
			{
				my $height = $s->{gify} - $s->{t_margin} - $s->{b_margin};

				$s->{lg_ys} = 
					int($s->{t_margin} + $height/2 - $s->{lg_y_size}/2) ;
			}
		}
		else # 'B' is the default
		{
			# What width can we use
			my $width = $s->{gifx} - $s->{l_margin} - $s->{r_margin};

			(!defined($s->{lg_cols})) and 
				$s->{lg_cols} = int($width/$s->{lg_el_width});
			
			$s->{lg_cols} = _min($s->{lg_cols}, $num);

			$s->{lg_rows} = 
				int($num/$s->{lg_cols}) + (($num % $s->{lg_cols}) ? 1 : 0);

			$s->{lg_x_size} = $s->{lg_cols} * $s->{lg_el_width};
			$s->{lg_y_size} = $s->{lg_rows} * $s->{lg_el_height};

			# Adjust the bottom margin for the rest of the graph
			$s->{b_margin} += $s->{lg_y_size};

			# Set the y starting point
			$s->{lg_ys} = $s->{gify} - $s->{b_margin};

			# Set the x starting point, depending on alignment
			if ($lg_align eq 'R')
			{
				$s->{lg_xs} = $s->{gifx} - $s->{r_margin} - $s->{lg_x_size};
			}
			elsif ($lg_align eq 'L')
			{
				$s->{lg_xs} = $s->{l_margin};
			}
			else # default 'C'
			{
				$s->{lg_xs} =  
					int($s->{l_margin} + $width/2 - $s->{lg_x_size}/2);
			}

		}
	}

	sub draw_legend($) # (GD::Image)
	{
		my $s = shift;
		my $g = shift;

		return unless defined($s->{legend});

		my $xl = $s->{lg_xs} + $s->{legend_spacing};
		my $y = $s->{lg_ys} + $s->{legend_spacing} - 1;
		
		my $i = 0;
		my $row = 1;
		my $x = $xl;	# start position of current element

		my $legend;
		foreach $legend (@{$s->{legend}})
		{
			$i++;

			my $xe = $x;	# position within an element

			next unless (defined($legend) && $legend ne "");

			$s->draw_legend_marker($g, $i, $xe, $y);

			$xe += $s->{legend_marker_width} + $s->{legend_spacing};
			my $ys = int($y + $s->{lg_el_height}/2 - $s->{lgfh}/2);

			$g->string($s->{lgf}, $xe, $ys, $legend, $s->{tci});

			$x += $s->{lg_el_width};

			if (++$row > $s->{lg_cols})
			{
				$row = 1;
				$y += $s->{lg_el_height};
				$x = $xl;
			}
		}
	}

	# This will be virtual; every sub class should define their own
	# if this one doesn't suffice
	sub draw_legend_marker($$$$) # (GD::Image, data_set_number, x, y)
	{
		my $s = shift;
		my $g = shift;
		my $n = shift;
		my $x = shift;
		my $y = shift;

		my $ci = $s->set_clr( $g, $s->pick_data_clr($n) );

		$y += int($s->{lg_el_height}/2 - $s->{legend_marker_height}/2);

		$g->filledRectangle(
			$x, $y,
			$x + $s->{legend_marker_width}, $y + $s->{legend_marker_height},
			$ci
		);

		$g->rectangle(
			$x, $y, 
			$x + $s->{legend_marker_width}, $y + $s->{legend_marker_height},
			$s->{acci}
		);

	}

} # End of package GIFgraph::legend
 
1;
