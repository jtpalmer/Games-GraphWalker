package Games::GraphWalker::Grid;

# ABSTRACT: Grid model

use strict;
use warnings;
use Moo;
use namespace::clean -except => 'meta';
use MooX::Types::MooseLike::Base qw(Num);
use Carp qw(croak);
use Games::GraphWalker::GridNode;

with qw(Games::GraphWalker::Role::Graph);

use constant {
    NORTH => 1,
    SOUTH => 2,
    WEST  => 4,
    EAST  => 8,
};

use Sub::Exporter -setup => {
    exports => [qw( NORTH SOUTH WEST EAST )],
    groups  => { directions => [qw( NORTH SOUTH WEST EAST )], },
};

has _walkers => (
    is      => 'ro',
    #isa     => 'ArrayRef[Games::GraphWalker::Walker]',
    default => sub { [] },
);

has _node_at => (
    is       => 'ro',
    #isa      => 'ArrayRef[ArrayRef[Games::GraphWalker::GridNode]]',
    required => 1,
);

has x_spacing => (
    is      => 'ro',
    isa     => Num,
    default => sub { 1 },
);

has y_spacing => (
    is      => 'ro',
    isa     => Num,
    default => sub { 1 },
);

around BUILDARGS => sub {
    my ( $orig, $class, %args ) = @_;

    croak "width and height are required"
        unless defined $args{width} and defined $args{height};

    my ( $width, $height ) = @args{qw( width height )};

    my ( $x_spacing, $y_spacing ) = @args{qw( x_spacing y_spacing )};

    $x_spacing = 1 unless defined $x_spacing;
    $y_spacing = 1 unless defined $y_spacing;

    my ( @node_at, @nodes, @edges );

    for my $x ( 0 .. $width - 1 ) {
        for my $y ( 0 .. $height - 1 ) {
            my $node = Games::GraphWalker::GridNode->new(
                x => $x,
                y => $y,

                # TODO:
                #graph => $self,
            );
            push @nodes, $node;
            $node_at[$x][$y] = $node;
        }
    }

    for my $x ( 0 .. $width - 1 ) {
        for my $y ( 0 .. $height - 1 ) {
            if ( $x != $width - 1 ) {
                push @edges => {
                    src       => $node_at[$x][$y],
                    dest      => $node_at[ $x + 1 ][$y],
                    distance  => $x_spacing,
                    direction => EAST,
                };
                push @edges => {
                    src       => $node_at[ $x + 1 ][$y],
                    dest      => $node_at[$x][$y],
                    distance  => $x_spacing,
                    direction => WEST,
                };
            }
            if ( $y != $height - 1 ) {
                push @edges => {
                    src       => $node_at[$x][$y],
                    dest      => $node_at[$x][ $y + 1 ],
                    distance  => $y_spacing,
                    direction => SOUTH,
                };
                push @edges => {
                    src       => $node_at[$x][ $y + 1 ],
                    dest      => $node_at[$x][$y],
                    distance  => $y_spacing,
                    direction => NORTH,
                };
            }
        }
    }

    return $class->$orig(
        %args,
        _node_at => \@node_at,
        nodes    => \@nodes,
        edges    => \@edges,
    );
};

sub get_node {
    my ( $self, $x, $y ) = @_;

    return $self->_node_at->[$x][$y];
}

__PACKAGE__->meta->make_immutable();

1;

__END__

=pod

=head1 SYNOPSIS

    my $grid = Games::GraphWalker->new(
        width     => 30,
        height    => 20,
        x_spacing => 10,
        y_spacing => 10,
    );

=head1 DESCRIPTION

Represents a grid.

=head1 METHODS

=head1 SEE ALSO

=over 4

=item * L<Games::GraphWalker>

=item * L<Games::GraphWalker::Role::Graph>

=back

=cut

