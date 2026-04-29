use     Object::Pad v0.820;

class   Management::App::MVC::Model::BusinessLogic::EntryFactory 1.00;

# Custom Libraries:
use     Path::Tiny;
use     Management::App::Boilerplate::Code;
use     Management::App::MVC::Model::BusinessLogic::Entry;
use     Log::Any ();

#field   $logger     :param;
#field   $start_date :param;
#field   $string     :param;

=utf8

=over

=item multiple_entries

Returns an array of entries.

=back

=cut

# What approach should we have to logging? Should we have a log object or a language object?

method multiple_entries :common ($start_date, $string) {

    return () unless $start_date && $string; # Unhelpful premature exit. Perhaps specify that no true arguments were passed in.
    my $log =   Log::Any->get_logger->clone( prefix => 'Management::App::MVC::Model::BusinessLogic::EntryFactory' );

    #$start_date =   s/-/\//g; # Replace dashes with slashes.
    my ($day, $month, $year) = split /-|\//, $start_date;
    $log->debug('Day, Month, and Year are...', { ddmmyyyy => [$day, $month, $year] }, );

    # Only object instances can access fields, so these are locally scoped variables while :common is in place:
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
                                                                                                start_time  =>  %LAST_PAREN_MATCH{start_time},
                                                                                                end_time    =>  %LAST_PAREN_MATCH{end_time},
                                                                                                categories  =>  [split /,/ %LAST_PAREN_MATCH{categories}],
                                                                                                details     =>  %LAST_PAREN_MATCH{details},
                                                                                                logger      =>  Log::Any->get_logger,
                                                                                            ):
                                            undef;
        next unless $entry_object;
        push @array                     ,   $entry_object;

    };

    return @array;

}

# Commandline execution with test data, and pretty output:
unless (caller) {

say $ARG->status_string for Management::App::MVC::Model::BusinessLogic::EntryFactory->multiple_entries(
'29/04/2026',
'
15:02-15:15 - YOUTUBE		- Watched youtube videos.
15:22-15:26 - PLANNING		- Getting organised.
hjkdfshflhflaflalh
adjdkjd
15:22-cjcxkxl something.
15:34-15:35 - SOMETHING		- Else.
');

};

__END__

Brand New PDL:

multiple_entries
Desired - output an array of entry objects.

input is a starting date, and a multiline string of data.

