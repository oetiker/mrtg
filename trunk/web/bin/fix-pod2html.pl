#!/usr/sepp/bin/perl-5.8.8 -w

use strict;
use HTML::Parser;

# fix pod2html output:
# v1.0: defer </dd> and </dt> tags until
# the next <dd>, <dt> or </dl>

# v1.1: don't nest any <a> elements; 
# end one before beginning another

# v1.2: insert <dd> tags if <dl> occurs
# inside <dt>

# v1.3: <a> anchors must not start with a digit;
# insert a letter "N" at the start if they do

# v1.4: insert the "N" letter into <a href="#xxx"> too.

my $p = HTML::Parser->new(api_version => 3);
$p->handler(start => \&startsub, 'tagname, text');
$p->handler(end => \&endsub, 'tagname, text');
$p->handler(default => sub { print shift() }, 'text');
$p->parse_file(shift||"-") or die("parse: $!");

my @ddstack;
my @listack;
my $a=0;

sub startsub {
        my $tag = shift;
        my $text = shift;
        if ($tag eq "dl") {
		if (@ddstack and $ddstack[0] eq "dt") {
			$ddstack[0] = "dd";
			print "</dt><dd>";
		}
                unshift @ddstack, 0;
        }
        if ($tag =~ /^[uo]l$/) {
                unshift @listack, 0;
        }
        if (($tag eq "dt" or $tag eq "dd") and $ddstack[0]) {
                print "</$ddstack[0]>";
                $ddstack[0] = 0;
        }
        if (($tag eq "li") and $listack[0]) {
                print "</$listack[0]>";
                $listack[0] = 0;
        }
	if ($tag eq "a") {
		if ($a) {
			print "</a>";
		} else {
			$a++;
		}
		$text =~ s/(name="|href="#)(\d)/$1N$2/;
	}
        print $text;
}
                

sub endsub {
        my $tag = shift;
        my $text = shift;
        if ($tag eq "dl") {
                print "</$ddstack[0]>" if $ddstack[0];
                shift @ddstack;
        } elsif ($tag =~ /^[uo]l$/) {
                print "</$listack[0]>" if $listack[0];
                shift @listack;
        } 

	if ($tag eq "a") {
		if ($a) {
			print "</a>";
			$a--;
		}
	} elsif ($tag eq "dd" or $tag eq "dt") {
                $ddstack[0] = $tag;
	} elsif ($tag eq "li") {
               $listack[0] = $tag;
        } else {
                print $text;
        }
}
