package Games::GridWalker::Walker;
use strict;
use warnings;
use Mouse;
use namespace::clean -except => 'meta';
use Games::GridWalker qw(:compass);

# ABSTRACT: Undocumented class.

has [qw( x y v vx vy )] => (
    is      => 'rw',
    isa     => 'Num',
    default => 0,
);

has [qw( _want_vx _want_vy _last_x _last_y _next_x _next_y )] => (
    is      => 'rw',
    isa     => 'Num',
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

    if ( $direction == NORTH ) {
        $self->_want_vx(0);
        $self->_want_vy( -$self->v );
    }
    if ( $direction == SOUTH ) {
        $self->_want_vx(0);
        $self->_want_vy( $self->v );
    }
    if ( $direction == WEST ) {
        $self->_want_vx( -$self->v );
        $self->_want_vy(0);
    }
    if ( $direction == EAST ) {
        $self->_want_vx( $self->v );
        $self->_want_vy(0);
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

=pod

=head1 SYNOPSIS

    package My::Walker;
    use Mouse;
    with 'Games::GridWalker::Walker';

=head1 DESCRIPTION

What does this module do?

=head1 METHODS

=head2 method

=head1 CAVEATS

=head1 BUGS

=head1 RESTRICTIONS

=head1 NOTES

=head1 SEE ALSO

=over 4

=item * L<Games::GridWalker>

=back

=cut

