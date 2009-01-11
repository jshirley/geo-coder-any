package Geo::Coder::Any::Google;

use Moose;

extends 'Geo::Coder::Google';

sub process {
    my ( $self, $location ) = @_;
    my @results = $self->geocode( location => $location );
    if ( $results[0] and $results[0]->{Point} ) {
        return { result => Geo::Coder::Google::Location->new( $results[0] ) };
    }
}

1;

