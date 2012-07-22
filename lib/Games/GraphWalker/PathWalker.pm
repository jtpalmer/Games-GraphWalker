package Games::GraphWalker::PathWalker;

# ABSTRACT: Walker that follows a path

use strict;
use warnings;
use Moo;
use namespace::clean -except => 'meta';
use MooX::Types::MooseLike::Base qw( Bool Int );
use Carp qw(croak);

with qw(Games::GraphWalker::Role::Walker);

has path => (
    is       => 'ro',
    #isa      => 'ArrayRef[Games::GraphWalker::Role::Node]',
    required => 1,
);

has _path_index => (
    is      => 'rw',
    isa     => Int,
    default => sub {0},
);

has is_cycle => (
    is      => 'ro',
    isa     => Bool,
    default => sub {0},
);

has '+current_node' => (
    lazy     => 1,
    builder  => '_build_current_node',
    required => 0,
);

sub _build_current_node {
    return $_[0]->path->[0];
}

sub BUILD {
    my $self = shift;

    $self->register_observer( 'entered_node',
        sub { $self->_walk_to_next_node() } );

    $self->_walk_to_next_node();
}

sub stop {
    my $self = shift;
    return;
}

sub _walk_to_next_node {
    my $self = shift;

    my $index = $self->_path_index + 1;

    if ( $index == @{ $self->path } ) {
        if ( $self->is_cycle ) {
            $index = 0;
        }
        else {
            return;
        }
    }

    my $node = $self->path->[$index];

    eval {
        $self->walk_to_node($node);
        $self->_path_index($index);
        1;
    } or do {
        croak "Can't walk to node at index $index";
    };

    return;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 SYNOPSIS

    use Games::GraphWalker::PathWalker;

    my $walker = Games::GraphWalker::PathWalker->new(
    );

=head1 DESCRIPTION

=head1 METHODS

=head1 SEE ALSO

=over 4

=item * L<Games::GraphWalker>

=item * L<Games::GraphWalker::Role::Walker>

=back

=cut

