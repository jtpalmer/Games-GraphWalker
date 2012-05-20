#!perl
use strict;
use warnings;
use Test::More;

BEGIN {
    my @modules = qw(
        Games::GridWalker
    );

    for my $module (@modules) {
        use_ok($module) or BAIL_OUT("Failed to load $module");
    }
}

diag(
    sprintf(
        'Testing Games::GridWalker %f, Perl %f, %s', $Games::GridWalker::VERSION, $], $^X
    )
);

done_testing();

