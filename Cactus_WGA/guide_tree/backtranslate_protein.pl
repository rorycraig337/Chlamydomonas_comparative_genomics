#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;
use Bio::AlignIO;
use Bio::SimpleAlign;

#script to take fasta file for protein alignment, and fasta file containing nucleotide sequences, and backtranslate to nucleotide alignment
#will only consider sites with an aligned amino acid in all species
#species in alignments are ordered with user defined list
#usage: perl backtranslate_protein.pl --prot prot.fa --nuc nuc.fa --list order.txt --out aligned_codons.fa

my $prot;
my $nuc;
my $list;
my $out;

GetOptions(
	'prot=s' => \$prot,
	'nuc=s' => \$nuc,
	'list=s' => \$list,
	'out=s' => \$out,
) or die "missing input\n";

#build hash of codon table for validation

my %aacode = (
  TTT => "F", TTC => "F", TTA => "L", TTG => "L",
  TCT => "S", TCC => "S", TCA => "S", TCG => "S",
  TAT => "Y", TAC => "Y", TAA => "X", TAG => "X",
  TGT => "C", TGC => "C", TGA => "X", TGG => "W",
  CTT => "L", CTC => "L", CTA => "L", CTG => "L",
  CCT => "P", CCC => "P", CCA => "P", CCG => "P",
  CAT => "H", CAC => "H", CAA => "Q", CAG => "Q",
  CGT => "R", CGC => "R", CGA => "R", CGG => "R",
  ATT => "I", ATC => "I", ATA => "I", ATG => "M",
  ACT => "T", ACC => "T", ACA => "T", ACG => "T",
  AAT => "N", AAC => "N", AAA => "K", AAG => "K",
  AGT => "S", AGC => "S", AGA => "R", AGG => "R",
  GTT => "V", GTC => "V", GTA => "V", GTG => "V",
  GCT => "A", GCC => "A", GCA => "A", GCG => "A",
  GAT => "D", GAC => "D", GAA => "E", GAG => "E",
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

#add nucleotide fasta sequences to a hash

open (IN2, "$nuc") or die;

my %seq_index;
my %gap_tally;
my $spp_id;
my $spp_count = 0;
my $line_count = 0;
my $spp_seq;

while (my $fline = <IN2>) {
	chomp $fline;
	if ($fline =~ /^>/) {
		if ($spp_count > 0) {
			if ( ( (length $spp_seq) % 3) == 1) {
				$seq_index{$spp_id} = substr $spp_seq, 1; #BUSCO nuc sequences rarely have bases upstream of first codon
			}
                       	elsif ( ( (length $spp_seq) % 3) == 2) {
                               	$seq_index{$spp_id} = substr $spp_seq, 2; #BUSCO nuc sequences rarely have bases upstream of first codon
                        }
			else {
				$seq_index{$spp_id} = $spp_seq;
			}
		}
		$spp_id = substr($fline, 1);
		$gap_tally{$spp_id} = 0; #initialise hash at 0 for use later
		undef $spp_seq;
		$spp_count++;
		$line_count = 0;
	}
	else {
		my $uc_seq = uc $fline;
		if ($line_count == 0) {
			$spp_seq = $uc_seq;
		}
		else {
			$spp_seq = $spp_seq . $uc_seq;
		}
		$line_count++;
	}
}

#add final fasta sequence to hash

if ( ( (length $spp_seq) % 3) == 1) {
	$seq_index{$spp_id} = substr $spp_seq, 1;
}
elsif ( ( (length $spp_seq) % 3) == 2) {
        $seq_index{$spp_id} = substr $spp_seq, 2;
}
else {
	$seq_index{$spp_id} = $spp_seq;
}

close IN2;

#loop through aligned amino acids in protein file, and extract codons for columns with alignment in all species

my %codons;

my $str = Bio::AlignIO->new(-file => "$prot",
	-format => "fasta" );
my $aln = $str->next_aln();
my $aln_ordered=$aln->sort_by_list($list);
my $len = $aln_ordered->length();
my $pos = 1;
my $hit = 0;
until ($pos == $len) {
	my @aa;
	my $gap = 0;
	my $x = 0;
	my $loop1 = 0;
	foreach my $seq ($aln_ordered->each_seq) {
		my $res = $seq->subseq($pos, $pos);
		push @aa, $res;
		if ($res eq "-") {
			$gap = 1; #gap present in alignment, won't be considered
			$gap_tally{$spp_order{$loop1}}++; #tally number of gaps seen so far for each species
		}
		if ($res eq "X") { #some BUSCOs rarely contain internal stop codons as X residues
			$x = 1;
		}
		$loop1++;
	}
	if ( ($gap == 0) and ($x == 0) ) { #good site, extract codons
		$hit++;
		my $loop2 = 0;
		foreach my $amino (@aa) {
			my $nuc_pos = $pos - $gap_tally{$spp_order{$loop2}}; #extract gaps that have been seen so far, nuc sequence doesn't contain gaps
			my $base1 = ($nuc_pos * 3) - 3; #get coordinates for codon bases i.e. for amino acid 1, this would be nucloetide coordinates 0,1,2
			my $base2 = ($nuc_pos * 3) - 2;
			my $base3 = ($nuc_pos * 3) - 1;
			my @sequence = split("", $seq_index{$spp_order{$loop2}}); #split nucleotide sequence to per-base array
			my $codon = $sequence[$base1] . $sequence[$base2] . $sequence[$base3]; #combine bases of codon
			if ($hit == 1) {
				$codons{$spp_order{$loop2}} = $codon;
			}
			else {
				$codons{$spp_order{$loop2}} = $codons{$spp_order{$loop2}} . $codon; #add codon to sequence array for species
			}
			if ($aacode{$codon} ne "$amino") {
				die "extracted codon $codon does not equal $amino for $spp_order{$loop2}} at position $pos\n";
			}
			$loop2++;
		}
	}
	$pos++;
}

open (OUT, ">$out") or die;

foreach my $species (sort {$a <=> $b} keys %spp_order) {
	my $header = ">" . $spp_order{$species};
	print OUT "$header\n";
	print OUT "$codons{$spp_order{$species}}\n";
}

close OUT;

exit;
