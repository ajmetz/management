use     Object::Pad v0.820;

class   Management::Model::Database::SQLite;
use     Management::Boilerplate::Code;
use     Mojo::SQLite;
#use     Data::Dumper;


field   $app    :param;

method connection {

    state   $sql    =   Mojo::SQLite->new->from_filename(
                            $app->home->rel_file(
                                $app->config->{'sqlite_file'}
                            )->to_string
                        )->auto_migrate(1);

}

__END__
