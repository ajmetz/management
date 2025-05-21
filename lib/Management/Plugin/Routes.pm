package Management::Plugin::Routes;
use     Mojo::Base  'Mojolicious::Plugin',
                    -signatures;
use Management::Boilerplate::Code;
use English;


sub register ($self, $app, $conf) {

#    $app->routes
#        ->under('/*rest_of_url')->to(rest_of_url => q{})
 #       ->under ->to('Auto#'.   'auto')
  #      ->under ->to('Stash#'.  'values')
   #     ->under ->to('Stash#'.  'ticket')
    #    ->under ->to('Stash#'.  'form_validation_rules')
    #    ->under ->to('Form#'.   'save_form_submission')
    #    ->under ->to('Stash#'.  'database')
#        ->any   ->to('Root#'.   'home_page');
        $app->routes->any('/hello')      ->to('Root#'.   'hello_world'   );
        #$app->routes->any('/build_out')  ->to('Root#'.   'build_out'     );
    return; # Why not return true?
}

1;