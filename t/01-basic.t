use strict;
use warnings;
use Test::More;
use Games::MapWalker;

my ( $width, $height ) = ( 200, 100 );

my $grid = Games::MapWalker::make_grid(
    width  => $width,
    height => $height,
);
ok( $grid, 'make_grid' );
isa_ok( $grid, 'Games::MapWalker::Grid' );

is( $grid->width,  $width,  'width' );
is( $grid->height, $height, 'height' );

done_testing();

