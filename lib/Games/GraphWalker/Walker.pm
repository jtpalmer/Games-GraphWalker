package Games::GraphWalker::Walker;

# ABSTRACT: Walker model

use strict;
use warnings;
use Mouse;
use namespace::clean -except => 'meta';
use Games::GraphWalker qw(:compass);
use Games::GraphWalker::Types;

has max_v => (
    is      => 'rw',
    isa     => 'NonNegativeNum',
    default => 0.1,
);

has _x => (
    is       => 'rw',
    isa      => 'Num',
    init_arg => 'x',
    default  => 0,
);

has _y => (
    is       => 'rw',
    isa      => 'Num',
    init_arg => 'y',
    default  => 0,
);

has [qw( _vx _vy _want_vx _want_vy )] => (
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

sub x { $_[0]->_x; }

sub y { $_[0]->_y; }

sub vx { $_[0]->_vx; }

sub vy { $_[0]->_vy; }

sub move {
    my ( $self, $dt ) = @_;

    return unless $self->moving;

    $self->_last_x( $self->_x );
    $self->_last_y( $self->_y );

    $self->_x( $self->_x + $self->_vx * $dt );
    $self->_y( $self->_y + $self->_vy * $dt );

    if ( $self->_vx && $self->_vx != $self->_want_vx ) {
        if ( $self->_vx > 0 && $self->_x > $self->_next_x ) {
            $self->_x( $self->_next_x );
            $self->_vx( $self->_want_vx );
            $self->_vy( $self->_want_vy );
        }

        if ( $self->_vx < 0 && $self->_x < $self->_next_x ) {
            $self->_x( $self->_next_x );
            $self->_vx( $self->_want_vx );
            $self->_vy( $self->_want_vy );
        }
    }
    else {
        if ( $self->_vx > 0 && $self->_x > $self->_next_x ) {
            $self->_next_x( $self->_next_x + 1 );
        }

        if ( $self->_vx < 0 && $self->_x < $self->_next_x ) {
            $self->_next_x( $self->_next_x - 1 );
        }
    }

    if ( $self->_vy && $self->_vy != $self->_want_vy ) {
        if ( $self->_vy > 0 && $self->_y > $self->_next_y ) {
            $self->_y( $self->_next_y );
            $self->_vx( $self->_want_vx );
            $self->_vy( $self->_want_vy );
        }

        if ( $self->_vy < 0 && $self->_y < $self->_next_y ) {
            $self->_y( $self->_next_y );
            $self->_vx( $self->_want_vx );
            $self->_vy( $self->_want_vy );
        }
    }
    else {
        if ( $self->_vy > 0 && $self->_y > $self->_next_y ) {
            $self->_next_y( $self->_next_y + 1 );
        }

        if ( $self->_vy < 0 && $self->_y < $self->_next_y ) {
            $self->_next_y( $self->_next_y - 1 );
        }
    }

    if ( !$self->_vx && !$self->_vy ) {
        $self->moving(0);
    }

    return;
}

sub set_direction {
    my ( $self, $direction ) = @_;

    for ($direction) {
        if ( $_ == NORTH ) {
            $self->_want_vx(0);
            $self->_want_vy( -$self->max_v );
            last;
        }
        if ( $_ == SOUTH ) {
            $self->_want_vx(0);
            $self->_want_vy( $self->max_v );
            last;
        }
        if ( $_ == WEST ) {
            $self->_want_vx( -$self->max_v );
            $self->_want_vy(0);
            last;
        }
        if ( $_ == EAST ) {
            $self->_want_vx( $self->max_v );
            $self->_want_vy(0);
            last;
        }
    }

    if ( !$self->moving ) {
        $self->_vx( $self->_want_vx );
        $self->_vy( $self->_want_vy );

        $self->_next_x( $self->_x + 1 ) if $self->_vx > 0;
        $self->_next_x( $self->_x - 1 ) if $self->_vx < 0;
        $self->_next_y( $self->_y + 1 ) if $self->_vy > 0;
        $self->_next_y( $self->_y - 1 ) if $self->_vy < 0;

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

    use Games::GraphWalker::Walker;

    my $walker = Games::GraphWalker::Walker->new();

=head1 DESCRIPTION



=head1 METHODS

=head2 move

=head2 set_direction

=head2 stop

=head1 SEE ALSO

=over 4

=item * L<Games::GraphWalker>

=back

=cut

