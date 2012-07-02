use strict;
use warnings;
use Test::More;
use Games::GraphWalker;

my ( $width, $height ) = ( 200, 100 );

my $grid = Games::GraphWalker::make_grid(
    width  => $width,
    height => $height,
);
ok( $grid, 'make_grid' );
isa_ok( $grid, 'Games::GraphWalker::Grid' );

is( $grid->width,  $width,  'width' );
is( $grid->height, $height, 'height' );

done_testing();

