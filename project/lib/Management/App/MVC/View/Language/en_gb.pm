use     Object::Pad v0.820;

class   Management::App::MVC::View::Language::en_gb;

use     Management::App::Boilerplate::Code;
inherit Management::App::MVC::View::Language;

# ----------------------------------

en_GB_Tokens_Phrases_Lexicon: {

#my  $new_line                   =   "\n";

my  @tokens_short;
my  @tokens_long;
my  @webapp_phrases;
my  @logging_trace_phrases;
my  @logging_debug_phrases;
my  @logging_info_phrases;
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

            'options.abbreviated_month.1'               =>  'Jan',
            'options.abbreviated_month.2'               =>  'Feb',
            'options.abbreviated_month.3'               =>  'Mar',
            'options.abbreviated_month.4'               =>  'Apr',
            'options.abbreviated_month.5'               =>  'May',
            'options.abbreviated_month.6'               =>  'Jun',
            'options.abbreviated_month.7'               =>  'Jul',
            'options.abbreviated_month.8'               =>  'Aug',
            'options.abbreviated_month.9'               =>  'Sep',
            'options.abbreviated_month.10'              =>  'Oct',
            'options.abbreviated_month.11'              =>  'Nov',
            'options.abbreviated_month.12'              =>  'Dec',


            # Management::Model::Entry - $set_duration private method

            'model.entry.set_duration.duration_string'  =>  '[_1]hr [_2]mins',
            
            # Management::App::MVC::Controller::Input::get_valid_add_entries_input
            'confirm_entries.time_logging.descriptive_field_name'   =>  'Time Logging',
            'confirm_entries.error.empty_or_zero_length'            =>  'Validation Error - [_1] field was either empty or had a value of zero length.',
            'confirm_entries.error.invalid_date'                    =>  'Validation Error - invalid date.',
            'confirm_entries.error.invalid_stage'                   =>  'Validation Error - invalid stage.',
            'confirm_entries.date.descriptive_field_name'           =>  'Date',
            'confirm_entries.stage.descriptive_field_name'          =>  'Stage',
            'confirm_entries.yyyymmdd.descriptive_field_name'       =>  'YYYY/MM/DD Date',
            
            
            # save_input
            'error.last_saved_entry_id.invalid'                     =>  'No last_saved_entry_id was forthcoming.',
        );
    } #short

    Long: {

        @tokens_long = (

            'object.entry.error.invalid_start_values'
                =>  'Could not obtain values from start string. Please use the format "dd/mm/yyyy hh:mm" or an epoch number.',

            # Management::Model::TimeLog::Entry::status

            'object.entry.status.category_delimiter'
                =>
'
                ',

            'object.entry.status.formatting'
                =>
'
Class:          [_1]

ID:             [_2]
Start:          [_3]
End:            [_4]
Start Epoch:    [_5]
End Epoch:      [_6]
Duration:       [_7]

Top Category:   [_8]
Categories:     [_9]

Details:
[_10]
',


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
            'Categories'                            =>  'Categories',
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
        @logging_trace_phrases = (
        
            # Management::App::MVC::Model::Database::Data::Entry::save

            'Beginning the process of actually saving to database...'       =>  'Beginning the process of actually saving to database...',
            'Checking our Entry Object is valid.'                           =>  'Checking our Entry Object is valid.',
            'Checking our top category is new...'                           =>  'Checking our top category is new...',
            'Checking our top category is valid.'                           =>  'Checking our top category is valid.',
            'Decided to save these categories:'                             =>  'Decided to save these categories:',
            'Decided we do not have a valid and new top category to save.'  =>  'Decided we do not have a valid and new top category to save.',
            'Detected we have something to save to categories table...'     =>  'Detected we have something to save to categories table...',
            'Existing categories from database are...'                      =>  'Existing categories from database are...',
            'Fetching existing categories from database.'                   =>  'Fetching existing categories from database.',
            'For category...'                                               =>  'For category...',
            'Intending to save the following category...'                   =>  'Intending to save the following category...',
            'Our top category is invalid.'                                  =>  'Our top category is invalid.',
            "Processing our Entry Object's categories."                     =>  "Processing our Entry Object's categories.",
            'Successfully saved category with the following id...'          =>  'Successfully saved category with the following id...',
            'Successfully saved entry with the following id...'             =>  'Successfully saved entry with the following id...',
            'These are the arguments we are sending to select...'           =>  'These are the arguments we are sending to select...',
            'Updated the last_saved_entry_id attribute.'                    =>  'Updated the last_saved_entry_id attribute.',
            'We will be associating the following entry id...'              =>  'We will be associating the following entry id...',
            '...with this list of categories...'                            =>  '...with this list of categories...',


            'Because we checked for a valid entry earlier, we are assuming we can proceed to save to the entry table...'
                =>  'Because we checked for a valid entry earlier, we are assuming we can proceed to save to the entry table...',

            'Checking to see if this entry id already exists in the entries_categories table...'
                =>  'Checking to see if this entry id already exists in the entries_categories table...',
                
            'This entry id is not yet in the entries_categories table, so we will now proceed to saving it there...'
                =>  'This entry id is not yet in the entries_categories table, so we will now proceed to saving it there...',


            # Management::App::MVC::Model::Database::Data::Entry::retrieve
            'Making first attempt to retrieve data.'                        =>  'Making first attempt to retrieve data.',
            'Obtained categories in this order:'                            =>  'Obtained categories in this order:',
            'Preparing values for second data retrieval.'                   =>  'Preparing values for second data retrieval.',
            'Processing categories.'                                        =>  'Processing categories.',
            'Retrieved the following:'                                      =>  'Retrieved the following:',
            'Set initial values.'                                           =>  'Set initial values.',
            'This will do for now.'                                         =>  'This will do for now.',


            # Management::App::MVC::Model::Database::Data::save
        
            'Beginning with the following data...'                          =>  'Beginning with the following data...',
            'Our top category is valid.'                                    =>  'Our top category is valid.',
            'This is what we have been asked to save...'                    =>  'This is what we have been asked to save...',
            'To be saved to the following table...'                         =>  'To be saved to the following table...',

            
            # Management::App::MVC::Model::Entry - $set_duration private method

            'Set duration data.'                                            =>  'Set duration data.',
            
            # Management::App::MVC::Controller::Input::confirm_entries
            'Entries array contains [_1] entries.'                          =>  'Entries array contains [_1] entries.', # Also used by Management::App::MVC::Controller::Input::save_input
            'Generated the following layout structure:'                     =>  'Generated the following layout structure:',
            'Moving on to generate the page layout...'                      =>  'Moving on to generate the page layout...',
            
            # Management::App::MVC::Controller::Input::save_input
            'About to set initial values.'                                  =>  'About to set initial values.',

            'Saved Entry and then looked up the last saved entry ID, and got: [_1]'
                =>  'Saved Entry and then looked up the last saved entry ID, and got: [_1]',
        
        );
    } #trace

    Debug: {

        @logging_debug_phrases = (


            # Commonly used...


            # Management::App::MVC::Controller::Input

            'About to set initial values.'                                  =>  'About to set initial values.',
            'About to start processing.'                                    =>  'About to start processing.',
            'Created layout using Template Nest, and saved it to variable.' =>  'Created layout using Template Nest, and saved it to variable.',
            'No form input.'                                                =>  'No form input.',
            'Obtained form input...'                                        =>  'Obtained form input...',
            'Rendered the layout as text/html.'                             =>  'Rendered the layout as text/html.',
            'Set layout data structure as follows:'                         =>  'Set layout data structure as follows:',


            # Management::App::MVC::Controller::Input::entries
            
            'Invalid input.'                                                =>  'Invalid input.',
            'Valid input.'                                                  =>  'Valid input.',
            'What fields failed validation:'                                =>  'What fields failed validation:',

            # Management::App::MVC::Controller::Input::get_valid_add_entries_input

            'Values before validation:'                                     =>  'Values before validation:',


            # Management::App::MVC::Controller::Root::hello_world            
            'Testing from Hello World!'                                     =>  'Testing from Hello World! bob',


            # Management::App::MVC::Model::Entry

            'Invalid digit provided.'                                       =>  'Invalid digit provided.',


            # Management::App::MVC::Model::Entry - $set_duration private method

            'Duration is...'                                                =>  'Duration is...',
            'End Epoch is [_1] and Start Epoch is [_2].'                    =>  'End Epoch is [_1] and Start Epoch is [_2].',
            
            
            # Management::App::MVC::Model::BusinessLogic::Entry::$set_year_month_day_time
            
            'Start is...'                                                   =>  'Start is...',
            'End is...'                                                     =>  'End is...',
            
            # Management::App::MVC::Model::BusinessLogic::EntryFactory::multiple_entries
            
            'Day, Month, and Year are...'                                   =>  'Day, Month, and Year are...',
            
            # MojoLogCustomised:
            'Error stashed:'    =>  'Error stashed:',
            'Errors stashed:'   =>  'Errors stashed:',
            'Valid fields stashed:'  =>  'Valid fields stashed:',
            'Valid field stashed:'  =>  'Valid field stashed:',
        );

    } #debug

    Info: {
    
        @logging_info_phrases = (

        # Management::App::MVC::Controller::Root
        'Testing log any from test_logging subroutine.'                     =>  'Testing log any from test_logging subroutine.',
        'Testing TestLogAny from test_logging.'                             =>  'Testing TestLogAny from test_logging.',
        
        # Management::App::MVC::Model::TestLogAny
        'Log message from the test method via \$log.'                       =>  'Log message from the test method via \$log.',
        'Log message from the test method via \$self->log.'                 =>  'Log message from the test method via \$self->log.',

        );
    }

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
    @logging_debug_phrases,
    @logging_trace_phrases,
    @logging_info_phrases,
    @verbose_phrases,
    @stdout_phrases,
);

}

# ----------------------------------

#1;
