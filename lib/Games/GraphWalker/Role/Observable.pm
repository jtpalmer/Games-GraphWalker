package Games::GraphWalker::Role::Observable;

# ABSTRACT: Observable role

use strict;
use warnings;
use Moo::Role;
use MooX::Types::MooseLike::Base qw( ArrayRef CodeRef HashRef );
use Carp qw(croak);

has _observers => (
    is      => 'ro',
    #isa     => HashRef[ArrayRef[CodeRef]],
    default => sub { {} },
);

sub register_observer {
    my ( $self, $event, $sub ) = @_;

    croak "Not a CodeRef: '$sub'" unless ref $sub eq 'CODE';

    push @{ $self->_observers->{$event} }, $sub;

    return $sub;
}

sub unregister_observer {
    my ( $self, $event, $sub ) = @_;

    croak "Not a CodeRef: '$sub'" unless ref $sub eq 'CODE';

    @{ $self->_observers->{$event} }
        = grep { $_ != $sub } @{ $self->_observers->{$event} };

    return $sub;
}

sub notify_observers {
    my $self  = shift;
    my $event = shift;

    $_->(@_) for @{ $self->_observers->{$event} };
}

1;

