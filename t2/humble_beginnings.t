
# Custom Libraries:
use Path::Tiny;
#use lib path(__FILE__)->parent->parent->realpath->stringify;
use lib path(__FILE__)->parent->sibling('lib')->realpath->stringify;

# Standard Test Boilerplate:
use Management::Boilerplate::Test;

# Specific Modules used:
use Test::Mojo;

=pod Name, Version, Synopsis, Description

=encoding utf8

=head1 NAME

humble_beginnings.t Test File.

=head1 VERSION

v1.0.0

=cut

our $VERSION                    =   'v1.0.0';

=head1 SYNOPSIS

    yath -v # Will automatically run tests found in the ./t2 folder ( such as this test ), in verbose mode.

=head1 DESCRIPTION

Will fill this out in due course.

=cut

say 'Testing our test can function.';
ok(1, "pass");
done_testing();

=head1 AUTHOR

Andrew Mehta

=cut

__END__
