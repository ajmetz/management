use     Object::Pad v0.820;

class   Management::Model::Entry;
use     Management::Boilerplate::Code;
use     Management::Languages;
use     Mojo::Util qw(dumper);
use     English;
use     Entry;
use     Data::Util;
use     List::Util qw(none);

field   $data                   :param  :accessor   ;
field   $app                    :param  :accessor   ;
field   $last_saved_entry_id    :reader             =   undef;
field   $matches_valid_digit                        =   qr/^\p{Digit}+$/;
field   $matches_allowed_characters                 =   qr/\p{Identifier_Status: Allowed}+/;
field   $input_class                                =   'Entry';
field   $table_name                                 =   {
                                                            entries                 =>  'entries',
                                                            top_categories          =>  'top_categories',
                                                            categories              =>  'categories',
                                                            entries_categories      =>  'entries_categories',
                                                        };
field   $fields                                     =   {
                                                            all                     =>  undef,
                                                            entries_fields_renamed  =>  [
                                                                                
                                                                                            qw(
                                                                                                details
                                                                                            ),
                                                                                
                                                                                            # Fields AS ...
                                                                                            [start_time_utc_epoch   =>  'start_epoch'],
                                                                                            [end_time_utc_epoch     =>  'end_epoch'],
                                                                                
                                                                                        ],
                                                            categories_fields       =>  ['category','top_category'],
                                                            category                =>  ['category'],
                                                            top_categories_fields   =>  ['top_category'],
                                                            entry_id                =>  ['entry_id'], # This is in both entries table and entries_categories table.

                                                        };



method object_params_to_data ($entry) {

    return {
        entries         =>  [{
                                'start_time_utc_epoch'  =>  $entry->start_epoch,
                                'end_time_utc_epoch'    =>  $entry->end_epoch,
                                'details'               =>  $entry->details,
                            }],
        categories      =>  $entry->categories,
        top_categories  =>  [{
                                top_category            =>  $entry->top_category,
                            }],
    };

}

method valid_for_saving ($entry) {
    # Checks if entry has all info needed for saving.
    
}

method $is_new ($value, $existing_values) {
    return none { fc $value eq fc $ARG } $existing_values->@*;
}

