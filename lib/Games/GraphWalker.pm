package Games::GraphWalker;

# ABSTRACT: Framework for animating objects that move on a graph

use strict;
use warnings;
use Any::Moose;
use namespace::clean -except => 'meta';

has graph => (
    is       => 'ro',
    required => 1,
);

has walkers => (
    is       => 'ro',
    required => 1,
);

has projection => (
    is       => 'ro',
    required => 1,
    handles  => [qw( coords_for_node coords_for_walker )],
);

sub move_walkers {
    my ( $self, $dt ) = @_;

    for my $walker ( @{ $self->walkers } ) {
        $walker->move($dt);
    }

    return;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head1 SEE ALSO

=over 4

=item * L<Graph>

=back

=cut

