use     Object::Pad v0.820;

class   Management::Model::Entry;
use     Management::Boilerplate::Code;
use     Management::Languages;
use     Mojo::Util qw(dumper);
use     English;
use     Entry;

# Define once during class declaration:

my  $table_name =   {
                        entries             =>  'entries',
                        top_categories      =>  'top_categories',
                        categories          =>  'categories',
                        entries_categories  =>  'entries_categories',
                    };

my  $fields     =   {
                        all                     =>  undef,
                        entries_fields_renamed  =>  [
                                            
                                                        qw(
                                                            details
                                                            top_category_id
                                                        ),
                                            
                                                        # Fields AS ...
                                                        [start_time_utc_epoch   =>  'start_epoch'],
                                                        [end_time_utc_epoch     =>  'end_epoch'],
                                            
                                                    ],
                        categories_fields_without_id    =>  ['category','level'],
                        top_categories_top_category     =>  ['top_category'],
                    };

# When the defined once during class declaration stuff is used in fields below, it is a constant accessible as per the field declaration, in each instance:

field   $data                   :param  :accessor;
field   $last_saved_entry_id    :reader                         =   undef;

field   $table_name                                             =   $table_name;
field   $fields                                                 =   $fields;
field   $matches_valid_digit                                    =   qr/^\p{Digit}+$/;
field   $entries_categories_table_joined_with_categories_table  =   [
                                                                        $table_name->{'entries_categories'} =>  [
                                                                                                                    $table_name->{'categories'},
                                                                                                                        # Column in categories table    =>  Column in entries_categories table
                                                                                                                        'id'                            =>  'category_id',
                                                                                                                ],
                                                                    ];
field   $entries_table_joined_with_top_categories_table         =   [
                                                                        $table_name->{'entries'}            =>  [
                                                                                                                   $table_name->{'top_categories'},
                                                                                                                         # Column in top_categories table   =>  Column in entries table
                                                                                                                         'category'                         =>  'top_categories_id',
                                                                                                                ],
                                                                    ];

method  $top_category_from_id($id) {

    my  $where  =   {
        'id_is_id'  =>  {   id    =>  $id   },
    };

    $data->database->select(
        $table_name->{'top_categories'},
        $fields->{'all'},
        $where->{'id_is_id'},
    )->hash->{'top_category'};

}

method $top_categories_table_row_id ($top_category) {

    my  $where  =   {
        'top_category_equals_top_category'  =>  {   top_category    =>  $top_category   },
    };

    $data->database->select(
        $table_name->{'top_categories'},
        $fields->{'all'},
        $where->{'category_equals_category'},
    )->hash->{'id'};
}

method create (%object_construction_params) {

    # Initial Values:
    my  $entry          =   Entry->new(%object_construction_params);
    my  $valid_data     =   $entry
                            && blessed($entry)
                            && $entry->can('save_data')
                            && $entry->save_data?   $entry:
                            undef; # Should also add validation for data structure too, and table names too, most likely.
    my  $top_category_id=   $self->$top_categories_table_row_id($valid_data->{$table_name->{'entries'}}->[0]->{'top_category_id'});
    $valid_data->{$table_name->{'entries'}}->[0]->{'top_category_id'} = $top_category_id;
    
    warn                    $valid_data?    'Valid data to save.':
                            'Invalid data to save.';

    if ($valid_data) {
        my  $last_insert_id_lookup    =   $data->save($valid_data)->last_insert_id_lookup;
        warn 'last insert data is....'.dumper($last_insert_id_lookup);
        $last_saved_entry_id  =   $last_insert_id_lookup->{entries};
        my  $junction_table_save_data   =   {
            entries_categories  =>  [
                                        map {
                                            {
                                                entry_id            =>  $last_insert_id_lookup->{entries},
                                                category_id         =>  $ARG,
                                            }
                                        } $last_insert_id_lookup->{categories}->@*,
                                    ],
        };
        $data->save($junction_table_save_data);
    };
    
    return $self;

}

method retrieve_last_saved {
    return  $last_saved_entry_id? $self->retrieve($last_saved_entry_id):
            undef;
}

method retrieve ($id) {

    $data->app->log_fatal('Invalid digit provided.') unless $id =~ $matches_valid_digit;

    #Grab from db
    my  $where  =   {
        'id_is_id'                      =>  {   id          =>  $id },
        'entry_id_is_id'                =>  {   'entry_id'  =>  $id },
    };

    my  $entries_params                 =   $data->database->select(
                                                $table_name->{'entries'},
                                                $fields->{'entries_fields_renamed'},
                                                $where->{'id_is_id'},
                                            )->hash;
                                            
    $where->{'top_categories_id_is_top_category_id'}    =  {   'id'  =>  $entries_params->{top_category_id},  };
    $entries_params->{categories}       =   $data->database->select(
                                                $entries_categories_table_joined_with_categories_table,
                                                $fields->{'categories_fields'},
                                                $where->{'entry_id_is_id'},
                                            )->hashes->to_array; # Validation?
    $entries_params->{top_category}   =   $self->top_category_from_id($entries_params->{top_category_id});


    #die "That will do for now.".dumper($entries_params); # Let's learn how category gets retrieved, since it is expected to be a value that's an array ref of hashrefs.
    warn "Entries_params:".dumper($entries_params); # Let's learn how category gets retrieved, since it is expected to be a value that's an array ref of hashrefs.
    
    # Create object with values
    my  $entry  =   Entry->new(
        $entries_params->%*,
    );
    
    return $entry;
    

}

