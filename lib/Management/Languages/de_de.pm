use     Object::Pad v0.820;

class   Management::Languages::de_de;

use     Management::Boilerplate::Code;
inherit Management::Languages;

# ----------------------------------

my  @tokens = (

);

my  @phrases = (
    'Please enter some data as input...' =>	'Bitte geben Sie einige Daten als Eingabe ein...',

);

my  @debug_phrases = (

    # Not yet translated to German:

    # Management::Controller::Input
    'About to set initial values.'                                  =>  'About to set initial values.',
    'Set layout data structure as follows:'                         =>  'Set layout data structure as follows:',
    'Created layout using Template Nest, and saved it to variable.' =>  'Created layout using Template Nest, and saved it to variable.',
    'Rendered the layout as text/html.'                             =>  'Rendered the layout as text/html.',
    'No form input.'                                                =>  'No form input.',
    'Obtained form input...'                                        =>  'Obtained form input...',
    'About to start processing.'                                    =>  'About to start processing.',
);

our %Lexicon = ( # Shouldn't there be my or our?
    #'_AUTO' => 1, # Commented out the auto for now.
    @tokens,
    @phrases,
    @debug_phrases,
);

# ----------------------------------

#1;
