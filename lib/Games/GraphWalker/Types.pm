package Games::GraphWalker::Types;

# ABSTRACT: Types

use strict;
use warnings;
use Mouse::Util::TypeConstraints;

subtype 'NonNegativeNum' => (
    as 'Num',
    where { $_ >= 0 },
    message {"The number you provided, $_, is not a non-negative number"}
);

subtype 'Coordinate' => (
    as 'ArrayRef[Num]',
    where { scalar @$_ == 2 },
    message {"The coordinate you provided, $_, is not valid"}
);

1;

__END__

=pod

=head1 SYNOPSIS

    package My::Example;
    use Mouse;
    use Games::GraphWalker::Types;

    has number => (
        is  => 'rw',
        isa => 'NonNegativeNum',
    );

    1;

=head1 DESCRIPTION

Games::Gridwalker::Types Provides types used by Games::GraphWalker
classes.

=head1 SEE ALSO

=over 4

=item * L<Games::GraphWalker>

=back

=cut

