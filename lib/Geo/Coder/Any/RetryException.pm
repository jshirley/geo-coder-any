package Geo::Coder::Any::RetryException;

use Moose;

=head1 NAME

Geo::Coder::Any::RetryException - Die with this to restart a new

=head1 SYNOPSIS

This is an internal class for developing your own Geo::Coder::Any plugins, and
gives a capability to start from the very top, doing a recursive Geo::Coder::Any
call.  In your Geo::Coder::Any plugin, simply do:

    die Geo::Coder::Any::RetryException->new( location => 'New Location' );

I'll leave this to your imagination as to why this is useful.

=cut

has 'location' => (
    is  => 'ro',
    isa => 'Str',
    required => 1
);

1;
