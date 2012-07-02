package Games::GridWalker::Role::Event;

# ABSTRACT: Undocumented class

use strict;
use warnings;
use Mouse::Role;

has type => (
    is       => 'ro',
    required => 1,
);

1;

