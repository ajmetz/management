use     Object::Pad v0.820;

class   Management::App::Languages::en_gb;

use     Management::App::Boilerplate::Code;
inherit Management::App::Languages;

# ----------------------------------

en_GB_Tokens_Phrases_Lexicon: {

#my  $new_line                   =   "\n";

my  @tokens_short;
my  @tokens_long;
my  @webapp_phrases;
my  @trace_phrases;
my  @debug_phrases;
my  @verbose_phrases;
my  @stdout_phrases;

Tokens: {

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

    Short: {
        @tokens_short = (


            # Management::Controller::Input::ask_days

            'options.abbreviated_month.1'   =>  'Jan',
            'options.abbreviated_month.2'   =>  'Feb',
            'options.abbreviated_month.3'   =>  'Mar',
            'options.abbreviated_month.4'   =>  'Apr',
            'options.abbreviated_month.5'   =>  'May',
            'options.abbreviated_month.6'   =>  'Jun',
            'options.abbreviated_month.7'   =>  'Jul',
            'options.abbreviated_month.8'   =>  'Aug',
            'options.abbreviated_month.9'   =>  'Sep',
            'options.abbreviated_month.10'  =>  'Oct',
            'options.abbreviated_month.11'  =>  'Nov',
            'options.abbreviated_month.12'  =>  'Dec',

        );
    } #short

    Long: {

        @tokens_long = (

            'object.entry.error.invalid_start_values'
                =>  'Could not obtain values from start string. Please use the format "yyyy/mm/dd hh:mm" or an epoch number.',

            # Nothing yet.
        );
    } #long

} # tokens

Phrases: {

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


            # Commonly used...

            # Management::Controller::Input::add_entries

            'Please enter some data as input...'    =>  'Please enter some data as input...',


            # Management::Controller::Input::ask_days

            'Select a Month...'                     =>  'Select a Month...',
            'Select a Year...'                      =>  'Select a Year...',

            'Month Selection for beginning of Time Range.'
                =>  'Month Selection for beginning of Time Range.',

            'Month Selection for end of Time Range.'
                =>  'Month Selection for end of Time Range.',

            'Year Selection for beginning of Time Range.'
                =>  'Year Selection for beginning of Time Range.',

            'Year Selection for end of Time Range.'
                =>  'Year Selection for end of Time Range.',



            # Management::Controller::Input::confirm_entries

            'Add Time Logging Entry'                =>  'Add Time Logging Entry',
            'Category'                              =>  'Category',
            'Details'                               =>  'Details',
            'Discard'                               =>  'Discard',
            'Duration'                              =>  'Duration',
            'How do you wish to proceed?'           =>  'How do you wish to proceed?',
            'No Time Logging Entries to confirm.'   =>  'No Time Logging Entries to confirm.',
            'Save'                                  =>  'Save',
            'Time Range'                            =>  'Time Range',


        );

    } #webapp

    Trace: {
        @trace_phrases = (
        
            # Management::App::Model::Database::Data::Entry:save

            'Checking our Entry Object is valid.'                           =>  'Checking our Entry Object is valid.',
            'Checking our top category is valid.'                           =>  'Checking our top category is valid.',
            'Our top category is invalid.'                                  =>  'Our top category is invalid.',
        
        );
    } #trace

    Debug: {

        @debug_phrases = (


            # Commonly used...


            # Management::Controller::Input

            'About to set initial values.'                                  =>  'About to set initial values.',
            'About to start processing.'                                    =>  'About to start processing.',
            'Created layout using Template Nest, and saved it to variable.' =>  'Created layout using Template Nest, and saved it to variable.',
            'No form input.'                                                =>  'No form input.',
            'Obtained form input...'                                        =>  'Obtained form input...',
            'Rendered the layout as text/html.'                             =>  'Rendered the layout as text/html.',
            'Set layout data structure as follows:'                         =>  'Set layout data structure as follows:',


            # Management::Model::Entry

            'Invalid digit provided.'                                       =>  'Invalid digit provided.',


        );

    } #debug

    Verbose: {

        @verbose_phrases =(
        );

    }

    Stdout: {

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
    @trace_phrases,
    @verbose_phrases,
    @stdout_phrases,
);

}

# ----------------------------------

#1;
