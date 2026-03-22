
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

our $VERSION            =   'v1.0.0';                               #   Set Version.

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

=head2 Database Config Tests.

Then we begin testing our Database configuration...

=cut


# Database App Config Tests:

my  $app                                    =   Test::Mojo->new('Management')->app;     # Created app object.
ok( defined(
        $app->config('sqlite_file')
    )                                       ,   'Configuration value for location '.
                                                'of database file, is defined.',
);

ok(
    defined(
        $app->config('migration_file')
    )                                       ,   'Configuration value for location '.
                                                'of migrations file, is defined.',
);

ok(
    path(
        $app->home->rel_file(
            $app->config('sqlite_file')
        )
    )
    ->is_file                               ,   'Database file found.',
);

ok(
    path(
        $app->home->rel_file(
            $app->config('migration_file')
        )
    )
    ->is_file                               ,   'Database Migration file found.',
);

=head2 Database Tests.

Then we begin testing our Database itself...

=cut

# Database Tests:
my  $database                               =   $app->database; # Created database object.

ok(
    $database->handle->ping                 ,   'Can ping the database okay.',
);
#warn "Table Names:\n".join("\n", $database->tables->@*);

like(
    $database->handle->tables,
    array {
        item '"main"."categories"';                     
        item '"main"."entries"';
        item '"main"."entries_categories"';
        item '"main"."mojo_migrations"';
        item '"main"."sqlite_sequence"';
        item '"main"."top_categories"';
        end();
    }                                       ,   'Table names as expected.',
);
                                                


done_testing();

=head1 AUTHOR

Andrew Mehta

=cut

__END__

Old lines that could prove useful again later:
#use lib path(__FILE__)->parent->parent->realpath->stringify;


                                        #etc();
                                        #field entries => T();
                                        #field entries => hash { all_values => T() };
                                        #field categories => hash { all_values => T() };
                                        #field top_categories => hash { all_values => T() };
                                        #field entries_categories => hash { all_values => T() };
#                                                   field entries => hash { prop size => '3' };