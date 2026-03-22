use     Object::Pad v0.820;

class   Management::Model::Database;
# As I learn how classes interoperate, I may be repeating stuff already done within the framework.
# This class for example, attempts to be a parent database class, when Mojo::SQLite::Database may already be one.

use     Management::Boilerplate::Code;
use     Management::Model::Database::SQLite;

field $app              :param  :reader ;
field $database_type            :reader =   'Management::Model::Database::SQLite'; # Change the type here if required.

method handle {
    state   $handle             =   $self->connection->db;  # I presently believe the handle should always be the same one
                                                            # and if I'm wrong feel free to lose the state $handle part 
                                                            # and revert to this method simply returning: $self->connection->db;
}

method connection {
    state   $connection         =   $database_type->new(app => $app)->connection;
}

method fetch_main_table_names {

    my  $captures_table_name    =   qr/
                                        ^                   # Start
                                        \"main\"\.\"        # main in speechmarks followed by a dot followed by an opening speechmark
                                        (?<table_name>.+)   # One or more of any characters
                                        \"                 # Followed by a closing speechmark
                                        $                   # End
                                    /x;
    
    #warn dumper $database->tables;
    
    return (
        map {($ARG =~ $captures_table_name)? $+{'table_name'}:()} $self->handle->tables->@*
    );

}

__END__

$self->database->dbh->tables or ->table_info
https://metacpan.org/release/HMBRAND/DBI-1.647/view/DBI.pm#tables
https://metacpan.org/release/HMBRAND/DBI-1.647/view/DBI.pm#table_info
...could be a more direct alternative to fetch_main_table_names
