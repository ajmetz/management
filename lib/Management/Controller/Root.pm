use     Object::Pad v0.820;

class   Management::Controller::Root;

inherit Mojolicious::Controller;
use     Management::Boilerplate::Code;
use     Template::Nest;

method auto {
    my  @supported_languages        =   ('en-GB','de-DE'); # TODO - create language class method for this.
    my  $valid_language_requested   =   $self->validation->has_data
                                        && $self->validation->required('language')->in(@supported_languages)->is_valid? $self->validation->output:
                                        undef;
    return $self;
    #$self->language->try_or_die($language_requested) if $language_requested;
                                        
}

method hello_world {

    $self->render(
        text => "Hello World!",
    );

}

method homepage {

    # Initial values:
    my  $layout_data_structure      =   {
        TEMPLATE                    =>  'main.htm',
        SCRIPTS                     =>  q{},
        CONTENT                     =>  {
            TEMPLATE                =>  'generic-content.htm',
            'SPECIFIC CONTENT'      =>  {
                TEMPLATE            =>  'homepage/content.htm',
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
        TEMPLATE                    =>  'main.htm',
        SCRIPTS                     =>  q{},
        CONTENT                     =>  {
            TEMPLATE                =>  'generic-content.htm',
            'SPECIFIC CONTENT'      =>  {
                TEMPLATE            =>  'outcomes/content.htm',
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
        TEMPLATE                    =>  'main.htm',
        SCRIPTS                     =>  {
            TEMPLATE                =>  'demo-chart/scripts.htm',
        },
        CONTENT                     =>  {
            TEMPLATE                =>  'generic-content.htm',
            'SPECIFIC CONTENT'      =>  {
                TEMPLATE            =>  'demo-chart/content.htm',

                TOGGLES             =>  {
                    TEMPLATE        =>  'demo-chart/toggles.htm',
                },
                CHART               =>  {
                    TEMPLATE        =>  'demo-chart/chart.htm',
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