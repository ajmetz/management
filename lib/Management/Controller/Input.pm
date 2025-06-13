use     Object::Pad v0.820;

class   Management::Controller::Input;

inherit Mojolicious::Controller;
use     Management::Boilerplate::Code;
use     Template::Nest;


method add_entries {

    $self->log_debug('About to set initial values.');

    # Initial values:
    my  $layout_data_structure      =   {
        TEMPLATE                    =>  'main.htm',
        SCRIPTS                     =>  q{},
        CONTENT                     =>  {
            TEMPLATE                =>  'generic-content.htm',
            'SPECIFIC CONTENT'      =>  {
                TEMPLATE            =>  'add_entries/content.htm',
                PROMPT              =>  $self->language->localise_html('Please enter some data as input...'),
            },
        },
    };

    $self->log_debug('Set layout data structure as follows:')->log_dump_values($layout_data_structure);

    $self->log_debug('About to start processing.');

    # Processing:
    my  $layout                     =   Template::Nest->new($self->stash->{layout_settings}->@*)->render($layout_data_structure);

    $self->log_debug('Created layout using Template Nest, and saved it to variable.');

    # Output:
    $self->render(
        text                        =>  $layout,
    );
    
    $self->log_debug('Rendered the layout as text/html.');

}

method confirm_entries {

    $self->log_debug('About to set initial values.');

    my  $valid_data                 =   $self->validation->has_data
                                        && $self->validation->required('data')->size(1,undef)->is_valid?
                                            $self->validation->param:
                                        undef;


    $self->log_debug('Obtained form input...')->log_dump_values($valid_data) if $valid_data;
    $self->log_debug('No form input.') unless $valid_data;

#    parse_data($valid_data)


    # Initial values:
    my  $layout_for_data            =   {
        TEMPLATE                    =>  'confirm_entries/content.htm',

        'TIME RANGE LABEL'          =>  $self->language->localise('Time Range'),
        'DURATION LABEL'            =>  $self->language->localise('Duration'),
        'CATEGORY LABEL'            =>  $self->language->localise('Category'),
        'DETAILS LABEL'             =>  $self->language->localise('Details'),
        'QUESTION'                  =>  $self->language->localise('How do you wish to proceed?'),
        'SAVE LABEL'                =>  $self->language->localise('Save'),
        'DISCARD LABEL'             =>  $self->language->localise('Discard'),
        ENTRIES                     =>  {
            TEMPLATE                =>  'entries.htm',
        },
    };
    my  $layout_for_no_data           =   {
        TEMPLATE                    =>  'confirm_entries/no_content.htm',

        'INTRO'                     =>  $self->language->localise('No Time Logging Entries to confirm.'),
        'ADD ENTRIES LABEL'         =>  $self->language->localise('Add Time Logging Entry'),
    };

    my  $layout_data_structure      =   {
        TEMPLATE                    =>  'main.htm',
        SCRIPTS                     =>  q{},

        CONTENT                     =>  {
            TEMPLATE                =>  'generic-content.htm',

            'SPECIFIC CONTENT'      =>  $valid_data? $layout_for_data:
                                        $layout_for_no_data,
        },
    };

    $self->log_debug('Set layout data structure as follows:')->log_dump_values($layout_data_structure);


    $self->log_debug('About to start processing.');

    # Processing:
    my  $layout                     =   Template::Nest->new($self->stash->{layout_settings}->@*)->render($layout_data_structure);

    $self->log_debug('Created layout using Template Nest, and saved it to variable.');

    # Output:
    $self->render(
        text                        =>  $layout,
    );
    
    $self->log_debug('Rendered the layout as text/html.');
    
    
}

__END__