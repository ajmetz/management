use     Object::Pad v0.820;

class   Management::App::Plugin::TimeLogClass;

use     Management::App::Boilerplate::Code;
inherit Mojolicious::Plugin;

# Not presently used/implemented - 26th March 2026 11:02am.

method register ($app) {

    my  $helpers        =   {
        timelog_class   =>  sub { return 'Management::App::Model::TimeLog' }
    };

    for my $current (keys $helpers->%*) {
        $app->helper($current    =>  $helpers->{$current});
    };

    return;

}

__END__
