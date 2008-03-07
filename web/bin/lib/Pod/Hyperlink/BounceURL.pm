package Pod::Hyperlink::BounceURL;
use Pod::ParseUtils;
use URI::Escape;

use vars qw($VERSION @ISA);
$VERSION = ('$Revision: 1.7 $' =~ /([\d\.]+)/)[0];
@ISA = 'Pod::Hyperlink';

sub configure {
	my $self = shift;
	my %opts = @_;
	if ($opts{'URL'}) {
		$self->{'___url'} = $opts{'URL'};
	}
}

sub type {
	my $self = shift;

	# very special case - if we are called explicitly (rather than by our superclass) and with other conditions
	# 1) a page type with a page value
	# 2) an item type with a page value
	# We don't care about any other cases
	my ($callpack) = caller();
	if ($callpack ne $ISA[0]) {
		DUMP(__PACKAGE__."::type", [ $self, @_ ]);
	} else {
		DUMP(" indirect call of ".__PACKAGE__."::type", [ $self, @_ ]);
	}
	
	if (
		($callpack ne $ISA[0])
		&& (($self->{'-type'} eq 'page') || ($self->{'-type'} eq 'item'))
		&& $self->{'-page'}
	) {
		my $page_esc = uri_escape( $self->{'-page'} );
		my $node_esc = uri_escape( $self->{'-node'} );
		my $url = sprintf( $self->{'___url'}, $page_esc, $node_esc );
		return "bounceurl:$url";
	}
	# in all other cases, let the superclass handle the work
	return $self->SUPER::type(@_);
}

# debug hooks
sub TRACE {}
sub DUMP {}

1;

=head1 NAME

Pod::Hyperlink::BounceURL - Allow off-page links in POD to point to a URL

=head1 SYNOPSIS

	use Pod::Hyperlink::BounceURL;
	my $linkparser = new Pod::Hyperlink::BounceURL;
	$linkparser->configure( URL => '/cgi-perl/support/bounce.pl?page=%s' );
	my $pod2xhtml = new Pod::Xhtml( LinkParser => $linkparser );

=head1 DESCRIPTION

Some links in your pod may not be resolveable by Pod::Hyperlink, e.g. C<LE<lt>Some::ModuleE<gt>> -
this module allows you to detect such links and generate a hyperlink instead of some static text.
The target URL will probably be some kind of dynamic webpage or CGI application which can then serve up
the relevant page or send a redirect to the page, hence the "bounce" in this module's name.

This module overrides the type() method and, for relevant links, will return a string which is
"bounceurl:" followed by the URL, instead of returning "page" or "item".
Your pod-conversion module can then switch on this case and emit the correct kind of markup.
L<Pod::Xhtml> supports the use of this module.

=head1 METHODS

=over 4

=item configure( %OPTIONS )

Set persistent configuration for this object. See L</OPTIONS>.

=item type()

Behaves as L<Pod::Hyperlink>'s type() method except for the unresolveable links, where the string returned is
as described in L</DESCRIPTION>.

=back

=head1 OPTIONS

=over 4

=item URL

The URL to handle the link, which may be absolute or relative, of any protocol - it's just
treated as a string and is passed through sprintf(), with two string arguments that are both
already URL-escaped.

The first argument is the page name, and will always exist. The second argument is the "node" within the page, and may be
empty.

Insert '%s' where you wish the arguments to be interpolated. The string goes through sprintf() so
you should have '%%' where you want an actual percent sign. If you need the arguments in a different order, see
the perl-specific features of L<perlfunc/sprintf>.

=back

=head1 VERSION

$Revision: 1.7 $

=head1 AUTHOR

P Kent E<lt>cpan _at_ bbc _dot_ co _dot_ ukE<gt>

=head1 COPYRIGHT

(c) BBC 2007. This program is free software; you can redistribute it and/or modify it under the GNU GPL.

See the file COPYING in this distribution, or http://www.gnu.org/licenses/gpl.txt

=cut

