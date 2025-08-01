use     Object::Pad v0.820;

class   Management::Plugin::Log;

use     Management::Boilerplate::Code;
inherit Mojolicious::Plugin;

use     Mojo::Util qw(dumper);

method register ($app, $config) {

    my  $helpers        =   {

        log_debug       =>  sub ($self, @arguments) {

                                $self->log->debug(
                                    $self->language->localise(@arguments),
                                );

                                return $self;

                            },

        log_trace       =>  sub ($self, @arguments) {

                                $self->log->trace(
                                    $self->language->localise(@arguments),
                                );

                                return $self;

                            },

        log_dump_values =>  sub ($self, @arguments) {

                                $self->log->info(
                                    "-\n".dumper(@arguments)
                                );

                                return $self;

                            },
    };

    for my $current (keys $helpers->%*) {
        $app->helper($current    =>  $helpers->{$current});
    };

    return;

}
