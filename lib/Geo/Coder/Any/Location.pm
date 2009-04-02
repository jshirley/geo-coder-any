package Geo::Coder::Any::Location;

use Moose;

=head1 NAME

Geo::Coder::Any::Location - A normalized record describing a coordinate in
space.

=head1 ATTRIBUTES

=head2 address

The normalized street address, in a pretty format ready to send to your users

=head2 latitude

=head2 longitude

=head2 thoroughfare

The street, and just the street information

=head2 sub_administrative_area

This is typically what you would think of as a city, an independent area.
Inspired from the Google responses

=head2 administrative_area

The description of the unit under the country, in the USA this would be the 
state

=head2 geocoder

What is the geocoder that returned this object?  Well, that's this object.

You can even do:

 $location->process( $new_location );

=cut

has 'geocoder' => ( is => 'ro', isa => 'Object' );

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

has 'geocoder' => ( is => 'ro', isa => 'Object' );

1;
