#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);

#script to take faidx for a genome, and produce a BED file containing contigs

my $fai;
my $out;

GetOptions(
        'fai=s' => \$fai,
        'out=s' => \$out,  
) or die "missing input\n";

open (IN, "$fai") or die;
open (OUT, ">$out") or die;

while (my $line = <IN>) {
	chomp $line;
	my @cols = split(/\t/, $line);
	my $length = $cols[1];
	print OUT "$cols[0]\t0\t$length\n";
}

close IN;
close OUT;

exit;

