use strict;
use GIFgraph::colour qw( :colours :files :lists );

my $n_def = scalar @{[colour_list()]};

print "1..6\n";

# Test 1 .. 2 : read_rgb

my $n = read_rgb("t/colour_rgb.txt");
print $n == 44 ? "" : "not " , "ok 1\n";
$n = scalar @{[colour_list()]};
print $n == $n_def + 44 ? "" : "not " , "ok 2\n";

# Test 3 .. 5 : _rgb, _luminance, _hue

my @rgb = _rgb('light steel blue');
print $rgb[0]==176 && $rgb[1]==196 && $rgb[2]==222 ? "" : "not " , "ok 3\n";
$n = sprintf "%8f", _hue(@rgb);
print $n == 0.776471 ? "" : "not " , "ok 4\n";
$n = sprintf "%8f", _luminance(@rgb);
print $n == 0.759306 ? "" : "not " , "ok 5\n";

# Test 6 .. 6 : lists

my @list = sorted_colour_list(10);
print scalar(@list) == 10 && $list[0] eq 'white' ? "" : "not " , "ok 6\n";

