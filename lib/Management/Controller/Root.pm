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

    method homepage {

        $self->render(
            text => "Management",
        );

    }

    method dynamic01 {

        # Initial values:
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
        my  $layout_object          =   Template::Nest->new($self->stash->{layout_settings}->@*);

        # Output:
        $self->render(
            text                    =>  $layout_object->render($layout_data_structure)
        );
    }

}

__END__