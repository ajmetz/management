use     Object::Pad v0.820;

class   Management::Controller::Root;

inherit Mojolicious::Controller;
use     Management::Boilerplate::Code;
use     Template::Nest;

method hello_world {

    $self->render(
        text => "Hello World!",
    );

}

method homepage {

    # Initial values:
    my  $layout_data_structure      =   {
        NAME                        =>  'main.htm',
        SCRIPTS                     =>  q{},
        CONTENT                     =>  {
            NAME                    =>  'generic-content.htm',
            'SPECIFIC CONTENT'      =>  {
                NAME                =>  'homepage/content.htm',
            },
        },
    };

    # Processing:
    my  $layout                     =   Template::Nest->new($self->stash->{layout_settings}->@*)->render($layout_data_structure);

    # Output:
    $self->render(
        text                        =>  $layout,
    );

}

method outcomes {

    # Initial values:
    my  $layout_data_structure      =   {
        NAME                        =>  'main.htm',
        SCRIPTS                     =>  q{},
        CONTENT                     =>  {
            NAME                    =>  'generic-content.htm',
            'SPECIFIC CONTENT'      =>  {
                NAME                =>  'outcomes/content.htm',
            },
        },
    };

    # Processing:
    my  $layout                     =   Template::Nest->new($self->stash->{layout_settings}->@*)->render($layout_data_structure);

    # Output:
    $self->render(
        text                        =>  $layout,
    );

}

method dynamic01 {

    # Initial values:
    my  $layout_data_structure      =   {
        NAME                        =>  'main.htm',
        SCRIPTS                     =>  {
            NAME                    =>  'demo-chart/scripts.htm',
        },
        CONTENT                     =>  {
            NAME                    =>  'generic-content.htm',
            'SPECIFIC CONTENT'      =>  {
                NAME                =>  'demo-chart/content.htm',

                TOGGLES             =>  {
                    NAME            =>  'demo-chart/toggles.htm',
                },
                CHART               =>  {
                    NAME            =>  'demo-chart/chart.htm',
                },
                #'DETAILS BOX'       =>  '\PUT DETAILS BOX HERE',
                #'DAY SIZE'          =>  '\PUT DAY SIZE HERE',
                #'ROUTINE CHECKLIST' =>  '\PUT ROUTINE CHECKLIST HERE',
                #HEALTH              =>  '\PUT HEALTH HERE',
                #DIET                =>  '\PUT DIET HERE',
                #'KEY TIMES'         =>  '\PUT KEY TIMES HERE',
                #SLEEP               =>  '\PUT SLEEP HERE',

            },
        },
    };

    # Processing:
    my  $layout                     =   Template::Nest->new(
                                            $self->stash->{layout_settings}->@*
                                        )
                                        ->render($layout_data_structure);

    # Output:
    $self->render(
        text                    =>  $layout,
    );
}

__END__