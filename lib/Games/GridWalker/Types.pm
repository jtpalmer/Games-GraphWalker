package Games::GridWalker::Types;

# ABSTRACT: Types

use strict;
use warnings;
use Mouse::Util::TypeConstraints;

subtype 'NonNegativeNum' => (
    as 'Num',
    where { $_ >= 0 },
    message {"The number you proveded, $_, was nont a non-negative number"}
);

1;

__END__

