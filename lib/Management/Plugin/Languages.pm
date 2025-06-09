use     Object::Pad v0.820;

class   Management::Plugin::Languages;

use     Management::Boilerplate::Code;
inherit Mojolicious::Plugin;
use     Management::Languages;

method register ($app, $config) {

    my  $helpers={
        language    =>  sub {
                            # State will only initialise it once regardless of multiple calls.
                            # Should you wish to change language, you should code a dedicated method for that,
                            # within the Management::Languages class.
                            state   $language   =   Management::Languages->try_or_die(
                                                        $app->config->{'default_language'}
                                                    );
                        },
    };

    for my $current (keys $helpers->%*) {
        $app->helper($current    =>  $helpers->{$current});
    };

    return;

}
