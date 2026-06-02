use     Management::App::Boilerplate::ObjectPadVersion;

class   Management::App::MVC::View::Language::de_de;

use     Management::App::Boilerplate::Code;
inherit Management::App::MVC::View::Language;

# ----------------------------------

de_DE_Token_Phrasen_Lexikon: {

#my  $new_line                   =   "\n";

my  @tokens_short;
my  @tokens_long;
my  @webapp_phrases;
my  @debug_phrases;
my  @verbose_phrases;
my  @stdout_phrases;

Token: {

    # Comment Headings Style Guide:
    # -----------------------------
    # Class Names if only a few tokens/phrases.
    # Class Names with subroutine names,
    # if it makes more sense due to the number of phrases.
    # Two blank lines above each heading.

    # Key Value Style Guide:
    # -----------------------------
    # All on one line for short tokens.
    # For long tokens, fat comma on new line,
    # with one line translations on the same line as the fat comma
    # and multi-line translations on the line below the fat comma,
    # flushed to the left.

    # Ordering Style Guide
    # -----------------------------
    # Alphabetical where possible.
    # Leading underscores ignored, as these may be added
    # or removed depending on whether the method is made
    # public or private.

    Kurz: {

        @tokens_short = (


            # Management::Controller::Input::ask_days

            'options.abbreviated_month.1'   =>  'Jän',
            'options.abbreviated_month.2'   =>  'Feb',
            'options.abbreviated_month.3'   =>  'März',
            'options.abbreviated_month.4'   =>  'Apr',
            'options.abbreviated_month.5'   =>  'Mai',
            'options.abbreviated_month.6'   =>  'Juni',
            'options.abbreviated_month.7'   =>  'Juli',
            'options.abbreviated_month.8'   =>  'Aug',
            'options.abbreviated_month.9'   =>  'Sept',
            'options.abbreviated_month.10'  =>  'Okt',
            'options.abbreviated_month.11'  =>  'Nov',
            'options.abbreviated_month.12'  =>  'Dez',

        );
    } #short

    Lang: {

        @tokens_long = (

            # Nothing yet.
        );
    } #long

} # tokens

Phrasen: {

    # Comment Headings Style Guide:
    # -----------------------------
    # Use heading 'Commonly used:' for common phrases.
    # For all other headings use class names with subroutine names.
    # Leave two blank lines between headings.

    # Key Value Style Guide:
    # -----------------------------
    # Key and value on same line unless key is long.
    # Lines should have their fat commas space-aligned
    # via four-space tabbing.
    # When not on the same line,
    # fat commas should be four-space-tabbed one tab in,
    # under the previous line.
    # Long keys and values and anything multi-lined,
    # to be collated in a section one blank line down
    # from the previous short keys and values.
    # Both alphabetically ordered independent of one another.
    # I.e. Under a single heading,
    # alphabetically sorted short keys and values,
    # followed by alphabetically sorted long keys and values,
    # with a blank line between short and long.

    # Ordering Style Guide
    # -----------------------------
    # Alphabetical where possible.
    # Under each heading, the set of short phrases
    # and set of long phrases,
    # are each sorted independently from one another.

    Webapp: {

        @webapp_phrases = (


            # Commonly used:


            # Management::Controller::Input::add_entries

            'Please enter some data as input...'    =>	'Bitte geben Sie einige Daten als Eingabe ein...',


            # Management::Controller::Input::ask_days

            'Select a Month...'                     =>  'Wählen Sie einen Monat aus...',
            'Select a Year...'                      =>  'Wählen Sie ein Jahr aus...',

            'Month Selection for beginning of Time Range.'
                =>  'Monatsauswahl für den Beginn des Zeitraums.',

            'Month Selection for end of Time Range.'
                =>  'Monatsauswahl für das Ende des Zeitraums.',

            'Year Selection for beginning of Time Range.'
                =>  'Jahresauswahl für den Beginn des Zeitraums.',

            'Year Selection for end of Time Range.'
                =>  'Jahresauswahl für das Ende des Zeitraums.',


            # Management::Controller::Input::confirm_entries

            'Add Time Logging Entry'                =>  'Zeitprotokolleintrag hinzufügen',
            'Category'                              =>  'Kategorie',
            'Details'                               =>  'Details',
            'Discard'                               =>  'Verwerfen',
            'Duration'                              =>  'Dauer',
            'How do you wish to proceed?'           =>  'Wie möchten Sie weiter vorgehen?',
            'No Time Logging Entries to confirm.'   =>  'Keine Zeitprotokolleinträge zur Bestätigung.',
            'Save'                                  =>  'Speichern',
            'Time Range'                            =>  'Zeitraum',

        );

    } #webapp

    Debug: {

        @debug_phrases = (


            # Commonly used:


            # Management::Controller::Input

            'About to set initial values.'                                  =>  'Im Begriff, Anfangswerte festzulegen.',
            'About to start processing.'                                    =>  'Jetzt am Anfang der Verarbeitung.',
            'Created layout using Template Nest, and saved it to variable.' =>  'Layout mit Template Nest erstellt und in Variable gespeichert.',
            'No form input.'                                                =>  'Keine Formulareingabe.',
            'Obtained form input...'                                        =>  'Formulareingabe erhalten...',
            'Rendered the layout as text/html.'                             =>  'Das Layout wurde als text/html gerendert.',
            'Set layout data structure as follows:'                         =>  'Die Layoutdatenstruktur wurde wie folgt festgelegt:',


            # Management::Model::Entry

            'Invalid digit provided.'                                       =>  'Ungültige Ziffer angegeben.',


        );

    } #dedbug

    Ausführlich: {

        @verbose_phrases =(
        );

    }

    Standardausgabe: {

        @stdout_phrases =(
        );

    }

} #phrases


our %Lexicon = (
    #'_AUTO' => 1, # Commented out the auto for now.
    @tokens_short,
    @tokens_long,
    @webapp_phrases,
    @debug_phrases,
    @verbose_phrases,
    @stdout_phrases,
);

}

# ----------------------------------

#1;
