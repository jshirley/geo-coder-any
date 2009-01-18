package Geo::Coder::Any::Yahoo;

use Moose;
use Geo::Coder::Yahoo;
use Geo::Coder::Any::Location;

has appid => ( is => 'ro', isa => 'Str', required => 1 ); 
has yahoo => ( is => 'ro', isa => 'Geo::Coder::Yahoo', lazy_build => 1 ); #, handles => [qw/geocode/]); 

sub _build_yahoo { 

    my $self = shift; 
    Geo::Coder::Yahoo->new( appid => $self->appid ); 

}


sub process {
    my ( $self, $location ) = @_;
    my $results = $self->yahoo->geocode( location => $location );
    if ( $results->[0] and $results->[0]->{latitude} and $results->[0]->{longitude}  ) {
        my $rs = Geo::Coder::Any::Location->new($self->_normalize($results->[0]));
        return { result => $rs };
    }
}

=head1 _normalize($in)

Normalize data returned from Geo::Coder::Yahoo for use with Geo::Coder::Any.
Much less finer grain than Geo::Coder::Google, so some hacking must
be done to populate all the proper hash keys

=cut

sub _normalize {
    my ( $self, $in ) = @_;

    my $rs = {
        'latitude'  => $in->{latitude},
        'longitude' => $in->{longitude},
        'address'   => $in->{address},
       # 'thoroughfare'        => $locality->{Thoroughfare}->{ThoroughfareName},
       # 'locality'            => $locality->{LocalityName},
       # 'administrative_area' => $aa->{AdministrativeAreaName} || '',
       # 'sub_administrative_area' => $aa->{SubAdministrativeArea}->{SubAdministrativeAreaName} || '',
        'country' => $in->{country},
    };

    return $rs;
}


=head1 example Yahoo! data

This is what Geo::Coder::Yahoo returns.  Much coarser grain than Geo::Coder::Yahoo.

    {
     'country' => 'US',
     'longitude' => '-118.3387',
     'state' => 'CA',
     'zip' => '90028',
     'city' => 'LOS ANGELES',
     'latitude' => '34.1016',
     'warning' => 'The exact location could not be found, here is the closest match: Hollywood Blvd At N Highland Ave, Los Angeles, CA 90028',
     'address' => 'HOLLYWOOD BLVD AT N HIGHLAND AVE',
     'precision' => 'address'
     }
=cut
1;

