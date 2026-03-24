use     Object::Pad v0.820;

class   Management::App::Controller::Input;

inherit Mojolicious::Controller;
use     Management::App::Boilerplate::Code;
use     Template::Nest;
use     Management::App::Model::TimeLog::EntryFactory;
use     Management::App::Model::TimeLog::TimeRange;

my $time_range_class    =   'Management::App::Model::TimeLog::TimeRange';

method entries {

    $self->logger->debug('About to set initial values.');

    # Initial Values:
    my  $valid_input                =   $self->get_valid_entries_input;

    my  $layout_data_structure      =   $valid_input?   $valid_input->{'stage'} eq 'confirm'?   $self->confirm_input($valid_input):
                                                        $valid_input->{'stage'} eq 'save'?      $self->save_input($valid_input):
                                                        $self->request_input:
                                        $self->request_input;

    $self->logger->debug('Set layout data structure as follows:')->dump_values($layout_data_structure);

    $self->logger->debug('About to start processing.');

    # Processing:
    my  $layout                     =   Template::Nest->new($self->stash->{layout_settings}->@*)->render($layout_data_structure);

    $self->logger->debug('Created layout using Template Nest, and saved it to variable.');

    # Output:
    $self->render(
        text                        =>  $layout,
    );

    $self->logger->debug('Rendered the layout as text/html.');

}

method get_valid_entries_input {
    # Conditional initial values:
    return  $self->validation->has_data
            && $self->validation->required('data')->size(1,undef)->is_valid
            && $self->validation->required('stage')->in('confirm', 'save')->is_valid?    $self->validation->output:
            undef;

}

