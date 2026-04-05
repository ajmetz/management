use     Object::Pad v0.820;

class   Management::App::MVC::Model::Database::Type::SQLite;
use     Management::App::Boilerplate::Code;
use     Mojo::SQLite;

field   $file_name  :param;

method connection {

    my  $options            =   {
                                    no_wal  =>  1,
                                };

    return  state   $sql    =   Mojo::SQLite->new->from_filename($file_name, $options)->auto_migrate(1);

}

__END__
