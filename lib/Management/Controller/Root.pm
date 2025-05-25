use     Management::Boilerplate::Code;
use     Object::Pad v0.820;

class   Management::Controller::Root :repr(HASH) {

    inherit Mojolicious::Controller;
    use Management::Boilerplate::Code;
    use Template::Nest;

    method hello_world {

        $self->render(
            text => "Hello World!",
        );

    }
    
    method dynamic01 {

        # Initial values:
        my  @layout_settings        =   (
            template_dir            =>  $self->app->home->rel_file('lib/Management/Files')->child('layouts')->to_string,
            fixed_indent            =>  1,
            token_delims            =>  ['PUT','HERE'],
        );
    
        my  $layout_data_structure  =   {
            NAME                    =>  'main',
            CONTENT                 =>  'TEST',
        };
        
        # Processing:
        my  $layout_object          =   Template::Nest->new(@layout_settings);

        # Output:
        $self->render(
            text                    =>  $layout_object->render($layout_data_structure)
        );
    }

}

__END__