use strict;
use warnings;
use Test::More;
use Games::GraphWalker::Grid;

my ( $width, $height ) = ( 20, 10 );

my $grid = Games::GraphWalker::Grid->new(
    width  => $width,
    height => $height,
);

ok( $grid, 'new');
isa_ok( $grid, 'Games::GraphWalker::Grid' );

done_testing();

