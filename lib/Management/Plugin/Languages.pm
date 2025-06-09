use     Object::Pad v0.820;

class   Management::Plugin::Languages;

use     Management::Boilerplate::Code;
inherit Mojolicious::Plugin;
use     Management::Languages;
use     HTML::Entities;

method $localise ($language, $say) {
    $language->maketext($say);
}

method $localise_html ($language, $say) {
    encode_entities(
        $self->$localise($language,$say)
    );
}

method register ($app, $config) {

#    my  $language           =   ;
#    warn 'Trying a warning - language is a '.ref($language);
warn 'Default language is...'.$app->config->{'default_language'};
    my  $helpers={
 #       localise            =>  sub ($language, $say) { $self->$localise($language,$say) },
 #       localise_html       =>  sub ($language, $say) { $self->$localise_html($language,$say) },
#        localise            =>  #sub ($language, $say) {
                                    #$language->maketext($say)
 #                                   'hello from localise'.ref($language)
                                #},
        language       =>  sub { return Management::Languages->try_or_die($app->config->{'default_language'}) },
                                 #sub ($language, $say) {
                                        #encode_entities($language->maketext($say))
#'hello from html_localise
#language is '.ref($language).
#'and say is '.ref($say);
#                                },
    };

    for my $current (keys $helpers->%*) {
        $app->helper($current    =>  $helpers->{$current});
    };

    return;

}
