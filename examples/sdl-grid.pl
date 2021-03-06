#!perl
use strict;
use warnings;
use SDL 2.500;
use SDL::Event qw( SDL_KEYDOWN SDL_KEYUP );
use SDL::Events qw( SDLK_LEFT SDLK_RIGHT SDLK_UP SDLK_DOWN );
use SDLx::App;
use Games::GraphWalker;
use Games::GraphWalker::Grid qw(-directions);
use Games::GraphWalker::GridProjection;
use Games::GraphWalker::DirectionalWalker;
use Games::GraphWalker::PathWalker;

my ( $width, $height ) = ( 640, 480 );
my $cell_size   = 40;
my $walker_size = 20;
my ( $grid_width, $grid_height ) = ( $width / 40, $height / 40 );

my $grid = Games::GraphWalker::Grid->new(
    width  => $grid_width,
    height => $grid_height,
);

my @remove_nodes = ( [ 0, 0 ], [ 3, 4 ], [ 10, 0 ] );
for my $coord (@remove_nodes) {
    my $node = $grid->get_node(@$coord);
    $grid->delete_node($node);
}

my $node = $grid->get_node( int( $grid_width / 2 ), int( $grid_height / 2 ) );

die 'Node not found' unless $node;

my $walker = Games::GraphWalker::DirectionalWalker->new(
    max_v        => 0.5,
    graph        => $grid,
    current_node => $node,
);

my @path = map { $grid->get_node(@$_) }
    ( [ 8, 8 ], [ 8, 9 ], [ 8, 10 ], [ 9, 10 ], [ 9, 9 ], [ 9, 8 ] );

my $path_walker = Games::GraphWalker::PathWalker->new(
    max_v    => 0.2,
    graph    => $grid,
    path     => \@path,
    is_cycle => 1,
);

my $projection = Games::GraphWalker::GridProjection->new(
    offset_x => $cell_size / 2,
    offset_y => $cell_size / 2,
    scale_x  => $cell_size,
    scale_y  => $cell_size,
);

my $gw = Games::GraphWalker->new(
    graph      => $grid,
    walkers    => [ $walker, $path_walker ],
    projection => $projection,
);

my $app = SDLx::App->new(
    width  => $grid_width * $cell_size,
    height => $grid_height * $cell_size,
    delay  => 5,
    eoq    => 1,
);

my $grid_surface = SDLx::Surface->new( width => $width, height => $height );

for my $edge ( $grid->edges ) {
    my $p0 = $gw->coords_for_node( $edge->[0] );
    my $p1 = $gw->coords_for_node( $edge->[1] );
    $grid_surface->draw_line( $p0, $p1, 0x444444ff );
}

$app->add_move_handler( sub { $gw->move_walkers(@_) } );

$app->add_show_handler(
    sub {
        $app->draw_rect( undef, undef );

        $app->blit_by($grid_surface);

        my ( $pos, $x, $y );

        $pos = $gw->coords_for_walker($walker);
        $x   = $pos->[0] - $walker_size / 2;
        $y   = $pos->[1] - $walker_size / 2;
        $app->draw_rect( [ $x, $y, $walker_size, $walker_size ], 0xFFFF00FF );

        $pos = $gw->coords_for_walker($path_walker);
        $x   = $pos->[0] - $walker_size / 2;
        $y   = $pos->[1] - $walker_size / 2;
        $app->draw_rect( [ $x, $y, $walker_size, $walker_size ], 0xFF0000FF );

        $app->update();
    }
);

$app->add_event_handler(
    sub {
        my ($event) = @_;

        if ( $event->type == SDL_KEYDOWN ) {
            $walker->direction(WEST)  if $event->key_sym == SDLK_LEFT;
            $walker->direction(EAST)  if $event->key_sym == SDLK_RIGHT;
            $walker->direction(NORTH) if $event->key_sym == SDLK_UP;
            $walker->direction(SOUTH) if $event->key_sym == SDLK_DOWN;
        }
        elsif ( $event->type == SDL_KEYUP ) {
            $walker->stop() if $event->key_sym == SDLK_LEFT;
            $walker->stop() if $event->key_sym == SDLK_RIGHT;
            $walker->stop() if $event->key_sym == SDLK_UP;
            $walker->stop() if $event->key_sym == SDLK_DOWN;
        }
    }
);

$app->run();

exit;

