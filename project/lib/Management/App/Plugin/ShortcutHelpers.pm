use     Object::Pad v0.820;

class   Management::App::Plugin::ShortcutHelpers;

use     Management::App::Boilerplate::Code;
inherit Mojolicious::Plugin;

# Not presently used/implemented - 26th March 2026 11:02am.
# We now register the plugin - as of 5th April 2026 17:29pm - however we never use the registered helper.

method register ($app, $conf) {

    my  $helpers                =   {
        business_logic_class    =>  sub { return 'Management::App::MVC::Model::BusinessLogic' }
    };

    for my $current (keys $helpers->%*) {
        $app->helper($current   =>  $helpers->{$current});
    };

    return;

}

__END__
