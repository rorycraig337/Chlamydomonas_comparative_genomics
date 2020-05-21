#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;

#converts gene entries in gff3 to bed6
#allows filtering of genes by a list
#converted from script to extract CDS
#usage: perl CDS_ggf2bed.pl --gff in.gff --filter list.txt --out cds.bed

my $gff;
my $list;
my $out;

GetOptions(
	'gff=s' => \$gff,
	'list=s' => \$list,
	'out=s' => \$out,
) or die "missing input\n";

open (IN1, "$list") or die;

my %filter;

while (my $fline = <IN1>) {
	chomp $fline;
	$filter{$fline} = 1;
}

close IN1;

open (IN, "$gff") or die;
open (OUT, ">$out") or die;

my $p = 0;
my $gene;
my $cds = 0;
my $f = 0;

while (my $line = <IN>) {
	unless ($line =~ /^#/) {
		chomp $line;
		my @cols = split(/\t/, $line);
		if ($cols[2] eq "gene") {
			my @i1 = split(/;/, $cols[8]);
			my @i2 = split(/=/, $i1[0]);
			my @i3 = split(/\./, $i2[1]);
			$gene = $i3[0] . "." . $i3[1];
			if (exists $filter{$gene}) {
				$p = 0;
				$f++;
			}
			else {
				$p = 1;
				print OUT "$cols[0]\t$cols[3]\t$cols[4]\t$gene\t0\t$cols[6]\n"; #keep it 1-based, not proper BED but we need 1-based later
			}
			$cds = 0;
		}
	}
}

print "$f filtered genes\n";

close IN;
close OUT;

exit;
