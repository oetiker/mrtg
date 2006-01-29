#==========================================================================
#              Copyright (c) 1995-1998 Martien Verbruggen
#--------------------------------------------------------------------------
#
#	Name:
#		GIFgraph.pm
#
#	Description:
#       Module to create graphs from a data set, outputting
#		GIF format graphics.
#
#		Package of a number of graph types:
#		GIFgraph::bars
#		GIFgraph::lines
#		GIFgraph::points
#		GIFgraph::linespoints
#		GIFgraph::area
#		GIFgraph::pie
#		GIFgraph::mixed
#
# $Id: GIFgraph.pm,v 1.1.1.1 2002/02/26 10:16:37 oetiker Exp $
#
#==========================================================================

require 5.004;

use strict;

use vars qw(@ISA);

# Use Lincoln Stein's GD and Thomas Boutell's libgd.a
use GD;

#
# GIFgraph
#
# Parent class containing data all graphs have in common.
#

package GIFgraph;

$GIFgraph::prog_name    = 'GIFgraph.pm';
$GIFgraph::prog_rcs_rev = '$Revision: 1.1.1.1 $';
$GIFgraph::prog_version = 
	($GIFgraph::prog_rcs_rev =~ /\s+(\d*\.\d*)/) ? $1 : "0.0";

$GIFgraph::VERSION = '1.10';

# Some tools and utils
use GIFgraph::colour qw(:colours);

my $OS;

# Let's guess what the OS is
# (from CGI.pm by Lincoln Stein)
# OVERRIDE THE OS HERE IF THE GUESS IS WRONG

# $OS = 'UNIX';
# $OS = 'MACINTOSH';
# $OS = 'WINDOWS';
# $OS = 'VMS';
# $OS = 'OS2';

# FIGURE OUT THE OS WE'RE RUNNING UNDER
# Some systems support the $^O variable.  If not
# available then require() the Config library
unless ($OS) {
    unless ($OS = $^O) {
        require Config;
        $OS = $Config::Config{'osname'};
    }
	if ($OS=~/Win/i) {
		$OS = 'WINDOWS';
	} elsif ($OS=~/vms/i) {
		$OS = 'VMS';
	} elsif ($OS=~/Mac/i) {
		$OS = 'MACINTOSH';
	} elsif ($OS=~/os2/i) {
		$OS = 'OS2';
	} else {
		$OS = 'UNIX';
	}
}

$GIFgraph::needs_binmode = $OS=~/^(WINDOWS|VMS|OS2)/;

my %GIFsize = ( 
	'x' => 400, 
	'y' => 300 
);

my %Defaults = (

	# Set the top, bottom, left and right margin for the GIF. These 
	# margins will be left empty.

	t_margin      => 0,
	b_margin      => 0,
	l_margin      => 0,
	r_margin      => 0,

	# Set the factor with which to resize the logo in the GIF (need to
	# automatically compute something nice for this, really), set the 
	# default logo file name, and set the logo position (UR, BR, UL, BL)

	logo_resize   => 1.0,
	logo          => undef,
	logo_position => 'LR',

	# Write a transparent GIF?

	transparent   => 1,

	# Write an interlaced GIF?

	interlaced    => 1,

	# Set the background colour, the default foreground colour (used 
	# for axes etc), the textcolour, the colour for labels, the colour 
	# for numbers on the axes, the colour for accents (extra lines, tick
	# marks, etc..)

	bgclr         => 'white',
	fgclr         => 'dblue',
	textclr       => 'dblue',
	labelclr      => 'dblue',
	axislabelclr  => 'dblue',
	accentclr     => 'gray',

	# number of pixels to use as text spacing

	text_space    => 8,
);

