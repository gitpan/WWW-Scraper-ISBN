package WWW::Scraper::ISBN;

use 5.008;
use strict;
use warnings;

use WWW::Scraper::ISBN::Record;
use Carp;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use WWW::Scraper::ISBN ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.18';


# Preloaded methods go here.
sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	$self->{DRIVERS} = [];
	bless ($self, $class);
	return $self;
}

sub drivers {
	my $self = shift;
	$self->{DRIVERS} = [];
	while ($_ = shift) {  push @{$self->{DRIVERS}}, $_; }
	foreach my $driver ( @{ $self->{DRIVERS} }) {
		require "WWW/Scraper/ISBN/".$driver."_Driver.pm";
	}
	return @{ $self->{DRIVERS} };
}

sub search {
	my $self = shift;
	my $isbn = shift;
	if( $self->drivers == 0 ) {
		croak("No search drivers specified.\n");
	}
	my $record = WWW::Scraper::ISBN::Record->new();
	$record->isbn($isbn);
	foreach my $driver_name (@{ $self->{DRIVERS} }) {
		my $driver = "WWW::Scraper::ISBN::${driver_name}_Driver"->new();
		$driver->search($record->isbn);
		if ($driver->found) {
			$record->found("1");
			$record->found_in("$driver_name");
			$record->book($driver->book);
			last;
		}
		if ($driver->error) {
			$record->error($record->error.$driver->error);
		}
	}
	return $record;
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

WWW::Scraper::ISBN - Perl extension for retrieving information about books (e.g., title, author, etc) from a variety of 
sources on the internet, by ISBN number.

=head1 SYNOPSIS

  use WWW::Scraper::ISBN;
  my $scraper = WWW::Scraper::ISBN->new();
  $scraper->drivers("Driver1", "Driver2");
  my $isbn = "123456789X";
  my $record = $scraper->search($isbn);
  if($record->found) {
	print "Book ".$record->isbn." found by driver ".$record->found_in."\n";
	my $book = $record->book;
	# do stuff with book hash
	print $book->{'title'};
	print $book->{'author'};
  	# etc
  } else {
	print $book->error;
  }

=head1 REQUIRES

Requires the following modules be installed:

WWW::Scraper::ISBN::Record
Carp

=head1 DESCRIPTION

The WWW::Scraper::ISBN class was built as a way to retrieve information on books from multiple sources 
easily.  It utilizes at least one driver implemented as a subclass of WWW::Scraper::ISBN::Driver, each of 
which is designed to scrape from a single source.  Because we found that different sources had different 
information available on different books, we designed a basic interface that could be implemented in 
whatever ways necessary to retrieve the desired information.

=head2 EXPORT

None by default.

=head1 METHODS

=head2 new()

Class constructor.  Returns a reference to an empty scraper object.  No drivers by default

=head2 drivers() or drivers($DRIVER1, $DRIVER2)

foreach my $driver ( $scraper->drivers() ) { ... }

$scraper->drivers("DRIVER1", "DRIVER2");

Accessor/Mutator method which handles the drivers that this instance of the WWW::Scraper::ISBN class 
should utilize.  The appropriate driver module must be installed (e.g. WWW::Scraper::ISBN::DRIVER1_Driver 
for "DRIVER1", etc.).  The order of arguments determines the order in which the drivers will be searched.

When this method is called, it loads the specified drivers using 'require'.

Must be set before search() method is called.

=head2 search($isbn)

my $record = $scraper->search("123456789X");

Searches for information on the given ISBN number.  It goes through the drivers in the order they are 
specified, stopping when the book is found or all drivers are exhausted.  It returns a 
WWW::Scraper::ISBN::Record object, which will have its found() field set according to whether or not the 
search was successful.

=head1 CODE EXAMPLE

use WWW::Scraper::ISBN;

# instantiate the object
my $scraper = WWW::Scraper::ISBN->new();

# load the drivers.  requires that 
#	WWW::Scraper::ISBN::LOC_Driver and
#	WWW::Scraper::ISBN::ISBNnu_Driver 
# be installed
$scraper->drivers("LOC", "ISBNnu"); 

@isbns = [ "123456789X", "132457689X", "987654321X" ];

foreach my $num (@isbns) {
	$scraper->isbn($num);
	$scraper->search($scraper->isbn);
	if ($scraper->found) {
		my $b = $scraper->book;
		print "Title: ".$b->{'title'}."\n";
		print "Author: ".$b->{'author'}."\n\n";
	} else {
		print "Book: ".$scraper->isbn." not found.\n\n";
	}
}

=head1 SEE ALSO

WWW::Scraper::ISBN::Driver
WWW::Scraper::ISBN::Record

No mailing list or website currently available.  Primary development done through CSX [http://csx.calvin.edu/]

=head1 AUTHOR

Andy Schamp, E<lt>ams5@calvin.eduE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2004 by Andy Schamp

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
