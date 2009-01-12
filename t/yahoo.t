use Test::More;

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

my $result = $ga->geocode('1600 NE Pennsylvania Ave, Washington D.C.');
ok($result, 'got geocode result');

my $expected = {
     'country' => 'US',
     'longitude' => '-118.3387',
     'state' => 'CA',
     'zip' => '90028',
     'city' => 'LOS ANGELES',
     'latitude' => '34.1016',
     'warning' => 'The exact location could not be found, here is the closest match: Hollywood Blvd At N Highland Ave, Los Angeles, CA 90028',
     'address' => 'HOLLYWOOD BLVD AT N HIGHLAND AVE',
     'precision' => 'address'
};

is_deeply($result, $expected, 'proper result');

