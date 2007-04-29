package GIFgraph::EvenlySpaced;

use strict;

use MRP::BaseClass;

use vars qw(@ISA %fields $AUTOLOAD $VERSION);

$VERSION = 1.0;

sub AUTOLOAD {
  my $thing = shift;
  my ($package, $function) = $AUTOLOAD =~ m/^(.*)::([^:]+)$/;
  return if $function eq 'DESTROY';

  if(ref($thing)) {
    return $thing->_DelegateGraph->$function(@_);
  }
#  my $super = join '::', 'SUPER', $function;
#  return $thing->$super(@_);
  die "Could not find $AUTOLOAD via $thing ";
}

sub new {
  my $class = shift;
  my $graph = shift;
  my $self = new MRP::BaseClass;
  $self->rebless($class);
  $self->_DelegateGraph($graph);
  return $self;
}

sub plot {
  my ($self, $data) = @_;
  my $fudge = $self->fudge;
  my @processed;

  my @x = @{$data->[0]};
  my @distances;
  my ($min, $max) = ($x[0], $x[$#x]);
  my $len = $max-$min;
  foreach my $i (1 .. $#x) {
    $distances[$i-1] = $x[$i] - $x[$i-1];
  }
  my @sdist = sort { $a<=>$b } @distances;

  my $sd = shift @sdist;
  while(@sdist) {
    my $nd = shift @sdist;
    my $diff = $nd/$sd;
    $diff = $diff - int($diff);
    $diff = 1-$diff if $diff > 0.5;
    next if $diff < $fudge;
    my $rat = $nd/$sd;
    my $continue = 1;
    for(my $ax = 2; $continue; $ax++) {
      my $yx = $ax*$rat;
      if($yx !~ /\./) {
	$sd = $nd/$yx;
	$continue = 0;
      }
    }
  }

  my $lowest = shift @x;
  my $column = 0;
  for(my $newX = $min; ($newX-$sd) < $max; $newX+=$sd) {
    if($newX >= $lowest) {
      foreach my $series (0 .. $#$data) {
	push @{$processed[$series]}, $data->[$series][$column];
      }
      $column++;
      $lowest = shift @x;
    } else {
      foreach my $series (0 .. $#$data) {
	push @{$processed[$series]}, undef;
      }
    }
  }

  local $^W = undef;
  return $self->_DelegateGraph->plot(\@processed);
}

sub isa {
  my ($thing, $type) = @_;
  return $thing->_DelegateGraph->isa($type) || $thing->SUPER::isa($type);
}

BEGIN {
  @ISA = qw(MRP::BaseClass);
  %fields = (
	     fudge => 0.1,
	     _DelegateGraph => undef,
	    );
  GIFgraph::EvenlySpaced->check4Clashes;
}

$VERSION;

__END__

=head1 NAME

GIFgraph::EvenlySpaced - spaces the data points evenly

=head1 DESCRIPTION

This module wraps a GIFgraph object so that the data points become
numericaly spaced (aproximately).

=head1 SYNOPSIS

Wrapps a GIFgraph object (probably a GIFgraph::lines) so that the x
values are spaced numericaly. Use exactly as your GIFgraph object. Due
to a problem I had with AUTOLOAD, it must be the outer wrapper class.

=head1 Use

  $graph = new GIFgraph::lines(400,300);
  $es = new GIFgraph::EvenlySpaced($graph);

or

  $graph = new GIFgraph::lines(400,300);
  $withmap = new GIFgraph::WithMap($graph);
  $es = new GIFgraph::EvenlySpaced($withmap);

or even

  $es = new GIFgraph::EvenlySpaced(new GIFgraph::WithMap(new GIFgraph::lines(400,300)));

etc. etc. etc.

=head1 Functions

=over

=item new

Returns a new GIFgraph::EvenlySpaced object

  $es = new GIFgraph::EvenlySpaced($parentGraph);

where $parentGraph is any object that behaves like a GIFgraph::lines
type object such as a GIFgraph::WithMap.

=item plot

This function is overridden to space the data numericaly along the
x-axis.

=back

=head1 Fields

=over

=item fudge

This is a fudge factor used in checking whether one number roughly
devides into another. It defaults to 0.1 but if it is obviously doing
silly things then change it. Good luck - I don't realy know how it
works.

=back

=head1 Guts

This module uses MRP::BaseClass to implement member access functions.

To make the 'parent' object behave as if it the super class I have
done some magic with AUTOLOAD. This has produced the restriction that
you can not wrap an EvenlySpaced object inside another - such as
WithMap - that also uses magic.

@ISA does not include the parent type as it is not known. The isa()
method is overridden to account for this.

=head1 AUTHOR

Matthew Pocock mrp@sanger.ac.uk
