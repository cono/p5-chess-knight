#!/usr/bin/perl 

use strict;
use warnings;

use File::Spec;
use FindBin qw|$Bin|;
use lib File::Spec->catdir($Bin, qw|.. lib|);

use CK::Piece::Knight;
use CK::Graph;

my $filename = shift;
my $graph    = CK::Graph->new(
    filename => $filename,
    piece    => 'Knight'
);

$graph->create;
$graph->walk;

$graph->print;
