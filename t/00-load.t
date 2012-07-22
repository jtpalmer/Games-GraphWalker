use strict;
use warnings;
use Test::More;

BEGIN {
    my @modules = qw(
        Games::GraphWalker
        Games::GraphWalker::DirectionalWalker
        Games::GraphWalker::Grid
        Games::GraphWalker::GridNode
        Games::GraphWalker::GridProjection
        Games::GraphWalker::PathWalker
        Games::GraphWalker::Role::Graph
        Games::GraphWalker::Role::Node
        Games::GraphWalker::Role::Observable
        Games::GraphWalker::Role::Projection
        Games::GraphWalker::Role::Walker
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

