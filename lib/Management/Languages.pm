use     Object::Pad v0.820;

class   Management::Languages;

use     Management::Boilerplate::Code;
inherit Locale::Maketext; # Should it be inherit? We'll wait and see when we need to use it.
use     HTML::Entities;

method try_or_die :common ($language = 'en-GB') {

    my  $error={
        language    =>  'Trouble finding a language to use.',
    };

    #warn 'language is...'.$language;

    return              __PACKAGE__->get_handle($language)
                        || die  $error->{'language'};

}

method localise_html (@ARG) {
    encode_entities(
        $self->localise(@ARG)
    );
}

method localise (@ARG) {
    $self->maketext(@ARG);
}