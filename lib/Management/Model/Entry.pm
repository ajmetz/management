use     Object::Pad v0.820;

class   Management::Model::Entry;
use     Management::Boilerplate::Code;
use     Management::Languages;
use     Mojo::Util qw(dumper);
use     English;
use     Entry;

field   $data                   :param  :accessor;
#field   $last_insert_id_lookup  :reader             =   {};
field   $last_entry_id          :reader             =   undef;


method create (%object_construction_params) {

    # Initial Values:
    my  $entry          =   Entry->new(%object_construction_params);
    my  $valid_data     =   $entry
                            && blessed($entry)
                            && $entry->can('save_data')
                            && $entry->save_data; # Should also add validation for data structure too, and table names too, most likely.

    warn                    $valid_data?    'Valid data to save.':
                            'Invalid data to save.';

    if ($valid_data) {
        my  $last_insert_id_lookup    =   $data->save($valid_data)->last_insert_id_lookup;
        warn 'last insert data is....'.dumper($last_insert_id_lookup);
        $last_entry_id  =   $last_insert_id_lookup->{entries};
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

method retrieve_last {
    return  $last_entry_id? $self->retrieve($last_entry_id):
            undef;
}

method retrieve ($id) {

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

    die "That will do for now.".dumper($retrieved); # Let's learn how category gets retrieved, since it is expected to be a value that's an array ref of hashrefs.

    # Create object with values
    my  $entry  =   Entry->new(
        $retrieved->%*,
    );
    

}

method update {
}

method delete {

}


__END__

# "SELECT * FROM a JOIN b ON (b.a_id = a.id) JOIN c ON (c.a_id = a.id)"
$abstract->select(['a', ['b', a_id => 'id'], ['c', a_id => 'id']]);


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
