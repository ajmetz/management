use     Object::Pad v0.820;

class   Management::App::Plugin::MyLogAny;

use     Management::App::Boilerplate::Code;
inherit Mojolicious::Plugin;
use     Log::Any::Adapter;
use     Log::Any;

method register ($app, $config) {

    Log::Any::Adapter->set('+Management::App::MVC::View::MyLogAnyAdapter', language => $app->language, logger => $app->log);
    $app->helper(log => sub { Log::Any->get_logger }); # Replaces default helper "log". 
                                                                    # If you find you've lost the request_id,
                                                                    # it can be reinstated via $controller->req->request_id.
                                                                    # I'd add it here if I had the controller object present.
    return;

}

__END__