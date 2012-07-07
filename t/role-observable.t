use strict;
use warnings;
use Test::More;

{
    package My::Observable;
    use Mouse;

    with qw(Games::GraphWalker::Role::Observable);

    sub ping {
        my $self = shift;
        $self->notify_observers('pinged', @_);
    }
}

my $o = My::Observable->new();

my $data;

$o->register_observer('pinged', sub { $data = \@_; });

$o->ping('a');

is($data->[0], 'a');

done_testing();

