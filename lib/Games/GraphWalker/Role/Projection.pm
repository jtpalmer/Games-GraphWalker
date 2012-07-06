package Games::GraphWalker::Role::Projection;

# ABSTRACT: Projection role

use strict;
use warnings;
use Moose::Role;

requires qw( coords_for_node coords_for_walker );

has [qw( width height )] => (
    is       => 'rw',
    isa      => 'Num',
    required => 1,
);

1;

