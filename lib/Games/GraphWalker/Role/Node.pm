package Games::GraphWalker::Role::Node;

# ABSTRACT: Graph node role

use strict;
use warnings;
use Any::Moose qw(Role);
use namespace::clean -except => 'meta';

# Events:
# entering
# entered
# exiting
# exited

has graph => (
    is       => 'ro',
    isa      => 'Games::GraphWalker::Role::Graph',
    #required => 1,
);

has data => ( is => 'rw' );

1;

