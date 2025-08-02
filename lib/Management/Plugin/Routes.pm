use     Object::Pad v0.820;

class   Management::Plugin::Routes;

use     Management::Boilerplate::Code;
inherit Mojolicious::Plugin;

method register ($app, $conf) {

    my  $routes =   $app->routes->under->to('Root#auto');

    # Default at root:
    $routes
        ->any('/')              ->to('Root#'.   'homepage'      ); # Dedicated entry for matching simply '/' (root)

    # Root.pm:
    $routes
        ->any('/hello')         ->to('Root#'.   'hello_world'   );
    $routes
        ->any('/outcomes')      ->to('Root#'.   'outcomes'      );
    $routes
        ->any('/dynamic01')     ->to('Root#'.   'dynamic01'     );


    # Input.pm:
    $routes
        ->any('/entries')       ->to('Input#'.  'entries'       );
    $routes
        ->any('/days')          ->to('Input#'.  'days'          );



    # Default / fall back for anything else (other than simply root)...
    $routes
        ->any('/*rest_of_url')  ->to('Root#'.   'homepage'      ); # Does not match '/' and only matches '/some-stuff'

    return;

}