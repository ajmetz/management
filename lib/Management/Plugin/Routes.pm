use     Object::Pad v0.820;

class   Management::Plugin::Routes;

use     Management::Boilerplate::Code;
inherit Mojolicious::Plugin;

method register ($app, $conf) {

    my  $routes =   $app->routes->under->to('Root#auto');

    # Default at root:
    $routes
        ->any('/')              ->to('Root#'.   'homepage'      ); # Dedicated entry for matching simply '/' (root) - list of management, comms, action, routines

    # Root.pm:
    $routes
        ->any('/hello')         ->to('Root#'.   'hello_world'   );  # Hello world test.
    $routes
        ->any('/outcomes')      ->to('Root#'.   'outcomes'      );  # HTML page showing list of outcome categories - people, print, videos, website
    $routes
        ->any('/dynamic01')     ->to('Root#'.   'dynamic01'     );  # Dynamic layout population - example of a pie chart and some radio buttons


    # Input.pm:
    $routes
        ->any('/entries')       ->to('Input#'.  'entries'       );  # Enter time logging
    $routes
        ->any('/days')          ->to('Input#'.  'days'          );  # Select a time range and submit to the same days endpoint



    # Default / fall back for anything else (other than simply root)...
    $routes
        ->any('/*rest_of_url')  ->to('Root#'.   'homepage'      ); # Does not match '/' and only matches '/some-stuff'

    return;

}