method save ($entry) {

    # Build what to save for top categories table.
    
    
    # Initial Values

    my  @nothing                    =   ();
    my  $save                       =   {};
    my  $saved                      =   {};
    my  $where                      =   {};
    my  $valid_entry                =   instance($entry, $input_class)
                                        && $entry->can('start_epoch')
                                        && $entry->can('end_epoch')
                                        && $entry->can('details')
                                        && $entry->start_epoch  =~ $matches_valid_digit
                                        && $entry->end_epoch    =~ $matches_valid_digit
                                        && $entry->details # not blank/false/untrue. We may wish to add further validation later.
                                        ;
    my  $valid_top_category         =   $valid_entry->top_category
                                        && ($valid_entry->top_category =~ $matches_allowed_characters)? $valid_entry->top_category:
                                        undef;
    my  $existing_top_categories    =   $data->database->select($table_name->{top_categories} => $fields->{top_categories_fields})->arrays->to_array;
    my  $valid_new_top_category     =   $self->$is_new($valid_top_category, $existing_top_categories)? $valid_top_category:
                                        undef;
    $save->{top_categories}         =   [$valid_new_top_category]
                                        if $valid_new_top_category;
    
    # Build what to save for categories table:
    my  $existing_categories        =   $data->database->select($table_name->{categories} => $fields->{category})->arrays->to_array; # Can we not just category->retrieve_list?
    $save->{categories}             =   [];
    foreach my $current_category ($valid_entry->categories->@*) {
        my      $valid_category                 =   $current_category
                                                    && ($current_category =~ $matches_allowed_characters)?  $current_category:
                                                    undef;
        push    @valid_categories               ,   $valid_category; # This is silly. All categories in the entry should be valid already. Either validated on object construction, or via setters.
        my      $valid_new_category             =   $self->$is_new($valid_category, $existing_categories)?         $valid_category:
                                                    undef;
        my      $is_new_and_is_last_category    =   fc $valid_new_category eq fc $valid_entry->categories->[-1];
        my      @with_optional_top_category     =   $is_new_and_is_last_category && $valid_top_category?    $valid_top_category:
                                                    @nothing;
        push    $save->{categories}->@*         ,   $valid_new_category?    [$valid_new_category, @with_optional_top_category]:
                                                    @nothing;

    }
    
    # Build what to save for junction table:
        # Skipped.
        
    # Saving...
    if ($save->{top_categories}) {
        $saved->{top_category}  =   $data
                                    ->save(
                                        {
                                            $table_name->{top_categories} => $save->{top_categories},
                                        }
                                    )
                                    ->last_insert_id_lookup->{$table_name->{top_categories}};
        die                         $app->log_fatal('model.entry.save.error.save_top_categories_data')
                                    unless $saved->{top_category};
    };
    
    foreach my $current_category_fields_to_save ($save->{categories}->@*) {

        # Initial Values:
        $saved->{category}      =   undef; # Reset to undef for each loop.
        
        # Processing
        $saved->{category}      =   $app->category
                                    ->save($current_category_fields_to_save->@*)
                                    ->last_saved_category;
        # Verify:
        die                         $app->log_fatal('model.entry.save.error.save_category')
                                    unless $saved->{category};

    };

    $saved->{entry}             =   $data
                                    ->save(
                                        {
                                            $table_name->{entries} => {
                                                start_time_utc_epoch    =>  $valid_entry->start_epoch,
                                                end_time_utc_epoch      =>  $valid_entry->end_epoch,
                                                details                 =>  $valid_entry->details,
                                            },
                                        }
                                    )
                                    ->last_insert_id_lookup->{$table_name->{entries}};
    die $app->log_fatal('model.entry.save.error.save_entry') unless $saved->{entry};
    my  $valid_entry_id         =   $saved->{entry} =~ $matches_valid_digit; # Again - silly - the object should validate within its setter.
    die $app->log_fatal('model.entry.save.error.invalid_entry_id') unless $valid_entry_id;
    $valid_entry->id($saved->{entry});

    # Check entry is not already in junction table:
    $where->{matches_valid_entry_id}    =   { $fields->{entry_id} =>  $valid_entry->id };
    my  $existing_record_found          =   scalar $data->database
                                            ->select(
                                                $table_name->{entries_categories},
                                                $fields->{entry_id},
                                                $where->{matches_valid_entry_id},
                                            )
                                            ->arrays->to_array->@*; # Later, this need not be a die, and can simply prompt for confirmation before overwrite - which will be a removal, before an insert.

    die                                     $app->log_fatal('model.entry.save.error.existing_record_found')
                                            if $existing_record_found;

    foreach my $current_valid_category (@valid_categories) {
        $saved->{entries_categories}    =   $data->save($table_name->{entries_categories} => [$valid_entry->id, $current_valid_category])->last_insert_id_lookup->{$table_name->{entries_categories}};
        die                                 $app->log_fatal('model.entry.save.error.save_entries_categories')
                                            unless $saved->{entries_categories};
    }
    
    return $self;

}



method retrieve_last_saved {
    return  $last_saved_entry_id? $self->retrieve($last_saved_entry_id):
            undef;
}






__END__

========

Entry Model:

	* build what to save for top categories table
		do we have a top category?
				compare against list of known top categories
					if it's a new top category
						is it valid?
							set is as one to save

	* build what to save for catagories table
			compare against list of known (prevalidated) categories.
			if it's a new category,
				is it valid?
					set it as one to save
						and is it the last category, and do we have a valid top_category?
							set valid top category to include alongside it

	* build what to save for junction table:
		not necessary - by this stage we know all categories are valid.
			As long as new valid categories are saved successfully first 
			The hash still needs building of course
				entries_categories => [entry_id, category]
					so perhaps you could build it as a string with %s as a placeholder, and then populate it later, with sprintf, and then turn it into a hash with eval? No. Lol.


	* Check Entry has valid start_epoch, end_epoch and details. Potentially via validator.

	* Save any new top categories set to be saved.
	* Check valid last top_category inserted, else complain there's a problem with top_category save.

	* Save any new categories set to be saved.
	* Check valid last category saved, else complain there's a problem.

	* Save entry details to the entries table, and obtain a last entry inserted id.
	* Check valid last entry inserted id
		else complain there's a problem with entry save.
    	add to entry->id

	* Build what to save for junction table
		for each @category
			push to $what to save
				entries_catagories => [entry_id, $current_category]
	* save to junction table
		Check the last_updated_entry_id isn't already present in the junction table.
		If it is, we'll need a remove procedure before an insert procedure,
			and the user should be consulted for approval for such an overwrite.
		$self->data->save($what_to_save)->get last id;

==========




    # Validate the entry object - check it has all the value we'll be looking for when saving.
    # This may not be a fail. We might populate key fields ourselves - i.e. the top_category.





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