use     Management::Boilerplate::Code;
use     Object::Pad v0.820;

class   Management::Controller::Root :repr(HASH) {

    inherit Mojolicious::Controller;

    method hello_world {

        $self->render(
            text => "Hello World!",
        );

    }

}