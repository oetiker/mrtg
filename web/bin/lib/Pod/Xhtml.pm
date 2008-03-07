# $Id: Xhtml.pm,v 1.59 2007/08/02 12:24:15 andreww Exp $
package Pod::Xhtml;

use strict;
use Pod::Parser;
use Pod::ParseUtils;
use Carp;
use vars qw/@ISA %COMMANDS %SEQ $VERSION $FirstAnchorId $ContentSuffix/;
use constant P2X_REGION => qr/(?:pod2)?xhtml/;

$FirstAnchorId = "TOP";
$ContentSuffix = "-CONTENT";

@ISA = qw(Pod::Parser);
($VERSION) = ('$Revision: 1.59 $' =~ m/([\d\.]+)/);

# recognized commands
%COMMANDS = map { $_ => 1 } qw(pod head1 head2 head3 head4 item over back for begin end);

# recognized special sequences
%SEQ = (
	B => \&seqB,
	C => \&seqC,
	E => \&seqE,
	F => \&seqF,
	I => \&seqI,
	L => \&seqL,
	S => \&seqS,
	X => \&seqX,
	Z => \&seqZ,
);


########## New PUBLIC methods for this class
sub asString { my $self = shift; return $self->{buffer}; }
sub asStringRef { my $self = shift; return \$self->{buffer}; }
sub addHeadText { my $self = shift; $self->{HeadText} .= shift; }
sub addBodyOpenText { my $self = shift; $self->{BodyOpenText} .= shift; }
sub addBodyCloseText { my $self = shift; $self->{BodyCloseText} .= shift; }

########## Override methods in Pod::Parser
########## PUBLIC INTERFACE
sub parse_from_file {
	my $self = shift;
	$self->resetMe;
	$self->SUPER::parse_from_file(@_);
}

sub parse_from_filehandle {
	my $self = shift;
	$self->resetMe;
	$self->SUPER::parse_from_filehandle(@_);
}

########## INTERNALS
sub initialize {
	my $self = shift;

	$self->{TopLinks} = qq(<p><a href="#<<<G?$FirstAnchorId>>>" class="toplink">Top</a></p>) unless defined $self->{TopLinks};
	$self->{MakeIndex} = 1 unless defined $self->{MakeIndex};
	$self->{MakeMeta} = 1 unless defined $self->{MakeMeta};
	$self->{FragmentOnly} = 0 unless defined $self->{FragmentOnly};
	$self->{HeadText} = $self->{BodyOpenText} = $self->{BodyCloseText} = '';
	$self->{LinkParser} ||= new Pod::Hyperlink;
	$self->{TopHeading} ||= 1;
	$self->{TopHeading} = int $self->{TopHeading}; # heading level must be an integer
	croak "TopHeading must be greater than zero" if $self->{TopHeading} < 1; # (prevent negative heading levels)
	$self->SUPER::initialize();
}

sub command {
	my ($parser, $command, $paragraph, $line_num, $pod_para) = @_;
	my $ptree = $parser->parse_text( $paragraph, $line_num );
	$pod_para->parse_tree( $ptree );
	$parser->parse_tree->append( $pod_para );
}

sub verbatim {
	my ($parser, $paragraph, $line_num, $pod_para) = @_;
	$parser->parse_tree->append( $pod_para );
}

sub textblock {
	my ($parser, $paragraph, $line_num, $pod_para) = @_;
	my $ptree = $parser->parse_text( $paragraph, $line_num );
	$pod_para->parse_tree( $ptree );
	$parser->parse_tree->append( $pod_para );
}

