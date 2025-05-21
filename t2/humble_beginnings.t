
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


ok(1, "Testing our test can function.");

my $test_object = Test::Mojo->new('Management');

# Get Tests
$test_object->get_ok('/hello')->status_is(200)->content_like(qr/hello/i);
ok($test_object->get_ok('/website01_static.htm')->status_is(200)->tx->res->dom->at('canvas#myChart'), "We have a chart on a static page.");

#$t->get_ok('/website02_dynamic')->status_is(200)->content_like(qr/hello/i);


done_testing();

=head1 AUTHOR

Andrew Mehta

=cut

__END__
