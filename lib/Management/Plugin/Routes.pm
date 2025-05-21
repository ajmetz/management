package Management::Plugin::Routes;
use     Mojo::Base  'Mojolicious::Plugin',
                    -signatures;
use Management::Boilerplate::Code;
use English;


sub register ($self, $app, $conf) {

    $app->routes
        ->any('/dynamic01')     ->to('Root#'.   'dynamic01'     );
    $app->routes
        ->any('/*rest_of_url')  ->to('Root#'.   'hello_world'   );

    return; # Why not return true?
}

1;