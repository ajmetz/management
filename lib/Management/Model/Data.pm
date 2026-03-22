use     Object::Pad v0.820;

class   Management::Model::Data;
use     Management::Boilerplate::Code;
use     Management::Languages;
use     Data::Util qw(is_hash_ref);

field   $database               :param  :reader;
field   $last_insert_id_lookup  :reader             =   {};

method save ($what_to_save) {

    foreach my ($table_name, $table_data) ($what_to_save->%*) {

        $last_insert_id_lookup->{$table_name}       =   [
                                                            map {
                                                                $database->handle->insert($table_name => $ARG)->last_insert_id
                                                            } $table_data->@*,
                                                        ];

    }

    return  $self;

}

method retrieve ($what_to_retrieve ||= undef) {


    my $data =  {};
    my  $valid_input                                =   $what_to_retrieve
                                                        && is_array_ref($what_to_retrieve)
                                                        && scalar $what_to_retrieve->@*?    $what_to_retrieve:
                                                        undef;

    if ($valid_input) {

        for my ($table_name, $query) ($valid_input->%*) {   # Please check query is sane perhaps before execution? Or will SQL Abstract handle that for us?

            $data->{$table_name}                    =   $database->handle->select($table_name, $query->@*)->hashes->to_array;

        };

    }
    else {

        for my $current_table ($database->fetch_main_table_names) {
            # Key                                       # Value
            $data->{$current_table}                 =   $database->handle->select($current_table)->hashes->to_array; # Array ref.
        };

    };

    return  $data->%*?  $data:
            undef;

}

__END__