package Management::Plugin::Routes;
use     Mojo::Base  'Mojolicious::Plugin',
                    -signatures;
use Management::Boilerplate::Code;
use English;


sub register ($self, $app, $conf) {

    $app->routes
        ->any('/')              ->to('Root#'.   'homepage'      );
    $app->routes
        ->any('/hello')         ->to('Root#'.   'hello_world'   );
    $app->routes
        ->any('/outcomes')      ->to('Root#'.   'outcomes'   );
    $app->routes
        ->any('/dynamic01')     ->to('Root#'.   'dynamic01'     );
    $app->routes
        ->any('/*rest_of_url')  ->to('Root#'.   'homepage'      ); # Does not match '/' and only matches '/some-stuff'

    return; # Why not return true?
}

1;