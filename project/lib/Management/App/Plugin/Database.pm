use     Object::Pad v0.820;

class   Management::App::Plugin::Database;
use     Management::App::Boilerplate::Code;
inherit Mojolicious::Plugin;
#use     Mojo::Util qw(dumper);

use     Management::App::MVC::Model::Database;


=pod Name, Version, Synopsis

=encoding utf8

=head1 NAME

Database - Simple helper that acts as glue to the Model Database class.

=head1 VERSION

v1.0.0

=head1 SYNOPSIS

=cut

=pod Description - Register

=head1 DESCRIPTION

Registers C<< database >> as a Mojolicious Helper.

=cut

method register ($app, $config) {

    # Initial values:

    my  $database_params = {
        file_name           =>  $app->home->rel_file(
                                    $app->config('sqlite_file')
                                )->to_string,
        logger              =>  $app->logger,
        time_zone           =>  $app->config('time_zone') // undef,
    };

    my  $helpers={
        # When adding new lines, remember to also update the registration order below this.
        database            =>  sub { $self->database   ($database_params)  },
    };

    my $registration_order  =   [qw(
                                    database
                                )];

    # Processing:

    # Register helpers in order:
    $app->helper(
        $ARG            =>  $helpers->{$ARG}
    ) for ($registration_order->@*);

    $self->setup_database_migration($app);

    return $app;

}

method database ($database_params) {
    state $database = Management::App::MVC::Model::Database->new($database_params->%*);  # State means $database set only once then re-used.
}

method setup_database_migration ($app) {

    $app->database->connection->migrations->from_file(
        $app->home->rel_file(
            $app->config('migration_file')
        )->to_string
    );

    my $dbh =    $app->database->handle; # First call might trigger migration.

    return $self;
}


1; ####

=pod See Also, Author and License sections.

=head1 SEE ALSO

L<MojoTest>

=head1 AUTHOR

Andrew Mehta

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__END__

Old code we removed:

use     Management::Model::Data;
use     Management::Model::Entry;

method data ($app) {
    state   $data   =   Management::Model::Data->new(database => $app->database, app => $app);  # State means $data set only once then re-used.
}


