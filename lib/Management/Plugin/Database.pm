use     Object::Pad v0.820;

class   Management::Plugin::Database;
use     Management::Boilerplate::Code;
inherit Mojolicious::Plugin;
use     Mojo::Util qw(dumper);

use     Management::Model::Database;

=pod Name, Version, Synopsis

=encoding utf8

=head1 NAME

Database - Simple Database helper.

=head1 VERSION

v1.0.0

=head1 SYNOPSIS

=cut

=pod Description - Register

=head1 DESCRIPTION

Registers C<< database >> as a Mojolicious Helper.

=cut

method register ($app, $config) {

    my  $helpers={
        connection      =>  sub { $self->connection($app)      },
        database        =>  sub { $self->connection($app)->db  },
       #data            =>  sub { data($app)            },
    };

    $app->helper(
        $ARG            =>  $helpers->{$ARG}
    ) for (keys $helpers->%*);

    return;

}

method connection ($app) {
    state $connection = Management::Model::Database->new(app => $app)->connection;
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