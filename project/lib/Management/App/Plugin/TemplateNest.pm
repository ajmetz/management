use     Management::App::Boilerplate::ObjectPadVersion;

class   Management::App::Plugin::TemplateNest;

use     Management::App::Boilerplate::Code;
inherit Mojolicious::Plugin;

use     Management::App::MVC::View::TemplateNest;

method register ($app, $conf) {

    my  $params = {
        mojo_home           =>  $app->home,
    };

    $app->defaults(
        # Store Template::Nest setup data in the stash:
        layout_settings     =>   Management::App::MVC::View::TemplateNest->default_settings($params),
    );

    return;

}

__END__