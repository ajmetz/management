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
    ->setup_customisation_of_mojolicious_file_paths
    ->setup_template_nest;

}

method load_plugins {

    my  $config_params = {
        file    =>  $self->home->rel_file('config/management.yml')->to_string,
    };

    $self->plugin('NotYAMLConfig', $config_params);
    $self->plugin('Management::App::Plugin::Languages');
    $self->plugin('Management::App::Plugin::Log'); # Uses Languages
    $self->plugin('Management::App::Plugin::Database'); # Uses Log
    $self->plugin('Management::App::Plugin::Routes');
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

method setup_template_nest {

    $self->defaults(

        # Store Template::Nest setup data in the stash:
        layout_settings     =>   [

            template_dir    =>  $self->app->home->rel_file('lib/Management')->child('HTML')->to_string,
            token_delims    =>  ['PUT','HERE'],
            escape_char     =>  '\\',
            name_label      =>  'TEMPLATE',
            template_ext    =>  '', # Blank so can declare extension under the NAME key (labelled TEMPLATE).
                                    # This will allow me to use htm and html
                                    # or anything else as I wish.

            fixed_indent    =>  0,  # Off (0)
                                    # - On (1) would be nice for tidy source code,
                                    # and would mess with white space in substituted multi-line values
                                    # - i.e. textarea values, or hidden form values -
                                    # so I've decided to keep this off.
        ],

    );

    return $self;

}

__END__

method setup_database {

    $self->database->connection->migrations->from_file(
        $self->home->rel_file(
            $self->config->{'migration_file'}
        )->to_string
    );

    my $db  =    $self->database->handle; # First call might trigger migration.

    return $self;
}

