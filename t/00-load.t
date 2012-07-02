use strict;
use warnings;
use Test::More;

BEGIN {
    my @modules = qw(
        Games::MapWalker
        Games::MapWalker::Grid
        Games::MapWalker::Types
        Games::MapWalker::Walker
    );

    for my $module (@modules) {
        use_ok($module) or BAIL_OUT("Failed to load $module");
    }
}

diag(
    sprintf(
        'Testing Games::MapWalker %f, Perl %f, %s',
        $Games::MapWalker::VERSION, $], $^X
    )
);

done_testing();

