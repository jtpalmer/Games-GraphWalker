#!perl
use strict;
use warnings;
use SDL 2.500;
use SDL::Event qw( SDL_KEYDOWN SDL_KEYUP );
use SDL::Events qw( SDLK_LEFT SDLK_RIGHT SDLK_UP SDLK_DOWN );
use SDLx::App;
use Games::GraphWalker qw(:all);

my ( $width, $height ) = ( 640, 480 );
my $cell_size   = 40;
my $walker_size = 20;
my ( $grid_width, $grid_height ) = ( $width / 40, $height / 40 );

my $grid = make_grid(
    width  => $grid_width,
    height => $grid_height,
);

my $walker = make_walker(
    x     => int( $grid_width / 2 ),
    y     => int( $grid_height / 2 ),
    max_v => 0.5,
);

my $app = SDLx::App->new(
    width  => $grid_width * $cell_size,
    height => $grid_height * $cell_size,
    delay  => 20,
    eoq    => 1,
);

$app->add_move_handler( sub { $walker->move(@_) } );

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

        my $x = ( $walker->x + 0.5 ) * $cell_size - $walker_size / 2;
        my $y = ( $walker->y + 0.5 ) * $cell_size - $walker_size / 2;
        $app->draw_rect( [ $x, $y, $walker_size, $walker_size ], 0xFFFF00FF );

        $app->update();
    }
);

$app->add_event_handler(
    sub {
        my ($event) = @_;

        if ( $event->type == SDL_KEYDOWN ) {
            $walker->set_direction(WEST)  if $event->key_sym == SDLK_LEFT;
            $walker->set_direction(EAST)  if $event->key_sym == SDLK_RIGHT;
            $walker->set_direction(NORTH) if $event->key_sym == SDLK_UP;
            $walker->set_direction(SOUTH) if $event->key_sym == SDLK_DOWN;
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

