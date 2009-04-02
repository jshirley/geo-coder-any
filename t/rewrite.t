use Test::More;

use lib 't/lib';

my $API_KEY = $ENV{YAHOO_APIKEY};

unless ( $API_KEY ) {
    plan skip_all =>
        "Define the YAHOO_APIKEY environment variable to run this test";
    exit;
}

plan tests => 4;

use_ok('Geo::Coder::Any');


my $ga = Geo::Coder::Any->new(
    steps => [
        'Map'   => { },
        'Yahoo' => { apikey => $API_KEY }
    ]
);
ok($ga, 'created geocoder');

my $result = $ga->geocode('Hollywood and Highland, Los Angeles, CA');
ok($result, 'got geocode result');

my $expected = {
    'country' => 'US',
    'longitude' => '-77.035971',
    'latitude' => '38.898590',
    'sub_administrative_area' => 'Washington',
    'address' => '1600 Pennsylvania Ave NW',
    'administrative_area' => 'DC'
};
my $result_hash = { map { $_ => $result->$_ } keys %$expected };
is_deeply($result_hash, $expected, 'proper result');

