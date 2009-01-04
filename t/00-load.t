#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Geo::Coder::Any' );
}

diag( "Testing Geo::Coder::Any $Geo::Coder::Any::VERSION, Perl $], $^X" );
