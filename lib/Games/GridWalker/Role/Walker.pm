package Games::GridWalker::Walker;
use strict;
use warnings;
use Mouse::Role;
use namespace::clean -except => 'meta';

# ABSTRACT: An object that moves around a grid

has [qw( _x _y _vx _vy )] => (
    is      => 'rw',
    isa     => 'Num',
    default => 0,
);

has [qw( _want_vx _want_vy _next_x _next_y )] => (
    is      => 'rw',
    isa     => 'Num',
    default => 0,
);

has moving => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

sub x {
    my $self = shift;

    if (@_) {
        $self->_x(@_);
    }

    return $self->_x;
}

sub y {
    my $self = shift;

    if (@_) {
        $self->_y(@_);
    }

    return $self->_y;
}

sub vx {
    my $self = shift;

    if (@_) {
        $self->_vx(@_);
    }

    return $self->_vx;
}

sub vy {
    my $self = shift;

    if (@_) {
        $self->_vy(@_);
    }

    return $self->_vy;
}

sub move {
    my ( $self, $dt ) = @_;

    return unless $self->moving;

    my $new_x = $self->_x + $self->_vx * $dt;
    my $new_y = $self->_y + $self->_vy * $dt;

    # did we move too far

    # should we change velocity

    $self->_x($new_x);
    $self->_y($new_y);

    return;
}

__PACKAGE__->meta->make_immutable;

1;

=pod

=head1 SYNOPSIS

    package My::Walker;
    use Mouse;
    with 'Games::GridWalker::Walker';

=head1 DESCRIPTION

What does this module do?

=head1 METHODS

=head2 method

=head1 CAVEATS

=head1 BUGS

=head1 RESTRICTIONS

=head1 NOTES

=head1 SEE ALSO

=over 4

=item * L<Games::GridWalker>

=back

=cut

