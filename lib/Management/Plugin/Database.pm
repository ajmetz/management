use     Object::Pad v0.820;

class   Management::Plugin::Database;
use     Management::Boilerplate::Code;
inherit Mojolicious::Plugin;
#use     Mojo::Util qw(dumper);

use     Management::Model::Database;


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
    my  $helpers={
        # When adding new lines, remember to also update the registration order below this.
        database            =>  sub { $self->database($app) },
    };

    my $registration_order  =   [qw(
                                    database
                                )];

    # Processing:

    # Register helpers in order:
    $app->helper(
        $ARG            =>  $helpers->{$ARG}
    ) for ($registration_order->@*);

    return;

}

method database ($app) {
    state $database = Management::Model::Database->new(app => $app);  # State means $database set only once then re-used.
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

method entry ($app) {
    state   $entry   =   Management::Model::Entry->new(data => $app->data, app => $app);  # State means $entry set only once then re-used. This is the object model for entry crud commands and not an actual entry object.
}

method category ($app) {
    state   $category=   Management::Model::Category->new(data => $app->data, app => $app);  # State means $category set only once then re-used. This is the object model for category crud commands and not an actual category object.
}
