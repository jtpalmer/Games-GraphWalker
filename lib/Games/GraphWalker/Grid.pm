package Games::GraphWalker::Grid;

# ABSTRACT: Grid model

use strict;
use warnings;
use Mouse;
use Carp qw(croak);
use Games::GraphWalker qw(:compass);
use Games::GraphWalker::Walker;

has _grid => (
    is      => 'ro',
    isa     => 'ArrayRef[ArrayRef]',
    default => sub { [ [] ] },
);

has _walkers => (
    is      => 'ro',
    isa     => 'ArrayRef[Games::GraphWalker::Walker]',
    default => sub { [] },
);

has [qw( width height )] => (
    is       => 'ro',
    isa      => 'Int',
    default => 10,
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
    my ( $self, $pos ) = @_;

    for my $walker ( @{ $self->_walkers } ) {
    }

    return 0;
}

sub move_walkers {
    my ( $self, $dt ) = @_;

    $_->move($dt) for @{ $self->_walkers };

    return;
}

sub _get_direction {
    my ( $self, $pos_a, $pos_b ) = @_;

    croak sprintf( '(%d, %d) and (%d, %d) are not adjacent',
        $pos_a->[0], $pos_a->[1], $pos_b->[0], $pos_b->[1] )
        unless $self->_adjacent( $pos_a, $pos_b );

    for ( $pos_b->[0] - $pos_a->[0] ) {
        return EAST if $_ == 1;
        return WEST if $_ == -1;
    }

    for ( $pos_b->[1] - $pos_a->[1] ) {
        return SOUTH if $_ == 1;
        return NORTH if $_ == -1;
    }
}

sub _adjacent {
    my ( $self, $pos_a, $pos_b ) = @_;

    return ( abs( $pos_b->[0] - $pos_a->[0] ) == 1 )
        ^ ( abs( $pos_b->[1] - $pos_a->[1] ) == 1 );
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

=head2 width

=head2 height

=head2 x_spacing

=head2 y_spacing

=head1 SEE ALSO

=cut

