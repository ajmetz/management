use     Object::Pad v0.820;

class   Management::App::MVC::Model::Logger;
use     Management::App::Boilerplate::Code;

use     Mojo::Util qw(dumper);
use     Data::Util qw(is_string);

field   $logger     :param;
field   $language   :param  :reader;
field   $dump_level                     //= 'trace';
field   $new_line                       =   "\n";
#field   $prefix_string      :accessor   =   q{};

method  debug (@arguments) {
    $logger->debug(
        $language->localise(@arguments),
    );
    $dump_level =   'debug';
    return $self;
}

method  trace (@arguments) {
    $logger->trace(
        $language->localise(@arguments),
    );
    $dump_level =   'trace';
    return $self;
}

method  error (@arguments) {
    $logger->error(
        $language->localise(@arguments),
    );
    $dump_level =   'error';
    return $self;
}

method  fatal (@arguments) {
    $logger->fatal(
        $language->localise(@arguments),
    );
    $dump_level =   'fatal';
    return $self;
}

method dump_values (@arguments) {
    $logger->$dump_level(
        '-'.$new_line.dumper(@arguments)
    );
    return $self;
}

method context (@arguments) {
    my  @bracketed_arguments    =   @arguments? map {
                                                    is_string($ARG)?    '['.$ARG.']':
                                                    $ARG
                                                }
                                                @arguments:
                                    ();

    return Management::App::MVC::Model::Logger->new(
        logger      => $logger->context(@bracketed_arguments),
        language    => $language,
    );

}

__END__