sub end_pod {
	my $self = shift;
	my $ptree = $self->parse_tree;

	# clean up tree ready for parse
	foreach my $para (@$ptree) {
		if ($para->{'-prefix'} eq '=') {
			$para->{'TYPE'} = 'COMMAND';
		} elsif (! @{$para->{'-ptree'}}) {
			$para->{'-ptree'}->[0] = $para->{'-text'};
			$para->{'TYPE'} = 'VERBATIM';
		} else {
			$para->{'TYPE'} = 'TEXT';
		}
		foreach (@{$para->{'-ptree'}}) {
			unless (ref $_) { s/\n\s+$//; }
		}
	}

	# now loop over each para and expand any html escapes or sequences
	$self->_paraExpand( $_ ) foreach (@$ptree);

	$self->{buffer} =~ s/(\n?)<\/pre>\s*<pre>/$1/sg; # concatenate 'pre' blocks
	1 while $self->{buffer} =~ s/<pre>(\s+)<\/pre>/$1/sg;
	$self->{buffer} = $self->_makeIndex . $self->{buffer} if $self->{MakeIndex};
	$self->{buffer} =~ s/<<<G\?($FirstAnchorId)>>>/$1/ge;
	$self->{buffer} = join "\n", qq[<div class="pod">], $self->{buffer},
		( @{ $self->{sections} } > 1 && "</div>" ), "</div>";

	# Expand internal L<> links to the correct sections
	$self->{buffer} =~ s/#<<<(.*?)>>>/'#' . $self->_findSection($1)/eg;
	die "gotcha" if $self->{buffer} =~ /#<<</;

	my $headblock = sprintf "%s\n%s\n%s\n\t<title>%s</title>\n",
		qq(<?xml version="1.0" encoding="UTF-8"?>),
		qq(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">),
		qq(<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">\n<head>),
		_htmlEscape( $self->{doctitle} );
	$headblock .= $self->_makeMeta if $self->{MakeMeta};

	unless ($self->{FragmentOnly}) {
		$self->{buffer} = $headblock . $self->{HeadText} . "</head>\n<body>\n" . $self->{BodyOpenText} . $self->{buffer};
		$self->{buffer} .= $self->{BodyCloseText} . "</body>\n</html>\n";
	}

	# in stringmode we only accumulate the XHTML else we print it to the
	# filehandle
	unless ($self->{StringMode}) {
		my $out_fh = $self->output_handle;
		print $out_fh $self->{buffer};
	}
}

########## Everything else is PRIVATE
sub resetMe {
	my $self = shift;
	$self->{'-ptree'} = new Pod::ParseTree;
	$self->{'sections'} = [];
	$self->{'listKind'} = [];
	$self->{'listHasItems'} = [];
	$self->{'dataSections'} = [];
	$self->{'section_names'} = {};
	$self->{'section_ids'} = {};
	$self->{'tagStack'} = [];

	foreach (qw(inList titleflag )) { $self->{$_} = 0; }
	foreach (qw(buffer doctitle)) { $self->{$_} = ''; }
	
	# add the "$FirstAnchor" section into the sections
	$self->_addSection ( '', $FirstAnchorId );
}

sub parse_tree { return $_[0]->{'-ptree'}; }

sub _paraExpand {
	my $self = shift;
	my $para = shift;

	# skip data region unless its ident matches P2X_REGION (eg xhtml)
	my $in_dsection = !!(@{$self->{dataSections}});
	my $p2x_region = $in_dsection && $self->{dataSections}->[-1] =~ P2X_REGION;
	my $skip_region = $in_dsection && !$p2x_region;

	# collapse interior sequences and strings
	# escape html unless it's a html data region
	foreach ( @{$para->{'-ptree'}} ) {
		$_ = (ref $_) ? $self->_handleSequence($_, $p2x_region) :
			$p2x_region ? $_ : _htmlEscape($_);
	}
	# the parse tree has now been collapsed into a list of strings
	my $string = join('', @{$para->{'-ptree'}});

	if ($para->{TYPE} eq 'TEXT') {
		return if $skip_region;
		$self->_addTextblock($string, $p2x_region);
	} elsif ($para->{TYPE} eq 'VERBATIM') {
		return if $skip_region;
		my $paragraph = "<pre>$string\n\n</pre>";
		$self->_addTextblock( $paragraph, 1 );  # no wrap
		if ($self->{titleflag} != 0) {
			$self->_setTitle( $paragraph );
			warn "NAME followed by verbatim paragraph";
		}
	} elsif ($para->{TYPE} eq 'COMMAND') {
		$self->_addCommand($para->{'-name'}, $string, $para->{'-text'}, $para->{'-line'} )
	} else {
		warn "Unrecognized paragraph type $para->{TYPE} found at $self->{_INFILE} line $para->{'-line'}\n";
	}
}

sub _addCommand {
	my $self = shift;
	my ($command, $paragraph, $raw_para, $line) = @_;
	my $anchor;

	unless (exists $COMMANDS{$command}) {
		warn "Unrecognized command '$command' skipped at $self->{_INFILE} line $line\n";
		return;
	}

	for ($command) {
		my $data_para = @{$self->{dataSections}}; # inside a data paragraph?
		/^head1/ && !$data_para && do {
			my $top_heading = 'h'. $self->{TopHeading};
			$top_heading = 'h1' if !$self->{FragmentOnly}; # ignore TopHeading when not in fragment mode

			# if ANY sections are open then close the previously opened div
			$self->{buffer} .= "\n</div>\n" unless ( @{ $self->{sections} } == 1 );
			
			$anchor = $self->_addSection( 'head1', $paragraph );
			my $anchorContent = $self->_addSection( '', $paragraph . $ContentSuffix);
			
			$self->{buffer} .= qq(<$top_heading id="$anchor">$paragraph</$top_heading>)
					.($self->{TopLinks} ? $self->{TopLinks} : '')."\n"
					."<div id=\"$anchorContent\">\n";

			if ($anchor eq 'NAME') { $self->{titleflag} = 1; }
			last;
		};
		/^head([234])/ && !$data_para && do {
			my $head_level = $1;
			if($self->{FragmentOnly}){
				$head_level += ($self->{TopHeading} - 1);
				$head_level = 6 if $head_level > 6;
			}
			# if ANY sections are open then close the previously opened div
			$self->{buffer} .= "\n</div>\n" unless ( @{ $self->{sections} } == 1 );

			$anchor = $self->_addSection( "head${head_level}", $paragraph );
			my $anchorContent = $self->_addSection( '', $paragraph . $ContentSuffix);

			$self->{buffer} .= "<h${head_level} id=\"$anchor\">$paragraph</h${head_level}>\n" . "<div id=\"$anchorContent\">\n";
			last;
		};
		/^item/ && !$data_para && do {
			unless ($self->{inList}) {
				warn "Not in list at $self->{_INFILE} line $line\n";
				last;
			}

			$self->{listHasItems}[-1]++;
			$self->{listCurrentParas}[-1] = 0;

			# is this the first item in the list?
			if (@{$self->{listKind}} && $self->{listKind}[-1] == 0) {
				my $parent_list = $self->{listKind}[-2]; # this is a sub-list
				if ($parent_list && $parent_list == 1) {
					# <ul> sub lists must be in an <li> [BEGIN]
					$self->{buffer} .= $self->_tagLevel () . "<li>\n";
					push @{$self->{tagStack}}, "li";
				} elsif ($parent_list && $parent_list == 2) {
					# <dl> sub lists must be in a <p> [BEGIN]
					$self->{buffer} .= $self->_tagLevel () . "<p>\n";
					push @{$self->{tagStack}}, "p";
				}

				if ($paragraph eq '*') {
					$self->{listKind}[-1] = 1;
					$self->{buffer} .= $self->_tagLevel () . "<ul>\n";
					push @{$self->{tagStack}}, "ul";
				} else {
					$self->{listKind}[-1] = 2;
					$self->{buffer} .= $self->_tagLevel () . "<dl>\n";
					push @{$self->{tagStack}}, "dl";
				}
			} else {
				# close last list item's tag#
				if ($self->{listKind}[-1] == 1) {
					my $o = pop @{$self->{tagStack}};
					warn "expected 'li' to be on the tag stack but got '$o'\n"
						if $o ne 'li';
					$self->{buffer} .= $self->_tagLevel () . "</li>\n";
				}
			}
			if (@{$self->{listKind}} && $self->{listKind}[-1] == 2) {
				if (@{$self->{tagStack}} && $self->{tagStack}[-1] eq "dd") {
					my $o = pop @{$self->{tagStack}};
					warn "expected 'dd' to be on the tag stack but got '$o'\n"
						if $o ne 'dd';
					$self->{buffer} .= $self->_tagLevel () . "</dd>\n";
				}
				$self->{buffer} .= $self->_tagLevel () . qq(<dt);
				push @{$self->{tagStack}}, "dt";
				if ($self->{MakeIndex} >= 2) {
					$anchor = $self->_addSection( 'item', $paragraph );
					$self->{buffer} .= qq( id="$anchor");
				}
				$self->{buffer} .= ">";
				$self->{buffer} .= qq($paragraph</dt>\n);
				my $o = pop @{$self->{tagStack}};
				warn "expected 'dt' to be on the tag stack but got '$o'\n"
					if $o ne 'dt';
			}
			last;
		};
		/^over/ && !$data_para && do {
			$self->{inList}++;
			push @{$self->{listKind}}, 0;
			push @{$self->{listHasItems}}, 0;
			push @{$self->{sections}}, 'over' if $self->{MakeIndex} >= 2;
			push @{$self->{listCurrentParas}}, 0;
		};
		/^back/ && !$data_para && do {
			my $listItems = pop @{$self->{listHasItems}};
			if (--$self->{inList} < 0) {
				warn "=back commands don't balance =overs at $self->{_INFILE} line $line\n";
				last;
			} elsif ($listItems == 0) {
				warn "empty list at $self->{_INFILE} line $line\n";
				last;
			} elsif (@{$self->{listKind}} && $self->{listKind}[-1] == 1) {
				my $o = pop @{$self->{tagStack}};
				warn "expected 'li' to be on the tag stack but got '$o'\n"
					if $o ne 'li';
				$o = pop @{$self->{tagStack}};
				warn "expected 'ul' to be on the tag stack but got '$o'\n"
					if $o ne 'ul';
				$self->{buffer} .= "</li>\n</ul>\n\n";
			} else {
				while (@{$self->{tagStack}} && $self->{tagStack}[-1] eq "dd") {
					pop @{$self->{tagStack}};
					$self->{buffer} .=$self->_tagLevel () . "</dd>\n";
				}
				my $o = pop @{$self->{tagStack}};
				warn "expected 'dl' to be on the tag stack but got '$o'\n"
					if $o ne 'dl';
				$self->{buffer} .= $self->_tagLevel () . "</dl>\n";
			}

			my $parent_list = $self->{listKind}[-2]; # this is a sub-list
			if ($parent_list && $parent_list == 1) {
				my $o = pop @{$self->{tagStack}};
				warn "expected 'li' to be on the tag stack but got '$o'\n"
					if $o ne 'li';
				# <ul> sub lists must be in an <li> [END]
				$self->{buffer} .= $self->_tagLevel () . "</li>\n";
			}
			if ($parent_list && $parent_list == 2) {
				my $o = pop @{$self->{tagStack}};
				warn "expected 'p' to be on the tag stack but got '$o'\n"
					if $o ne 'p';
				# <dl> sub lists must be in a <p> [END]
				$self->{buffer} .= $self->_tagLevel () . "</p>\n";
			}

			if ( $self->{MakeIndex} >= 2 ) {
				if ( ! ref $self->{sections}->[ -1 ] ) {
					if ( $self->{sections}->[ -1 ] =~ /^over$/i ) {
						pop @{ $self->{sections} };
					}
				} else {
					if ( $self->{sections}->[ -1 ] [ 0 ] =~ /^item$/i ) {
						push @{ $self->{sections} }, 'back';
					}
				}
			}

			pop @{$self->{listKind}};
			pop @{$self->{listCurrentParas}};
			last;
		};
		/^for/ && !$data_para && do {
			my($ident, $html) = $raw_para =~ /^\s*(\S+)\s+(.*)/;
			$html = undef unless $ident =~ P2X_REGION;
			$self->{buffer} .= $html if $html;
		};
		/^begin/ && !$data_para && do {
			my ($ident) = $paragraph =~ /(\S+)/;
			push @{$self->{dataSections}}, $ident;
			last;
		};
		/^end/ && do {
			my ($ident) = $paragraph =~ /(\S+)/;
			unless (@{$self->{dataSections}}) {
				warn "no corresponding '=begin $ident' marker at $self->{_INFILE} line $line\n";
				last;
			}
			my $current_section = $self->{dataSections}[-1];
			unless ($current_section eq $ident) {
				warn "'=end $ident' doesn't match '=begin $current_section' at $self->{_INFILE} line $line\n";
				last;
			}
			pop @{$self->{dataSections}};
			last;
		};
	}
}

sub _addTextblock {
	my $self = shift;
	my($paragraph, $no_wrap) = @_;

	if ($self->{titleflag} != 0) { $self->_setTitle( $paragraph ); }

	# DON'T wrap a paragraph in a <p> if it's a <pre>!
	$no_wrap = 1 if $paragraph =~ m/^\s*<pre>/im;

	if (! @{$self->{listKind}} || $self->{listKind}[-1] == 0) {
		if (!$no_wrap) {
			$self->{buffer} .= $self->_tagLevel () . "<p>$paragraph</p>\n";
		} else {
			$self->{buffer} .= "$paragraph\n";
		}
	} elsif (@{$self->{listKind}} && $self->{listKind}[-1] == 1) {
		if ($self->{listCurrentParas}[-1]++ == 0) {
			# should this list item be closed?
			push @{$self->{tagStack}}, "li";
			$self->{buffer} .= $self->_tagLevel () . "<li>$paragraph";
		} else {
			$self->{buffer} .= "\n<br /><br />$paragraph";
		}
	} else {
		if ($self->{listCurrentParas}[-1]++ == 0) {
			$self->{buffer} .= $self->_tagLevel () . "<dd>\n";
			push @{$self->{tagStack}}, "dd";
		}

		if (!$no_wrap) {
			$self->{buffer} .= $self->_tagLevel () . "<p>$paragraph</p>\n";
		} else {
			$self->{buffer} .= "$paragraph\n";
		}
	}
}

sub _tagLevel {
	my $self = shift;
	return ( "\t" x scalar @{$self->{tagStack}} );
}

# expand interior sequences recursively, bottom up
sub _handleSequence {
	my $self = shift;
	my($seq, $no_escape) = @_;
	my $buffer = '';

	foreach (@{$seq->{'-ptree'}}) {
		if (ref $_) {
			$buffer .= $self->_handleSequence($_);
		} else {
			$buffer .= $no_escape ? $_ : _htmlEscape($_);
		}
	}

	unless (exists $SEQ{$seq->{'-name'}}) {
		warn "Unrecognized special sequence '$seq->{'-name'}' skipped at $self->{_INFILE} line $seq->{'-line'}\n";
		return $buffer;
	}
	return $SEQ{$seq->{'-name'}}->($self, $buffer);
}

sub _makeIndexId {
	my $arg = shift;

	$arg =~ s/\W+/_/g;
	$arg =~ s/^_+|_+$//g;
	$arg =~ s/__+/_/g;
	$arg = substr($arg, 0, 36);
	return $arg;
}

sub _addSection {
	my $self = shift;
	my ($type, $htmlarg) = @_;
	return unless defined $htmlarg;

	my $index_id;
	if ($self->{section_names}{$htmlarg}) {
		$index_id = $self->{section_names}{$htmlarg};
	} else {
		$index_id = _makeIndexId($htmlarg);
	}
	
	if ($self->{section_ids}{$index_id}++) {
		$index_id .= "-" . $self->{section_ids}{$index_id};
	}
	
	# if {section_names}{$htmlarg} is already set then this is a duplicate 'id',
	# so keep the reference to the first one
	$self->{section_names}{$htmlarg} = $index_id
		unless exists $self->{section_names}{$htmlarg};

	push( @{$self->{sections}}, [$type, $index_id, $htmlarg]);
	return $index_id;
}

sub _findSection {
	my $self = shift;
	my ($htmlarg) = @_;

	my $index_id;
	if ($index_id = $self->{section_names}{$htmlarg}) {
		return $index_id;
	} else {
		return _makeIndexId($htmlarg);
	}
}

sub _get_elem_level {
	my $elem = shift;
	if (ref($elem)) {
		my $type = $elem->[0];
		if ($type =~ /^head(\d+)$/) {
			return $1;
		} else {
			return 0;
		}
	} else {
		return 0;
	}
}

sub _makeTabbing {
	my $level = shift || 0;

	return "\n" . ( "\t" x $level );
}

sub _makeIndex {
	my $self = shift;

	my $string = "<!-- INDEX START -->\n<h3 id=\"$FirstAnchorId\">Index</h3>\n";

	my $previous_level = 0;
	my $previous_section = '';
	
	SECTION: foreach my $section ( @{ $self->{sections} } )
	{
		my $this_level = 0;

		if ( ! ref $section )
		{
			for ( $section )
			{
				if ( $section =~ m/^over$/i )
				{
					$previous_level++;
					$string .= ( $previous_section ne 'over' && "</li>\n" ) .
						"<li>\n<ul>\n";
				}
				elsif ( $section =~ m/^back$/i )
				{
					$previous_level--;
					$string .= "\n</li>\n</ul>";
				}
			}

			$previous_section = $section;
		}
		else
		{
			my ( $type, $href, $name ) = @$section;
			
			if ( $section->[ 0 ] =~ m/^item$/i )
			{
				$this_level = $previous_level;
			}
			else
			{
				$this_level = _get_elem_level ( $section );
			}

			next SECTION if $this_level == 0;
			
			if ( $this_level > $previous_level )
			{
				# open new list(s)
				$string .= "\n<ul>" .
					( "\n<li>\n<ul>" ) x ( $this_level - $previous_level - 1 );
			}
			elsif ( $this_level < $previous_level )
			{
				# close list(s)
				$string .= "</li>\n" .
					( "</ul>\n</li>\n" ) x ( $previous_level - $this_level );
			}
			else
			{
				$string .= "</li>\n" unless $previous_section =~ /^over$/i;
			}

			$string .= '<li><a href="#' . $href . '">' . $name . '</a>';

			$previous_level = $this_level;

			$previous_section = ( ref $section ? $section->[ 0 ] : $section );
		}
	}

	$string .= ( "\n</li>\n</ul>" x $previous_level );
	$string .= "<hr />\n<!-- INDEX END -->\n\n";
	
	return $string;
}

sub _makeMeta {
	my $self = shift;
	return
		qq(\t<meta name="description" content="Pod documentation for ) . _htmlEscape( $self->{doctitle} ) . qq(" />\n)
		. qq(\t<meta name="inputfile" content=") . _htmlEscape( $self->input_file ) . qq(" />\n)
		. qq(\t<meta name="outputfile" content=") . _htmlEscape( $self->output_file ) . qq(" />\n)
		. qq(\t<meta name="created" content=") . _htmlEscape( scalar(localtime) ) . qq(" />\n)
		. qq(\t<meta name="generator" content="Pod::Xhtml $VERSION" />\n);
}

sub _setTitle {
	my $self = shift;
	my $paragraph = shift;

	if ($paragraph =~ m/^(.+?) - /) {
		$self->{doctitle} = $1;
	} elsif ($paragraph =~ m/^(.+?): /) {
		$self->{doctitle} = $1;
	} elsif ($paragraph =~ m/^(.+?)\.pm/) {
		$self->{doctitle} = $1;
	} else {
		$self->{doctitle} = substr($paragraph, 0, 80);
	}
	$self->{titleflag} = 0;
}

sub _htmlEscape {
	my $txt = shift;
	$txt =~ s/&/&amp;/g;
	$txt =~ s/</&lt;/g;
	$txt =~ s/>/&gt;/g;
	$txt =~ s/\"/&quot;/g;
	return $txt;
}

########## Sequence handlers
sub seqI { return '<i>' . $_[1] . '</i>'; }
sub seqB { return '<strong>' . $_[1] . '</strong>'; }
sub seqC { return '<code>' . $_[1] . '</code>'; }
sub seqF { return '<cite>' . $_[1] . '</cite>'; }
sub seqZ { return ''; }

sub seqL {
	my ($self, $link) = @_;
	$self->{LinkParser}->parse( $link );

	my $page = $self->{LinkParser}->page;
	my $kind = $self->{LinkParser}->type;
	my $string = '';

	if ($kind eq 'hyperlink') {	#easy, a hyperlink
		my $targ = $self->{LinkParser}->node;
		my $text = $self->{LinkParser}->text;
		$string = qq(<a href="$targ">$text</a>);
	} elsif ($kind =~ m/^bounceurl:(.+)$/) {
		# Our link-parser has decided that the link should be handled by a particular URL
		my $url = $1;
		$url = _htmlEscape( $url ); # since the URL may contain ampersands
		$string = $self->{LinkParser}->markup;
		if ($string =~ m/P<.+>/) {	# when there's no alternative text we get P, and maybe Q
			$string =~ s|Q<(.+?)>|<strong class="pod_xhtml_bounce_url_text">$1</strong>|;
			$string =~ s|P<(.+?)>|<a class="pod_xhtml_bounce_url" href="$url">$1</a>|;
		} else {
			$string =~ s|Q<(.+?)>|<a class="pod_xhtml_bounce_url" href="$url">$1</a>|;
		}
	} elsif ($page eq '') {	# a link to this page
		# Post-process these links so we can things up to the correct sections
		my $targ = $self->{LinkParser}->node;
		$string = $self->{LinkParser}->markup;
		$string =~ s|Q<(.+?)>|<a href="#<<<$targ>>>">$1</a>|;
	} elsif ($link !~ /\|/) {	# a link off-page with _no_ alt text
		$string = $self->{LinkParser}->markup;
		$string =~ s|Q<(.+?)>|<b>$1</b>|;
		$string =~ s|P<(.+?)>|<cite>$1</cite>|;
	} else {	# a link off-page with alt text
		my $text = _htmlEscape( $self->{LinkParser}->text );
		my $targ = _htmlEscape( $self->{LinkParser}->node );
		$string = "<b>$text</b> (";
		$string .= "<b>$targ</b> in " if $targ;
		$string .= "<cite>$page</cite>)";
	}
	return $string;
}

sub seqS {
	my $text = $_[1];
	$text =~ s/\s/&nbsp;/g;
	return $text;
}

sub seqX {
	my $self = shift;
	my $arg = shift;
	my $anchor = $self->_addSection( 'head1', $arg );
	return qq[<span id="$anchor">$arg</span>];
}

sub seqE {
	my $self = shift;
	my $arg = shift;
	my $rv;

	if ($arg eq 'sol') {
		$rv = '/';
	} elsif ($arg eq 'verbar') {
		$rv = '|';
	} elsif ($arg =~ /^\d$/) {
		$rv = "&#$arg;";
	} elsif ($arg =~ /^0?x(\d+)$/) {
		$rv = $1;
	} else {
		$rv = "&$arg;";
	}
	return $rv;
}
1;
__END__

=head1 NAME

Pod::Xhtml - Generate well-formed XHTML documents from POD format documentation

=head1 SYNOPSIS

This module inherits from Pod::Parser, hence you can use this familiar
interface:

	use Pod::Xhtml;
	my $parser = new Pod::Xhtml;
	$parser->parse_from_file( $infile, $outfile );

	# or use filehandles instead
	$parser->parse_from_filehandle($in_fh, $out_fh);

	# or get the XHTML as a scalar
	my $parsertoo = new Pod::Xhtml( StringMode => 1 );
	$parsertoo->parse_from_file( $infile, $outfile );
	my $xhtml = $parsertoo->asString;

	# or get a reference to the XHTML string
	my $xhtmlref = $parsertoo->asStringRef;

	# to parse some other pod file to another output file all you need to do is...
	$parser->parse_from_file( $anotherinfile, $anotheroutfile );

There are options specific to Pod::Xhtml that you can pass in at construction
time, e.g.:

	my $parser = new Pod::Xhtml(StringMode => 1, MakeIndex => 0);

See L<"OPTIONS">. For more information also see L<Pod::Parser> which this
module inherits from.

=head1 DESCRIPTION

=over 4

=item new Pod::Xhtml( [ OPTIONS ] )

Create a new object. Optionally pass in some options in the form
C<'new Pod::Xhtml( StringMode =E<gt> 1);'>

=item $parser->parse_from_file( INPUTFILE, [OUTPUTFILE] )

Read POD from the input file, output to the output file (or STDOUT if no
file is given). See Pod::Parser docs for more.
Note that you can parse multiple files with the same object. All your options
will be preserved, as will any text you added with the add*Text methods.

=item $parser->parse_from_filehandle( [INPUTFILEHANDLE, [OUTPUTFILEHANDLE]] )

Read POD from the input filehandle, output to the output filehandle
(STDIN/STDOUT if no filehandle(s) given). See Pod::Parser docs for more.  Note
that you can parse multiple files with the same object. All your options will
be preserved, as will any text you added with the add*Text methods.

=item $parser->asString

Get the XHTML as a scalar. You'll probably want to use this with the
StringMode option.

=item $parser->asStringRef

As above, but you get a reference to the string, not the string itself.

=item $parser->addHeadText( $text )

Inserts some text just before the closing head tag. For example you can add a
link to a stylesheet. May be called many times to add lots of text. Note: you
need to call this some time B<before> any output is done, e.g. straight after
new(). Make sure that you only insert valid XHTML fragments.

=item $parser->addBodyOpenText( $text ) / $parser->addBodyCloseText( $text )

Inserts some text right at the beginning (or ending) of the body element. For
example you can add a navigation header and footer.  May be called many times
to add lots of text. Note: you need to call this some time B<before> any output
is done, e.g. straight after new(). Make sure that you only insert valid XHTML
fragments.

=back

=head1 OPTIONS

=over 4

=item StringMode

Default: 0. If set to 1 this does no output at all, even if filenames/handles
are supplied. Use asString or asStringRef to access the text if you set this
option.

=item MakeIndex

Default: 1. If set to 1 then an index of sections is created at the top of the
body. If set to 2 then the index includes non-bulleted list items

=item MakeMeta

Default: 1. If set to 1 then some meta tags are created, recording things like
input file, description, etc.

=item FragmentOnly

Default: 0. If 1, we only produce an XHTML fragment (suitable for use as a
server-side include etc). There is no HEAD element nor any BODY or HTML
tags. Any text added with the add*Text methods will B<not> be output.


=item TopHeading

Allows you to set the starting heading level when in fragment mode.
For example, if your document already has h1 tags and you want the
generated POD to nest inside the outline, you can specify

	TopHeading => 2

and C<=head1> will be tagged with h2 tags, C<=head3> with h3, and so
on.

Note that XHTML doesn't allow for heading tags past h6, so h7 and up
will be translated to h6 as necessary.

=item TopLinks

At each section head this text is added to provide a link back to the top.
Set to 0 or '' to inhibit links, or define your own.

	Default: <p><a href="#TOP" class="toplink">Top</a></p>

=item LinkParser

An object that parses links in the POD document. By default, this is a regular
Pod::Hyperlink object. Any user-supplied link parser must conform the the
Pod::Hyperlink API.

This module works with a L<Pod::Hyperlink::BounceURL> link parser and generates
hyperlinks as 'a' elements with a class of 'pod_xhtml_bounce_url'. The optional
text giving the "node" is enclosed in a 'strong' element with a class of 'pod_xhtml_bounce_url_text'

=back

=head1 RATIONALE

There's Pod::PXML and Pod::XML, so why do we need Pod::Xhtml? You need an XSLT
to transform XML into XHTML and many people don't have the time or inclination
to do this. But they want to make sure that the pages they put on their web
site are well-formed, they want those pages to use stylesheets easily, and
possibly they want to squirt the XHTML through some kind of filter for more
processing.

By generating well-formed XHTML straight away we allow anyone to just use the
output files as-is. For those who want to use XML tools or transformations they
can use the XHTML as a source, because it's a well-formed XML document.

=head1 CAVEATS

This module outputs well-formed XHTML if the POD is well-formed. To check this
you can use something like:

	use Pod::Checker;
	my $syn = podchecker($defaultIn);

If $syn is 0 there are no syntax errors. If it's -1 then no POD was found. Any
positive number indicates that that number of errors were found. If the input
POD has errors then the output XHTML I<should> be well-formed but will probably
omit information, and in addition Pod::Xhtml will emit warnings. Note that
Pod::Parser seems to be sensitive to the current setting of $/ so ensure it's
the end-of-line character when the parsing is done.

=head1 AUTHOR

P Kent E<amp> Simon Flack  E<lt>cpan _at_ bbc _dot_ co _dot_ ukE<gt>

=head1 COPYRIGHT

(c) BBC 2004, 2005. This program is free software; you can redistribute it
and/or modify it under the GNU GPL.

See the file COPYING in this distribution, or http://www.gnu.org/licenses/gpl.txt

=cut

# vim:noet
