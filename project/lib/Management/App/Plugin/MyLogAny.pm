use     Object::Pad v0.820;

class   Management::App::Plugin::MyLogAny;

use     Management::App::Boilerplate::Code;
inherit Mojolicious::Plugin;
use     Log::Any::Adapter;
use     Log::Any;

method register ($app, $config) {

    Log::Any::Adapter->set(
        '+Management::App::MVC::View::MyLogAnyAdapter', # Location of custom coded adapter, based on the MojoLog adapter.
        language => $app->language,                     # Language object, accessed via a helper, setup by a previously declared plugin
        localisation_scope => 'Management',             # Any classes under this namespace will have localisation/translation applied to their log messages. Should I have used 'category' instead?
        logger => $app->log,                            # Logger to use is Mojo::Log.
    );
    $app->helper(logger => sub { Log::Any->get_logger });  # Replaces default helper "log". 
                                                        # If you find you've lost the request_id,
                                                        # it can be reinstated via $controller->req->request_id.
                                                        # I'd add it here if I had the controller object present.
    return;

}

__END__