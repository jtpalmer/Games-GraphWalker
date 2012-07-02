package Games::GridWalker::Role::Observable;

# ABSTRACT: Undocumented role

use strict;
use warnings;
use Moose::Role;
use Carp qw(croak);

has _observers => (
    is      => 'ro',
    isa     => 'ArrayRef[CodeRef]',
    default => sub { [] },
);

sub register_observer {
    my ( $self, $sub ) = @_;

    croak "Not a CodeRef: '$sub'" unless ref $sub eq 'CODE';

    push @{ $self->_observers }, $sub;
}

sub unregister_observer {
    my ( $self, $sub ) = @_;

    croak "Not a CodeRef: '$sub'" unless ref $sub eq 'CODE';

    @{ $self->_observers } = grep { $_ != $sub } @{ $self->_observers };
}

sub notify_observers {
    my ( $self, $event ) = @_;

    $_->notify($event) for @{ $self->_observers };
}

1;

