package CK::Piece::Knight;

use strict;
use warnings;

use Tie::Array;
our @ISA = qw( Tie::Array );

our @MOVES = (
    [-2,  1],
    [-1,  2],
    [ 1,  2],
    [ 2,  1],
    [ 2, -1],
    [ 1, -2],
    [-1, -2],
    [-2, -1]
);
 
sub TIEARRAY {
    my $class = shift;
    my $param = {
        _iteration => 0
    };

    return bless($param, $class);
}

sub STORE {
    die "STORE error: read only";
}

sub FETCH {
    my $self  = shift;
    my $index = shift;

    return {
        x => $MOVES[$index]->[0],
        y => $MOVES[$index]->[1]
    };
}

sub FETCHSIZE {
    return scalar @MOVES;
}

sub STORESIZE {
    die "STORESIZE error: read only";
}

sub EXTEND {
    die "EXTEND error: read only";
}

sub EXISTS {
    die "EXISTS error: deprecated method";
}

sub DELETE {
    die "DELETE error: read only";
}

sub CLEAR {
    die "CLEAR error: read only";
}

sub DESTROY { }

sub PUSH {
    die "PUSH error: read only";
}

sub POP {
    die "POP error: read only";
}

sub SHIFT {
    die "SHIFT error: read only";
}

sub UNSHIFT {
    die "UNSHIFT error: read only";
}

sub SPLICE {
    die "SPLICE error: read only";
}

42;
