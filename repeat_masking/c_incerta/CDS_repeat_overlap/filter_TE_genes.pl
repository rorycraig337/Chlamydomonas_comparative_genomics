#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);

#filters ouput of gene_TE_overlap.pl based upon overlap of CDS by TEs/satellites/rRNA or simple/low-complexity repeats
#usage: perl filter_TE_genes.pl --overlap repeat_overlap.tsv --TE 30 --simple 70 --out filter.txt

my $overlap;
my $TE;
my $simple;
my $out;

GetOptions(
        'overlap=s' => \$overlap,
        'TE=i' => \$TE,
        'simple=i' => \$simple,
        'out=s' => \$out,
) or die "missing input\n";

open (IN, "$overlap") or die;
open (OUT, ">$out") or die;

my $header = <IN>;

while (my $line = <IN>) {
	chomp $line;
	my @cols = split(/\t/, $line);
	if (($cols[3] >= $TE) or ($cols[4] >= $simple)) {
		print OUT "$cols[0]\n";
	}
}

close IN;
close OUT;

exit;
