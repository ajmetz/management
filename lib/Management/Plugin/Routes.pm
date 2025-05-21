package Management::Plugin::Routes;
use     Mojo::Base  'Mojolicious::Plugin',
                    -signatures;
use Management::Boilerplate::Code;
use English;


sub register ($self, $app, $conf) {

    my  @default_route  =   (
        controller  => 'Root',
        action      => 'hello_world',
    );


    $app->defaults(@default_route);

    $app->routes->any('/dynamic01')->to('Root#'.   'dynamic01'   );
        #$app->routes->any('/build_out')  ->to('Root#'.   'build_out'     );
    return; # Why not return true?
}

1;