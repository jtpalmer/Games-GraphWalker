package Games::GraphWalker::Role::Walker;

# ABSTRACT: Walker role

use strict;
use warnings;
use Moo::Role;
use namespace::clean -expect => 'meta';
use MooX::Types::MooseLike::Base qw(Bool);
use MooX::Types::MooseLike::Numeric qw(PositiveOrZeroNum);
use Carp qw(croak);

with qw(Games::GraphWalker::Role::Observable);

# Events:
# moved?
# changed_direction?
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
    isa     => PositiveOrZeroNum,
    default => sub { 0.1 },
);

has _position => (
    is      => 'rw',
    #isa     => 'Maybe[Num]',
    default => sub { undef },
);

has _distance => (
    is      => 'rw',
    #isa     => 'Maybe[Num]',
    default => sub { undef },
);

# Either current_node or both _prev_node and _next_node must be defined
has current_node => (
    is       => 'rw',
    #isa      => 'Maybe[Games::GraphWalker::Role::Node]',
    writer   => '_current_node',
    required => 1,
);

has _prev_node => (
    is      => 'rw',
    #isa     => 'Maybe[Games::GraphWalker::Role::Node]',
    default => sub { undef },
);

has _next_node => (
    is      => 'rw',
    #isa     => 'Maybe[Games::GraphWalker::Role::Node]',
    default => sub { undef },
);

has moving => (
    is      => 'rw',
    isa     => Bool,
    default => sub { 0 },
);

sub edge {
    my $self = shift;
    return [ $self->_prev_node, $self->_next_node ];
}

sub move {
    my ( $self, $dt ) = @_;

    return if defined $self->current_node;

    return unless defined $dt;

    my $pos = $self->_position + $dt * $self->max_v;

    my $remainder = $pos - $self->_distance;

    if ( $remainder < 0 ) {
        $self->_position($pos);
    }
    else {
        my $prev_node = $self->_prev_node;
        my $next_node = $self->_next_node;

        $self->_distance(undef);
        $self->_position(undef);

        $self->notify_observers( 'exited_node',  $self, $prev_node );

        $self->_prev_node(undef);
        $self->_next_node(undef);
        $self->_current_node($next_node);

        $self->notify_observers( 'entered_node', $self, $next_node );
    }

    $self->notify_observers( 'moved', $self );

    if ( $remainder > 0 ) {
        if ( defined $self->_next_node ) {
            return $self->move($remainder);
        }
        else {
            $self->moving(0);
            $self->notify_observers( 'stopped_moving', $self );
        }
    }

    return;
}

sub walk_to_direction {
    my $self = shift;
    my $dir  = shift;

    croak 'not on a node' unless $self->current_node;

    my $nodes = $self->graph->successors( $self->current_node );

    croak 'Edge not found' unless defined $nodes->{$dir};

    return $self->walk_to_node( $nodes->{$dir}, @_ );
}

sub walk_to_node {
    my ( $self, $node, $dt ) = @_;

    croak 'not on a node' unless defined $self->current_node;

    my $prev_node = $self->current_node;
    my $next_node = $node;
    my $distance  = $self->graph->get_edge_distance( $prev_node, $next_node );

    $self->_distance($distance);
    $self->_position(0);

    if ( !$self->moving ) {
        $self->moving(1);
        $self->notify_observers( 'started_moving', $self );
    }

    $self->notify_observers( 'exiting_node',  $self, $prev_node );

    $self->_prev_node($prev_node);
    $self->_next_node($next_node);
    $self->_current_node(undef);

    $self->notify_observers( 'entering_node', $self, $next_node );

    return $self->move($dt);
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

