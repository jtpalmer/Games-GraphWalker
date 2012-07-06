package Games::GraphWalker::Walker;

# ABSTRACT: Walker model

use strict;
use warnings;
use Mouse;
use namespace::clean -except => 'meta';
use Games::GraphWalker::Types;

with qw(Games::GraphWalker::Role::Walker);

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 SYNOPSIS

    use Games::GraphWalker::Walker;

    my $walker = Games::GraphWalker::Walker->new();

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

