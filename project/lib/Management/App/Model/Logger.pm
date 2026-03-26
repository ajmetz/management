use     Object::Pad v0.820;

class   Management::App::Model::Logger;
use     Management::App::Boilerplate::Code;

use     Mojo::Util qw(dumper);

field   $log        :param;
field   $language   :param;
field   $new_line                       =   "\n";
#field   $prefix_string      :accessor   =   q{};

method  debug (@arguments) {
    $log->debug(
        $language->localise(@arguments),
    );
    return $self;
}

method  trace (@arguments) {
    $log->trace(
        $language->localise(@arguments),
    );
    return $self;
}

method  error (@arguments) {
    $log->error(
        $language->localise(@arguments),
    );
    return $self;
}

method  fatal (@arguments) {
    $log->fatal(
        $language->localise(@arguments),
    );
    return $self;
}

method dump_values (@arguments) {
    $log->info(
        '-'.$new_line.dumper(@arguments)
    );
    return $self;
}

method context (@arguments) {
    return Management::App::Model::Logger->new(log => $log->context(@arguments), language => $language);
}

__END__


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

        log_error       =>  sub ($self, @arguments) {

                                $self->log->error(
                                    $self->language->localise(@arguments),
                                );

                                return $self;

                            },

        log_fatal       =>  sub ($self, @arguments) {

                                $self->log->fatal(
                                    $self->language->localise(@arguments),
                                );
                                # Will the next line execute, if this is fatal?
                                # It appears to be a message only, and would need to be paired with a die.
                                return $self;

                            },

        log_dump_values =>  sub ($self, @arguments) {

                                $self->log->info(
                                    "-\n".dumper(@arguments)
                                );

                                return $self;

                            },