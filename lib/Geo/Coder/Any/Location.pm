package Geo::Coder::Any::Location;

has 'latitude'     => ( is => 'rw',  isa => 'Num' );
has 'longitude'    => ( is => 'rw',  isa => 'Num');
has 'country'      => ( is => 'rw',  isa => 'Str', default => 'US' );
has 'thoroughfare' => ( is => 'rw',  isa => 'Str' );
#has 'locality'     => ( ... );

# etc etc etc

1;
