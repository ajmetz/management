package Management::App::Boilerplate::ObjectPadVersion;

use     strict;
use     warnings;
use     utf8;

our $VERSION                        =   'v1.0.0';

sub import {

    # Processing / Declaring what to import:
    Object::Pad->import('v0.820');
}

# Protect subclasses using AUTOLOAD
sub DESTROY { }

__END__