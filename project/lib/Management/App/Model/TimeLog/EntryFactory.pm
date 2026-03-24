use     Object::Pad v0.820;

class   Management::App::Model::TimeLog::EntryFactory 1.00;

# Custom Libraries:
use     Path::Tiny;
use     Management::App::Boilerplate::Code;
use     Management::App::Model::TimeLog::Entry;

=utf8

=over

=item multiple_entries

Returns an array of entries.

=back

=cut

# What approach should we have to logging? Should we have a log object or a language object?

method multiple_entries :common ($string) {

    return () unless $string; # Unhelpful premature exit. Perhaps specify that no true arguments were passed in.

    # Only object instances can access fields, so these are locally scoped variables while :common is in place:
    my  $entry_delimiter                =   "\n";
    my  $matches_and_captures_values    =   qr/
                                                ^                                           # Start of string
                                                (?<start_time>\p{Digit}{2}:\p{Digit}{2})    # Start time - two digits, colon, two digits
                                                -                                           # Dash
                                                (?<end_time>\p{Digit}{2}:\p{Digit}{2})      # End time - two digits, colon, two digits
                                                [\s-]+                                      # One or more characters that are spaces or a dash
                                                (?<category>[^\t]+)                         # One or more of anything that isn't a tab.
                                                \t                                          # tab
                                                [\s-]*                                      # Zero or more characters that are spaces or a dash
                                                (?<details>.*)                              # Zero or more of anything - risk of being greedy, so ensure string only has one entry.
                                                $                                           # End of string.
                                            /x;

    my  @array                          =   ();

    foreach my $entry_string (split $entry_delimiter, $string) {

        my $entry_object                =   $entry_string =~ $matches_and_captures_values?  Management::App::Model::TimeLog::Entry->new(%{^CAPTURE}):
                                            undef;
        next unless $entry_object;
        push @array                     ,   $entry_object;

    };

    return @array;

}

# Commandline execution with test data, and pretty output:
unless (caller) {

    
    say # the following pretty output:
'
Start: '.$ARG->start_time.'
End:   '.$ARG->end_time.'
Duration: '.$ARG->duration.'
Category: '.$ARG->category.'
Details:  '.$ARG->details.'
=========
'
for (
    EntryFactory->multiple_entries(
'
15:02-15:15 - YOUTUBE		- Watched youtube videos.
15:22-15:26 - PLANNING		- Getting organised.
hjkdfshflhflaflalh
adjdkjd
15:22-cjcxkxl something.
15:34-15:35 - SOMETHING		- Else.
'
    )
);

};
__END__

