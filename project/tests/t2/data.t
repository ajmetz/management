
# Custom Libraries:
use Path::Tiny;
use lib path(__FILE__)->parent->parent->sibling('lib')->realpath->stringify;

# Standard Test Boilerplate:
use Management::App::Boilerplate::Test;

# Specific Modules used:
use Test::Mojo;
use Management::App::Model::Database::Data;

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
my          $app                =   Test::Mojo->new('Management')->app;
my          $data               =   Management::App::Model::Database::Data->new(
                                        database    =>  $app->database,
                                        logger      =>  $app->logger,
                                    );
isa_ok  (   $data               ,   ['Management::App::Model::Database::Data'],             'Our Management::App::Model::Database::Data object is '.
                                                                                            'of Management::App::Model::Database::Data class.'     );
#warn "Table Names:\n".join("\n", keys $data->table_list->%*);

like    (   $data->retrieve     ,   hash {
                                                    #field entries => T();
                                                    #field entries => hash { all_values => T() };
                                                    field categories => array { all_values => T() };
                                                    field top_categories => array { all_values => T() };
                                                    #field entries_categories => hash { all_values => T() };
#                                                   field entries => hash { prop size => '3' };
                                                },                                                  'Our '.
                                                                                                    #'Entry, '.
                                                                                                    'Category '.
                                                                                                    'and Top Categories data '.
                                                                                                    'can be retrieved.'              );

done_testing();

=head1 AUTHOR

Andrew Mehta

=cut

__END__

Old lines that could prove useful again later:
#use lib path(__FILE__)->parent->parent->realpath->stringify;



