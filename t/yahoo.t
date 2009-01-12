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
    address => '1600 Pennsylvania Ave NW, Washington, DC 20006, USA',
    administrative_area => 'DC',
    country => 'US',
    latitude => -77.0366871,
    longitude => 38.8987745,
    sub_administrative_area => '',
    thoroughfare => '1600 Pennsylvania Ave NW',
};

is_deeply($result, $expected, 'proper result');

