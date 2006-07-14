#==========================================================================
#              Copyright (c) 1995-1998 Martien Verbruggen
#--------------------------------------------------------------------------
#
#	Name:
#		GIFgraph::colour.pm
#
#	Description:
#		Package of colour manipulation routines, to be used 
#		with GIFgraph.
#
# $Id: colour.pm,v 1.1.1.1 2002/02/26 10:16:37 oetiker Exp $
#
#==========================================================================

 
package GIFgraph::colour;

use vars qw( @EXPORT_OK %EXPORT_TAGS );
use strict qw( vars refs subs );
require Exporter;

@GIFgraph::colour::ISA = qw( Exporter );

$GIFgraph::colour::prog_name    = 'GIFgraph::colour.pm';
$GIFgraph::colour::prog_rcs_rev = '$Revision: 1.1.1.1 $';
$GIFgraph::colour::prog_version = 
	($GIFgraph::colour::prog_rcs_rev =~ /\s+(\d*\.\d*)/) ? $1 : "0.0";

@EXPORT_OK = qw( 
	_rgb _luminance _hue 
	colour_list sorted_colour_list
	read_rgb
);
%EXPORT_TAGS = ( 
		colours => [qw( _rgb _luminance _hue )],
		lists => [qw( colour_list sorted_colour_list )],
		files => [qw( read_rgb )],
	);

{
    my %RGB = (
        white	=> [0xFF,0xFF,0xFF], 
        lgray	=> [0xBF,0xBF,0xBF], 
		gray	=> [0x7F,0x7F,0x7F],
		dgray	=> [0x3F,0x3F,0x3F],
		black	=> [0x00,0x00,0x00],
        lblue	=> [0x00,0x00,0xFF], 
		blue	=> [0x00,0x00,0xBF],
        dblue	=> [0x00,0x00,0x7F], 
		gold	=> [0xFF,0xD7,0x00],
        lyellow	=> [0xFF,0xFF,0x00], 
        yellow	=> [0xBF,0xBF,0x00], 
		dyellow	=> [0x7F,0x7F,0x00],
        lgreen	=> [0x00,0xFF,0x00], 
        green	=> [0x00,0xBF,0x00], 
		dgreen	=> [0x00,0x7F,0x00],
        lred	=> [0xFF,0x00,0x00], 
		red		=> [0xBF,0x00,0x00],
		dred	=> [0x7F,0x00,0x00],
        lpurple	=> [0xFF,0x00,0xFF], 
        purple	=> [0xBF,0x00,0xBF],
		dpurple	=> [0x7F,0x00,0x7F],
        lorange	=> [0xFF,0xB7,0x00], 
		orange	=> [0xFF,0x7F,0x00],
        pink	=> [0xFF,0xB7,0xC1], 
		dpink	=> [0xFF,0x69,0xB4],
        marine	=> [0x7F,0x7F,0xFF], 
		cyan	=> [0x00,0xFF,0xFF],
        lbrown	=> [0xD2,0xB4,0x8C], 
		dbrown	=> [0xA5,0x2A,0x2A],
    );

    sub colour_list 
	{
        my $n = ( $_[0] ) ? $_[0] : keys %RGB;
		return (keys %RGB)[0 .. $n-1]; 
    }

    sub sorted_colour_list 
	{
        my $n = $_[0] ? $_[0] : keys %RGB;
        return (sort by_luminance keys %RGB)[0 .. $n-1];
#        return (sort by_hue keys %rgb)[0..$n-1];

        sub by_luminance 
        { 
            _luminance(@{$RGB{$b}}) <=> _luminance(@{$RGB{$a}}); 
        }
        sub by_hue 
        { 
            _hue(@{$RGB{$b}}) <=> _hue(@{$RGB{$a}}); 
        }

    }

	# return the luminance of the colour (RGB)
    sub _luminance 
	{ 
		(0.212671 * $_[0] + 0.715160 * $_[1] + 0.072169 * $_[2])/0xFF; 
	}

	# return the hue of the colour (RGB)
    sub _hue 
	{ 
		($_[0] + $_[1] + $_[2])/(3 * 0xFF); 
	}

my %WarnedColours = ();

	# return the RGB values of the colour name
    sub _rgb 
	{ 
		my $clr = shift;
		my $rgb_ref;
		$rgb_ref = $RGB{$clr} or do {
			$rgb_ref = $RGB{'black'};
			unless ($WarnedColours{$clr})
			{
				$WarnedColours{$clr} = 1;
				warn "Colour $clr is not defined, reverting to black"; 
			}
		};
		@{$rgb_ref};
	}

    sub version 
	{
        return $GIFgraph::colour::prog_version;
    }

	sub dump_colours
	{
		my $max = $_[0] ? $_[0] : keys %RGB;
		my $n = 0;

		my $clr;
		foreach $clr (sorted_colour_list($max))
		{
			last if $n > $max;
			print "colour: $clr, " . 
				"${$RGB{$clr}}[0], ${$RGB{$clr}}[1], ${$RGB{$clr}}[2]\n"
		}
	}

	#
	# Read a rgb.txt file (X11)
	#
	# Expected format of the file:
	#
	# R G B colour name
	#
	# Fields can be separated by any number of whitespace
	# Lines starting with an exclamation mark (!) are comment and 
	# will be ignored.
	#
	# returns number of colours read

	sub read_rgb($) # (filename)
	{
		my $fn = shift;
		my $n = 0;
		my $line;

		open(RGB, $fn) or return 0;

		while (defined($line = <RGB>))
		{
			next if ($line =~ /\s*!/);
			chomp($line);

			# remove leading white space
			$line =~ s/^\s+//;

			# get the colours
			my ($r, $g, $b, $name) = split(/\s+/, $line, 4);
			
			# Ignore bad lines
			next unless (defined $name);

			$RGB{$name} = [$r, $g, $b];
			$n++;
		}

		close(RGB);

		return $n;
	}
 
    $GIFgraph::colour::prog_name;

} # End of package Colour

