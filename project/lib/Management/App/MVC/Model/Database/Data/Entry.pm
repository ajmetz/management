use     Object::Pad v0.820;

class   Management::App::MVC::Model::Database::Data::Entry;
use     Management::App::Boilerplate::Code;
use     Management::App::MVC::View::Language;
use     Mojo::Util qw(dumper);
use     Data::Util qw(
            is_instance
            is_array_ref
        );
use     List::Util qw(none);

field   $data                   :param  :accessor   ;
field   $logger                 :param  :accessor   ;
field   $last_saved_entry_id    :reader             =   undef;
field   $matches_valid_digit                        =   qr/^\p{Digit}+$/;
field   $matches_allowed_characters                 =   qr/\p{Identifier_Status: Allowed}+/;
field   $entry_class                                =   'Management::App::MVC::Model::BusinessLogic::Entry';
field   $table_name                                 =   {
                                                            entries                     =>  'entries',
                                                            top_categories              =>  'top_categories',
                                                            categories                  =>  'categories',
                                                            entries_categories          =>  'entries_categories',
                                                        };
field   $fields                                     =   {
                                                            all                         =>  undef,
                                                            entries_fields_renamed      =>  [
                                                                                    
                                                                                                qw(
                                                                                                    details
                                                                                                ),
                                                                                    
                                                                                                # Fields AS ...
                                                                                                [start_time_utc_epoch   =>  'start_epoch'],
                                                                                                [end_time_utc_epoch     =>  'end_epoch'],
                                                                                    
                                                                                            ],
                                                            categories_fields           =>  ['category','top_category'],
                                                            category                    =>  ['category'],
                                                            top_categories_fields       =>  ['top_category'],
                                                            categories_top_category     =>  ['top_category'],
                                                            entries_id                  =>  ['id'],
                                                            entries_categories_entry_id =>  ['entry_id'], # entries_categories table.

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
    return none { fc $value eq fc $ARG->[0] } $existing_values->@*;
}

