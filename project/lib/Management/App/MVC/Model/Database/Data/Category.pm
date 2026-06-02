use     Management::App::Boilerplate::ObjectPadVersion;

class   Management::App::MVC::Model::Database::Data::Category;
use     Management::App::Boilerplate::Code;
#use     Mojo::Util qw(dumper);

field   $data                   :param  :accessor               ;
field   $last_saved_category    :reader                         =   undef;
field   $table_name             :reader                         =   'categories';
field   $default_top_category                                   =   'OTHER';

method save ($category, $top_category //= $default_top_category) {

    $last_saved_category    =   $data->save({$table_name => [$category,$top_category]})->last_insert_id_lookup;

    return $self;

}

__END__