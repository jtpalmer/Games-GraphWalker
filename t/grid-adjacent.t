use strict;
use warnings;
use Test::More;
use Games::GraphWalker::Grid;

my $grid = Games::GraphWalker::Grid->new();

ok( $grid->_adjacent( [2, 2], [2, 1] ) );
ok( $grid->_adjacent( [2, 2], [1, 2] ) );
ok( $grid->_adjacent( [2, 2], [2, 3] ) );
ok( $grid->_adjacent( [2, 2], [3, 2] ) );

ok( ! $grid->_adjacent( [2, 2], [2, 2] ) );
ok( ! $grid->_adjacent( [2, 2], [1, 1] ) );
ok( ! $grid->_adjacent( [2, 2], [3, 3] ) );
ok( ! $grid->_adjacent( [2, 2], [2, 4] ) );
ok( ! $grid->_adjacent( [2, 2], [4, 2] ) );

done_testing();

