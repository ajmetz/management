package Management;
use Mojo::Base 'Mojolicious', -signatures;
use Management::Boilerplate::Code;
use English;

# This method will run once at server start
sub startup ($self) {

    $self
    ->get_configuration_from_file
    ->configure_the_application
    ->load_additional_plugins;

}

sub load_additional_plugins ($self) {

    $self->plugin('Management::Plugin::Routes');
    
    return $self;

}

sub get_configuration_from_file ($self) {
    $self->plugin('NotYAMLConfig');
    return $self;
}

sub configure_the_application ($self) {

    $self           ->  secrets(
                            $self->config->{secrets}
                        );

    return $self    ->  exclude_author_commands
                    ->  setup_custom_file_paths; # returns $self
}

sub exclude_author_commands ($self) {

    # Exclude author commands...
    $self->commands->namespaces([
        'Mojolicious::Command',
    ]);
    # ...by setting just Mojolicious::Command 
    # and not Mojolicious::Command 
    # and Mojolicious::Command::Author::whatever)

    return $self;

}

sub setup_custom_file_paths ($self) {

    #Initial Values:
    my  $files                  =   $self->home->rel_file('lib/Management/Files');

    # Switch to installable "public" directory
    $self->static->paths->[0]   =   $files->child('public');

    # Switch to installable "templates" directory
    $self->renderer->paths->[0] =   $files->child('templates');

    return $self;

}



__END__