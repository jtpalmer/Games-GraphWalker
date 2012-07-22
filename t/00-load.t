use strict;
use warnings;
use Test::More;

BEGIN {
    my @modules = qw(
        Games::GraphWalker
        Games::GraphWalker::Grid
        Games::GraphWalker::Walker
    );

    for my $module (@modules) {
        use_ok($module) or BAIL_OUT("Failed to load $module");
    }
}

diag(
    sprintf(
        'Testing Games::GraphWalker %f, Perl %f, %s',
        $Games::GraphWalker::VERSION, $], $^X
    )
);

done_testing();

