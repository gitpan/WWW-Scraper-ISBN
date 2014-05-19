#!/usr/bin/perl -w
use strict;

use lib qw(t/lib);

use Test::More;
use WWW::Scraper::ISBN;

# Can we create the object?

my $scraper = WWW::Scraper::ISBN->new();
isa_ok($scraper,'WWW::Scraper::ISBN');
my $scraper2 = $scraper->new();
isa_ok($scraper2,'WWW::Scraper::ISBN');

# can we handle drivers?

my @drivers = $scraper->drivers("Test");
is(@drivers,1);
is($drivers[0],'Test');
@drivers = $scraper->reset_drivers();
is(@drivers,0);

# Can we search for a vslid ISBN, with no driver?

my $isbn = "123456789X";
my $record;
eval { $record = $scraper->search($isbn) };
like($@,qr/No search drivers specified/);

@drivers = $scraper->drivers("Test");
is(@drivers,1);
is($drivers[0],'Test');

# Can we search for a vslid ISBN, with driver?

eval { $record = $scraper->search($isbn) };
is($@,'');
isa_ok($record,'WWW::Scraper::ISBN::Record');
is($record->found,1);
my $b = $record->book;
is($b->{isbn},'123456789X');
is($b->{title},'test title');
is($b->{author},'test author');

# Can we search for an invalid ISBN?

$isbn = "1234567890";
$record = undef;
eval { $record = $scraper->search($isbn) };

# Note: validation is different if Business::ISBN is installed

like($@,qr/Invalid ISBN specified/);
is($record,undef);

done_testing();
