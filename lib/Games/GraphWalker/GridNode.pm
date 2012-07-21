package Games::GraphWalker::GridNode;

# ABSTRACT: Grid node model

use strict;
use warnings;
use Moo;
use namespace::clean -except => 'meta';
use MooX::Types::MooseLike::Base qw(Int);

with qw(Games::GraphWalker::Role::Node);

has x => (
    is       => 'ro',
    isa      => Int,
    required => 1,
);

has y => (
    is       => 'ro',
    isa      => Int,
    required => 1,
);

__PACKAGE__->meta->make_immutable;

1;

