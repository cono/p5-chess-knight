package CK::Graph;

use strict;
use warnings;

use CK::Graph::Point;

sub MAX_X() { 8 }
sub MAX_Y() { 8 }
sub A() { ord('a') }

sub new {
    my $class = shift;
    my %param = @_;

    my $self = bless(\%param, $class);
    $self->_init;

    return $self;
}

sub _index {
    my ($x, $y) = @_;

    return ($x * MAX_X + $y);
}

sub _init {
    my $self = shift;

    if ($self->{'filename'}) {
        my $line = do {
            open(my $fh, '<', $self->{'filename'})
                or die "Can't open file $self->{'filename'}: $!";
            my $tmp = <$fh>;
            chomp($tmp);
            $tmp;
        };

        @$self{ qw|start stop| } = split /\s+/, $line;
    }

    my $board = [];
    for (my $x = 0; $x < MAX_X; ++$x) {
        for (my $y = 0; $y < MAX_Y; ++$y) {
            $board->[_index($x, $y)] = CK::Graph::Point->new(
                x => chr(A + $x),
                y => ($y + 1)
            );
        }
    }

    for my $p ( qw|start stop| ) {
        my %coords;
        @coords{ "${p}_x", "${p}_y" } = split //, $self->{$p};

        $coords{"${p}_x"} = ord($coords{"${p}_x"}) - A;
        --$coords{"${p}_y"};

        $self->{"${p}_point"} = $board->[_index($coords{"${p}_x"}, $coords{"${p}_y"})];
    }

    $self->{'_board'}  = $board;
    $self->{'_result'} = [];
}

sub _is_valid_coords {
    my ($x, $y) = @_;

    return 0 if $x < 0 || $y < 0;

    return 1 if $x < MAX_X && $y < MAX_Y;

    return 0;
}

sub create {
    my $self  = shift;
    my $board = $self->{'_board'};
    my @piece;
    my $piece_class = "CK::Piece::$self->{'piece'}";

    tie @piece, $piece_class;

    for (my $x = 0; $x < MAX_X; ++$x) {
        for (my $y = 0; $y < MAX_Y; ++$y) {
            for my $move ( @piece ) {
                my ($new_x, $new_y) = (
                    $move->{'x'} + $x,
                    $move->{'y'} + $y
                );

                next unless _is_valid_coords($new_x, $new_y);

                $board->[_index($x, $y)]->set_link( $board->[_index($new_x, $new_y)] );
            }
        }
    }
}

sub set_weights {
    my $self   = shift;
    my @queue  = ( $self->{'start_point'} );
    $queue[-1]->set_weight(1);

    while ( scalar @queue ) {
        my $point  = shift @queue;
        my $weight = $point->get_weight + 1;

        for my $p ( grep { $_->is_active } $point->get_links ) {
            push @queue, $p->set_weight($weight);
        }
        $point->disable;
    }
}

sub find_the_way {
    my $self       = shift;
    my $end        = $self->{'stop_point'};
    my $max_weight = $end->get_weight;
    my @stack      = ( $self->{'start_point'} );
    my $result     = $self->{'_result'};

    while (42) {
        my $point  = pop @stack;
        my $weight = $point->get_weight;
        $result->[$weight - 1] = $point;

        if ($weight == $max_weight) {
            return if $point->equal_to($end);
        } else {
            push @stack, grep {
                $_->get_weight > $weight
            } $point->get_links;
        }
    }
}

sub walk {
    my $self = shift;

    $self->set_weights;
    $self->find_the_way;
}

sub print {
    my $self   = shift;
    my $board  = $self->{'_board'};
    my $result = $self->{'_result'};

    print "  a b c d e f g h  \n\n";
    for (my $y = MAX_Y; $y; --$y) {
        printf("%d ", $y);

        CYCLE_Y:
        for (my $x = 0; $x < MAX_Y; ++$x) {
            my $point = $board->[_index($x, $y - 1)];

            for my $p ( @$result ) {
                if ( $p->equal_to($point) ) {
                    printf("%d ", $p->get_weight);
                    next CYCLE_Y;
                }
            }

            print "  ";
        }

        printf("%d\n\n", $y);
    }
    print "  a b c d e f g h  \n\n";
}

sub results {
    my $self   = shift;
    my $result = $self->{'_result'};

    return map { $_->x . $_->y } @$result;
}

42;