method save ($entry) {

    # Build what to save for top categories table.
    
    
    # Initial Values
    my $log                         =   $logger->clone( prefix => '[Management::App::MVC::Model::Database::Data::Entry::save] ');
    $log->trace('About to set initial values.');
    my  @nothing                    =   ();
    my  $save                       =   {};
    my  $saved                      =   {};
    my  $where                      =   {};
    my  @valid_categories           =   @nothing;
    
    $log->trace('Checking our Entry Object is valid.');
    
    my  $valid_entry                =   is_instance($entry, $entry_class)
                                        && $entry->can('start_epoch')
                                        && $entry->can('end_epoch')
                                        && $entry->can('details')
                                        && $entry->start_epoch  =~ $matches_valid_digit
                                        && $entry->end_epoch    =~ $matches_valid_digit
                                        && $entry->details? # not blank/false/untrue. We may wish to add further validation later.
                                            $entry:
                                        undef;
    die $log->fatal('Cannot save an invalid Entry object.') unless $valid_entry;

    $log->trace('Checking our top category is valid.');
    
    my  $valid_top_category         =   $valid_entry->top_category
                                        && ($valid_entry->top_category =~ $matches_allowed_characters)? $valid_entry->top_category:
                                        undef;
    $log->trace('Our top category is '.($valid_top_category? 'valid.':'invalid.'));

    $log->trace('Checking our top category is new...');
    my  $existing_top_categories    =   $data->database->handle->select($table_name->{top_categories} => $fields->{top_categories_fields})->arrays->to_array;
    my  $valid_new_top_category     =   $valid_top_category
                                        && is_array_ref($existing_top_categories)
                                        && $self->$is_new($valid_top_category, $existing_top_categories)? $valid_top_category:
                                        undef;
    $save->{top_categories}         =   [$valid_new_top_category]
                                        if $valid_new_top_category;
    
    $log->trace('Decided we have a valid and new top category to save.') if $valid_new_top_category;
    $log->trace('Decided we do not have a valid and new top category to save.') unless $valid_new_top_category;

    # Build what to save for categories table:

    $log->trace('Fetching existing categories from database.');
    my  $existing_categories        =   $data->database->handle->select($table_name->{categories} => $fields->{category})->arrays->to_array; # Can we not just category->retrieve_list?
    $log->trace('Existing categories from database are...', { existing_categories => $existing_categories },);

    $log->trace('Processing our Entry Object\'s categories.');
    $save->{categories}             =   [];
    foreach my $current_category ($valid_entry->categories->@*) {
        my      $valid_category                 =   $current_category
                                                    && ($current_category =~ $matches_allowed_characters)?  $current_category:
                                                    undef;
        push    @valid_categories               ,   $valid_category? $valid_category:@nothing; # This is silly. All categories in the entry should be valid already. Either validated on object construction, or via setters.
        my      $valid_new_category             =   $valid_category 
                                                    && $self->$is_new($valid_category, $existing_categories)?   $valid_category:
                                                    undef;
        my      $is_new_and_is_last_category    =   $valid_new_category
                                                    && fc $valid_new_category eq fc $valid_entry->categories->[-1];
        my      @with_optional_top_category     =   $is_new_and_is_last_category && $valid_top_category?    $valid_top_category:
                                                    @nothing;
        push    $save->{categories}->@*         ,   $valid_new_category?    [$valid_new_category, @with_optional_top_category]:
                                                    @nothing;

    }
    $log->trace('Decided to save these categories:', { categories => $save->{categories}}, ) if $save->{categories};
    
    # Build what to save for junction table:
        # Skipped.
        
    # Saving...
    $log->trace('Beginning the process of actually saving to database...');
    if ($save->{top_categories}) {
        $log->trace('Detected we have something to save to top_categories table...');
        $saved->{top_category}  =   $data
                                    ->save(
                                        {
                                            $table_name->{top_categories} => $save->{top_categories},
                                        }
                                    )
                                    ->last_insert_id_lookup->{$table_name->{top_categories}};
        die                         $log->fatal('model.entry.save.error.save_top_categories_data')
                                    unless $saved->{top_category};
        $log->trace('Successfully saved top category with the following id...', { top_category => $saved->{top_category} },);
    };
    
    foreach my $current_category_to_save ($save->{categories}->@*) {

        $log->trace('Detected we have something to save to categories table...', { categories => $save->{categories} }, );

        # Initial Values:
        $saved->{category}      =   undef; # Reset to undef for each loop.
        
        # Processing
        $log->trace('Intending to save the following category...', {current_category_to_save => $current_category_to_save},);
        $saved->{category}      =   $data->category
                                    ->save($current_category_to_save->@*)
                                    ->last_saved_category;
        # Verify:
        die                         $log->fatal('model.entry.save.error.save_category')
                                    unless $saved->{category};
        $log->trace('Successfully saved category with the following id...', { category => $saved->{category} },);
    };

    $log->trace(
        'Because we checked for a valid entry earlier, '.
        'we are assuming we can proceed to save to the entry table...'
    );
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
    die $log->fatal('model.entry.save.error.save_entry') unless $saved->{entry};
    my  $valid_entry_id         =   $saved->{entry} =~ $matches_valid_digit?    $saved->{entry}:
                                    undef; # Again - silly - the object should validate within its setter.
    die $log->fatal('model.entry.save.error.invalid_entry_id') unless $valid_entry_id;
    $valid_entry->id($saved->{entry});
    $log->trace('Successfully saved entry with the following id...')
    ->dump_values($valid_entry->id);
    $last_saved_entry_id    =   $valid_entry_id;
    $log->trace('Updated the last_saved_entry_id attribute.', { last_saved_entry_id => $last_saved_entry_id },);

    # Check entry is not already in junction table:
    $where->{matches_valid_entry_id}    =   { $fields->{entries_categories_entry_id}->[0] =>  $valid_entry->id }; # entry_id has to be dereferenced for a where clause. 
    $log->trace('Checking to see if this entry id already exists in the entries_categories table...');
    $log->trace('These are the arguments we are sending to select...', {
                                                arguments =>
                                                [
                                                    $table_name->{entries_categories},
                                                    $fields->{entries_categories_entry_id},
                                                    $where->{matches_valid_entry_id},
                                                ],
    });
    my  $existing_record_found          =   scalar ($data->database->handle
                                            ->select(
                                                $table_name->{entries_categories},
                                                $fields->{entries_categories_entry_id},
                                                $where->{matches_valid_entry_id},
                                            )
                                            ->arrays->to_array->@*); # Later, this need not be a die, and can simply prompt for confirmation before overwrite - which will be a removal, before an insert.

    die                                     $log->fatal('model.entry.save.error.existing_record_found')
                                            if $existing_record_found;

    $log
    ->trace('This entry id is not yet in the entries_categories table, so we will now proceed to saving it there...')
    ->trace('We will be associating the following entry id...', { id => $valid_entry->id },)
    ->trace('...with this list of categories...',{ valid_categories => [@valid_categories] },);

    foreach my $current_valid_category (@valid_categories) {
        $log->trace('For category...', {current_valid_category => $current_valid_category},);
        $saved->{entries_categories}    =   $data->save(
                                                {
                                                    $table_name->{entries_categories} =>    [$valid_entry->id, $current_valid_category],
                                                }
                                            )->last_insert_id_lookup->{$table_name->{entries_categories}};
        die                                 $log->fatal('model.entry.save.error.save_entries_categories')
                                            unless $saved->{entries_categories};
    }
    
    return $self;

}



