use 5.008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'WWW::Scraper::ISBN',
    'VERSION_FROM'	=> 'ISBN.pm', # finds $VERSION
    'PREREQ_PM'		=> {
			Carp => 1.0,
			WWW::Scraper::ISBN::Record => 0.15
			}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      ( AUTHOR     => 'Andy Schamp <andy@schamp.net>') : ()),
);
