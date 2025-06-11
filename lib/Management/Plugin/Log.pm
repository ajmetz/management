use     Object::Pad v0.820;

class   Management::Plugin::Log;

use     Management::Boilerplate::Code;
inherit Mojolicious::Plugin;

method register ($app, $config) {

    my  $helpers    =   {
        log_debug   =>  sub ($self, @arguments) {
                            $self->log->debug(
                                $self->language->localise(@arguments),
                            );
                        },
    };

    for my $current (keys $helpers->%*) {
        $app->helper($current    =>  $helpers->{$current});
    };

    return;

}
