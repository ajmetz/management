use     Management::App::Boilerplate::ObjectPadVersion;

class   Management::App::MVC::View::TemplateNest;
use     Management::App::Boilerplate::Code;

method default_settings :common ($params) {

    return [
        template_dir    =>  $params->{mojo_home}->rel_file('lib/Management')->child('HTML')->to_string,
        token_delims    =>  ['PUT','HERE'],
        escape_char     =>  '\\',
        name_label      =>  'TEMPLATE',
        template_ext    =>  '', # Blank so can declare extension under the NAME key (labelled TEMPLATE).
                                # This will allow me to use htm and html
                                # or anything else as I wish.
    
        fixed_indent    =>  0,  # Off (0)
                                # - On (1) would be nice for tidy source code,
                                # and would mess with white space in substituted multi-line values
                                # - i.e. textarea values, or hidden form values -
                                # so I've decided to keep this off.
    ];

}

__END__
