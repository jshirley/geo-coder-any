package Geo::Coder::Any::Map;

use Moose;

sub process {
    my ( $self, $location ) = @_;
    return { location => '1600 NW Pennsylvania Ave Washington Dc' };
}

1;
