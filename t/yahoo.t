use Test::More;
use Data::Dumper;

my $API_KEY = $ENV{YAHOO_APIKEY};

unless ( $API_KEY ) {
    plan skip_all =>
        "Define the YAHOO_APIKEY environment variable to run this test";
    exit;
}

plan tests => 6;

use_ok('Geo::Coder::Any');

my $ga = Geo::Coder::Any->new(
    steps => [
        'Yahoo' => { apikey => $API_KEY }
    ]
);
ok($ga, 'created geocoder');

my $result = $ga->geocode('Hollywood and Highland, Los Angeles, CA');
ok($result, 'got geocode result');

my $expected = {
    'country' => 'US',
    'longitude' => '-118.339073',
    'latitude' => '34.101559',
    'address' => 'Hollywood and Highland',
    'sub_administrative_area' => 'Los Angeles',
    'administrative_area' => 'CA',
};

my $result_hash = { map { $_ => $result->$_ } keys %$expected };
is_deeply($result_hash, $expected, 'proper result');

$result = $ga->geocode('1600 Pennsylvanie Ave NW, Washington, DC 20006');
ok($result, 'got geocode result');

$expected = {
    'country' => 'US',
    'longitude' => '-77.035971',
    'latitude' => '38.898590',
    'address' => '1600 Pennsylvania Ave NW',
    'sub_administrative_area' => 'Washington',
    'administrative_area' => 'DC',
};

$result_hash = { map { $_ => $result->$_ } keys %$expected };
is_deeply($result_hash, $expected, 'proper result');

