package Geo::Coder::Any::Google;

use Moose;
use Geo::Coder::Any::Location;

extends 'Geo::Coder::Google';

=head1 NAME

Geo::Coder::Any::Google - Interface to Geo::Coder::Google

=head1 SYNOPSIS

    use Geo::Coder::Any;

    my $ga = Geo::Coder::Any->new(
        steps => [
            'Google' => { apikey => $YOUR_GOOGLE_API_KEY }
        ]
    );
    # Returns a Geo::Coder::Any::Location object
    my $result = $ga->geocode('1600 NE Pennsylvania Ave, Washington D.C.');

=head1 DESCRIPTION

This class is simply an adapter for L<Geo::Coder::Google> and profies a simple
unified interface that works with L<Geo::Coder::Any>.

=head1 METHODS

=head2 process($location)

This method geocodes the incoming $location against the Yahoo API and wil return
a L<Geo::Coder::Any::Location> object

=cut

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
        'geocoder'  => $self,
        'latitude'  => $in->{Point}->{coordinates}->[1],
        'longitude' => $in->{Point}->{coordinates}->[0],

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

