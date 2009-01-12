package Geo::Coder::Any::Yahoo;

use Moose;
use Geo::Coder::Any::Location;

extends 'Geo::Coder::Yahoo';

sub process {
    my ( $self, $location ) = @_;
    my @results = $self->geocode( location => $location );
    if ( $results[0] and $results[0]->{Point} ) {
        my $rs = Geo::Coder::Any::Location->new($self->_normalize($results[0]));
        return { result => $rs };
    }
}

sub _normalize {
    my ( $self, $in ) = @_;

    my $aa = $in->{AddressDetails}->{Country}->{AdministrativeArea};

    my $locality = $aa->{SubAdministrativeArea}->{Locality} || 
                   $aa->{Locality};
    my $rs = {
        'latitude'  => $in->{Point}->{coordinates}->[0],
        'longitude' => $in->{Point}->{coordinates}->[1],

        'address'             => $in->{address},
        'thoroughfare'        => $locality->{Thoroughfare}->{ThoroughfareName},
        'locality'            => $locality->{LocalityName},
        'administrative_area' => $aa->{AdministrativeAreaName} || '',
        'sub_administrative_area' => $aa->{SubAdministrativeArea}->{SubAdministrativeAreaName} || '',
        'country' => $in->{AddressDetails}->{Country}->{CountryNameCode},
    };

    return $rs;
}

1;