{
    #
    # PUBLIC methods, documented in pod.
    #
    sub new  # ( width, height ) optional;
	{
        my $type = shift;
        my $self = {};
        bless $self, $type;

        if (@_) 
		{
            # If there are any parameters, they should be the size
            $self->{gifx} = shift;

            # If there's an x size, there should also be a y size.
            die "Usage: GIFgraph::<type>::new( [x_size, y_size] )\n" unless @_;
            $self->{gify} = shift;
        } 
		else 
		{
            # There were obviously no parameters, so use defaults
            $self->{gifx} = $GIFsize{'x'};
            $self->{gify} = $GIFsize{'y'};
        }

        # Initialise all relevant parameters to defaults
        # These are defined in the subclasses. See there.
        $self->initialise( );

        return $self;
    }

    sub set
	{
        my $s = shift;
        my %args = @_;

        foreach (keys %args) 
		{ 
			$s->{$_} = $args{$_}; 
		}
    }

    # These should probably not be used, or be rewritten to 
    # accept some keywords. Problem is that GD is very limited 
    # on fonts, and this routine just accepts GD font names. 
    # But.. it's not nice to require the user to include GD.pm
    # just because she might want to change the font.

    sub set_title_font # (fontname)
	{
        my $self = shift;

        $self->{tf} = shift;
        $self->set( 
			tfw => $self->{tf}->width,
			tfh => $self->{tf}->height,
		);
    }

    sub set_text_clr # (colour name)
	{
        my $s = shift;
        my $c = shift;

        $s->set(
            textclr       => $c,
            labelclr      => $c,
            axislabelclr  => $c,
        );
    }

	sub plot # (\@data)
	{
		# ABSTRACT
		my $s = shift;
		$s->die_abstract( "sub plot missing," );
	}

    sub plot_to_gif # ("file.gif", \@data)
	{
        my $s = shift;
        my $file = shift;
        my $data = shift;

        open (GIFPLOT,">$file") || do 
		{ 
			warn "Cannot open $file for writing: $!";
			return 0; 
		};
		binmode GIFPLOT if ($GIFgraph::needs_binmode);
        print GIFPLOT $s->plot( $data );
        close(GIFPLOT);
    }

    # Routine to read GNU style data files
	# NOT USEABLE

    sub ReadFile 
	{
        my $file = shift; 
		my @cols = @_; 
		my (@out, $i, $j);

        @cols = 1 if ( $#cols < 1 );

        open (DATA, $file) || do { 
			warn "Cannot open file: $file"; 
			return []; 
		};

        $i=0; 
        while (defined(<DATA>)) 
		{ 
            s/^\s+|\s+$//;
            next if ( /^#/ || /^!/ || /^[ \t]*$/ );
            @_ = split(/[ \t]+/);
            $out[0][$i] = $_[0];
            $j=1;
            foreach (@cols) 
			{
                if ( $_ > $#_ ) { 
					warn "Data column $_ not present"; 
					return []; 
				}
                $out[$j][$i] = $_[$_]; $j++;
            }
            $i++;
        }
        close(DATA);

        return @out;

    } # ReadFile

    #
    # PRIVATE methods
    #

    # Set defaults that apply to all graph/chart types. 
    # This is called by the default initialise methods 
    # from the objects further down the tree.

    sub initialise()
	{
        my $self = shift;

		foreach (keys %Defaults) 
		{
			$self->set( $_ => $Defaults{$_} );
		}

        $self->set_title_font(GD::gdLargeFont);

		$self->open_graph();
    }


    # Check the integrity of the submitted data
    #
    # Checks are done to assure that every input array 
    # has the same number of data points, it sets the variables
    # that store the number of sets and the number of points
    # per set, and kills the process if there are no datapoints
    # in the sets, or if there are no data sets.

    sub check_data($) # \@data
	{
        my $self = shift;
        my $data = shift;

        $self->set(numsets => $#$data);
        $self->set(numpoints => $#{@$data[0]});

        ( $self->{numsets} < 1 || $self->{numpoints} < 0 ) && die "No Data";

		my $i;
        for $i ( 1..$self->{numsets} ) 
		{
			die "Data array $i: length misfit"
				unless ( $self->{numpoints} == $#{@$data[$i]} );
        }
    }

    # Open the graph output canvas by creating a new GD object.

    sub open_graph()
	{
        my $self = shift;
		if ( !exists $self->{graph} )
		{
			my $graph = new GD::Image($self->{gifx}, $self->{gify});
			$self->{graph} = $graph;
			return $graph;
		}
		else
		{
			return $self->{graph};
		}
    }

    # Initialise the graph output canvas, setting colours (and getting back
    # index numbers for them) setting the graph to transparent, and 
    # interlaced, putting a logo (if defined) on there.

    sub init_graph($) # GD::Image
	{
        my $self = shift;
        my $graph = shift;

        $self->{bgci} = $self->set_clr( $graph, _rgb($self->{bgclr}) );
        $self->{fgci} = $self->set_clr( $graph, _rgb($self->{fgclr}) );
        $self->{tci}  = $self->set_clr( $graph, _rgb($self->{textclr}) );
        $self->{lci}  = $self->set_clr( $graph, _rgb($self->{labelclr}) );
        $self->{alci} = $self->set_clr( $graph, _rgb($self->{axislabelclr}) );
        $self->{acci} = $self->set_clr( $graph, _rgb($self->{accentclr}) );
        $graph->transparent($self->{bgci}) if $self->{transparent};
        $graph->interlaced($self->{interlaced});
        $self->put_logo($graph);
    }

    # read in the logo, and paste it on the graph canvas

    sub put_logo($) # GD::Image
	{
        my $self = shift;
        my $graph = shift;

		return unless(defined($self->{logo}));

        my ($x, $y, $glogo);
        my $r = $self->{logo_resize};

        my $r_margin = (defined $self->{r_margin_abs}) ? 
            $self->{r_margin_abs} : $self->{r_margin};
        my $b_margin = (defined $self->{b_margin_abs}) ? 
            $self->{b_margin_abs} : $self->{b_margin};

        open(GIFLOGO, $self->{logo}) || return;
		binmode(GIFLOGO) if ($GIFgraph::needs_binmode);
        unless ( $glogo = newFromGif GD::Image(\*GIFLOGO) ) 
		{
            warn "Problems reading $self->{logo}"; 
			close(GIFLOGO); 
			return;
        }
        close(GIFLOGO);

        my ($w, $h) = $glogo->getBounds;
        LOGO: for ($self->{logo_position}) {
            /UL/i && do {
                $x = $self->{l_margin};
                $y = $self->{t_margin};
                last LOGO;
            };
            /UR/i && do {
                $x = $self->{gifx} - $r_margin - $w * $r;
                $y = $self->{t_margin};
                last LOGO;
            };
            /LL/i && do {
                $x = $self->{l_margin};
                $y = $self->{gify} - $b_margin - $h * $r;
                last LOGO;
            };
            # default "LR"
            $x = $self->{gifx} - $r_margin - $r * $w;
            $y = $self->{gify} - $b_margin - $r * $h;
            last LOGO;
        }
        $graph->copyResized($glogo, $x, $y, 0, 0, $r * $w, $r * $h, $w, $h);
        undef $glogo;
    }

    # Set a colour to work with on the canvas, by rgb value. 
    # Return the colour index in the palette

    sub set_clr($$$$) # GD::Image, r, g, b
	{
        my $s = shift; 
		my $g = shift; 
		my $i;

        # Check if this colour already exists on the canvas
        if ( ( $i = $g->colorExact( @_ ) ) < 0 ) 
		{
            # if not, allocate a new one, and return it's index
            return $g->colorAllocate( @_ );
        } 
        return $i;
    }
    
    # Set a colour, disregarding wether or not it already exists.

    sub set_clr_uniq($$$$) # GD::Image, r, g, b
	{
        my $s=shift; 
        my $g=shift; 

        $g->colorAllocate( @_ ); 
    }

    # Return an array of rgb values for a colour number

    sub pick_data_clr($) # number
	{
        my $s = shift;

		# Set up the data colour list if it doesn't exist yet.
		# It seemed easier & more robust to me to do it here rather than
		# relying on users doing it.	AF
		$s->set( 
			dclrs => [ qw(lred lgreen lblue lyellow lpurple lbrown cyan
				lorange marine dyellow red green yellow blue
				lgray dbrown purple orange pink gold)] 
		) unless ( exists $s->{dclrs} );

        return _rgb( $s->{dclrs}[ $_[0] % (1+$#{$s->{dclrs}}) -1 ] );
    }

    # DEBUGGING
	# data_dump obsolete now, use Data::Dumper

	sub die_abstract()
	{
		my $s = shift;
		my $msg = shift;
		# ABSTRACT
		die
			"Subclass (" .
			ref($s) . 
			") not implemented correctly: " .
			(defined($msg) ? $msg : "unknown error");
	}

    # Return the gif contents

    sub gifdata() 
	{
        my $s = shift;

        return $s->{graph}->gif;
    }

} # End of package GIFgraph

$GIFgraph::prog_name;

__END__

=head1 NAME

GIFgraph - Graph Plotting Module for Perl 5

=head1 SYNOPSIS

use GIFgraph::moduleName;

=head1 DESCRIPTION

B<GIFgraph> is a I<perl5> module to create and display GIF output 
for a graph.
The following classes for graphs with axes are defined:

=over 4

=item C<GIFgraph::lines>

Create a line chart.

=item C<GIFgraph::bars>

Create a bar chart.

=item C<GIFgraph::points>

Create an chart, displaying the data as points.

=item C<GIFgraph::linespoints>

Combination of lines and points.

=item C<GIFgraph::area>

Create a graph, representing the data as areas under a line.

=item C<GIFgraph::mixed>

Create a mixed type graph, any combination of the above. At the moment
this is fairly limited. Some of the options that can be used with some
of the individual graph types won't work very well. Multiple bar
graphs in a mixed graph won't display very nicely.

=back

Additional types:

=over 4

=item C<GIFgraph::pie>

Create a pie chart.

=back

=head1 EXAMPLES

See the samples directory in the distribution.

=head1 USAGE

Fill an array of arrays with the x values and the values of the data
sets.  Make sure that every array is the same size, otherwise
I<GIFgraph> will complain and refuse to compile the graph.

    @data = ( 
        ["1st","2nd","3rd","4th","5th","6th","7th", "8th", "9th"],
        [    1,    2,    5,    6,    3,  1.5,    1,     3,     4]
        [ sort { $a <=> $b } (1, 2, 5, 6, 3, 1.5, 1, 3, 4) ]
    );

If you don't have a value for a point in a certain dataset, you can
use B<undef>, and I<GIFgraph> will skip that point.

Create a new I<GIFgraph> object by calling the I<new> operator on the
graph type you want to create (I<chart> is I<bars, lines, points,
linespoints> or I<pie>).

    $my_graph = new GIFgraph::chart( );

Set the graph options. 

    $my_graph->set( 
        x_label           => 'X Label',
        y_label           => 'Y label',
        title             => 'Some simple graph',
        y_max_value       => 8,
        y_tick_number     => 8,
        y_label_skip      => 2 
    );

Output the graph

    $my_graph->plot_to_gif( "sample01.gif", \@data );

=head1 METHODS AND FUNCTIONS

=head2 Methods for all graphs

=over 4

=item new GIFgraph::chart([width,height])

Create a new object $graph with optional width and heigth. 
Default width = 400, default height = 300. I<chart> is either
I<bars, lines, points, linespoints, area> or I<pie>.

=item set_text_clr( I<colour name> )

Set the colour of the text. This will set the colour of the titles,
labels, and axis labels to I<colour name>. Also see the options
I<textclr>, I<labelclr> and I<axislabelclr>.

=item set_title_font( I<fontname> )

Set the font that will be used for the title of the chart.  Possible
choices are defined in L<GD>. 
B<NB.> If you want to use this function, you'll
need to use L<GD>. At some point I'll rewrite this, so you can give this a
number from 1 to 4, or a string like 'large' or 'small'. On the other
hand, I might not, if Thomas Boutell decides to support more fonts.

=item plot( I<\@data> )

Plot the chart, and return the GIF data.

=item plot_to_gif( F<filename>, I<\@data> )

Plot the chart, and write the GIF data to I<filename>.

=item set( key1 => value1, key2 => value2 .... )

Set chart options. See OPTIONS section.

=back

=head2 Methods for Pie charts

=over 4

=item set_label_font( I<fontname> )

=item set_value_font( I<fontname> )

Set the font that will be used for the label of the pie or the 
values on the pie.  Possible choices are defined in L<GD>. 
See also I<set_title_font>.

=back


=head2 Methods for charts with axes.

=over 4

=item set_x_label_font ( I<font name> )

=item set_y_label_font ( I<font name> )

=item set_x_axis_font ( I<font name> )

=item set_y_axis_font ( I<font name> )

Set the font for the x and y axis label, and for the x and y axis
value labels.
See also I<set_title_font>.

=back


=head1 OPTIONS

=head2 Options for all graphs

=over 4

=item gifx, gify

The width and height of the gif file in pixels
Default: 400 x 300.
B<NB> At the moment, these are read-only options. If you want to set
the size of a graph, you will have to do that with the I<new> method.

=item t_margin, b_margin, l_margin, r_margin

Top, bottom, left and right margin of the GIF. These margins will be
left blank.
Default: 0 for all.

=item logo

Name of a logo file. This should be a GIF file. 
Default: no logo.

=item logo_resize, logo_position

Factor to resize the logo by, and the position on the canvas of the
logo. Possible values for logo_position are 'LL', 'LR', 'UL', and
'UR'.  (lower and upper left and right). 
Default: 'LR'.

=item transparent

If set to a true value, the produced GIF will have the background
colour marked as transparent (see also option I<bgclr>).  Default: 1.

=item interlaced

If set to a true value, the produced GIF will be interlaced.
Default: 1.

=item bgclr, fgclr, textclr, labelclr, axislabelclr, accentclr

Background, foreground, text, label, axis label and accent colours.

=item dclrs (short for datacolours)

This controls the colours for the bars, lines, markers, or pie slices.
This should be a reference to an array of colour names as defined in
L<GIFgraph::colour> (C<S<perldoc GIFgraph::colour>> for the names available).

    $graph->set( dclrs => [ qw(green pink blue cyan) ] );

The first (fifth, ninth) data set will be green, the next pink, etc.
Default: [ qw(lred lgreen lblue lyellow lpurple cyan lorange) ] 

=back

=head2 Options for graphs with axes.

options for I<bars>, I<lines>, I<points>, I<linespoints> and 
I<area> charts.

=over 4

=item long_ticks, tick_length

If I<long_ticks> is a true value, ticks will be drawn the same length
as the axes.  Otherwise ticks will be drawn with length
I<tick_length>. if I<tick_length> is negative, the ticks will be drawn
outside the axes.  Default: long_ticks = 0, tick_length = 4.

=item x_ticks

If I<x_ticks> is a true value, ticks will be drawm for the x axis.
These ticks are subject to the values of I<long_ticks> and
I<tick_length>.  Default: 1.

=item y_tick_number

Number of ticks to print for the Y axis. Use this, together with
I<y_label_skip> to control the look of ticks on the y axis.
Default: 5.

=item y_number_format

This can be either a string, or a reference to a subroutine. If it is
a string, it will be taken to be the first argument to an sprintf,
with the value as the second argument:

    $label = sprintf( $s->{y_number_format, $value );

If it is a code reference, it will be executed with the value as the
argument:

    $label = &{$s->{y_number_format}}($value);

This can be useful, for example, if you want to reformat your values
in currency, with the - sign in the right spot. Something like:

    sub y_format
    {
        my $value = shift;
        my $ret;

        if ($value >= 0)
        {
            $ret = sprintf("\$%d", $value * $refit);
        }
        else
        {
            $ret = sprintf("-\$%d", abs($value) * $refit);
        }

        return $ret;
    }

    $my_graph->set( 'y_number_format' => \&y_format );

(Yes, I know this can be much shorter and more concise)

Default: undef.

=item x_label_skip, y_label_skip

Print every I<x_label_skip>th number under the tick on the x axis, and
every I<y_label_skip>th number next to the tick on the y axis.
Default: 1 for both.

=item x_all_ticks

Force a print of all the x ticks, even if x_label_skip is set to a value
Default: 0.

=item x_label_position

Controls the position of the X axis label (title). The value for this
should be between 0 and 1, where 0 means aligned to the left, 1 means
aligned to the right, and 1/2 means centered. 
Default: 3/4

=item y_label_position

Controls the position of both Y axis labels (titles). The value for
this should be between 0 and 1, where 0 means aligned to the bottom, 1
means aligned to the top, and 1/2 means centered. 
Default: 1/2

=item x_labels_vertical

If set to a true value, the X axis labels will be printed vertically.
This can be handy in case these labels get very long.
Default: 0.

=item x_plot_values, y_plot_values

If set to a true value, the values of the ticks on the x or y axes
will be plotted next to the tick. Also see I<x_label_skip,
y_label_skip>.  Default: 1 for both.

=item box_axis

Draw the axes as a box, if true.
Default: 1.

=item two_axes

Use two separate axes for the first and second data set. The first
data set will be set against the left axis, the second against the
right axis. If this is set to a true value, trying to use anything
else than 2 datasets will generate an error.  Default: 0.

=item zero_axis

If set to a true value, the axis for y values of 0 will always be
drawn. This might be useful in case your graph contains negative
values, but you want it to be clear where the zero value is. (see also
I<zero_axis_only> and I<box_axes>).
Default: 0.

=item zero_axis_only

If set to a true value, the zero axis will be drawn (see
I<zero_axis>), and no axis at the bottom of the graph will be drawn.
The labels for X values will be placed on the zero exis.
Default: 0.

=item y_max_value, y_min_value

Maximum and minimum value displayed on the y axis. If two_axes is a
true value, then y1_min_value, y1_max_value (for the left axis),
and y2_min_value, y2_max_value (for the right axis) take precedence
over these.

The range (y_min_value..y_max_value) has to include all the values of
the data points, or I<GIFgraph> will die with a message.

For bar and area graphs, the range (y_min_value..y_max_value) has to
include 0. If it doesn't, the values will be adapted before attempting
to draw the graph.

Default: Computed from data sets.

=item axis_space

This space will be left blank between the axes and the text.
Default: 4.

=item overwrite

If set to 0, bars of different data sets will be drawn next to each
other. If set to 1, they will be drawn in front of each other. If set
to 2 they will be drawn on top of each other.
Default: 0.

If you have negative values in your data sets, setting overwrite to 2
might produce odd results. Of course, the graph itself would be quite
meaningless, because overwrite = 2 is meant to show some cumulative
effect.

=back

=head2 Options for graphs with a numerical X axis

First of all: GIFgraph does B<not> support numerical x axis the way it
should. Data for X axes should be equally spaced. That understood:
There is some support to make the printing of graphs with numerical X
axis values a bit better, thanks to Scott Prahl. If the option
C<x_tick_number> is set to a defined value, GIFgraph will attempt to
treat the X data as numerical.

Extra options are:

=over 4

=item x_tick_number

If set to I<'auto'>, GIFgraph will attempt to format the X axis in a
nice way, based on the actual X values. If set to a number, that's the
number of ticks you will get. If set to undef, GIFgraph will treat X
data as labels.
Default: undef.

=item x_min_value, x_max_value

The minimum and maximum value to use for the X axis.
Default: computed.

=item x_number_format

See y_number_format

=item x_label_skip

See y_label_skip

=back


=head2 Options for graphs with bars

=over 4

=item bar_spacing

Number of pixels to leave open between bars. This works well in most
cases, but on some platforms, a value of 1 will be rounded off to 0.
Default: 0

=back

=head2 Options for graphs with lines

=over 4

=item line_types

Which line types to use for I<lines> and I<linespoints> graphs. This
should be a reference to an array of numbers:

    $graph->set( line_types => [3, 2, 4] );

Available line types are 1: solid, 2: dashed, 3: dotted, 4:
dot-dashed.

Default: [1] (always use solid)

=item line_type_scale

Controls the length of the dashes in the line types. default: 6.

=item line_width

The width of the line used in I<lines> and I<linespoints> graphs, in pixels.
Default: 1.

=back

=head2 Options for graphs with points

=over 4

=item markers

This controls the order of markers in I<points> and I<linespoints>
graphs.  This should be a reference to an array of numbers:

    $graph->set( markers => [3, 5, 6] );

Available markers are: 1: filled square, 2: open square, 3: horizontal
cross, 4: diagonal cross, 5: filled diamond, 6: open diamond, 7:
filled circle, 8: open circle.

Default: [1,2,3,4,5,6,7,8]

=item marker_size

The size of the markers used in I<points> and I<linespoints> graphs,
in pixels.  Default: 4.

=back

=head2 Options for mixed graphs

=over 4

=item types

A reference to an array with graph types, in the same order as the
data sets. Possible values are:

  $graph->set( types => [qw(lines bars points area linespoints)] );
  $graph->set( types => ['lines', undef, undef, 'bars'] );

values that are undefined or unknown will be set to C<default_type>.

Default: all set to C<default_type>

=item default_type

The type of graph to draw for data sets that either have no type set,
or that have an unknown type set.

Default: lines

=back

=head2 Graph legends (axestype graphs only)

At the moment legend support is minimal.

B<Methods>

=over 4

=item set_legend( I<@legend_keys> );

Sets the keys for the legend. The elements of @legend_keys correspond
to the data sets as provided to I<plot()> or I<plot_to_gif()>.

If a key is I<undef> or an empty string, the legend entry will be skipped.

=item set_legend_font( I<font name> );

Sets the font for the legend text (see also I<set_title_font>).
Default: GD::gdTinyFont.

=back

B<Options>

=over 4

=item legend_placement

Where to put the legend. This should be a two letter key of the form:
'B[LCR]|R[TCB]'. The first letter sigifies the placement (I<B>ottom or
I<R>ight), and the second letter signifies the alignment (I<L>eft,
I<R>ight, I<C>enter, I<T>op, or I<B>ottom).
Default: 'BC'

If the legend is placed at the bottom, some calculations will be made
to ensure that there is some 'intelligent' wrapping going on. if the
legend is placed at the right, all entries will be placed below each
other.

=item legend_spacing

The number of pixels to place around a legend item, and between a
legend 'marker' and the text.
Default: 4

=item legend_marker_width, legend_marker_height

The width and height of a legend 'marker' in pixels.
Defaults: 12, 8

=item lg_cols

If you, for some reason, need to force the legend at the bottom to
have a specific number of columns, you can use this.
Default: computed

=back


=head2 Options for pie graphs

=over 4

=item 3d

If set to a true value, the pie chart will be drawn with a 3d look.
Default: 1.

=item pie_height

The thickness of the pie when I<3d> is true.
Default: 0.1 x GIF y size.

=item start_angle

The angle at which the first data slice will be displayed, with 0 degrees
being "6 o'clock".
Default: 0.

=back

=head1 NOTES

All references to colours in the options for this module have been
shortened to clr. The main reason for this was that I didn't want to
support two spellings for the same word ('colour' and 'color')

Wherever a colour is required, a colour name should be used from the
package L<GIFgraph::colour>. C<S<perldoc GIFgraph::colour>> should give
you the documentation for that module, containing all valid colour
names. I will probably change this to read the systems rgb.txt file if 
it is available.

Wherever a font name is required, a font from L<GD> should be used.

=head1 AUTHOR

Martien Verbruggen

=head2 Contact info 

email: mgjv@comdyn.com.au

=head2 Copyright

Copyright (C) 1995-1998 Martien Verbruggen.
All rights reserved.  This package is free software; you can redistribute it 
and/or modify it under the same terms as Perl itself.

=cut

# WWW: L<http://www.tcp.chem.tue.nl/~tgtcmv/>
