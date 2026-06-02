use     Management::App::Boilerplate::ObjectPadVersion;

class   Management::App::Plugin::ShortcutHelpers;

use     Management::App::Boilerplate::Code;
inherit Mojolicious::Plugin;

# Not presently used/implemented - 26th March 2026 11:02am.
# We now register the plugin - as of 5th April 2026 17:29pm - however we never use the registered helper.

method register ($app, $conf) {

    my  $helpers                =   {
        business_logic_class    =>  sub { return    'Management::App::MVC::Model::BusinessLogic'    },
        time_zone_string        =>  sub { return    $app->config('time_zone') // 'Europe/London'    },
    };

    for my $current (keys $helpers->%*) {
        $app->helper($current   =>  $helpers->{$current});
    };

    return;

}

__END__

Could probably simply do $self->config('time_zone') in the appropriate place(s).
Where do we do this sort of stuff?
Database I think.

