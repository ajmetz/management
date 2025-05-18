package Tickets::Languages;
use Mojo::Base 'Locale::Maketext', -signatures;

sub try_or_die ($self, $language = 'en-GB') {

    my  $error={
        language    =>  'Trouble finding a language to use.',
    };

    return  $self->get_handle($language)
            || die  $error->{'language'};
}

1; # Comment out to make failure possible. Uncomment to always return true.