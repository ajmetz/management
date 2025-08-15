use     Object::Pad v0.820;

class   Management::Model::Data::Entries;
use     Management::Boilerplate::Code;
use     Management::Languages;
use     Mojo::Util qw(dumper);
use     English;

field   $data :accessor :param;
field   $table_name :accessor   =   "entries";
field   $all_fields =   undef;

method retrieve ($id) {

    # Definitions:
    my  $where_id_is_the_same   =   {id => $id};
    
    # Processing & Output:
    return $data->database->select($table_name,$all_fields,$where_id_is_the_same)->hash;
}

method save ($entry) {

    # Processing & Output:
    return $data->database->insert($entry->save_data)->last_insert_id;

}



__END__
