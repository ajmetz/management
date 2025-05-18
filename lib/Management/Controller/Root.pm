package Management::Controller::Root;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Management::Boilerplate::Code;
use English;

sub hello_world ($self) {

    $self->render(
        text => "Hello World!",
    );

}
