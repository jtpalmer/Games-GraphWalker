package Games::MapWalker::Types;

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

=pod

=head1 SYNOPSIS

    package My::Example;
    use Mouse;
    use Games::MapWalker::Types;

    has number => (
        is  => 'rw',
        isa => 'NonNegativeNum',
    );

    1;

=head1 DESCRIPTION

Games::Gridwalker::Types Provides types used by Games::MapWalker
classes.

=head1 SEE ALSO

=over 4

=item * L<Games::MapWalker>

=back

=cut

