use     Object::Pad v0.820;

class   Management::App::Model::Database;
# As I learn how classes interoperate, I may be repeating stuff already done within the framework.
# This class for example, attempts to be a parent database class, when Mojo::SQLite::Database may already be one.

use     Management::App::Boilerplate::Code;
use     Management::App::Model::Database::Type::SQLite;
use     Management::App::Model::Database::Data;

field $file_name        :param  :reader;
field $logger           :param  :reader;
field $database_type            :reader =   'Management::App::Model::Database::Type::SQLite'; # Change the type here if required.

method handle {
    state   $handle                     =   $self->connection->db;  # I presently believe the handle should always be the same one
                                                                    # and if I'm wrong feel free to lose the state $handle part 
                                                                    # and revert to this method simply returning: $self->connection->db;
}

method connection {
    my      @params                     =   (
                                                file_name   =>  $file_name,
                                                logger      =>  $self->logger,
                                            );
    state   $connection                 =   $database_type->new(@params)->connection;   # This object only has connection and no other methods. 
                                                                                        # We are not giving access to Mojo::SQLite instance easily.
                                                                                        # We have replicated db (via handle) and connection (via connection) here in this class,
                                                                                        # so are only losing from filename and from string methods,
                                                                                        # and our database_type class will handle those.
}

method data {
    my      @params                     =   (
                                                database => $self,
                                                logger   => $self->logger
                                            );
    state   $data                       =   Management::App::Model::Database::Data->new();  # State means $data set only once then re-used.
}

method fetch_main_table_names {

    my  $captures_table_name            =   qr/
                                                ^                   # Start
                                                \"main\"\.\"        # main in speechmarks followed by a dot followed by an opening speechmark
                                                (?<table_name>.+)   # One or more of any characters
                                                \"                 # Followed by a closing speechmark
                                                $                   # End
                                            /x;
    
    #warn dumper $self->handle->tables;
    
    return (
        map {($ARG =~ $captures_table_name)? $+{'table_name'}:()} $self->handle->tables->@*
    );

}

__END__

TODO:

Add data and category
$self->database->dbh->tables or ->table_info
https://metacpan.org/release/HMBRAND/DBI-1.647/view/DBI.pm#tables
https://metacpan.org/release/HMBRAND/DBI-1.647/view/DBI.pm#table_info
...could be a more direct alternative to fetch_main_table_names
