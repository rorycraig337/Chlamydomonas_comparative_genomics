#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;

#takes full-genome maf file and fai for reference species, and splits maf to each fai element
#requires mafTools
#usage: perl maf_fai_splitter.pl --maf in.maf --fai genome.fai --ref ref

my $maf;
my $fai;
my $ref;

GetOptions(
	'maf=s' => \$maf,
	'fai=s' => \$fai,
	'ref=s' => \$ref,
) or die "missing input\n";

open (IN, "$fai") or die;

while (my $elem = <IN>) {
	chomp $elem;
	my @cols = split(/\t/, $elem);
	my $seq = $ref . "." . $cols[0];
	my $out = $cols[0] . ".maf";
	system("mafExtractor --maf $maf --seq $seq --start 0 --stop $cols[1] > $out");
}

close IN;

exit;
