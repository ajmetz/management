use     Object::Pad v0.820;

class   Management::Model::Data;
use     Management::Boilerplate::Code;
use     Management::Languages;
use     Mojo::Util qw(dumper);
use     English;

field   $database               :param  :reader;
field   $app                    :param  :reader;
field   $last_insert_id_lookup  :reader             =   {};

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

method $fetch_table_names {

    my  $captures_table_name    =   qr/
                                        ^                   # Start
                                        \"main\"\.\"        # main in speechmarks followed by a dot followed by an opening speechmark
                                        (?<table_name>.+)   # One or more of any characters
                                        \"                 # Followed by a closing speechmark
                                        $                   # End
                                    /x;
    
    #warn dumper $database->tables;
    
    return (
        map {($ARG =~ $captures_table_name)? $+{'table_name'}:()} $database->tables->@*
    );

}

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

method save ($what_to_save) {

    foreach my ($table_name, $table_data) ($what_to_save->%*) {

        $last_insert_id_lookup->{$table_name} =   [ map { $database->insert($table_name => $ARG)->last_insert_id } $table_data->@* ];

    }

    return  $self;

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
