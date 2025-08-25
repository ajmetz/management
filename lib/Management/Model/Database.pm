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

__END__
