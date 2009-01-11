package Geo::Coder::Any;

use Moose;

=head1 NAME

Geo::Coder::Any - The great new Geo::Coder::Any!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Geo::Coder::Any;

    my $foo = Geo::Coder::Any->new();
    ...

=head1 METHODS 

=cut

## set up "steps"
## A step is:
## An atomic geocoding unit, that attempts a lookup and returns a match 
## or if no match is found it is to return undef.
## Example: 
##   $geo->steps([ 'Google' => { api_key => 'abcdef' } ]);


has 'steps' => (
   isa => 'ArrayRef[Object]'
);

=head1 geocode

  iterate through the steps (see definition above) until we get
  a valid response

=cut

sub geocode {
    my ( $self, $location ) = @_;
    foreach my $step ( @{ $self->steps } ) {
        my $response = $step->process($location); };
        if ( $response and $response->{result} ) {
            # Got a valid response
            return $response->{result};
        }
        if ( $response and $response->{location} ) {
            $location = $response->{location};
        }
    }
}

=head1 BUILD

Setup the Geo::Coder::Any object and the steps.

Construction is:

 Geo::Coder::Any->new(
    steps => [
        'Google' => {
            api_key => 'abcdefghjijklmnopqrstuvwxyz'
        }
    ] 
 );

=cut

sub BUILD {
    my ( $self ) = @_;

    my @stores = @{ $self->steps };

    my @configured_steps = ();
    while ( @stores ) {
        my ( $name, $config ) = (shift @stores, shift @stores);
        die "$name config is not a hash reference"
            unless $config and ref $config eq 'HASH';
        my $class = "Geo::Coder::Any::$name";
        if ( $name =~ /^\+/ ) {
            $class = $name;
        }
        Class::MOP::load_class($class)
            unless Class::MOP::is_class_loaded($class);

        my $s = $class->new( $config );
        # Maybe?
        # croak "Argh, can't configure $class!" unless $s;
        push @configured_steps, $s if $s;
    }
    $self->steps( \@configured_steps );

    return $self;

}

=head1 AUTHOR

ToEat.com Developers, C<< <cpan at toeat.com> >>

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

Copyright 2009 ToEat.com Developers, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Geo::Coder::Any



