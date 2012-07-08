package Games::GraphWalker::GridProjection;

# ABSTRACT: Grid projection implementation

use strict;
use warnings;
use Any::Moose;
use namespace::clean -except => 'meta';

# TODO:
# make general cartesian projection (affine transformation?)
# add z coordinates
# add rotation
# update node accordingly

# Events:
# scale_changed
# offset_changed

with qw(Games::GraphWalker::Role::Projection);

has [qw( offset_x offset_y )] => (
    is      => 'rw',
    isa     => 'Num',
    default => 0,
);

has [qw( scale_x scale_y )] => (
    is      => 'rw',
    isa     => 'Num',
    default => 1,
);

sub coords_for_node {
    my ( $self, $node ) = @_;

    return [
        $node->x * $self->scale_x + $self->offset_x,
        $node->y * $self->scale_y + $self->offset_y,
    ];
}

sub coords_for_walker {
    my ( $self, $walker ) = @_;

    if ( $walker->current_node ) {
        return $self->coords_for_node( $walker->current_node );
    }

    my $edge = $walker->edge;

    return $self->_interpolate(
        $self->coords_for_node( $edge->[0] ),
        $self->coords_for_node( $edge->[1] ),
        $walker->_position / $walker->_distance
    );
}

sub _interpolate {
    my ( $self, $p0, $p1, $d ) = @_;

    return [
        $p0->[0] + ( $p1->[0] - $p0->[0] ) * $d,
        $p0->[1] + ( $p1->[1] - $p0->[1] ) * $d,
    ];

}

__PACKAGE__->meta->make_immutable;

1;

