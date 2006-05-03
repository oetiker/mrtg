package GIFgraph::WithMap;

use strict;
use vars qw (@ISA %fields $AUTOLOAD $VERSION);
use Carp;
use CGI;

use MRP::BaseClass;

$VERSION = 1.0;

# use AUTOLOAD to pass everything that we can't do to _GIFgraph.
# don't know if this is kosha. AHHHH.
sub AUTOLOAD {
  my $thing = shift;
  my ($package, $function) = $AUTOLOAD =~ m/^(.*)::([^:]+)$/;

  if(ref($thing)) {
    my $delegate = $thing->_GIFgraph;
    $function = join '::', $delegate, $function;
    return $thing->$function(@_);
  }
  die "Could not find method $AUTOLOAD via $thing";
}

sub isa {
  my ($thing, $type) = @_;
  return $thing->_GIFgraph->isa($type) || $thing->SUPER::isa($type);
}

sub new {
  my $class = shift;
  my $GIFgraph = shift;
  my $baseClass = new MRP::BaseClass;

  my $self = $class->rebless($GIFgraph, $baseClass);

  $self->_GIFgraph(ref $GIFgraph);

  return $self;
}

sub draw_data {
  my ($self, $gd, $data) = @_;
  my $fuzz = $self->fuzz;
  my $map = "";
  my $mapname = $self->mapname || confess "You must set the name for this map before calling plot";
  my $seriesnames = $self->seriesnames;
  my $links = $self->links;

  my $delegateFunc = join '::', $self->_GIFgraph, 'draw_data';
  $self->$delegateFunc($gd, $data);
  
  $map = '<MAP NAME="' . $mapname . '">'."\n";
  foreach my $series (1 .. $self->{numsets}) {
    my (@up, @down);
    foreach my $point (0 .. $self->{numpoints}) {
      next unless defined($$data[$series][$point]);
      my ($x, $y) = $self->val_to_pixel($point+1, $$data[$series][$point], $series);
      push @up, $x, $y+$fuzz;
      unshift @down, $x, $y-$fuzz;
    }
    my $seriesname = $seriesnames->[$series-1] || 'series '.$series;
    my $link = $links->[$series-1] || "#$seriesname";
    $map .= join("\n\t",
		 '<AREA',
		 'alt="' . $seriesname . '"',
		 'href="' . $link . '"',
		 'onMouseOver="self.status=' . "'$seriesname'" . '; return true"',
		 'onMouseOut="self.status=' . "''" . '; return true"',
		 'shape=polygon',
		 'coords="' .  join(', ', @up, @down) . '"',
		 );
    $map .= ">\n";
  }
  $map .= "</MAP>\n";

  $self->map($map);
}

BEGIN {
  @ISA = qw (MRP::BaseClass);
  %fields = (
	     'fuzz' => 1,
	     'map' => undef,
	     'mapname' => undef,
	     'seriesnames' => [],
	     'links' => [],
	     '_GIFgraph' => undef,
	    );
  GIFgraph::WithMap->check4Clashes;
}

$VERSION;

__END__

=head1 NAME

GIFgraph::WithMap - generates HTML map text while plotting graph

=head1 DESCRIPTION

Generates the html map block for a graph so that data series become
'clickable',

=head1 SYNOPSIS

This module extends GIFgraph objects such as GIFgraph::lines. You can
do everything that you would with a GIFgraph object. In addition, when
the data is plotted, it generates some MAP html text.

The series will be labeled 'series 1', 'series 2' etc. unless the
$obj->seriesnames has been set. For each series, it will create a
polygon area, with the following structure (assuming series is named
'Green', and that the links member array is empty:

 <AREA
        alt="Green"
        href="#Green"
        onMouseOver="self.status='Green'; return true"
        onMouseOut="self.status=''; return true"
        shape=polygon
        coords="87, 41, 165, 250, 165, 246, 87, 37">

So - clicking on the series will take you to #Green. If you don't
specify #Green in the document, clicking on it will do very little. If
you have (e.g. in the key) then it should take you there.

=head1 new

Use something like

 $map = new GIFgraph::WithMap(new GIFgraph::lines(400,300));

=head1 fields

=over

=item map

Once plot has been called, map contains the map text.

 print $graphWithMap->map;

=item fuzz

This is the up/down fuzz used to construct the ploygon. It defaults to
1 - so the polygon will be three pixles wide (the pixle drawn and one
above and below it).

=item mapname

Set this before calling plot. This is the name of the map, as given by
usemap="#mapname" in <img>. It is a fatal error to try to plot without
a name.

=item seriesnames

Array of names for the series. If a name is absent for a series (or
all series) then it will be named Series #. This must be set before
the graph is plotted.

 $graphWithMap->seriesnames('name1', 'name2');

=links

Array of links for the series. If a link is absent for a series (or
all series) then it will be named #SeriesName (where SeriesName is
generated as described in L<seriwsnames>).

=back

=head1 Guts

This module uses MRP::BaseClass to implement member access functions.

In the constructor, a new object is created that is a meld of an
MRP::BaseClass derived object, and the GIFgraph object passed in. The
type of that object is stoored in _GIFgraph. In AUTOLOAD, first I
check to see if the GIFgraph object's package named in _GIFgraph
implements the function. If it does, then I return the value of that
function - i.e. it behaves as if the object inherits from that
package. If that fails, then I return the value of SUPER::AUTLOLOAD,
which will presumably handle it or die gracefully. Hey presto -
dynamic parenting.

@ISA does not include anything to implement a GIFgraph object as a
parent. However, I have overridden 'isa' to account for this.
