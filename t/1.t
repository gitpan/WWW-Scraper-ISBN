# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 1;
use Data::Dump qw{ dump };
BEGIN { use_ok('WWW::Scraper::ISBN') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.


my $src = WWW::Scraper::ISBN->new();
$src->drivers( "LOC", "ISBNnu" );
my $book_record = $src->search("0195083792");
if ($book_record->found) {
	print "found!\n";
	print "found in: ".$book_record->found_in."\n";
	print "book:\n";
	dump($book_record->book);
} else {
	print "woah!\n";
	print "crapnotfound\n";
}
