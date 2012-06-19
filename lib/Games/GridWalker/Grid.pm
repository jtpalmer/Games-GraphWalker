package Games::GridWalker::Grid;
use strict;
use warnings;
use Mouse;
use Games::GridWalker qw(:compass);
use Games::GridWalker::Walker;

has _grid => (
    is      => 'ro',
    isa     => 'ArrayRef[ArrayRef]',
    default => sub { [ [] ] },
);

has _walkers => (
    is      => 'ro',
    isa     => 'ArrayRef[Games::GridWalker::Walker]',
    default => sub { [] },
);

has [qw( width height )] => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
);

has [qw( x_spacing y_spacing )] => (
    is      => 'ro',
    isa     => 'Num',
    default => 1,
);

sub is_connected {
    my ( $self, $pos_a, $pos_b ) = @_;

}

sub is_occupied {
}

sub move_walkers {
    my ( $self, $dt ) = @_;

    for my $walker ( @{ $self->_walkers } ) {
        $walker->move($dt);
    }

    return;
}

__PACKAGE__->meta->make_immutable();

1;

=pod

=head1 SYNOPSIS

    my $grid = Games::GridWalker->new(
        width     => 30,
        height    => 20,
        x_spacing => 10,
        y_spacing => 10,
    );

=head1 DESCRIPTION

Represents a grid.

=head1 METHODS

=head2 width

=head2 height

=head2 x_spacing

=head2 y_spacing

=head1 SEE ALSO

=cut

