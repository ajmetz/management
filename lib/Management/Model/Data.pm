use     Object::Pad v0.820;

class   Management::Model::Data;
use     Management::Boilerplate::Code;
use     Management::Languages;
use     Mojo::Util qw(dumper);
use     English;
use     Data::Util qw(is_hash_ref);

field   $database               :param  :reader;
field   $app                    :param  :reader;
field   $last_insert_id_lookup  :reader             =   {};



method save ($what_to_save) {

    foreach my ($table_name, $table_data) ($what_to_save->%*) {

        $last_insert_id_lookup->{$table_name}   =   [
                                                        map {
                                                            $database->insert($table_name => $ARG)->last_insert_id
                                                        } $table_data->@*,
                                                    ];

    }

    return  $self;

}

method retrieve ($what_to_retrieve ||= undef) {


    my $data =  {};
    my  $valid_input    =   $what_to_retrieve
                            && is_array_ref($what_to_retrieve)
                            && scalar $what_to_retrieve->@*?    $what_to_retrieve:
                            undef;

    if ($valid_input) {
        for my ($table_name, $query) ($valid_input->%*) {   # Please check query is sane perhaps before execution? Or will SQL Abstract handle that for us?

            $data->{$table_name}   =   $database->select($table_name, $query->@*)->hashes->to_array;

        }
    }
    else {
        for my $current_table ($database->fetch_main_table_names) {
            # Key                       # Value
            $data->{$current_table} =   $database->select($current_table)->hashes->to_array; # Array ref.
        };
    };

    return $data->%*? $data:undef;

}



__END__


method save ($what_to_save) {
    my  @tables_to_save_to  =   keys $what_to_save->%*;

    foreach $table_name (@tables_to_save_to) {
        
        # Definitions:

        my  $multiple_rows  =   reftype() eq 'ARRAY';
        
        if ($multiple_rows) {
            $data->database->insert($what_to_save->{$table_name})->last_insert_id
        }
        else {
            $data->database->insert($what_to_save->{$table_name})->last_insert_id
        };
    }
}


====

#ADJUST {
#    die "Database object should be a" $database
#}
# Worry about validation and language / phrase translation implications later.

#method table_list {
#    #$check_database_is_valid;
#    #$database->app->;
#    my $this = $database->dbh->table_info(undef,undef,undef,"'TABLE','VIEW','LOCAL TEMPORARY'");
#    die "Here is our dump:\n".dumper($this);
#    return $this;
#}


======



method retrieve {

    #warn "Short table names:".join("\n", @short_table_names);
        
    my $data =  {};
    for my $current_table ($self->$fetch_table_names) {
        $data->{$current_table} = $database->select($current_table)->hashes->to_array;
    };
    
    #warn "Our data:".dumper($data);
    
    #die "That'll do.";
    
    return $data;
}