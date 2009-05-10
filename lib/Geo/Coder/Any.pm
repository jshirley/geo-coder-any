package Geo::Coder::Any;

use Carp;
use Moose;

=head1 NAME

Geo::Coder::Any - Use flexible (and custom) geocoders

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Geo::Coder::Any is a processing pipeline for coupling and normalizing
Geo::Coder modules.  L<Geo::Coder::Google> and L<Geo::Coder::Yahoo> support is
shipped within this module.


    use Geo::Coder::Any;

    my $ga = Geo::Coder::Any->new();
    my $results = $ga->geocode('1600 Pennsylvania Ave Washington DC');

=head1 ATTRIBUTES

=head2 steps

A step is an individual geocoder that will attempt a lookup and returns a match 
or if no match is found it is to return undef.

=head1 steps


This is configured upon creation, such as:

    Geo::Coder::Any->new(
        steps => [ 
            'Google' => { api_key => 'abcdef' },
            'Yahoo'  => { api_key => 'byah'   },
        ]
    );

=cut

has 'steps' => (
    is => 'rw',
    isa => 'ArrayRef'
);

has 'geocoders' => (
    is => 'rw',
    isa => 'ArrayRef[Object]',
    clearer => 'reset_geocoders'
);


=head1 METHODS

=head2 geocode($address)

Iterate through the steps (see definition above) until we get a valid response.

=cut

sub geocode {
    my ( $self, $location, @skips ) = @_;
    foreach my $step ( @{ $self->geocoders } ) {
        next if grep { $step == $_ } @skips;

        my $response = eval { $step->process($location); };
        if ( $@ and 
            ( Scalar::Util::blessed($@) and $@->isa('Geo::Coder::Any::RetryException') )
        ){
            return $self->geocode( $@->location );
        }

        if ( $response and $response->{result} ) {
            # Got a valid response
            return $response->{result};
        }
        if ( $response and $response->{location} ) {
            $location = $response->{location};
            next;
        }
    }
}

=head1 INTERNAL METHODS

Here be dragons, you've been warned.  
=head2 BUILD

Setup the Geo::Coder::Any object and the steps.

Construction is:

 Geo::Coder::Any->new(
    steps => [
        'Google' => {
            api_key => 'abcdefghjijklmnopqrstuvwxyz'
        },
        'Yahoo'  => {
            appid => 'wharrrrgarrrrgarrrrgarrrrrbllll'
         },
    ] 
 );

=cut

sub BUILD {
    my ( $self ) = @_;
    $self->_configure_steps( $self->steps );

    return $self;

}

sub _configure_steps {
    my ( $self, $steps ) = @_;

    $self->reset_geocoders;

    return unless $steps and ref $steps eq 'ARRAY';

    my @stores = @$steps;

    my @configured_steps = ();
    while ( @stores ) {
        my ( $name, $config ) = (shift @stores, shift @stores);
        die "$name config is not a hash reference"
            unless $config and ref $config eq 'HASH';
        my $class;
        if ( $name =~ /^\+/ ) {
            $name =~ s/^\+//;
            $class = $name;
        } else {
            $class = join("::", ref($self), $name);
        }
        Class::MOP::load_class($class)
            unless Class::MOP::is_class_loaded($class);
        my $s = $class->new( %$config );
        croak "Unable to instantiate $class" unless defined $s;
        push @configured_steps, $s if $s;
    }
    $self->geocoders( \@configured_steps );
}

=head1 AUTHOR

J. Shirley C<< <jshirley@toeat.com> >>

Devin Austin C<< <dhoss@toeat.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-geo-coder-any at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Geo-Coder-Any>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Geo::Coder::Any


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Geo-Coder-Any>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Geo-Coder-Any>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Geo-Coder-Any>

=item * Search CPAN

L<http://search.cpan.org/dist/Geo-Coder-Any>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 The Authors, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Geo::Coder::Any



