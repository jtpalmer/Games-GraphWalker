package Games::GraphWalker::Role::Walker;

# ABSTRACT: Walker role

use strict;
use warnings;
use Any::Moose qw(Role);
use namespace::clean -expect => 'meta';
use Games::GraphWalker::Types;

# Events:
# moved
# changed_direction
# entering_node
# entered_node
# exiting_node
# exited_node
# started_moving
# stopped_moving

has graph => (
    is       => 'ro',
    required => 1,
);

has max_v => (
    is      => 'rw',
    isa     => 'NonNegativeNum',
    default => 0.1,
);

has direction => (
    is        => 'rw',
    clearer   => '_clear_direction',
    predicate => 'has_direction',
);

has _next_direction => ( is => 'rw' );

has [qw( _position _distance )] => (
    is      => 'rw',
    isa     => 'Num',
    default => 0,
);

has current_node => (
    is       => 'rw',
    isa      => 'Maybe[Games::GraphWalker::Role::Node]',
    writer   => '_current_node',
    required => 1,
);

has [qw( _last_node _next_node )] => (
    is      => 'rw',
    isa     => 'Maybe[Games::GraphWalker::Role::Node]',
    default => undef,
);

has moving => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

around direction => sub {
    my ( $orig, $self, $dir ) = @_;

    return $self->$orig unless defined $dir;

    $self->_next_direction($dir);

    return $self->$orig if $self->moving;

    return $self->$orig($dir);
};

sub move {
    my ( $self, $dt ) = @_;

    # Do we have a direction set?
    return unless $self->has_direction;

    # Do we have our next node set?
    if ( !$self->_next_node ) {
        return $self->_move_towards( $self->direction, $dt );
    }

    my $pos = $self->_position + $dt * $self->max_v;

    # Have we reached the next node?
    if ( $pos >= $self->_distance ) {
        my $remainder = $pos - $self->_distance;

        $self->_current_node( $self->_next_node );

        # Events:
        # entered_node

        if ( $remainder > 0 ) {

            # Do we want to stop moving?
            if ( !defined $self->_next_direction ) {
                $self->moving(0);
                $self->_clear_direction;
                $self->_next_node(undef);

                # Events:
                # stopped_moving
            }
            else {
                $self->_move_towards( $self->_next_direction );
            }
        }
    }
    else {
        $self->_position($pos);
    }

    # Events:
    # moved?
}

sub _move_towards {
    my ( $self, $dir, $dt ) = @_;

    # Do we have somewhere to move to?
    #my $nodes = $self->current_node->successors;
    my $nodes = $self->graph->successors( $self->current_node );

    if ( defined $nodes->{$dir} ) {

        my $node = $nodes->{$dir};

        $self->_last_node( $self->current_node );
        $self->_next_node($node);
        $self->_current_node(undef);

        $self->_distance(
            $self->graph->get_edge_distance(
                $self->_last_node, $self->_next_node
            )
        );
        $self->_position(0);

        # Events:
        # exiting_node
        # entering_node

        if ( !$self->moving ) {
            $self->moving(1);

            # Events:
            # started_moving
        }
        else {

            # Events:
            # changed_direction?
        }

        return $self->move($dt);
    }
    elsif ( $self->moving ) {
        $self->_clear_direction();
        $self->_next_direction(undef);
        $self->moving(0);

        # Event:
        # stopped_moving
        return;
    }

    # Events:
    # exiting_node
    # entering_node

}

sub stop {
    my $self = shift;

    $self->_next_direction(undef) if $self->moving;

}

1;

__END__

=pod

=head1 SYNOPSIS

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

