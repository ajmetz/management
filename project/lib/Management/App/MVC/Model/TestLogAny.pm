use     Object::Pad v0.820;

class   Management::App::MVC::Model::TestLogAny;
use     Management::App::Boilerplate::Code;

use     Mojo::Util qw(dumper);
use     Data::Util qw(is_string);

field   $logger :param  :reader =   Log::Any->get_logger;

method test {
    warn ('Log message from the test method of TestLogAny via warn.');
    $logger->info('Log message from the test method via \$logger.');
    $self->logger->info('Log message from the test method via \$self->logger.');
    return $self;
}

__END__
