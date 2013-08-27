#!/usr/bin/perl -w
use strict;

use lib qw(t/lib);

use Test::More tests => 18;
use WWW::Scraper::ISBN;

my $scraper = WWW::Scraper::ISBN->new();
isa_ok($scraper,'WWW::Scraper::ISBN');
my $scraper2 = $scraper->new();
isa_ok($scraper2,'WWW::Scraper::ISBN');

my @drivers = $scraper->drivers("Test");
is(@drivers,1);
is($drivers[0],'Test');
@drivers = $scraper->reset_drivers();
is(@drivers,0);

my $isbn = "123456789X";
my $record;
eval { $record = $scraper->search($isbn) };
like($@,qr/No search drivers specified/);

@drivers = $scraper->drivers("Test");
is(@drivers,1);
is($drivers[0],'Test');

eval { $record = $scraper->search($isbn) };
is($@,'');
isa_ok($record,'WWW::Scraper::ISBN::Record');
is($record->found,1);
my $b = $record->book;
is($b->{isbn},'123456789X');
is($b->{title},'test title');
is($b->{author},'test author');

$isbn = "1234567890";
eval { $record = $scraper->search($isbn) };
is($@,'');
isa_ok($record,'WWW::Scraper::ISBN::Record');
is($record->found,0);
$b = $record->book;
is($b,undef);
