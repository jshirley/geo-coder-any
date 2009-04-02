use Test::More;

my $API_KEY = $ENV{GOOGLE_APIKEY};

unless ( $API_KEY ) {
    plan skip_all =>
        "Define the GOOGLE_APIKEY environment variable to run this test";
    exit;
}

plan tests => 4;

use_ok('Geo::Coder::Any');

my $ga = Geo::Coder::Any->new(
    steps => [
        'Google' => { apikey => $API_KEY }
    ]
);
ok($ga, 'created geocoder');

my $result = $ga->geocode('1600 NE Pennsylvania Ave, Washington D.C.');
ok($result, 'got geocode result');

my $expected = {
    address => '1600 Pennsylvania Ave NW, Washington, DC 20006, USA',
    administrative_area => 'DC',
    country => 'US',
    longitude => -77.0366871,
    latitude   => 38.8987745,
    sub_administrative_area => '',
    thoroughfare => '1600 Pennsylvania Ave NW',
};

my $result_hash = { map { $_ => $result->$_ } keys %$expected };
is_deeply($result_hash, $expected, 'proper result');

