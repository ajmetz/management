use     Object::Pad v0.820;

class   Management::Model::Category;
use     Management::Boilerplate::Code;
use     Management::Languages;
use     Mojo::Util qw(dumper);
use     English;

field   $data                   :param  :accessor               ;
field   $app                    :param  :accessor               ;
field   $last_saved_category    :reader                         =   undef;
field   $default_top_category                                   =   'OTHER';

method save ($category, $top_category //= $default_top_category) {

    $last_saved_category    =   $data->save('categories' => [$category,$top_category]->last_insert_id_lookup;

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

======

field   $entries_table_joined_with_top_categories_table         =   [
                                                                        $table_name->{'entries'}            =>  [
                                                                                                                   $table_name->{'top_categories'},
                                                                                                                         # Column in top_categories table   =>  Column in entries table
                                                                                                                         'category'                         =>  'top_categories_id',
                                                                                                                ],
                                                                    ];
                                                                    
                                                                    ======
                                                                    
                                                                    method  $top_category_from_last_category($entry) {

    my  $where  =   {
        'id_is_id'  =>  {   top_category    =>  $id   },
    };

    $data->database->select(
        $table_name->{'top_categories'},
        $fields->{'all'},
        $where->{'id_is_id'},
    )->hash->{'top_category'};

}


======


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
    $entries_params->{top_category}   =   $self->$top_category_from_id($entries_params->{top_category_id});


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

method create (%object_construction_params) {

    # Initial Values:
    my  $entry              =   Entry->new(%object_construction_params);
    my  $valid_save_data    =   valid_save_data($entry);

    warn "Valid save data: ".dumper($valid_save_data);

    $valid_save_data->{"$table_name->{'entries'}"}->[0]->{'top_category_id'}    =   $self->$top_categories_table_row_id(
                                                                                        $valid_save_data->{"$table_name->{'entries'}"}->[0]->{'top_category_id'} # assuming top category name that needs converting to an id.
                                                                                    );
    
    warn                    $valid_save_data?    'Valid data to save.':
                            'Invalid data to save.';

    if ($valid_save_data) {

        my  $last_insert_id_lookup  =   $data->save($valid_save_data)->last_insert_id_lookup;

        warn 'last insert data is....'.dumper($last_insert_id_lookup);

        $last_saved_entry_id        =   $last_insert_id_lookup->{entries};

        $self->save_to_entries_categories_junction_table(
            $last_insert_id_lookup->{entries},
            $last_insert_id_lookup->{categories}->@*
        );
        
    };
    
    return $self;

}

method save_to_entries_categories_junction_table ($entry_id, @categories) {

        my  $junction_table_save_data   =   {
            entries_categories          =>  [
                                                map {
                                                        {
                                                            entry_id    =>  $entry_id,
                                                            category_id =>  $ARG,
                                                        }
                                                } @categories,
                                            ],                                    
        };

        $data->save($junction_table_save_data);

        return $self;

}