use     Management::App::Boilerplate::ObjectPadVersion;

class   Management::App::MVC::View::Router;
use     Management::App::Boilerplate::Code;

method routes :common ($routes) {

    # Applicable to all...
    my $auto_first_and_then  =  $routes->under->to('Root#auto', namespace => 'Management::App::MVC::Controller'); # Namespace stated because it's not the default for Mojolicious.

    # Default at root:
    $auto_first_and_then
        ->any('/')              ->to('Root#'.   'homepage'      ); # Dedicated entry for matching simply '/' (root) - list of management, comms, action, routines

    # Root.pm:
    $auto_first_and_then
        ->any('/hello')         ->to('Root#'.   'hello_world'   );  # Hello world test.
    $auto_first_and_then
        ->any('/outcomes')      ->to('Root#'.   'outcomes'      );  # HTML page showing list of outcome categories - people, print, videos, website
    $auto_first_and_then
        ->any('/dynamic01')     ->to('Root#'.   'dynamic01'     );  # Dynamic layout population - example of a pie chart and some radio buttons
    $auto_first_and_then
        ->any('/testlogging')   ->to('Root#'.   'test_logging'  );  # Testing Log::Any.

    # Input.pm:
    $auto_first_and_then
        ->any('/entries')       ->to('Input#'.  'entries'       );  # Enter time logging
    $auto_first_and_then
        ->any('/days')          ->to('Input#'.  'days'          );  # Select a time range and submit to the same days endpoint



    # Default / fall back for anything else (other than simply root)...
    $auto_first_and_then
        ->any('/*rest_of_url')  ->to('Root#'.   'homepage'      ); # Does not match '/' and only matches '/some-stuff'


    return;

}

__END__
