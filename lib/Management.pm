use     Object::Pad v0.820;

class   Management 1.00;

use     Management::Boilerplate::Code;
inherit Mojolicious;

# This method will run once at server start
method startup {

    $self
    ->get_configuration_from_file
    ->configure_the_application
    ->load_additional_plugins;

}

method load_additional_plugins {

    $self->plugin('Management::Plugin::Routes');
    $self->plugin('Management::Plugin::Languages');
    $self->plugin('Management::Plugin::Log');
    return $self;

}

method setup_database {
    $self->plugin('Management::Plugin::Database');
    my  $migrations_folder  =   $self->app->home->rel_file('lib/Management/Files/DatabaseMigration');
    $self->connection->migrations->from_file($migrations_folder->child('migrations.sql')->to_string);
}

method get_configuration_from_file {
    $self->plugin('NotYAMLConfig');
    return $self;
}

method configure_the_application {

    $self           ->  secrets(
                            $self->config->{secrets}
                        );

    return $self    ->  exclude_author_commands
                    ->  setup_customisation_of_mojolicious_file_paths
                    ->  setup_database
                    ->  setup_template_nest; # returns $self
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
    my  $files                  =   $self->home->rel_file('lib/Management/Files');

    # Switch to installable "public" directory
    $self->static->paths->[0]   =   $files->child('public');

    # Switch to installable "templates" directory
    $self->renderer->paths->[0] =   $files->child('templates');

    return $self;

}

method setup_template_nest {

    $self->defaults(

        # Store Template::Nest setup data in the stash:
        layout_settings     =>   [

            template_dir    =>  $self->app->home->rel_file('lib/Management/Files')->child('layouts')->to_string,
            fixed_indent    =>  1,
            token_delims    =>  ['PUT','HERE'],
            escape_char     =>  '\\',
            name_label      =>  'TEMPLATE',
            template_ext    =>  '', # Blank so can declare extension under the NAME key.
                                    # This will allow me to use htm and html
                                    # or anything else as I wish.

        ],

    );

    return $self;

}

__END__