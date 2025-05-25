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
            template_ext            =>  '', # Blank so can declare extension under the NAME key.
                                            # This will allow me to use htm and html
                                            # or anything else as I wish.
        );
    
        my  $layout_data_structure  =   {
            NAME                    =>  'main.htm',
            CONTENT                 =>  {
                NAME                =>  'content.htm',
                TOGGLES             =>  {
                    NAME            =>  'toggles.htm',
                },
                CHART               =>  {
                    NAME            =>  'chart.htm',
                },
                #'DETAILS BOX'       =>  '\PUT DETAILS BOX HERE',
                #'DAY SIZE'          =>  '\PUT DAY SIZE HERE',
                #'ROUTINE CHECKLIST' =>  '\PUT ROUTINE CHECKLIST HERE',
                #HEALTH              =>  '\PUT HEALTH HERE',
                #DIET                =>  '\PUT DIET HERE',
                #'KEY TIMES'         =>  '\PUT KEY TIMES HERE',
                #SLEEP               =>  '\PUT SLEEP HERE',
            },
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