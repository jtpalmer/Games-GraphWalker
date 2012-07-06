#!perl
use strict;
use warnings;
use SDL 2.500;
use SDL::Event qw( SDL_KEYDOWN SDL_KEYUP );
use SDL::Events qw( SDLK_LEFT SDLK_RIGHT SDLK_UP SDLK_DOWN );
use SDLx::App;
use Games::GraphWalker;
use Games::GraphWalker::Grid qw( NORTH SOUTH EAST WEST );
use Games::GraphWalker::GridProjection;
use Games::GraphWalker::Walker;

my ( $width, $height ) = ( 640, 480 );
my $cell_size   = 40;
my $walker_size = 20;
my ( $grid_width, $grid_height ) = ( $width / 40, $height / 40 );

my $grid = Games::GraphWalker::Grid->new(
    width  => $grid_width,
    height => $grid_height,
);

my $node = $grid->get_node(
    int( $grid_width / 2 ),
    int( $grid_height / 2 ),
);

my $walker = Games::GraphWalker::Walker->new(
    max_v        => 0.5,
    graph        => $grid,
    current_node => $node,
);

my $projection = Games::GraphWalker::GridProjection->new(
    width  => $width,
    height => $height,
);

my $gw = Games::GraphWalker->new(
    graph      => $grid,
    walkers    => [$walker],
    projection => $projection,
);

my $app = SDLx::App->new(
    width  => $grid_width * $cell_size,
    height => $grid_height * $cell_size,
    #delay  => 20,
    eoq    => 1,
);

$app->add_move_handler( sub { $gw->move_walkers(@_) } );

$app->add_show_handler(
    sub {
        $app->draw_rect( undef, undef );

        for my $n ( 0 .. $grid_width - 1 ) {
            my $x = ( $n + 0.5 ) * $cell_size;
            $app->draw_line( [ $x, 0 ], [ $x, $height ], 0x444444ff );
        }

        for my $n ( 0 .. $grid_height - 1 ) {
            my $y = ( $n + 0.5 ) * $cell_size;
            $app->draw_line( [ 0, $y ], [ $width, $y ], 0x444444ff );
        }

        my $pos = $gw->coords_for_walker($walker);
        my $x = ( $pos->[0] + 0.5 ) * $cell_size - $walker_size / 2;
        my $y = ( $pos->[1] + 0.5 ) * $cell_size - $walker_size / 2;
        $app->draw_rect( [ $x, $y, $walker_size, $walker_size ], 0xFFFF00FF );

        $app->update();
    }
);

$app->add_event_handler(
    sub {
        my ($event) = @_;

        if ( $event->type == SDL_KEYDOWN ) {
            $walker->direction(Games::GraphWalker::Grid::WEST)  if $event->key_sym == SDLK_LEFT;
            $walker->direction(Games::GraphWalker::Grid::EAST)  if $event->key_sym == SDLK_RIGHT;
            $walker->direction(Games::GraphWalker::Grid::NORTH) if $event->key_sym == SDLK_UP;
            $walker->direction(Games::GraphWalker::Grid::SOUTH) if $event->key_sym == SDLK_DOWN;
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

