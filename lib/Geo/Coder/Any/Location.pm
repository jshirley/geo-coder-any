package Geo::Coder::Any::Location;

use Moose;

has 'address' => (
    is  => 'rw',
    isa => 'Str'
);

has 'latitude'     => ( is => 'rw',  isa => 'Num' );
has 'longitude'    => ( is => 'rw',  isa => 'Num');
has 'country'      => ( is => 'rw',  isa => 'Str', default => 'US' );
has 'thoroughfare' => ( is => 'rw',  isa => 'Str' );
has 'sub_administrative_area' => ( is => 'rw',  isa => 'Str', default => '' );
has 'administrative_area'     => ( is => 'rw',  isa => 'Str', default => '' );

# etc etc etc

1;
