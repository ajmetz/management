#!/usr/bin/env perl

use strict;
use warnings;
use Mojo::File qw(curfile);
use lib curfile->dirname->child('lib')->to_string;

use     Management::App::Boilerplate::ObjectPadVersion;

class   TestScript 1.00;

use     Management::App::Boilerplate::Code;
use     Sub::Util('subname');
TestScript->new->test->test_two->test_three;

method test {
    say scalar __SUB__;
    return $self;
}

sub test_two($self) {
    say __SUB__;
    return $self;
}

method $test_four {
    say subname(__SUB__);
    return $self;
}

method test_three {
    say subname(__SUB__);
    $self->$test_four;
    return $self;
}




__END__