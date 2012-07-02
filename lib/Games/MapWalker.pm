package Games::MapWalker;

# ABSTRACT: Framework for animating objects that move on a grid

use strict;
use warnings;

use parent qw(Exporter);

use constant {
    NORTH => 1,
    SOUTH => 2,
    WEST  => 4,
    EAST  => 8,
};

our @EXPORT_OK = qw(
    NORTH
    SOUTH
    WEST
    EAST
    make_grid
    make_walker
);

our %EXPORT_TAGS = (
    all     => [qw( NORTH SOUTH WEST EAST make_grid make_walker )],
    compass => [qw( NORTH SOUTH WEST EAST )],
    factory => [qw( make_grid make_walker )],
);

sub make_grid {
    require Games::MapWalker::Grid;
    my $grid = Games::MapWalker::Grid->new(@_);

    return $grid;
}

sub make_walker {
    require Games::MapWalker::Walker;
    my $walker = Games::MapWalker::Walker->new(@_);

    return $walker;
}

sub move {
    my ( $self, $dt ) = @_;

    for my $walker (@{$self->walkers}) {
        $walker->move($dt);
    }

    return;
}

1;

__END__

=pod

=head1 SYNOPSIS

    my $gw = Games::MapWalker->new(
    );

=head1 DESCRIPTION



=head1 METHODS

=head1 SEE ALSO

=cut

