use     Object::Pad v0.820;

class   Management::Model::Database;
use     Management::Boilerplate::Code;
use     Management::Model::Database::SQLite;

field $app :param :reader;

method database {
    $self->connection->db;
}

method connection {
    state   $connection   =   Management::Model::Database::SQLite->new(app => $app)->connection;
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
        map {($ARG =~ $captures_table_name)? $+{'table_name'}:()} $self->database->tables->@*
    );

}

__END__

$self->database->dbh->tables or ->table_info
https://metacpan.org/release/HMBRAND/DBI-1.647/view/DBI.pm#tables
https://metacpan.org/release/HMBRAND/DBI-1.647/view/DBI.pm#table_info
...could be a more direct alternative to fetch_main_table_names
