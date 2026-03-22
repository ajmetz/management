use     Object::Pad v0.820;

class   Management::Model::Category;
use     Management::Boilerplate::Code;
use     Management::Languages;
use     Mojo::Util qw(dumper);
use     English;

field   $data                   :param  :accessor               ;
field   $last_saved_category    :reader                         =   undef;
field   $default_top_category                                   =   'OTHER';

method save ($category, $top_category //= $default_top_category) {

    $last_saved_category    =   $data->save('categories' => [$category,$top_category]->last_insert_id_lookup;

    return $self;

}

__END__