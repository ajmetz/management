use     Object::Pad v0.820;

class   Management::Plugin::Routes;

use     Management::Boilerplate::Code;
inherit Mojolicious::Plugin;

method register ($app, $conf) {

    $app->routes
        ->any('/')              ->to('Root#'.   'homepage'      ); # Dedicated entry for matching simply '/' (root)
    $app->routes
        ->any('/hello')         ->to('Root#'.   'hello_world'   );
    $app->routes
        ->any('/outcomes')      ->to('Root#'.   'outcomes'      );
    $app->routes
        ->any('/dynamic01')     ->to('Root#'.   'dynamic01'     );
    $app->routes
        ->any('/*rest_of_url')  ->to('Root#'.   'homepage'      ); # Does not match '/' and only matches '/some-stuff'

    return;

}