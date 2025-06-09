use     Object::Pad v0.820;

class   Management::Plugin::Routes;

use     Management::Boilerplate::Code;
inherit Mojolicious::Plugin;

method register ($app, $conf) {




    # Default at root:
    $app->routes
        ->any('/')              ->to('Root#'.   'homepage'      ); # Dedicated entry for matching simply '/' (root)

    # Root.pm:
    $app->routes
        ->any('/hello')         ->to('Root#'.   'hello_world'   );
    $app->routes
        ->any('/outcomes')      ->to('Root#'.   'outcomes'      );
    $app->routes
        ->any('/dynamic01')     ->to('Root#'.   'dynamic01'     );


    # Input.pm:
    $app->routes
        ->any('/add_entry')     ->to('Input#'.  'add_entry'     );


    # Default / fall back for anything else (other than simply root)...
    $app->routes
        ->any('/*rest_of_url')  ->to('Root#'.   'homepage'      ); # Does not match '/' and only matches '/some-stuff'

    return;

}