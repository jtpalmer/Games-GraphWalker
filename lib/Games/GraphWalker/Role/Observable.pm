package Games::GraphWalker::Role::Observable;

# ABSTRACT: Observable role

use strict;
use warnings;
use Any::Moose qw(Role);
use Carp qw(croak);

has _observers => (
    is      => 'ro',
    isa     => 'HashRef[ArrayRef[CodeRef]]',
    default => sub { {} },
);

sub register_observer {
    my ( $self, $event, $sub ) = @_;

    croak "Not a CodeRef: '$sub'" unless ref $sub eq 'CODE';

    push @{ $self->_observers->{$event} }, $sub;
}

sub unregister_observer {
    my ( $self, $event, $sub ) = @_;

    croak "Not a CodeRef: '$sub'" unless ref $sub eq 'CODE';

    @{ $self->_observers->{event} } = grep { $_ != $sub } @{ $self->_observers->{event} };
}

sub notify_observers {
    my $self = shift;
    my $event = shift;

    $_->(@_) for @{ $self->_observers->{$event} };
}

1;

