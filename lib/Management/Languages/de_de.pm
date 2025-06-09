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

our %Lexicon = ( # Shouldn't there be my or our?
    #'_AUTO' => 1, # Commented out the auto for now.
    @tokens,
    @phrases,
);

# ----------------------------------

#1;