method update {
}

method delete {

}


__END__

# "SELECT * FROM a JOIN b ON (b.a_id = a.id) JOIN c ON (c.a_id = a.id)"
$abstract->select(['a', ['b', a_id => 'id'], ['c', a_id => 'id']]);


FIRST APPROACH:

    #Grab from db
    
    #$data->database->select(['entries', ['categories', category_id => 'category_id']]
    my  $retrieved                  =   $data->database->select(
        # Source:
        [
            'entries_categories'    =>  ['entries',
                                            'id '   =>  'entries_categories.entry_id',
                                        ],
                                        ['categories',
                                            'categories.id' => 'entries_categories.category_id',
                                        ],
        ],
        # Fields:
        [

            qw(
                details
                top_category_id
            ),

            # Fields AS ...
            [start_time_utc_epoch   =>  'start_epoch'],
            [end_time_utc_epoch     =>  'end_epoch'],

        ],

        # Where:
        {
            'entries.id'            =>  $id,   
        }

    )->hash;


SECOND APPROACH:

    #Grab from db
    
    #$data->database->select(['entries', ['categories', category_id => 'category_id']]
    my  $retrieved                  =   $data->database->select(
        # Source:
        [
            'entries_categories'    =>  ['entries',
                                            'id'   =>  'entry_id',
                                        ],
                                        ['categories',
                                            'id' => 'category_id',
                                        ],
        ],
        # Fields:
        [

            qw(
                details
                top_category_id
                categories.category
            ),

            # Fields AS ...
            [start_time_utc_epoch   =>  'start_epoch'],
            [end_time_utc_epoch     =>  'end_epoch'],

        ],

        # Where:
        {
            'entries.id'            =>  $id,   
        },

    )->hashes;

....good, but two resultsets for two entries_catagories rows, creating too many.

ATTEMPTING A ROUGH THIRD APPROACH:

Due to lack of group_concat on SQLite, we'll 

    #Grab from db
    
    my$data->database->select(['entries', ['categories' category_id => 'category_id']]
    my  $retrieved                  =   $data->database->select(
        # Source:
        [
            'entries_categories'    =>  ['entries',
                                            'id'   =>  'entry_id',
                                        ],
                                        ['categories',
                                            'id' => 'category_id',
                                        ],
        ],
        # Fields:
        [

            qw(
                details
                top_category_id
                categories.category
            ),

            # Fields AS ...
            [start_time_utc_epoch   =>  'start_epoch'],
            [end_time_utc_epoch     =>  'end_epoch'],

        ],

        # Where:
        {
            'entries.id'            =>  $id,   
        },

    )->hashes;

FOURTH:

    $data->app->log_fatal('Invalid digit provided.') unless $id =~ $matches_valid_digit;

    #Grab from db
    my  $where  =   {
        'id_is_id'                      =>  {   id          =>  $id },
        'entry_id_is_id'                =>  {   'entry_id'  =>  $id },
    };

    my  $entries_params                 =   $data->database->select(
                                                $entries_table_name,
                                                $fields->{'entries_fields_renamed'},
                                                $where->{'id_is_id'},
                                            )->hash;
                                            
    $where->{'top_categories_id_is_top_category_id'}    =  {   'id'  =>  $entries_params->{top_category_id},  };
    $entries_params->{categories}       =   $data->database->select(
                                                $entries_categories_table_joined_with_categories_table,
                                                $fields->{'categories_fields'},
                                                $where->{'entry_id_is_id'},
                                            )->hashes->to_array; # Validation?
    $entries_params->{top_category}   =   $data->database->select(
                                                $top_categories_table_name,
                                                $fields->{'top_categories_top_category'},
                                                $where->{'top_categories_id_is_top_category_id'},
                                            )->hash;


    #die "That will do for now.".dumper($entries_params); # Let's learn how category gets retrieved, since it is expected to be a value that's an array ref of hashrefs.
    warn "Entries_params:".dumper($entries_params); # Let's learn how category gets retrieved, since it is expected to be a value that's an array ref of hashrefs.
    
    # Create object with values
    my  $entry  =   Entry->new(
        $entries_params->%*,
    );
    
    return $entry;
    
method  category_and_level(@params) {
    category_and_level_from_categories_table_id(@params);
    
}

method  category_and_level_from_categories_table_id ($id) {

    my  $where  =   {
        'id_is_id'  =>  {   id    =>  $id   },
    };

    $data->database->select(
        $categories_table_name,
        $fields->{'categories_fields_without_id'},
        $where->{'id_is_id'},
    )->hash;

}

method categories_table_row_id ($category) {
    my  $where  =   {
        'category_equals_category'  =>  {   category    =>  $category   },
    };

    $data->database->select(
        $categories_table_name,
        $fields->{'all'},
        $where->{'category_equals_category'},
    )->hash->{'id'};
}