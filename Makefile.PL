use inc::Module::Install;

perl_version '5.8.1';

name 'Geo-Coder-Any';
all_from 'lib/Geo/Coder/Any.pm';

requires 'Moose';
requires 'MooseX::AttributeHelpers';

feature 'Google Geocoding Support',
    -default => 1,
    'Geo::Coder::Google' => undef;

feature 'Yahoo Geocoding Support',
    -default => 1,
    'Geo::Coder::Yahoo' => undef;

auto_include;
auto_install;

WriteAll;


