use     Object::Pad v0.820;

class   Management::Languages::en_gb;

use     Management::Boilerplate::Code;
inherit Management::Languages;

# ----------------------------------

my  @tokens = (

);

my  @phrases = (
    'Please enter some data as input...' =>	'Please enter some data as input (translated)...',

);

our %Lexicon = ( # Shouldn't there be my or our?
    #'_AUTO' => 1, # Commented out the auto for now.
    @tokens,
    @phrases,
);

# ----------------------------------

#1;
