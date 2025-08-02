use     Object::Pad v0.820;

class   Management::Languages::de_de;

use     Management::Boilerplate::Code;
inherit Management::Languages;

# ----------------------------------

my  @tokens = (

);

my  @phrases = (

    # Management::Controller::Input::add_entries
    'Please enter some data as input...'    =>	'Bitte geben Sie einige Daten als Eingabe ein...',

    # Management::Controller::Input::ask_days
    'Select a Year...'                      =>  'Wählen Sie ein Jahr aus...',

    # Management::Controller::Input::confirm_entries
    'Time Range'                            =>  'Zeitraum',
    'Duration'                              =>  'Dauer',
    'Category'                              =>  'Kategorie',
    'Details'                               =>  'Details',
    'How do you wish to proceed?'           =>  'Wie möchten Sie weiter vorgehen?',
    'Save'                                  =>  'Speichern',
    'Discard'                               =>  'Verwerfen',
    'Add Time Logging Entry'                =>  'Zeitprotokolleintrag hinzufügen',
    'No Time Logging Entries to confirm.'   =>  'Keine Zeitprotokolleinträge zur Bestätigung.',

);

my  @debug_phrases = (

    # Not yet translated to German:

    # Management::Controller::Input
    'About to set initial values.'                                  =>  'Im Begriff, Anfangswerte festzulegen.',
    'Set layout data structure as follows:'                         =>  'Die Layoutdatenstruktur wurde wie folgt festgelegt:',
    'Created layout using Template Nest, and saved it to variable.' =>  'Layout mit Template Nest erstellt und in Variable gespeichert.',
    'Rendered the layout as text/html.'                             =>  'Das Layout wurde als text/html gerendert.',
    'No form input.'                                                =>  'Keine Formulareingabe.',
    'Obtained form input...'                                        =>  'Formulareingabe erhalten...',
    'About to start processing.'                                    =>  'Jetzt am Anfang der Verarbeitung.',
);

our %Lexicon = ( # Shouldn't there be my or our?
    #'_AUTO' => 1, # Commented out the auto for now.
    @tokens,
    @phrases,
    @debug_phrases,
);

# ----------------------------------

#1;