method request_input {

    return {
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

}

method confirm_input ($valid_input = undef) {

    $self->logger->debug('About to set initial values.');

    # Initial values:
    my @entries                     =   $valid_input->{'data'}?    Management::App::Model::TimeLog::EntryFactory->multiple_entries($valid_input->{'data'}):
                                        ();
    my  @entries_layout             =   ();

    for my $entry_object (@entries) {
        push @entries_layout        ,   {
            TEMPLATE                =>  'entries.htm',
            'TIME RANGE'            =>  sprintf('%s-%s', $entry_object->start_time, $entry_object->end_time),
            'DURATION'              =>  $entry_object->duration,
            'CATEGORY'              =>  $entry_object->category,
            'DETAILS'               =>  $entry_object->details,
        };
    };

    my  $layout_for_entries            =   {
        TEMPLATE                    =>  'confirm_entries/content.htm',

        'TIME RANGE LABEL'          =>  $self->language->localise('Time Range'),
        'DURATION LABEL'            =>  $self->language->localise('Duration'),
        'CATEGORY LABEL'            =>  $self->language->localise('Category'),
        'DETAILS LABEL'             =>  $self->language->localise('Details'),
        'QUESTION'                  =>  $self->language->localise('How do you wish to proceed?'),
        'SAVE LABEL'                =>  $self->language->localise('Save'),
        'DISCARD LABEL'             =>  $self->language->localise('Discard'),
        'DATA'                      =>  $valid_input->{'data'},
        ENTRIES                     =>  [@entries_layout],
    };
    my  $layout_for_no_entries           =   {
        TEMPLATE                    =>  'confirm_entries/no_content.htm',

        'INTRO'                     =>  $self->language->localise('No Time Logging Entries to confirm.'),
        'ADD ENTRIES LABEL'         =>  $self->language->localise('Add Time Logging Entry'),
    };

    my  $layout_data_structure      =   {
        TEMPLATE                    =>  'main.htm',
        SCRIPTS                     =>  q{},

        CONTENT                     =>  {
            TEMPLATE                =>  'generic-content.htm',

            'SPECIFIC CONTENT'      =>  @entries? $layout_for_entries:
                                        $layout_for_no_entries,
        },
    };

    return $layout_data_structure;

}

method save_input ($valid_input = undef) {

    return  $self->request_input unless $valid_input->{'data'};

    # Code to save put here

    return {
        TEMPLATE                    =>  'main.htm',
        SCRIPTS                     =>  q{},
        CONTENT                     =>  {
            TEMPLATE                =>  'generic-content.htm',
            'SPECIFIC CONTENT'      =>  {
                TEMPLATE            =>  'save_input/content.htm',
            },
        },
    };



}

method days {


    $self->logger->trace('About to set initial values.');

    # Initial Values:
    my  $valid_input                =   $self->get_valid_days_input;

    my  $layout_data_structure      =   $valid_input?   $self->show_days($valid_input):
                                        $self->ask_days;

    $self->logger->trace('Set layout data structure as follows:')->dump_values($layout_data_structure);

    $self->logger->trace('About to start processing.');

    # Processing:
    my  $layout                     =   Template::Nest->new($self->stash->{layout_settings}->@*)->render($layout_data_structure);

    $self->logger->trace('Created layout using Template Nest, and saved it to variable.');

    # Output:
    $self->render(
        text                        =>  $layout,
    );

    $self->logger->trace('Rendered the layout as text/html.');

}

method ask_days {

    my  @option_defaults = (
            TEMPLATE                =>  'ask_days/options.htm',
            VALUE                   =>  q{},
            LABEL                   =>  q{}, # can be overriden.
    );
    my  $blank_option               =   { @option_defaults };
    
    my  $year_options = [
        {
            @option_defaults,
            LABEL                   =>  $self->language->localise_html('Select a Year...'),
        },
        $blank_option,
    ];

    my  $month_options = [
        {
            @option_defaults,
            LABEL                   =>  $self->language->localise_html('Select a Month...'),
        },
        $blank_option,
    ];


    for my $value ($time_range_class::list_of_acceptable_years) {
        push $year_options->@*      ,   {
            @option_defaults,
            VALUE                   =>  $value,
            LABEL                   =>  $value,
        };
    };

    for my $value ($time_range_class::list_of_acceptable_months) {
        push $month_options->@*     ,   {
            @option_defaults,
            VALUE                   =>  $value,
            LABEL                   =>  $self->language->localise_html('options.abbreviated_month.'.$value),
        };
    };

    return {
        TEMPLATE                    =>  'main.htm',
        SCRIPTS                     =>  q{},
        CONTENT                     =>  {
            TEMPLATE                =>  'generic-content.htm',
            'SPECIFIC CONTENT'      =>  {
                TEMPLATE            =>  'ask_days/content.htm',
                'START YEAR SELECT' =>  {
                    TEMPLATE        =>  'ask_days/selects.htm',
                    TITLE           =>  $self->language->localise_html('Year Selection for beginning of Time Range.'),
                    NAME            =>  'time_range_start_year',
                    OPTIONS         =>  $year_options,
                },
                'START MONTH SELECT'=>  {
                    TEMPLATE        =>  'ask_days/selects.htm',
                    TITLE           =>  $self->language->localise_html('Month Selection for beginning of Time Range.'),
                    NAME            =>  'time_range_start_month',
                    OPTIONS         =>  $month_options,
                },
                'END YEAR SELECT' =>  {
                    TEMPLATE        =>  'ask_days/selects.htm',
                    TITLE           =>  $self->language->localise_html('Year Selection for end of Time Range.'),
                    NAME            =>  'time_range_end_year',
                    OPTIONS         =>  $year_options,
                },
                'END MONTH SELECT'=>  {
                    TEMPLATE        =>  'ask_days/selects.htm',
                    TITLE           =>  $self->language->localise_html('Month Selection for end of Time Range.'),
                    NAME            =>  'time_range_end_month',
                    OPTIONS         =>  $month_options,
                },
            }, # end specific content
        },
    };

}

method show_days {
    return 'Listing some days';
}

method get_valid_days_input {
    # Conditional initial values:
    return  $self->validation->has_data
            && $self->validation->required('time_range_start_year')->in($time_range_class::list_of_acceptable_years)->is_valid
            && $self->validation->required('time_range_start_month')->in($time_range_class::list_of_acceptable_months)->is_valid
            && $self->validation->required('time_range_end_year')->in($time_range_class::list_of_acceptable_years)->is_valid
            && $self->validation->required('time_range_end_month')->in($time_range_class::list_of_acceptable_months)->is_valid?     $self->validation->output:
            undef;

}

__END__