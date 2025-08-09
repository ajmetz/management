
# Custom Libraries:
use Path::Tiny;
use lib path(__FILE__)->parent->sibling('lib')->realpath->stringify;

# Standard Test Boilerplate:
use Management::Boilerplate::Test;

# Specific Modules used:
use Test::Mojo;
use Management::Model::Data;

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

=head2 Dummy Data.

Then we create Dummy Data we will need...

=cut

# Dummy Data for Object Tests:

# (No dummy data yet)

=head2 Object Tests.

Then we begin testing our Management::Model::Data Object...

=cut

# Object Tests:
my          $data               =   Management::Model::Data->new(
                                        database    =>  Test::Mojo->new('Management')->app->database,
                                    );
isa_ok  (   $data               ,   ['Management::Model::Data'],                            'Our Management::Model::Data object is '.
                                                                                            'of Management::Model::Data class.'     );
like    (   $data->retrieve     ,   hash {
                                                    #field entries => T();
                                                    #field entries => hash { all_values => T() };
                                                    field categories => hash { all_values => T() };
                                                    field top_categories => hash { all_values => T() };
                                                    field entries_categories => hash { all_values => T() };
#                                                   field entries => hash { prop size => '3' };
                                                },                                                  'Our Entry, Category, '.
                                                                                                    'and Top Categories data '.
                                                                                                    'can be retrieved'              );

done_testing();

=head1 AUTHOR

Andrew Mehta

=cut

__END__

Old lines that could prove useful again later:
#use lib path(__FILE__)->parent->parent->realpath->stringify;
