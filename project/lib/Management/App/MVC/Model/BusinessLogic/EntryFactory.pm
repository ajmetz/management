use     Object::Pad v0.820;

class   Management::App::MVC::Model::BusinessLogic::EntryFactory 1.00;

# Custom Libraries:
use     Path::Tiny;
use     Management::App::Boilerplate::Code;
use     Management::App::MVC::Model::BusinessLogic::Entry;
use     Log::Any ();
use     Log::Any::Adapter;

field   $logger             :param;
field   $default_time_zone          =   'Europe/London';


=utf8

=over

=item multiple_entries

Returns an array of entries.

=back

=cut

# What approach should we have to logging? Should we have a log object or a language object?

method multiple_entries ($start_yyyymmdd, $string, $time_zone //= $default_time_zone,) {

    my $log =   $logger->clone( prefix => 'Management::App::MVC::Model::BusinessLogic::EntryFactory::multiple_entries' );
    
    $log->debug(
        'Prepare to return an empty list as a quiet fail, if we don\'t have our prerequisites.',
        {
            start_yyyymmdd  =>  $start_yyyymmdd,
            string          =>  $string,
            time_zone       =>  $time_zone,
        },
    );

    return () unless $start_yyyymmdd && $string && $time_zone; # Unhelpful premature exit. Perhaps specify that no true arguments were passed in.



    #$start_date =   s/-/\//g; # Replace dashes with slashes.
    my ($year, $month, $day) = split /-|\//, $start_yyyymmdd;
    $log->debug('Day, Month, and Year are...', { ddmmyyyy => [$day, $month, $year] }, );

    # Only object instances can access fields, so these are locally scoped variables while :common is in place: UPDATE: Common no longer in place.
    my  $entry_delimiter                =   "\n";
    my  $matches_and_captures_values    =   qr/
                                                ^                                           # Start of string
                                                (?<start_time>\p{Digit}{2}:\p{Digit}{2})    # Start time - two digits, colon, two digits
                                                -                                           # Dash
                                                (?<end_time>\p{Digit}{2}:\p{Digit}{2})      # End time - two digits, colon, two digits
                                                [\s-]+                                      # One or more characters that are spaces or a dash
                                                (?<categories>[^\t]+)                       # One or more of anything that isn't a tab.
                                                \t                                          # tab
                                                [\s-]*                                      # Zero or more characters that are spaces or a dash
                                                (?<details>.*)                              # Zero or more of anything - risk of being greedy, so ensure string only has one entry.
                                                $                                           # End of string.
                                            /x;

    my  @array                          =   ();

    foreach my $entry_string (split $entry_delimiter, $string) {

        my $entry_object                =   $entry_string =~ $matches_and_captures_values?  Management::App::MVC::Model::BusinessLogic::Entry->new(
                                                                                                start_day   =>  $day,
                                                                                                start_month =>  $month,
                                                                                                start_year  =>  $year,
                                                                                                start_time  =>  $LAST_PAREN_MATCH{start_time},
                                                                                                end_time    =>  $LAST_PAREN_MATCH{end_time},
                                                                                                time_zone   =>  $time_zone,
                                                                                                categories  =>  [
                                                                                                                    split (
                                                                                                                        /,/,
                                                                                                                        $LAST_PAREN_MATCH{categories}
                                                                                                                    )
                                                                                                                ],
                                                                                                details     =>  $LAST_PAREN_MATCH{details},
                                                                                                logger      =>  $logger,
                                                                                            ):
                                            undef;
        next unless $entry_object;
        push @array                     ,   $entry_object;

    };

    return  wantarray?   @array:
            [@array];

}



__END__

