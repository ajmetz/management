use     Object::Pad v0.820;

class   Management::Languages;

use     Management::Boilerplate::Code;
use     Locale::Maketext; # Should it be inherit? We'll wait and see when we need to use it.

method try_or_die ($language = 'en-GB') {

    my  $error={
        language    =>  'Trouble finding a language to use.',
    };

    return              $self->get_handle($language)
                        || die  $error->{'language'};

}