__END__

=head1 NAME

Colour - Colour manipulation routines for use with GIFgraph

=head1 SYNOPSIS

use GIFgraph::colour qw( :colours :lists :files );

=head1 DESCRIPTION

The B<Colour> Package provides a few routines to convert some colour
names to RGB values. Also included are some functions to calculate
the hue and luminance of the colours, mainly to be able to sort them.

The :colours tags can be used to import the I<_rgb>, I<_hue>, and
I<_luminance> functions, the :lists tag for I<colour_list> and
I<sorted_colour_list>, and the :files tag exports the I<read_rgb>
function.

=head1 FUNCTIONS

=over 4

=item Colour::colour_list( I<number of colours> )

Returns a list of I<number of colours> colour names known to the package.

=item Colour::sorted_colour_list( I<number of colours> )

Returns a list of I<number of colours> colour names known to the package, 
sorted by luminance or hue.
B<NB.> Right now it always sorts by luminance. Will add an option in a later
stage to decide sorting method at run time.

=item Colour::_rgb( I<colour name> )

Returns a list of the RGB values of I<colour name>.

=item Colour::_hue( I<R,G,B> )

Returns the hue of the colour with the specified RGB values.

=item Colour::_luminance( I<R,G,B> )

Returns the luminance of the colour with the specified RGB values.

=item Colour::read_rgb( F<file name> )

Reads in colours from a rgb file as used by the X11 system.

Doing something like:

    use GIFgraph::bars;
    use GIFgraph::colour;

    GIFgraph::colour::read_rgb("rgb.txt") or die "cannot read colours";

Will allow you to use any colours defined in rgb.txt in your graph.

=back 

=head1 PREDEFINED COLOUR NAMES

white,
lgray,
gray,
dgray,
black,
lblue,
blue,
dblue,
gold,
lyellow,
yellow,
dyellow,
lgreen,
green,
dgreen,
lred,
red,
dred,
lpurple,
purple,
dpurple,
lorange,
orange,
pink,
dpink,
marine,
cyan,
lbrown,
dbrown.

=cut

