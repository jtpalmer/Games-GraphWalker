package Games::GraphWalker::Role::Projection;

# ABSTRACT: Projection role

use strict;
use warnings;
use Any::Moose qw(Role);

requires qw( coords_for_node coords_for_walker );

1;

