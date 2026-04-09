use     Object::Pad v0.820;

class   Management 1.00;

use     Management::App::Boilerplate::Code;
inherit Mojolicious;

# This method will run once at server start
method startup {

    $self
    ->load_plugins
    ->secrets( $self->config->{secrets} )
    ->exclude_author_commands
    ->setup_customisation_of_mojolicious_file_paths;

}

method load_plugins {

    my  $config_params = {
        file        =>  $self->home->rel_file('config/management.yml')->to_string,
    };  

    $self->plugin('NotYAMLConfig', $config_params);
    $self->plugin('Management::App::Plugin::Language');
    $self->plugin('Management::App::Plugin::Logger');           # Uses Languages
    $self->plugin('Management::App::Plugin::MyLogAny');
    $self->plugin('Management::App::Plugin::Database');         # Uses Logger
    $self->plugin('Management::App::Plugin::Router');
    $self->plugin('Management::App::Plugin::TemplateNest');
    $self->plugin('Management::App::Plugin::ShortcutHelpers');  # All other plugins had singular names and this is plural!
    return $self;

}

method exclude_author_commands {

    # Exclude author commands...
    $self->commands->namespaces([
        'Mojolicious::Command',
    ]);
    # ...by setting just Mojolicious::Command
    # and not Mojolicious::Command
    # and Mojolicious::Command::Author::whatever)

    return $self;

}

method setup_customisation_of_mojolicious_file_paths {

    #Initial Values:
    my  $files                  =   $self->home->rel_file('lib/Management/');

    # Switch to installable "public" directory
    $self->static->paths->[0]   =   $files->child('public_web_files');

    # Switch to installable "templates" directory
    $self->renderer->paths->[0] =   $files->child('HTML');

    return $self;

}

__END__



