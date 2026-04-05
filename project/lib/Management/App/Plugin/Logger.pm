use     Object::Pad v0.820;

class   Management::App::Plugin::Logger;

use     Management::App::Boilerplate::Code;
inherit Mojolicious::Plugin;
use     Management::App::MVC::Model::Logger;

method register ($app, $config) {

    my  $helpers        =   {
        logger          =>  sub { $self->logger($app->log, $app->language) }
    };

    for my $current (keys $helpers->%*) {
        $app->helper($current    =>  $helpers->{$current});
    };

    return;

}

method logger ($log, $language){
    state $logger = Management::App::MVC::Model::Logger->new(logger => $log, language => $language);  # State means $database set only once then re-used.
}

__END__