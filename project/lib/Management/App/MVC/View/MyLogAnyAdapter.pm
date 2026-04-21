package Management::App::MVC::View::MyLogAnyAdapter;
# Derived from: package Log::Any::Adapter::MojoLog;

use strict;
use warnings;

our $VERSION = '0.05';
$VERSION = eval $VERSION;

use Log::Any::Adapter::Util qw(make_method);
use base qw(Log::Any::Adapter::Base);

use Mojo::Log;
use Management::App::MVC::View::Language;
use Mojo::Util qw(dumper);
use Data::Util qw(
    is_string
    is_code_ref
);
use Carp;
use English;

sub init { 

$_[0]->{logger}             ||= Mojo::Log->new;
$_[0]->{language}           ||= Management::App::MVC::View::Language->try_or_die();
$_[0]->{localisation_scope} ||= undef;

};



# Create logging methods
#
foreach my $method ( Log::Any->logging_methods ) {
    my $mojo_method = $method;


    # Map log levels down to Mojo::Log levels where necessary
    #
    for ($mojo_method) {
        s/notice/info/;
        s/warning/warn/;
        s/critical|alert|emergency/fatal/;
    }

    
    make_method(
        $method,
        sub {
                # Initial Values:
                my  $self               =   shift;
                my  ($calling_class)    =   caller;

                # Definition:
                my  $management_code    =   $self->{scope}
                                            && $calling_class
                                            && 1+(
                                                index ($calling_class, $self->{localisation_scope}, 0)
                                            )?  'Yes, I believe this is Management class!':
                                            undef;

                # Processing:
                $self->{logger}->$mojo_method(

                    $management_code?       $self->{language}->localise(@ARG):
                    @ARG

                );

        }
    );
}

# Create detection methods: is_debug, is_info, etc.
#

foreach my $method ( Log::Any->detection_methods ) {
    my $level = $method;
    $level =~ s/^is_//;

    # Map log levels down to Mojo::Log levels where necessary
    #
    for ($level) {
        s/notice/info/;
        s/warning/warn/;
        s/critical|alert|emergency/fatal/;
    }

    make_method(
        $method,
        sub { $_[0]->{logger}->is_level($level ? $level : ()) }
    );
}

1;

__END__

                my  $first_argument     =   shift;
                # Not detecting the code ref (was it stringified earlier in the chain?)
                warn 'First arg is...'.dumper($first_argument);
                warn 'Is_code_ref is...'.dumper(ref $first_argument eq 'CODE');
                warn 'Seems to be '.(ref $first_argument eq 'CODE'? 'true - a code ref.':'false - not a code ref.');

                $first_argument         =   $first_argument->()
                                            if (ref $first_argument eq 'CODE');
                my  $string             =   ref $first_argument eq 'CODE'? 'Dereferenced and executed:'.$first_argument->(): 'Left as is:'.$first_argument;
                
                warn 'First arg becomes...'.dumper($first_argument); # Remains a code ref representation as a string, rather than the return string from the coderef.
                warn 'This string we got is...'.dumper($string);
                
                warn Carp::longmess('From anon sub in make_method in our custom LogAny Adapter');

=pod

=head1 NAME

Log::Any::Adapter::MojoLog - Log::Any integration for Mojo::Log

=head1 SYNOPSIS

    use Mojo::Log;
    use Log::Any::Adapter;

    Log::Any::Adapter->set('MojoLog', logger => Mojo::Log->new);

Mojolicious app:

    use Mojo::Base 'Mojolicious';

    use Log::Any::Adapter;

    sub startup {
        my $self = shift;

        Log::Any::Adapter->set('MojoLog', logger => $self->log);
    }

Mojolicious::Lite app:

    use Mojolicious::Lite;

    use Log::Any::Adapter;

    Log::Any::Adapter->set('MojoLog', logger => app->log);

=head1 DESCRIPTION

This Log::Any adapter uses L<Mojo::Log> for logging. Mojo::Log must
be initialized before calling I<set>. The parameter logger must
be used to pass in the logging object.

=head1 LOG LEVEL TRANSLATION

Log level which are not exectly the same are translated from Log::Any
to Mojo::Log as follows:

    notice -> info
    warning -> warn
    critical -> fatal
    alert -> fatal
    emergency -> fatal

=head1 SEE ALSO

=over

=item *

L<Log::Any::Adapter::Mojo> - The original release of this codebase

=item *

L<Log::Any>

=item *

L<Log::Any::Adapter>

=item *

L<Mojo::Log>

=back

=head1 SOURCE REPOSITORY

L<http://github.com/jberger/Log-Any-Adapter-MojoLog>

=head1 AUTHOR

Joel Berger, E<lt>joel.a.berger@gmail.comE<gt>

=head1 CONTRIBUTORS

Dan Book (Grinnz)

=head1 NOTES

This module was forked from L<Log::Any::Adapter::Mojo> which bears the copyright

Copyright (C) 2011 Henry Tang

and is licensed under the Artistic License version 2.0

This fork began as fixes for L<RT#111631|https://rt.cpan.org/Public/Bug/Display.html?id=111631> and L<RT#101167|https://rt.cpan.org/Public/Bug/Display.html?id=101167>.
However the eventual changes that were made prevented any possibility for keeping a consistent log formatter.
As such I think it is the responsible action to fork the module to release it.
I intend to work with the original author to see how much of these changes can be backported into that codebase without breaking the format.

=head1 COPYRIGHT & LICENSE

Log::Any::Adapter::MojoLog is Copyright (C) 2016 L</AUTHOR> and L</CONTRIBUTORS>.

Log::Any::Adapter::MojoLog is provided "as is" and without any express or
implied warranties, including, without limitation, the implied warranties
of merchantibility and fitness for a particular purpose.

This program is free software, you can redistribute it and/or modify it
under the terms of the Artistic License version 2.0.

=cut
