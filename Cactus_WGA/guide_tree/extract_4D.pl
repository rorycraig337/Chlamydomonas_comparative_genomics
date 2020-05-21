#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;
use Bio::AlignIO;
use Bio::SimpleAlign;

#script extract 4D sites from alignment of codons
#usage: extract_4D.pl --in codons.fa --list species.txt --out 4D.fa

my $in;
my $list;
my $out;

GetOptions(
	'in=s' => \$in,
	'list=s' => \$list,
	'out=s' => \$out,
) or die "missing input\n";

my %fD_codons = (
  TCT => "S", TCC => "S", TCA => "S", TCG => "S",
  CTT => "L", CTC => "L", CTA => "L", CTG => "L",
  CCT => "P", CCC => "P", CCA => "P", CCG => "P",
  CGT => "R", CGC => "R", CGA => "R", CGG => "R",
  ACT => "T", ACC => "T", ACA => "T", ACG => "T",
  GTT => "V", GTC => "V", GTA => "V", GTG => "V",
  GCT => "A", GCC => "A", GCA => "A", GCG => "A",
  GGT => "G", GGC => "G", GGA => "G", GGG => "G",
);

#read in species from list

open (IN1, "$list") or die;

my %spp_order;
my $spp_number = 0;

while (my $lline = <IN1>) {
	chomp $lline;
	$spp_order{$spp_number} = $lline;
	$spp_number++;
}

close IN1;

my %fDseq;

my $str = Bio::AlignIO->new(-file => "$in",
	-format => "fasta" );
my $aln = $str->next_aln();
my $aln_ordered=$aln->sort_by_list($list);
my $len = $aln_ordered->length();
my $pos = 1;
my $hit = 0;
until ($pos == ($len + 1)) {
	my @fDsites;
	my $ns = 0;
	foreach my $seq ($aln_ordered->each_seq) {
		my $end = $pos + 2;
		my $codon = $seq->subseq($pos, $end);
		my $site3 = $seq->subseq($end, $end);
		unless (exists $fD_codons{$codon}) { #does codon contain 4D site?
			$ns = 1;
		}
		push @fDsites, $site3;
	}
	if ($ns == 0) { #all codons contain 4D site
		$hit++;
		my $loop = 0;
		foreach my $fDsite (@fDsites) {
			if ($hit == 1) {
				$fDseq{$spp_order{$loop}} = $fDsite;
			}
			else {
				$fDseq{$spp_order{$loop}} = $fDseq{$spp_order{$loop}} . $fDsite;
			}
			$loop++;
		}
	}
	$pos = $pos + 3;
}

open (OUT, ">$out") or die;

foreach my $species (sort {$a <=> $b} keys %spp_order) {
	my $header = ">" . $spp_order{$species};
	print OUT "$header\n";
	print OUT "$fDseq{$spp_order{$species}}\n";
}

close OUT;

exit;
