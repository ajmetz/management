use     Object::Pad v0.820;

class   Management::App::MVC::Model::Database::Data;
use     Management::App::Boilerplate::Code;
use     Management::App::MVC::Model::Database::Data::Entry;
use     Management::App::MVC::Model::Database::Data::Category;
use     Data::Util qw(
            is_hash_ref
            is_array_ref
        );

field   $database               :param  :reader;
field   $logger                 :param  :reader;
field   $last_insert_id_lookup          :reader     =   {};

method save ($what_to_save) {
    my  $log    =   $logger->context('Management::App::MVC::Model::Database::Data::save');

    $log->trace('This is what we have been asked to save...')->dump_values($what_to_save);

    foreach my ($table_name, $table_data) ($what_to_save->%*) {
        $log->trace('Beginning with the following data...')->dump_values($table_data);
        $log->trace('To be saved to the following table...')->dump_values($table_name);
        $last_insert_id_lookup->{$table_name}       =   $database->handle->insert($table_name => $table_data)->last_insert_id;

    }

    return  $self;

}

method retrieve ($what_to_retrieve ||= undef) {


    my $data =  {};
    my  $valid_input                                =   $what_to_retrieve
                                                        && is_hash_ref($what_to_retrieve)
                                                        && scalar $what_to_retrieve->%*?    $what_to_retrieve:
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

method entry {
    my  @params                                     =   (
                                                            data    =>  $self,
                                                            logger  =>  $logger,
                                                        );
    state   $entry                                  =   Management::App::MVC::Model::Database::Data::Entry->new(@params);  # State means $entry set only once then re-used. This is the object model for entry crud commands and not an actual entry object.
}

method category {
    my  @params                                     =   (
                                                            data    =>  $self,
                                                        );
    state   $category                               =   Management::App::MVC::Model::Database::Data::Category->new(@params);  # State means $category set only once then re-used. This is the object model for category crud commands and not an actual category object.
}

__END__