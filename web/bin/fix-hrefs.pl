#!/usr/sepp/bin/perl-5.8.8 -w

use strict;
use HTML::Parser;

my $p = HTML::Parser->new(api_version => 3);
$p->handler(start => \&startsub, 'tagname, text');
#$p->handler(end => \&endsub, 'tagname, text');
$p->handler(default => sub { print shift() }, 'text');
$p->parse_file(shift||"-") or die("parse: $!");

sub startsub {
        my $tag = shift;
        my $text = shift;
        
	if ($tag eq "a") {
		$text =~ s,".*?/web/doc/,",;
		$text =~ /^http/ || $text =~ s,\.html,.en.html,;
	}
	print $text;
}
