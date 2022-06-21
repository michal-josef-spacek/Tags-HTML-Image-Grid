use strict;
use warnings;

use Tags::HTML::Image::Grid;
use Tags::Output::Raw;
use Test::More 'tests' => 3;
use Test::NoWarnings;

# Test.
my $obj = Tags::HTML::Image::Grid->new;
isa_ok($obj, 'Tags::HTML::Image::Grid');

# Test.
$obj = Tags::HTML::Image::Grid->new(
	'tags' => Tags::Output::Raw->new,
);
isa_ok($obj, 'Tags::HTML::Image::Grid');
