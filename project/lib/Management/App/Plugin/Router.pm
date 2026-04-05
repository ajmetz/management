use     Object::Pad v0.820;

class   Management::App::Plugin::Router;

use     Management::App::Boilerplate::Code;
inherit Mojolicious::Plugin;

use     Management::App::MVC::View::Router;

method register ($app, $conf) {

    Management::App::MVC::View::Router->routes($app->routes);

    return;

}

__END__