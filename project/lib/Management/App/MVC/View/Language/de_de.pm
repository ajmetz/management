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
my  @logging_trace_phrases;
my  @logging_debug_phrases;
my  @logging_info_phrases;
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


            # Management::App::MVC::Controller::Input::ask_days

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
        

            # Management::App::MVC::Model::BusinessLogic::Entry::status_string

            'object.entry.status.category_log_delimiter'    =>  ', ', # comma and space


            # Management::App::MVC::Model::BusinessLogic::Entry::$set_duration

            'model.entry.set_duration.duration_string'      =>  '[_1]hr [_2]mins',

            
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

    Lang: {

        @tokens_long = (

            'object.entry.error.invalid_start_values'
                =>  'Could not obtain values from start string. Please use the format "dd/mm/yyyy hh:mm" or an epoch number.',

            # Management::App::MVC::Model::BusinessLogic::Entry::status_string

            'object.entry.status.category_delimiter'
                =>
'
                ',

            'object.entry.status.formatting'
                =>
'
Class:              [_1]

ID:                 [_2]
Time Zone:          [_3]
Start:              [_4]
End:                [_5]
Start UTC Epoch:    [_6]
End UTC Epoch:      [_7]
Duration:           [_8]

Top Category:       [_9]
Categories:         [_10]

Details:
[_11]
',

            'object.entry.status.log_formatting'
                => 'Class: [_1], ID: [_2], Time Zone: [_3], Start: [_4], End: [_5], Start UTC Epoch: [_6], End UTC Epoch: [_7], Duration: [_8], Top Category: [_9], Categories: [_10], Details: [_11]',

            # Management::App::MVC::Model::BusinessLogic::Entry::$set_year_month_day_time

            'entry.set_year_month_day_time.log_string_of_set_values'
                =>  'Start Year: [_1], Start Month: [_2], Start Day: [_3], Start Time: [_4], End Year: [_5], End Month: [_6], End Day: [_7], End String: [_8]',

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


            # Commonly used...

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

        
            # Management::App::MVC::Controller::Root::hello_world

            'Testing from Hello World!' =>  'Testing from Hello World!',

        
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

    Trace: {
        @logging_trace_phrases = (

            # Management::App::MVC::Controller::Input::confirm_entries

            'Entries array contains [_1] entries.'                          =>  'Entries array contains [_1] entries.', # Also used by Management::App::MVC::Controller::Input::save_input
            'Generated the following layout structure:'                     =>  'Generated the following layout structure:',
            'Moving on to generate the page layout...'                      =>  'Moving on to generate the page layout...',
            
            # Management::App::MVC::Controller::Input::save_input

            'About to set initial values.'                                  =>  'About to set initial values.',

            'Saved Entry and then looked up the last saved entry ID, and got: [_1]'
                =>  'Saved Entry and then looked up the last saved entry ID, and got: [_1]',


            # Management::App::MVC::Model::BusinessLogic::Entry::$instance_setup
            
            'About to set the order in which we will run our setup-related private methods.'
                =>  'About to set the order in which we will run our setup-related private methods.',


            # Management::App::MVC::Model::BusinessLogic::Entry::new - ADJUST Phase
            
            'About to call private method [_1] as part of new\'s ADJUST phase (See URL: [_2]).'
                =>  'About to call private method [_1] as part of new\'s ADJUST phase (See URL: [_2]).',


            # Management::App::MVC::Model::BusinessLogic::Entry::$set_utc_epochs

            'UTC epochs already set.'                                       =>  'UTC epochs already set.',
            'UTC epochs set.'                                               =>  'UTC epochs set.',


            # Management::App::MVC::Model::BusinessLogic::Entry::$set_year_month_day_time

            'About to update our end string, using the new values.'         =>  'About to update our end string, using the new values.',

            'About to begin processing the end input param, to ensure it delivers the string we want.'
                =>  'About to begin processing the end input param, to ensure it delivers the string we want.',

            'About to begin processing the start input param, to ensure it delivers the string we want.'
                =>  'About to begin processing the start input param, to ensure it delivers the string we want.',
                
            'About to check our start and end strings for valid start and end values.'
                =>  'About to check our start and end strings for valid start and end values.',

            'About to return self for fluent interface / method chaining, and exit method.'
                =>  'About to return self for fluent interface / method chaining, and exit method.',

            'About to set our end year, month, day, and time, from our valid end values.'
                =>  'About to set our end year, month, day, and time, from our valid end values.',
                
            'About to set our start year, month, day, and time, from our valid start values.'
                =>  'About to set our start year, month, day, and time, from our valid start values.',

            'About to throw an exception if the hashrefs for valid start and end values are undefined, false, or zero length in scalar context.'
                =>  'About to throw an exception if the hashrefs for valid start and end values are undefined, false, or zero length in scalar context.',

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
        
        );
    } #trace

    Debug: {


        @logging_debug_phrases = (


            # Commonly used...

            # Management::App::MVC::Controller::Input
            
            'About to set initial values.'                                  =>  'Im Begriff, Anfangswerte festzulegen.',
            'About to start processing.'                                    =>  'Jetzt am Anfang der Verarbeitung.',
            'Created layout using Template Nest, and saved it to variable.' =>  'Layout mit Template Nest erstellt und in Variable gespeichert.',
            'No form input.'                                                =>  'Keine Formulareingabe.',
            'Obtained form input...'                                        =>  'Formulareingabe erhalten...',
            'Rendered the layout as text/html.'                             =>  'Das Layout wurde als text/html gerendert.',
            'Set layout data structure as follows:'                         =>  'Die Layoutdatenstruktur wurde wie folgt festgelegt:',


            # Management::App::MVC::Controller::Input::entries
            
            'Invalid input.'                                                =>  'Invalid input.',
            'Valid input.'                                                  =>  'Valid input.',
            'What fields failed validation:'                                =>  'What fields failed validation:',

            # Management::App::MVC::Controller::Input::get_valid_add_entries_input

            'Values before validation:'                                     =>  'Values before validation:',

            # Management::App::MVC::Controller::Input::show_days
            'Input Provided: '                                              =>  'Input Provided: ',
            'List of entry ids:'                                            =>  'List of entry ids:',
            'List of entry objects:'                                        =>  'List of entry objects:',
            

            # Management::App::MVC::Controller::Root::hello_world            
            'Testing from Hello World!'                                     =>  'Testing from Hello World! bob',


            # Management::App::MVC::Model::BusinessLogic::EntryFactory::multiple_entries
            
            'Day, Month, and Year are...'                                   =>  'Day, Month, and Year are...',

            'Prepare to return an empty list as a quiet fail, if we don\'t have our prerequisites.'
                =>  'Prepare to return an empty list as a quiet fail, if we don\'t have our prerequisites.',

            # Management::App::MVC::Model::BusinessLogic::Entry::new - ADJUST Phase
            
            'Instance status is: '                                          =>  'Instance status is: ',


            # Management::App::MVC::Model::BusinessLogic::Entry::$set_year_month_day_time

            'After update:'                                                 =>  'After update:',
            'Before update:'                                                =>  'Before update:',
            'Start is...'                                                   =>  'Start is...',
            'End is...'                                                     =>  'End is...',
            'Values set as follows: [_1]'                                   =>  'Values set as follows: [_1]',


            # Management::App::MVC::Model::Entry - Commonly used...

            'Daylight saving is in effect.'                                 =>  'Daylight saving is in effect.',
            'Daylight saving is not in effect.'                             =>  'Daylight saving is not in effect.',
            'Invalid digit provided.'                                       =>  'Ungültige Ziffer angegeben.', # Unsure this is used in the codebase anywhere.


            # Management::App::MVC::Model::BusinessLogic::Entry::$set_duration

            'Duration is...'                                                =>  'Duration is...',
            'End UTC Epoch is [_1] and Start UTC Epoch is [_2].'            =>  'End UTC Epoch is [_1] and Start UTC Epoch is [_2].',

            # Management::App::MVC::Model::BusinessLogic::Entry::$set_utc_epochs

            'End Datetime converted to UTC timezone: [_1]'                  =>  'End Datetime converted to UTC timezone: [_1]',
            'End Datetime created in "[_2]" timezone: [_1]'                 =>  'End Datetime created in "[_2]" timezone: [_1]',
            'Start Datetime converted to UTC timezone: [_1]'                =>  'Start Datetime converted to UTC timezone: [_1]',
            'Start Datetime created in "[_2]" timezone: [_1]'               =>  'Start Datetime created in "[_2]" timezone: [_1]',


            
            # Management::App::MVC::Model::BusinessLogic::Entry::$utc_epoch_to_time_zone_string

            'About to return the following string: [_1]'                    =>  'About to return the following string: [_1]',
            'UTC Datetime converted to [_2] Timezone : [_1]'                =>  'UTC Datetime converted to [_2] Timezone : [_1]',
            'UTC Epoch translated to Datetime: [_1]'                        =>  'UTC Epoch translated to Datetime: [_1]',


            # MojoLogCustomised:
            'Error stashed:'                                                =>  'Error stashed:',
            'Errors stashed:'                                               =>  'Errors stashed:',
            'Valid fields stashed:'                                         =>  'Valid fields stashed:',
            'Valid field stashed:'                                          =>  'Valid field stashed:',

            

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
    @logging_debug_phrases,
    @logging_trace_phrases,
    @logging_info_phrases,
    @verbose_phrases,
    @stdout_phrases,
);

}

# ----------------------------------

#1;
