
# Custom Libraries:
use Path::Tiny;
use lib path(__FILE__)->parent->sibling('lib')->realpath->stringify;

# Standard Test Boilerplate:
use Management::Boilerplate::Test;

# Specific Modules used:
use Test::Mojo;
use Day;
use Entry;
use TimeRange;

=pod Name, Version, Synopsis, Description

=encoding utf8

=head1 NAME

humble_beginnings.t Test File.

=head1 VERSION

v1.0.0

=cut

our $VERSION                    =   'v1.0.0';

=head1 SYNOPSIS

    yath -v # Will automatically run tests found in the ./t2 folder ( such as this test ), in verbose mode.

=head1 DESCRIPTION

Begins to implement test driven development for the Management Mojolicious WebApp by Andrew Mehta.

=cut


=head2 Initial Test.

First we test to see if the test is functioning correctly.

=cut

ok(1, "Testing our test can function.");


=head2 get_ok Tests

These tests create a new Test::Mojo object, and use the get_ok method to see if the expected webpages can be obtained.
In each case, a status 200 is sought, and then the content is tested via either a content_like method call,
or a specific DOM lookup via C<< tx->res->dom->at >> etc.

=cut

my  $test_object    =   Test::Mojo->new('Management');
my  $german_test_object    =   Test::Mojo->new('Management',{'default_language' => 'de-DE'});

# Get Tests
ok($test_object->get_ok('/hello')->status_is(200)->content_like(qr/hello/i)->success,                   'Our Hello World page appears to work.' );
ok($test_object->get_ok('/website01_static.htm')->status_is(200)->tx->res->dom->at('canvas#myChart'),   'We have a chart on a static page.'     );
ok($test_object->get_ok('/dynamic01')->status_is(200)->tx->res->dom->at('canvas#myChart'),              'We have a chart on a dynamic page.'    );
ok($test_object->get_ok('/')->status_is(200)->content_like(qr/management/i)->success,                   'Our home page shows our categories.'   );
ok($test_object->get_ok('/outcomes')->status_is(200)->content_like(qr/print/i)->success,                'Our outcomes page shows our outcomes.' );
ok($test_object->get_ok('/add_entry')->status_is(200)->content_like(qr/input/i)->success,               'Our add_entry page requests input.'    );
ok($german_test_object->get_ok('/add_entry')->status_is(200)->content_like(qr/Eingabe/i)->success,      'Our add_entry page requests input'.
                                                                                                        ' in German too.'                       );

# HTML form tests:
ok($test_object->get_ok('/add_entry')->status_is(200)->tx->res->dom->at('form')
                                                                    ->matches('form[method=POST]'),     'Has input form with POST method'       ); # Didn't pass without the "at" before "matches". Find could be used, and returns Mojo Collection of find results, so not an assertion of a match.
ok($test_object->get_ok('/add_entry')->status_is(200)->tx->res->dom->at('textarea#data'),               'Our add_entry page has a textarea'.
                                                                                                        ' for data input.'                      );

# Object Tests:
my  $time_range_object      =   TimeRange->new();
isa_ok($time_range_object   ,   ['TimeRange'],                                                          'Our TimeRange is a TimeRange.'         );

my  $day_object             =   Day->new();
isa_ok($day_object          ,   ['Day'],                                                                'Our Day is a Day.'                     );

my  $entry_object           =   Entry->new();
isa_ok($entry_object        ,   ['Entry'],                                                              'Our Entry is an Entry.'                );

done_testing();

=head1 AUTHOR

Andrew Mehta

=cut

__END__

Old lines that could prove useful again later:
#use lib path(__FILE__)->parent->parent->realpath->stringify;
