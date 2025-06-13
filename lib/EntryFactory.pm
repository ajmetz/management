use     Object::Pad v0.820;

class   EntryFactory 1.00;

# Custom Libraries:
use     Path::Tiny;
use     lib path(__FILE__)->parent->realpath->stringify;

use     Management::Boilerplate::Code;
use     Entry;

=utf8

=over

=item multiple_entries

Returns an array of entries.

=back

=cut



# What approach should we have to logging? Should we have a log object or a language object? We cannot think because we need to poo basically.

method multiple_entries :common ($string) {

    return undef unless $string;

    # Only object instances can access fields, so these are variables while :common is in place:
    my  $entry_delimiter                =   "\n";
    my  $matches_and_captures_values    =   qr/
                                                ^                                       # Start of string
                                                (?<start_time>\p{Digit}{2}:\p{Digit}{2})     # Start time - two digits, colon, two digits
                                                -                                       # Dash
                                                (?<end_time>\p{Digit}{2}:\p{Digit}{2})       # End time - two digits, colon, two digits
                                                [\s-]+                                  # One or more characters that are spaces or a dash
                                                (?<category>[^\t]+)                     # One or more of anything that isn't a tab.
                                                \t                                      # tab
                                                [\s-]*                                  # Zero or more characters that are spaces or a dash
                                                (?<details>.*)                          # Zero or more of anything - risk of being slurpy, so ensure string only has one entry.
                                                $                                       # End of string.
                                            /x;

    my  @array          =   ();
    my  @entry_strings  =   split $entry_delimiter, $string;

    foreach my $entry_string (@entry_strings) {
        if ($entry_string =~ $matches_and_captures_values) {
            my $entry_object    =   Entry->new(%{^CAPTURE});
            next unless $entry_object;
            push @array         ,   $entry_object;
        }
    };

    return @array;

}

unless (caller) {
    say '
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
'
    )
);

};
__END__

