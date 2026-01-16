
# Custom Libraries:
use Path::Tiny;
use lib path(__FILE__)->parent->sibling('lib')->realpath->stringify;

# Standard Test Boilerplate:
use Management::Boilerplate::Test;

# Specific Modules used:
use Test::Mojo;
use Entry;

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

ok(1, "Testing our test can function.");

=head2 Dummy Data.

Then we create Dummy Data we will need...

=cut

# Dummy Data for Object Tests:

my  @dummy_data_for_entry           =    (
                                            start_year      =>  '2025',
                                            start_month     =>  '1',
                                            start_day       =>  '1',
                                            start_time      =>  '0:00',

                                            end_year        =>  undef,      # Should be capable of assuming the same year/month/day as start if not stated.
                                            end_month       =>  undef,
                                            end_day         =>  undef,
                                            end_time        =>  '23:59',

                                            #top_category    =>  'Other',
                                            #category        =>  'Event',
                                            categories      =>  [
                                                                    'Event',
                                                                    'Silliness',
                                                                ],
                                            details         =>  'Did a day.',
                                        );

=head2 Object Tests.

Then we begin testing our Entry Object...

=cut

# Object Tests:
my          $entry_object                   =   Entry->new(@dummy_data_for_entry);
isa_ok  (   $entry_object                   ,   ['Entry'],                                              'Our Entry is an Entry.'                );
#can_ok  (   $entry_object                   ,   ['save_data'],                                          'Our Entry has a save_data method.'     );
#ok      (   $entry_object->save_data->%*    ,                                                           'Our Entry can deliver'.
#                                                                                                        ' some kind of save data.'              );
#like    (   $entry_object->save_data        ,   hash {
                                                        #field entries => T();
#                                                        field entries => array { item 0 => hash { all_values => T() } };
                                                        #field entries => hash { prop size => '3' };
#                                                },                                                      'Our Entry save data has an'.
#                                                                                                        ' entries key with true values'         );
like    (   $entry_object->start_epoch      ,   qr/^\p{Digit}+$/,                                       'Start Epoch is one or more digits'     );
like    (   $entry_object->end_epoch        ,   qr/^\p{Digit}+$/,                                       'End Epoch is one or more digits'       );
ok      (   $entry_object->start_epoch <= $entry_object->end_epoch,                                     'Start Epoch is less '.
                                                                                                        'or equal to End Epoch'                 );
ok      (   $entry_object->end_epoch >= $entry_object->start_epoch,                                     'End Epoch is less '.
                                                                                                        'or equal to Start Epoch'               );
like    (   $entry_object->duration         ,   qr/^\p{Digit}+hr \p{Digit}+mins$/,                      'We have the expected duration string'  );

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
