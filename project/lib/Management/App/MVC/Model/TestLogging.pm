use     Object::Pad v0.820;

class   Management::App::MVC::Model::TestLogging;
use     Management::App::Boilerplate::Code;

use     Mojo::Util qw(dumper);
use     Data::Util qw(is_string);

field   $log     :param :reader      =   Log::Any->get_logger;

method test {
    warn ('Log message from the test method via warn.');
    $log->info('Log message from the test method via \$log.');
}

__END__
