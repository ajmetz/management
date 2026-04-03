
# Custom Libraries:
use Path::Tiny;
use lib path(__FILE__)->parent->parent->sibling('lib')->realpath->stringify;

# Standard Test Boilerplate:
use Management::App::Boilerplate::Test;

# Specific Modules used:
use Test::Mojo;
use Management::App::Model::TimeLog::Entry;
use Mojo::Util qw(dumper);
use Object::Pad::MetaFunctions qw(
        deconstruct_object
    );

=pod Name, Version, Synopsis, Description

=encoding utf8

=head1 NAME

entry.t Test File for testing Entry.pm module.

=head1 VERSION

v1.0.0

=cut

our $VERSION                    =   'v2.0.0';

=head1 SYNOPSIS

    yath -v # Will automatically run tests found in the ./t2 folder ( such as this test ), in verbose mode.

=head1 DESCRIPTION

Test driven development for the Entry.pm perl module that is part of the Management webapp by Andrew Mehta.

=cut


=head2 Initial Test.

First we test to see if the test is functioning correctly.

=cut

ok(
    1                                   ,   "Testing our test can function."
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
my  @dummy_data_for_entry   =   (
    
    logger          =>  $test_app->logger,
    start           =>  '01/01/2026 00:00',
    end             =>  '23:59', # Should be capable of assuming the same year/month/day as start if not stated.
    categories      =>  [
                            'Event',
                            'Silliness',
                        ],
    details         =>  'Did a day.',

);

=head2 Object Tests.

Then we begin testing our Entry Object...

=cut

my  $regex_one_or_more_digits                   =   qr/^\p{Digit}+$/;

# Object Tests:
my          $entry_object                       =   Management::App::Model::TimeLog::Entry->new(@dummy_data_for_entry);
isa_ok  (   $entry_object                       ,   ['Management::App::Model::TimeLog::Entry'],             'Our Entry is a Management::App::Model::TimeLog::Entry.'    );

like    (   $entry_object->start_epoch          ,   $regex_one_or_more_digits,                              'Start Epoch is one or more digits.'                        );
like    (   $entry_object->end_epoch            ,   $regex_one_or_more_digits,                              'End Epoch is one or more digits.'                          );
like    (   $entry_object->duration             ,   qr/^\p{Digit}+hr \p{Digit}+mins$/,                      'We have the expected duration string.'                     );

ok      (   $entry_object->start_epoch          <=  $entry_object->end_epoch,                               'Start Epoch is less '.
                                                                                                            'or equal to End Epoch'                                     );
                                                                                                        
ok      (   $entry_object->end_epoch            >=  $entry_object->start_epoch,                             'End Epoch is less '.
                                                                                                            'or equal to Start Epoch.'                                  );

ok      (  my $saved_entry = $test_app->database->data->entry->save($entry_object),                         'Entry can be saved to the test database.'                  );

like    (   $saved_entry->last_saved_entry_id   ,  $regex_one_or_more_digits,                               'We can obtain a numeric id for the last saved item.'       );

ok      (  my $retrieved_entry = $saved_entry->retrieve($saved_entry->last_saved_entry_id),                 'Entry values can be retrieved from test database,'.
                                                                                                            ' by entry id.'                                             ); # Not enough to construct full object.

isa_ok  (   $retrieved_entry                    ,   ['Management::App::Model::TimeLog::Entry'],             'Our Entry is a Management::App::Model::TimeLog::Entry.'    );

warn $retrieved_entry->status_string;
warn dumper(deconstruct_object($retrieved_entry));

# * fetch our last save by id
# * check it's the same entry we created

#my  $test_object            =   Test::Mojo->new('Management');

#$test_object->app->entry->create(@dummy_data_for_entry)->retrieve_last_saved;

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
