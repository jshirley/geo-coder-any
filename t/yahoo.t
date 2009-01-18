use Test::More;
use Data::Dumper;

## use this key for testing: dIg5UJDV34F2VnuxrMYDcGd2WscAdhHYz6xxn4iZbcTgA4LBmbNWKkza_aAqgmc-

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
        'Yahoo' => { appid => $API_KEY }
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
     'sub_administrative_area' => '',
     'administrative_area' => '',
};


is_deeply($result, $expected, 'proper result');

