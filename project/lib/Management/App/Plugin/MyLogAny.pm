use     Object::Pad v0.820;

class   Management::App::Plugin::MyLogAny;

use     Management::App::Boilerplate::Code;
inherit Mojolicious::Plugin;
use     Log::Any::Adapter;

method register ($app, $config) {

    Log::Any::Adapter->set('+Management::App::MVC::View::MyLogAnyAdapter', language => $app->language, logger => $app->log);

    return;

}

__END__