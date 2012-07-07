package Games::GraphWalker::Role::Graph;

# ABSTRACT: Graph role

use strict;
use warnings;
use Any::Moose qw(Role);
use Carp qw(croak);
use Graph;

# Events:
# entering_node
# entered_node
# exiting_node
# exited_node

has _graph => (
    is      => 'ro',
    isa     => 'Graph',
    handles => {
        add_node     => 'add_vertex',
        has_node     => 'has_vertex',
        has_nodes    => 'has_vertices',
        delete_node  => 'delete_vertex',
        delete_nodes => 'delete_vertices',
        has_edge     => 'has_edge',
        has_edges    => 'has_edges',
        delete_edge  => 'delete_edge',
        delete_edges => 'delete_edges',
    },
);

around BUILDARGS => sub {
    my ( $orig, $class, %args ) = @_;

    my ( $nodes, $edges ) = @args{qw( nodes edges )};

    $nodes = [] unless ref $nodes eq 'ARRAY';

    warn(scalar @$nodes . " nodes");

    my $graph = Graph->new(
        directed    => 1,
        refvertexed => 1,
        vertices    => $nodes,
    );

    if ( ref $edges eq 'ARRAY' ) {
        for my $edge (@$edges) {

            $class->_add_edge_to_graph( $graph, $edge );
        }
    }

    return $class->$orig( %args,  _graph => $graph );
};

sub add_edge {
    my ( $self, %args ) = @_;

    $self->_add_edge_to_graph( $self->_graph, \%args );
}

sub _add_edge_to_graph {
    my ( $class, $graph, $edge ) = @_;

    my ( $u, $v, $dir, $dist ) = @$edge{qw( src dest direction distance )};

    $dist = 1 unless defined $dist;

    $graph->add_edge( $u, $v );
    $graph->set_edge_attribute( $u, $v, 'direction', $dir );
    $graph->set_edge_attribute( $u, $v, 'distance',  $dist );
}

sub successors {
    my ( $self, $v ) = @_;

    my %succ;

    for my $s ( $self->_graph->successors($v) ) {
        my $dir = $self->get_edge_direction( $v, $s );
        $succ{$dir} = $s;
    }

    return \%succ;
}

sub get_edge_direction {
    my ( $self, $u, $v ) = @_;
    return $self->_graph->get_edge_attribute( $u, $v, 'direction' );
}

sub get_edge_distance {
    my ( $self, $u, $v ) = @_;
    return $self->_graph->get_edge_attribute( $u, $v, 'distance' );
}

1;

