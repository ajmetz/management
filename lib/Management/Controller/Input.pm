use     Object::Pad v0.820;

class   Management::Controller::Input;

inherit Mojolicious::Controller;
use     Management::Boilerplate::Code;
use     Template::Nest;


method add_entry {

    $self->log_debug('About to set initial values.');
    # Initial values:
    my  $layout_data_structure      =   {
        TEMPLATE                    =>  'main.htm',
        SCRIPTS                     =>  q{},
        CONTENT                     =>  {
            TEMPLATE                =>  'generic-content.htm',
            'SPECIFIC CONTENT'      =>  {
                TEMPLATE            =>  'add_entry/content.htm',
                PROMPT              =>  $self->language->localise_html('Please enter some data as input...'),
            },
        },
    };

    $self->log_debug('Set layout data structure as follows:')->log_dump_values($layout_data_structure);

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