#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;

#scipt to take gff of genes and bed files of TE and non-TE repeat locations, and to extract % overlap between full transcript and CDS of each gene
#requires bedtools
#usage: perl gene_TE_overlap.pl --gff genes.gff --TEs TEs.bed --repeats other_repeats.bed --out chlamy_v5.repeat_overlap.tsv

my $gff;
my $TEs;
my $repeats;
my $out;

GetOptions(
	'gff=s' => \$gff,
	'TEs=s' => \$TEs,
	'repeats=s' => \$repeats,
	'out=s' => \$out,
) or die "missing input\n";

open (IN1, "$gff") or die;
open (OUT1, ">$out") or die;

print OUT1 "gene\t%TE\t%other\tCDS%TE\tCDS%other\n";

my $pro = 0;
my $transL = 0;
my $cdsL = 0;
my $geneID;

while (my $line = <IN1>) {
	chomp $line;
	my @cols = split(/\t/, $line);
	if ( ($line !~ /^#/) and ($cols[2] eq "gene") ) {
		$pro = 1;
		$geneID = substr ($cols[8], -13);
		open (OUT2, ">temp_transcript.bed") or die;
		open (OUT3, ">temp_CDS.bed") or die;
	}
	elsif ( ($line !~ /^#/) and ($cols[2] eq "exon") and ($pro == 1) ) {
		my $estart = $cols[3] - 1;
		print OUT2 "$cols[0]\t$estart\t$cols[4]\t$geneID\t.\t$cols[6]\n";
	}
	elsif ( ($line !~ /^#/) and ($cols[2] eq "CDS") and ($pro == 1) ) {
		my $cstart = $cols[3] - 1;
		print OUT3 "$cols[0]\t$cstart\t$cols[4]\t$geneID\t.\t$cols[6]\n";
	}
	elsif ( ($line =~ /^###/) and ($pro == 1) ) {
		close OUT2;
		close OUT3;
		system("sort -k1,1 -k2n,2n temp_transcript.bed > temp_transcript.s.bed");
		system("sort -k1,1 -k2n,2n temp_CDS.bed > temp_CDS.s.bed");
		system("bedtools merge -i temp_transcript.s.bed > temp_transcript.m.bed");
		system("bedtools merge -i temp_CDS.s.bed > temp_CDS.m.bed");
		open (IN4, "temp_transcript.m.bed") or die;
		while (my $tline = <IN4>) {
			chomp $tline;
			my @tcols = split(/\t/, $tline);
			$transL += ($tcols[2] - $tcols[1]);
		}
		close IN4;
		open (IN5, "temp_CDS.m.bed") or die;
		while (my $cline = <IN5>) {
			chomp $cline;
			my @ccols = split(/\t/, $cline);
			$cdsL += ($ccols[2] - $ccols[1]);
		}
		close IN5;
		system("bedtools intersect -a temp_transcript.m.bed -b $TEs > temp_TE.t.bed");
		system("bedtools intersect -a temp_CDS.m.bed -b $TEs > temp_TE.c.bed");
		system("bedtools intersect -a temp_transcript.m.bed -b $repeats > temp_other.t.bed");
		system("bedtools intersect -a temp_CDS.m.bed -b $repeats > temp_other.c.bed");
		system("sort -k1,1 -k2n,2n temp_TE.t.bed > temp_TE.ts.bed");
		system("sort -k1,1 -k2n,2n temp_TE.c.bed > temp_TE.cs.bed");
		system("sort -k1,1 -k2n,2n temp_other.t.bed > temp_other.ts.bed");
		system("sort -k1,1 -k2n,2n temp_other.c.bed > temp_other.cs.bed");
		system("bedtools merge -i temp_TE.ts.bed > temp_TE.tm.bed");
		system("bedtools merge -i temp_other.ts.bed > temp_other.tm.bed");
		system("bedtools merge -i temp_TE.cs.bed > temp_TE.cm.bed");
		system("bedtools merge -i temp_other.cs.bed > temp_other.cm.bed");
		my $o1 = 0;
		my $o2 = 0;
		my $o3 = 0;
		my $o4 = 0;
		open (IN2, "temp_TE.tm.bed") or die;
		while (my $oline1 = <IN2>) {
			chomp $oline1;
			my @ocols1 = split(/\t/, $oline1);
			$o1 += ($ocols1[2] - $ocols1[1]);
		}
		close IN2;
		open (IN3, "temp_other.tm.bed") or die;
		while (my $oline2 = <IN3>) {
			chomp $oline2;
			my @ocols2 = split(/\t/, $oline2);
			$o2 += ($ocols2[2] - $ocols2[1]);
		}
		close IN3;


		open (IN6, "temp_TE.cm.bed") or die;
		while (my $oline3 = <IN6>) {
			chomp $oline3;
			my @ocols3 = split(/\t/, $oline3);
			$o3 += ($ocols3[2] - $ocols3[1]);
		}
		close IN6;
		open (IN7, "temp_other.cm.bed") or die;
		while (my $oline4 = <IN7>) {
			chomp $oline4;
			my @ocols4 = split(/\t/, $oline4);
			$o4 += ($ocols4[2] - $ocols4[1]);
		}
		close IN7;


		my $op1t = ($o1 / $transL) * 100;
		my $op1c = ($o3 / $cdsL) * 100;
		my $op2t = ($o2 / $transL) * 100;
		my $op2c = ($o4 / $cdsL) * 100;
		print OUT1 "$geneID\t$op1t\t$op2t\t$op1c\t$op2c\n";
		system("rm temp*");
		$transL = 0;
		$cdsL = 0;
		undef $geneID;
	}
}

close IN1;
close OUT1;

exit;