method retrieve_last_saved {
    return  $last_saved_entry_id? $self->retrieve($last_saved_entry_id):
            undef;
}

method retrieve ($id) {

    # Initial Values:
    my  $log                                =   $logger->clone( prefix => '[Management::App::MVC::Model::Database::Data::Entry::retrieve] ', );

    $log->trace('About to set initial values.');

    my  $categories                         =   [];
    my  $where = {
        id_is_id                            =>  {
                                                    $fields->{entries_id}->[0] => $id,
                                                },
        entry_id_is_id                      =>  {
                                                    $fields->{entries_categories_entry_id}->[0] => $id,
                                                },
    };

    my  $what_to_retrieve = {
        $table_name->{entries}              =>  [
                                                    $fields->{entries_fields_renamed},
                                                    $where->{id_is_id},
                                                ],
        $table_name->{entries_categories}   =>  [
                                                    $fields->{category},
                                                    $where->{entry_id_is_id},
                                                ],
    };

    $log->trace('Set initial values.');
    
    # Processing:
    $log->trace('Making first attempt to retrieve data.');

    my  $hash_ref                           =   $data->retrieve($what_to_retrieve);

    $log->trace('Retrieved the following:', {hash_ref => $hash_ref},);
    
    #die $logger->fatal('This will do for now.')->dump_values($hash_ref);

    $log->trace('Processing categories.');

    push $categories->@*                    ,   $ARG->{category}
                                                for $hash_ref->{entries_categories}->@*;

    $log->trace('Obtained categories in this order:', { categories => $categories }, );
    #die $logger->fatal('This will do for now.', { categories => $categories }, );

    $log->trace('Preparing values for second data retrieval.');
    
    $where->{category_is_category}          =   {
                                                    $fields->{category}->[0] => $categories->[-1],
                                                };

    $what_to_retrieve = {
        $table_name->{categories}           =>  [
                                                    $fields->{categories_top_category},
                                                    $where->{category_is_category},
                                                ],
    };
 
    my  $top_category                       =   $data->retrieve($what_to_retrieve)->{categories}->[0]->{top_category};

    #die $logger->fatal('This will do for now.', { hash_ref => $hash_ref }, );

    my  @object_params                      =   (
                                                    start           =>  $hash_ref->{entries}->[0]->{start_epoch},
                                                    end             =>  $hash_ref->{entries}->[0]->{end_epoch},
                                                    details         =>  $hash_ref->{entries}->[0]->{details},
                                                    categories      =>  $categories,
                                                    top_category    =>  $top_category,
                                                    logger          =>  $logger,
                                                    id              =>  $id,
                                                );

    #die $logger->fatal('This will do for now.', { object_params => [@object_params] },);

    my  $entry                              =   $entry_class->new(@object_params);

    return                                      $entry? $entry:
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


