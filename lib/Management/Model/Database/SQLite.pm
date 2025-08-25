use     Object::Pad v0.820;

class   Management::Model::Database::SQLite;
use     Management::Boilerplate::Code;
use     Mojo::SQLite;
#use     Data::Dumper;


field   $app    :param;

method connection {

    my  $file_name          =   $app->home->rel_file(
                                    $app->config->{'sqlite_file'}
                                )->to_string;

    my  $options            =   {
                                    no_wal  =>  1,
                                };

    return  state   $sql    =   Mojo::SQLite->new->from_filename($file_name, $options)->auto_migrate(1);

}

__END__
