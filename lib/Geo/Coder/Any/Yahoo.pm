package Geo::Coder::Any::Yahoo;

use Moose;
use Geo::Coder::Any::Location;

extends 'Geo::Coder::Yahoo';

=head1 new

new must be overridden. Geo::Coder::Yahoo assumes $class.

=cut

sub new {
    my ( $class, %args ) = @_;
    warn "Class: $class, Args: " . $args{appid};
    bless { $class, appid => $args{appid} };
} 


sub process {
    my ( $self, $location ) = @_;
    my @results = $self->geocode( location => $location );
    if ( $results[0] and $results[0]->{Point} ) {
        my $rs = Geo::Coder::Any::Location->new($self->_normalize($results[0]));
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

    my $aa = $in->{AddressDetails}->{Country}->{AdministrativeArea};

    my $locality = $aa->{SubAdministrativeArea}->{Locality} || 
                   $aa->{Locality};
    my $rs = {
        'latitude'  => $in->{country},
        'longitude' => $in->{longitude},
        'address'             => $in->{address},
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

