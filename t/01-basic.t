use strict;
use warnings;
use Test::More;
use Games::GridWalker;

my ( $width, $height ) = ( 200, 100 );

my $grid = Games::GridWalker::make_grid(
    width  => $width,
    height => $height,
);
ok( $grid, 'make_grid' );
isa_ok( $grid, 'Games::GridWalker::Grid' );

is( $grid->width,  $width,  'width' );
is( $grid->height, $height, 'height' );

done_testing();

