package Management::App::Boilerplate::ObjectPadVersion;

use     strict;
use     warnings;
use     utf8;

use     Import::Into;

our $VERSION                        =   'v1.0.0';

sub import {

    # Processing / Declaring what to import:
    Object::Pad->import::into(
        {
            level   =>  1,
            version =>  'v0.820', # Ensures at least this version. Does not prevent newer versions. Equivalent to using a version number with a use statement.
        }
    );

}

# Protect subclasses using AUTOLOAD
sub DESTROY { }

__END__