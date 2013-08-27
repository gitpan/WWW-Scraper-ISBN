package WWW::Scraper::ISBN::Test_Driver;

use base qw(WWW::Scraper::ISBN::Driver);

sub search {
    my $self = shift;
    my $isbn = shift;

    if($isbn ne '123456789X') {
        $self->found(0);
        $self->book(undef);
        return;
    }

    my $bk = {
        isbn    => $isbn,
        title   => 'test title',
        author  => 'test author'
    };

    $self->book($bk);
    $self->found(1);
    return $self->book;
}

1;
