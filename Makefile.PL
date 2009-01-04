use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Geo::Coder::Any',
    AUTHOR              => 'ToEat.com Developers <cpan@toeat.com>',
    VERSION_FROM        => 'lib/Geo/Coder/Any.pm',
    ABSTRACT_FROM       => 'lib/Geo/Coder/Any.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Geo-Coder-Any-*' },
);
