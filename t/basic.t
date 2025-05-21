use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Management');
$t->get_ok('/hello')->status_is(200)->content_like(qr/hello/i);

done_testing();
