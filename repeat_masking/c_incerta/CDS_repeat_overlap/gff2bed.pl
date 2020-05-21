#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;

#converts gff3 to bed
#usage: perl ggf2bed.pl --gff in.gff --out out.bed

my $gff;
my $out;

GetOptions(
	'gff=s' => \$gff,
	'out=s' => \$out,
) or die "missing input\n";

open (IN, "$gff") or die;
open (OUT, ">$out") or die;

while (my $line = <IN>) {
	unless ($line =~ /^#/) {
		chomp $line;
		my @cols = split(/\t/, $line);
		my $start = $cols[3] - 1;
		print OUT "$cols[0]\t$start\t$cols[4]\n";
	}
}

close IN;
close OUT;

exit;
