use     Object::Pad v0.820;

class   Management::App::Plugin::MyLogAny;

use     Management::App::Boilerplate::Code;
inherit Mojolicious::Plugin;
use     Log::Any::Adapter;

method register ($app, $config) {

    Log::Any::Adapter->set('MojoLog', logger => $app->log);

    return;

}

__END__