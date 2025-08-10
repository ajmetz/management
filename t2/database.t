
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

database.t Test File.

=head1 VERSION

v1.0.0

=cut

our $VERSION                    =   'v1.0.0';

=head1 SYNOPSIS

    yath -v # Will automatically run tests found in the ./t2 folder ( such as this test ), in verbose mode.

=head1 DESCRIPTION

Test driven development for the database connection for the Management webapp by Andrew Mehta.

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
my          $database    =  Test::Mojo->new('Management')->app->database;

ok      (   $database->ping,    'Can ping the database okay.');
#warn "Table Names:\n".join("\n", $database->tables->@*);
like    (   $database->tables     ,   array {
                                                    item '"main"."categories"';                     
                                                    item '"main"."entries"';
                                                    item '"main"."entries_categories"';
                                                    item '"main"."mojo_migrations"';
                                                    item '"main"."sqlite_sequence"';
                                                    item '"main"."top_categories"';
                                                    end();
                                                    #etc();
                                                    #field entries => T();
                                                    #field entries => hash { all_values => T() };
                                                    #field categories => hash { all_values => T() };
                                                    #field top_categories => hash { all_values => T() };
                                                    #field entries_categories => hash { all_values => T() };
#                                                   field entries => hash { prop size => '3' };
                                                },                                                  'Table names as expected.'     );

done_testing();

=head1 AUTHOR

Andrew Mehta

=cut

__END__

Old lines that could prove useful again later:
#use lib path(__FILE__)->parent->parent->realpath->stringify;
