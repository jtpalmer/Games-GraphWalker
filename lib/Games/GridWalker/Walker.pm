package Games::GridWalker::Walker;

# ABSTRACT: Walker model

use strict;
use warnings;
use Mouse;
use namespace::clean -except => 'meta';
use Games::GridWalker qw(:compass);

has [qw( x y v )] => (
    is      => 'rw',
    isa     => 'Num',
    default => 0,
);

has [qw( vx vy _want_vx _want_vy )] => (
    is      => 'rw',
    isa     => 'Num',
    default => 0,
);

has [qw( _last_x _last_y _next_x _next_y )] => (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
);

has moving => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

sub move {
    my ( $self, $dt ) = @_;

    return unless $self->moving;

    $self->_last_x( $self->x );
    $self->_last_y( $self->y );

    $self->x( $self->x + $self->vx * $dt );
    $self->y( $self->y + $self->vy * $dt );

    if ( $self->vx && $self->vx != $self->_want_vx ) {
        if ( $self->vx > 0 && $self->x > $self->_next_x ) {
            $self->x( $self->_next_x );
            $self->vx( $self->_want_vx );
            $self->vy( $self->_want_vy );
        }

        if ( $self->vx < 0 && $self->x < $self->_next_x ) {
            $self->x( $self->_next_x );
            $self->vx( $self->_want_vx );
            $self->vy( $self->_want_vy );
        }
    }
    else {
        if ( $self->vx > 0 && $self->x > $self->_next_x ) {
            $self->_next_x( $self->_next_x + 1 );
        }

        if ( $self->vx < 0 && $self->x < $self->_next_x ) {
            $self->_next_x( $self->_next_x - 1 );
        }
    }

    if ( $self->vy && $self->vy != $self->_want_vy ) {
        if ( $self->vy > 0 && $self->y > $self->_next_y ) {
            $self->y( $self->_next_y );
            $self->vx( $self->_want_vx );
            $self->vy( $self->_want_vy );
        }

        if ( $self->vy < 0 && $self->y < $self->_next_y ) {
            $self->y( $self->_next_y );
            $self->vx( $self->_want_vx );
            $self->vy( $self->_want_vy );
        }
    }
    else {
        if ( $self->vy > 0 && $self->y > $self->_next_y ) {
            $self->_next_y( $self->_next_y + 1 );
        }

        if ( $self->vy < 0 && $self->y < $self->_next_y ) {
            $self->_next_y( $self->_next_y - 1 );
        }
    }

    if ( !$self->vx && !$self->vy ) {
        $self->moving(0);
    }

    return;
}

sub set_direction {
    my ( $self, $direction ) = @_;

    for ($direction) {
        if ( $_ == NORTH ) {
            $self->_want_vx(0);
            $self->_want_vy( -$self->v );
            last;
        }
        if ( $_ == SOUTH ) {
            $self->_want_vx(0);
            $self->_want_vy( $self->v );
            last;
        }
        if ( $_ == WEST ) {
            $self->_want_vx( -$self->v );
            $self->_want_vy(0);
            last;
        }
        if ( $_ == EAST ) {
            $self->_want_vx( $self->v );
            $self->_want_vy(0);
            last;
        }
    }

    if ( !$self->moving ) {
        $self->vx( $self->_want_vx );
        $self->vy( $self->_want_vy );

        $self->_next_x( $self->x + 1 ) if $self->vx > 0;
        $self->_next_x( $self->x - 1 ) if $self->vx < 0;
        $self->_next_y( $self->y + 1 ) if $self->vy > 0;
        $self->_next_y( $self->y - 1 ) if $self->vy < 0;

        $self->moving(1);
    }
}

sub stop {
    my $self = shift;

    $self->_want_vx(0);
    $self->_want_vy(0);
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 SYNOPSIS

    use Games::GridWalker::Walker;

    my $walker = Games::GridWalker::Walker->new();

=head1 DESCRIPTION



=head1 METHODS

=head2 move

=head2 set_direction

=head2 stop

=head1 SEE ALSO

=over 4

=item * L<Games::GridWalker>

=back

=cut

