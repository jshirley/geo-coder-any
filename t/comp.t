use Test::More;

my $GAPI_KEY = $ENV{GOOGLE_APIKEY};
my $YAPI_KEY = $ENV{YAHOO_APIKEY};

unless ( $GAPI_KEY and $YAPI_KEY) {
    plan skip_all =>
        "Define the GOOGLE_APIKEY and YAHOO_APIKEY environment variables to run this test";
    exit;
}

plan tests => 7;

use_ok('Geo::Coder::Any');

my $ga = Geo::Coder::Any->new(
    steps => [
        'Google' => { apikey => $GAPI_KEY },
        'Yahoo'  => { apikey => $YAPI_KEY },
    ]
);
ok($ga, 'created geocoder');

my $result = $ga->geocode('1600 NE Pennsylvania Ave, Washington D.C.');
ok($result, 'got geocode result');

my $expected = {
    address => '1600 Pennsylvania Ave NW, Washington, DC 20006, USA',
    administrative_area => 'DC',
    country => 'US',
    latitude => 38.8987745,
    longitude => -77.0366871,
    sub_administrative_area => '',
    thoroughfare => '1600 Pennsylvania Ave NW',
};

my $result_hash = { map { $_ => $result->$_ } keys %$expected };
is_deeply($result_hash, $expected, 'proper result');

my $result = $ga->geocode('Hollywood and Highland, Los Angeles, CA');
ok($result, 'got geocode result');

my $expected = {
     'country'   => 'US',
     'longitude' => '-118.338668',
     'latitude'  => '34.101564',
     'address'   => 'Hollywood Blvd \u0026 N Highland Ave, Los Angeles, CA 90028, USA',
     'sub_administrative_area'  => '',
     'administrative_area'      => 'CA',
};
isa_ok($result->geocoder, 'Geo::Coder::Any::Google', 'proper response');
my $result_hash = { map { $_ => $result->$_ } keys %$expected };
is_deeply($result_hash, $expected, 'proper result');

