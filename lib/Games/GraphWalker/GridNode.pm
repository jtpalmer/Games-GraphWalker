package Games::GraphWalker::GridNode;

# ABSTRACT: Grid node model

use strict;
use warnings;
use Mouse;
use namespace::clean -except => 'meta';

with qw(Games::GraphWalker::Role::Node);

has [qw( x y )] => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
);

__PACKAGE__->meta->make_immutable;

1;

