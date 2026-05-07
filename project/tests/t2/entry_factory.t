
# Custom Libraries:
use Path::Tiny;
use lib path(__FILE__)->parent->parent->sibling('lib')->realpath->stringify;

# Standard Test Boilerplate:
use Management::App::Boilerplate::Test;

# Specific Modules used:
use Test::Mojo;
use Management::App::MVC::Model::BusinessLogic::EntryFactory;
use Mojo::Util qw(dumper);

=pod Name, Version, Synopsis, Description

=encoding utf8

=head1 NAME

entry.t Test File for testing Entry.pm module.

=head1 VERSION

v1.0.0

=cut

our $VERSION                =   'v2.0.0';

=head1 SYNOPSIS

    yath -v # Will automatically run tests found in the ./t2 folder ( such as this test ), in verbose mode.

=head1 DESCRIPTION

Test driven development for the Entry.pm perl module that is part of the Management webapp by Andrew Mehta.

=cut


=head2 Initial Test.

First we test to see if the test is functioning correctly.

=cut

ok(
    1                       ,   "Testing our test can function."
);

=head2 Dummy Data.

Then we create Dummy Data we will need...

=cut

# Dummy Data for Object Tests:
my  $test_app_config        =   {
                                    secrets             =>  ['wakkawakka'],
                                    default_language    =>   'en-GB',
                                    sqlite_file         =>  '../../data/database/test_database.db',
                                    migration_file      =>  'lib/Management/SQL/database_migration.sql',
                                };
my  $test_app               =   Test::Mojo->new('Management',$test_app_config)->app;


=head2 Object Tests.

Then we begin testing our Entry Object...

=cut

my  $regex_one_or_more_digits                   =   qr/^\p{Digit}+$/;

my @dummy_data_for_entry_factory = (

#'29-04-2026',   # Date with dashes # While this date is what we type as humans, the html form in the webpage will deliver yyyy-mm-dd instead.
'2026-04-29',   # Providing value as a html date input field would.
'
15:02-15:15 - YOUTUBE		- Watched youtube videos.
15:22-15:26 - PLANNING		- Getting organised.
hjkdfshflhflaflalh
adjdkjd
15:22-cjcxkxl something.
15:34-15:35 - SOMETHING		- Else.
',

);
# Object Tests:
my          $entry_factory_object               =   Management::App::MVC::Model::BusinessLogic::EntryFactory->new(logger => $test_app->logger);


isa_ok  (   $entry_factory_object               ,   ['Management::App::MVC::Model::BusinessLogic::EntryFactory'],   'Our Entry is a Management::App::MVC::Model::BusinessLogic::EntryFactory.'  );

like(
    [$entry_factory_object->multiple_entries(@dummy_data_for_entry_factory)], # Needs to be an arrayref for the array check below to work
    array {
        all_items check_isa 'Management::App::MVC::Model::BusinessLogic::Entry';
    }                                           ,                                                           'Multiple Entries method returns an array of multiple entry object instances.'
);

=head2 Done.

Finally, we finish with C<done_testing();>.

=cut

done_testing();

=head1 AUTHOR

Andrew Mehta

=cut

__END__



Old lines that could prove useful again later:
#use lib path(__FILE__)->parent->parent->realpath->stringify;

#can_ok  (   $entry_object                   ,   ['save_data'],                                          'Our Entry has a save_data method.'     );
#ok      (   $entry_object->save_data->%*    ,                                                           'Our Entry can deliver'.
#                                                                                                        ' some kind of save data.'              );
#like    (   $entry_object->save_data        ,   hash {
                                                        #field entries => T();
#                                                        field entries => array { item 0 => hash { all_values => T() } };
                                                        #field entries => hash { prop size => '3' };
#                                                },                                                      'Our Entry save data has an'.
#                                                                                                        ' entries key with true values'         );

======



warn $retrieved_entry->status_string;
warn dumper($retrieved_entry->status_array);
warn $entry_object->details.':'.$retrieved_entry->details;

my  $status_categories_string   =   
warn $status_categories_string;
warn 'This is what we are comparing against our test...';
my @status_array_categories = $retrieved_entry->status_array;
warn $status_array_categories[9];
warn 'This is what we are testing against our compare...';
warn $entry_object->details;

warn 'This is our entry object\'s status string...';
warn $entry_object->status_string;


#warn $retrieved_entry->status_string;
#warn dumper(deconstruct_object($retrieved_entry));

# * fetch our last save by id
# * check it's the same entry we created

#my  $test_object            =   Test::Mojo->new('Management');

#$test_object->app->entry->create(@dummy_data_for_entry)->retrieve_last_saved;
