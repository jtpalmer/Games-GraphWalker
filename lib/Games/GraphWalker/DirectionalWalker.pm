package Games::GraphWalker::DirectionalWalker;

# ABSTRACT: Walker model

use strict;
use warnings;
use Moo;
use namespace::clean -except => 'meta';

with qw(Games::GraphWalker::Role::Walker);

has _direction      => ( is => 'rw' );
has _next_direction => ( is => 'rw' );

sub BUILD {
    my $self = shift;

    $self->register_observer(
        'entered_node',
        sub {
            return unless defined $self->_next_direction;

            eval {
                $self->walk_to_direction( $self->_next_direction );
                1;
            } or do {
                $self->_direction(undef);
            };
        }
    );
}

sub direction {
    my $self = shift;

    return $self->_direction unless @_;

    $self->_next_direction(@_);

    return $self->_direction if $self->moving;

    $self->_direction(@_);

    eval {
        $self->walk_to_direction(@_);
        1;
    } or do {
        $self->_direction(undef);
    };

    return $self->_direction;
}

sub stop {
    my $self = shift;
    $self->_next_direction(undef) if $self->moving;
    return;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 SYNOPSIS

    use Games::GraphWalker::DirectionalWalker;

    my $walker = Games::GraphWalker::DirectionalWalker->new(
    );

=head1 DESCRIPTION

=head1 METHODS

=head1 SEE ALSO

=over 4

=item * L<Games::GraphWalker>

=back

=cut

