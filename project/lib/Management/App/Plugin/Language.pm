use     Object::Pad v0.820;

class   Management::App::Plugin::Language;

use     Management::App::Boilerplate::Code;
inherit Mojolicious::Plugin;
use     Management::App::Language;

method register ($app, $config) {

    my  $helpers={
        language    =>  sub {
                            # State will only initialise it once, on a server's initial loading of the mojolicious app, regardless of multiple calls.
                            # Should you wish to change language dynamically, without reloading the app, you should code a dedicated method for that,
                            # within the Management::App::Languages class.
                            # Alternatively, you can move the yml config file to a folder that triggers app reloads, so when the yaml config is changed, the app reloads.
                            state   $language   =   Management::App::Language->try_or_die(
                                                        $app->config->{'default_language'}
                                                    );
                        },
    };

    $app->helper($ARG => $helpers->{$ARG}) for (keys $helpers->%*);

    return;

}
