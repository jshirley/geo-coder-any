package Geo::Coder::Any::Yahoo;

use Moose;

use Geo::Coder::Yahoo;
use Geo::Coder::Any::Location;

=head1 NAME

Geo::Coder::Any::Yahoo - Interface to Geo::Coder::Yahoo

=head1 SYNOPSIS

    use Geo::Coder::Any;

    my $ga = Geo::Coder::Any->new(
        steps => [
            'Yahoo' => { apikey => $YOUR_YAHOO_API_KEY }
        ]
    );
    # Returns a Geo::Coder::Any::Location object
    my $result = $ga->geocode('1600 NE Pennsylvania Ave, Washington D.C.');

=head1 DESCRIPTION

This class is simply an adapter for L<Geo::Coder::Yahoo> and profies a simple
unified interface that works with L<Geo::Coder::Any>.

=cut

has apikey => ( 
    is  => 'ro', 
    isa => 'Str', 
    required => 1 
);

has yahoo => ( 
    is  => 'ro', 
    isa => 'Geo::Coder::Yahoo', 
    lazy_build => 1 
); #, handles => [qw/geocode/]); # would be nice

sub _build_yahoo { 
    my $self = shift; 
    Geo::Coder::Yahoo->new( appid => $self->apikey ); 
}

=head1 METHODS

=head2 process($location)

This method geocodes the incoming $location against the Yahoo API and wil return
a L<Geo::Coder::Any::Location> object

=cut

sub process {
    my ( $self, $location ) = @_;
    my $results = $self->yahoo->geocode( location => $location );
    if ( $results->[0] and $results->[0]->{latitude} and $results->[0]->{longitude}  ) {
        my $rs = Geo::Coder::Any::Location->new($self->_normalize($results->[0]));
        return { result => $rs };
    }
}

=head2 _normalize($in)

Normalize data returned from Geo::Coder::Yahoo for use with Geo::Coder::Any.
Much less finer grain than Geo::Coder::Google, so some hacking must
be done to populate all the proper hash keys

=cut

sub _normalize {
    my ( $self, $in ) = @_;
    my $rs = {
        'geocoder'  => $self,
        'latitude'  => $in->{latitude},
        'longitude' => $in->{longitude},
        'address'   => $in->{address},
        'administrative_area' => $in->{state} || '',
        'sub_administrative_area' => $in->{city} || '',
        'country' => $in->{country},
    };

    return $rs;
}


# This is what Geo::Coder::Yahoo returns.  Much coarser grain than 
# Geo::Coder::Google.
#
# {
#     'country' => 'US',
#     'longitude' => '-118.3387',
#     'state' => 'CA',
#     'zip' => '90028',
#     'city' => 'LOS ANGELES',
#     'latitude' => '34.1016',
#     'warning' => 'The exact location could not be found, here is the closest match: Hollywood Blvd At N Highland Ave, Los Angeles, CA 90028',
#     'address' => 'HOLLYWOOD BLVD AT N HIGHLAND AVE',
#     'precision' => 'address'
# }

=head1 AUTHOR

J. Shirley C<< <jshirley@toeat.com> >>

Devin Austin C<< <dhoss@toeat.com> >>


=cut
1;

