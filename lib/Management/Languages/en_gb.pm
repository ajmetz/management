use     Object::Pad v0.820;

class   Management::Languages::en_gb;

use     Management::Boilerplate::Code;
inherit Management::Languages;

# ----------------------------------

my  @tokens = (

);

my  @phrases = (
    'Please enter some data as input...' =>	'Please enter some data as input...',

);

my  @debug_phrases = (

    # Management::Controller::Input
    'About to set initial values.'                                  =>  'About to set initial values.',
    'Set layout data structure as follows:'                         =>  'Set layout data structure as follows:',
    'Created layout using Template Nest, and saved it to variable.' =>  'Created layout using Template Nest, and saved it to variable.',
    'Rendered the layout as text/html.'                             =>  'Rendered the layout as text/html.',

);

our %Lexicon = ( # Shouldn't there be my or our?
    #'_AUTO' => 1, # Commented out the auto for now.
    @tokens,
    @phrases,
    @debug_phrases,
);

# ----------------------------------

#1;
