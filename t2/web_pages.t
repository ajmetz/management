
# Custom Libraries:
use Path::Tiny;
use lib path(__FILE__)->parent->sibling('lib')->realpath->stringify;

# Standard Test Boilerplate:
use Management::Boilerplate::Test;

# Specific Modules used:
use Test::Mojo;

=pod Name, Version, Synopsis, Description

=encoding utf8

=head1 NAME

humble_beginnings.t Test File.

=head1 VERSION

v1.0.0

=cut

our $VERSION                                                        =   'v1.0.0';

=head1 SYNOPSIS

    yath -v # Will automatically run tests found in the ./t2 folder ( such as this test ), in verbose mode.

=head1 DESCRIPTION

Begins to implement test driven development for the Management Mojolicious WebApp by Andrew Mehta.

=cut


=head2 Initial Test.

First we test to see if the test is functioning correctly.

=cut

ok( 1                                                               ,   "Testing our test can function."    );


=head2 get_ok Tests

These tests create a new Test::Mojo object, and use the get_ok method to see if the expected webpages can be obtained.
In each case, a status 200 is sought, and then the content is tested via either a content_like method call,
or a specific DOM lookup via C<< tx->res->dom->at >> etc.

=cut

my  $test_object                                                    =   Test::Mojo->new('Management');
my  $with_german_language_config                                    =   {
                                                                            $test_object->app->config->%*,
                                                                            'default_language'              =>  'de-DE',
                                                                        };
my  $german_test_object                                             =   Test::Mojo->new('Management'        ,   $with_german_language_config);
                                                                        # This approach should be refactored. Tests are better performed in a loop for each available language.

# Get Tests
ok( $test_object->get_ok('/hello')->status_is(200)
    ->content_like(qr/hello/i)->success                             ,   'Our Hello World page appears to work.' );
ok( $test_object->get_ok('/website01_static.htm')->status_is(200)
    ->tx->res->dom->at('canvas#myChart')                            ,   'We have a chart on a static page.'     );
ok( $test_object->get_ok('/dynamic01')->status_is(200)
    ->tx->res->dom->at('canvas#myChart')                            ,   'We have a chart on a dynamic page.'    );
ok( $test_object->get_ok('/')->status_is(200)
    ->content_like(qr/management/i)->success                        ,   'Our home page shows our categories.'   );
ok( $test_object->get_ok('/outcomes')->status_is(200)
    ->content_like(qr/print/i)->success                             ,   'Our outcomes page shows our outcomes.' );
ok( $test_object->get_ok('/entries')->status_is(200)
    ->content_like(qr/input/i)->success                             ,   'Our entries page requests input.'      );
ok( $german_test_object->get_ok('/entries')->status_is(200)
    ->content_like(qr/Eingabe/i)->success                           ,   'Our german entries page requests input'.
                                                                        ' in German.'                           );

done_testing();

=head1 AUTHOR

Andrew Mehta

=cut

__END__

Old lines that could prove useful again later:
#use lib path(__FILE__)->parent->parent->realpath->stringify;



like    (   $entry_object->save_data        ,   hash {
                                                    #field entries => T();
                                                    field entries => array { item 0 => hash { all_values => T() } };
#                                                   field entries => hash { prop size => '3' };
                                                },                                                      'Our Entry save data has an'.
                                                                                                        ' entries key with true values'         );
                                                                                                        
                                                                                                        
========

my  $dummy_data_for_entry_factory   =
'
15:02-15:15 - YOUTUBE		- Watched youtube videos.
15:22-15:26 - PLANNING		- Getting organised.
hjkdfshflhflaflalh
adjdkjd
15:22-cjcxkxl something.
15:34-15:35 - SOMETHING		- Else.
';


my  $entry_factory_object                   =   EntryFactory->new();
isa_ok  (   $entry_factory_object           ,   ['EntryFactory'],                                       'Our EntryFactory is an EntryFactory.'  );
# Details of entryfactory stuff will have to wait, since the way it handles categories is not current to our present desired approach - it anticipated only one category. 

# Input tests:
#ok($test_object->post_ok('/entries', form => { type => 'confirm' })->status_is(200)->tx->res->dom->at('textarea#data'),             'Our entries page has a textarea'.
#                                                                                                        ' for data input.'                      );

