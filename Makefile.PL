#!/usr/bin/perl

use strict;
use warnings;
use 5.006;

use ExtUtils::MakeMaker;

WriteMakefile(
    AUTHOR              => 'Barbie <barbie@cpan.org>',
    NAME                => 'WWW::Scraper::ISBN',
    VERSION_FROM        => 'lib/WWW/Scraper/ISBN.pm',
    ABSTRACT            => 'Retrieve information about books from online sources',
    NO_META             => 1,
    PREREQ_PM           => {

        # runtime prereqs
		'Carp'                          => '1.00',
		'WWW::Scraper::ISBN::Driver'    => '0.20',
		'WWW::Scraper::ISBN::Record'    => '0.19',

        # build/test prereqs
        'IO::File'                      => '0',
        'Test::More'                    => '0.88'

    }
);
