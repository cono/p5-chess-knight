package CK::Graph::Point;

use strict;
use warnings;

use Scalar::Util qw(weaken);
 
sub new {
    my $class = shift;
    my %param = @_;

    $param{'_links'}  = [];
    # 0 means infinity
    $param{'_weight'} = 0;
    $param{'_active'} = 1;

    return bless(\%param, $class);
}

sub is_active { $_[0]->{'_active'} }

sub set_link {
    my $self  = shift;
    my $to    = shift;
    my $links = $self->{'_links'};

    push @$links, $to;
    weaken($links->[-1]);
}

sub get_links {
    my $self  = shift;
    my $links = $self->{'_links'};

    return @$links;
}

sub set_weight {
    my $self   = shift;
    my $weight = shift;

    if ( !$self->{'_weight'} || $weight < $self->{'_weight'} ) {
        $self->{'_weight'} = $weight;

        return $self;
    }

    return ();
}

sub get_weight { $_[0]->{'_weight'} }

sub disable {
    my $self = shift;

    $self->{'_active'} = 0;
}

sub equal_to {
    my ($self, $target) = @_;

    return 1 if $self->x eq $target->x && $self->y == $target->y;
    return 0;
}

sub x { $_[0]->{'x'} }

sub y { $_[0]->{'y'} }

42;
