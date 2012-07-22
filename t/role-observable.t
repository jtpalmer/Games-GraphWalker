use strict;
use warnings;
use Test::More;

{

    package My::Observable;
    use Moo;

    with qw(Games::GraphWalker::Role::Observable);

    sub ping {
        my $self = shift;
        $self->notify_observers( 'pinged', @_ );
    }
}

my $o = My::Observable->new();

my $data;

my $ob = $o->register_observer( 'pinged', sub { $data = \@_; } );
$o->ping('a');
is( $data->[0], 'a' );

$data = undef;

$o->unregister_observer( 'pinged', $ob );
$o->ping('a');
is( $data, undef );

done_testing();

