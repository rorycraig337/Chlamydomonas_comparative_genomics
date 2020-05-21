#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;

#script to take ENSEMBL formatted BRAKER2 GTF file and a list of transcripts
#will modify GTF to remove transcripts, fixing the gene coordinates if one transcript of a multi-isoform gene is removed
#assumes list of transcripts does not contain duplicates
#usage: perl filterGTF.pl --gtf in.gtf --filter list.txt --out out.gtf

my $gtf;
my $filter;
my $out;

GetOptions(
	'gtf=s' => \$gtf,
	'filter=s' => \$filter,
	'out=s' => \$out,
) or die "missing input\n";

open (IN1, "$gtf") or die;

my %transcript_coor;

#first pass through GTF, build hash of transcript coordinates

while (my $gline = <IN1>) {
	chomp $gline;
	unless ($gline =~ /^#/) {
		my @gcols = split(/\t/, $gline);
		if ($gcols[2] eq "transcript") {
			my @info = split(/\./, $gcols[8]);
			push (@{$transcript_coor{$info[0]}}, "$gcols[8]\t$gcols[3]\t$gcols[4]");
		}
	}
}

#print Dumper(\%transcript_coor);

close IN1;

open (IN2, "$filter") or die;

my %filter_index1;
my %filter_index2;

#build hash containing gene and transcripts to filter

while (my $fline = <IN2>) {
	chomp $fline;
	my @fcols = split(/\./, $fline);
	$filter_index1{$fcols[0]}++;
	$filter_index2{$fline} = 1;
} 

close IN2;

open (IN3, "$gtf") or die;
open (OUT, ">$out") or die;

#filter transcripts and fix genes if neccessary

my $count = 0;
my $t_count = 0;
my $gcount1 = 0;
my $gcount2 = 0;
my $gene;
my @gene_model;

while (my $line = <IN3>) {
	chomp $line;
	if ($line eq "###") {
		$count++;
		if ($count > 1) {
			my @ginfo = split(/\t/, $gene);
			if (exists $filter_index1{$ginfo[8]}) { #gene contains at least one transcript to filter
#				print "$ginfo[8]\n$filter_index1{$ginfo[8]}\n$t_count\n";
				$gcount1++;
				if ($filter_index1{$ginfo[8]} != $t_count) { #not all isoforms of gene are to be filtered
#					print "$ginfo[8]\n$filter_index1{$ginfo[8]}\n$t_count\n";
					$gcount2++;
					my $start = 0;
					my $stop = 0;
					foreach my $isoform (@{$transcript_coor{$ginfo[8]}}) { #get new gene coordinates after exluding the neccessary transcripts
						my @icols = split(/\t/, $isoform);
						unless (exists $filter_index2{$icols[0]}) {
							if ($start == 0) {
								$start = $icols[1];
							}
							elsif ($icols[1] < $start) {
								$start = $icols[1];
							}
							if ($stop == 0) {
								$stop = $icols[2];
							}
							elsif ($icols[2] > $stop) {
								$stop = $icols[2];
							}
						}
					}
					print OUT "$ginfo[0]\t$ginfo[1]\t$ginfo[2]\t$start\t$stop\t$ginfo[5]\t$ginfo[6]\t$ginfo[7]\t$ginfo[8]\n";
					foreach my $elem (@gene_model) {
						my @einfo = split(/\t/, $elem);
						my @elast = split(";", $einfo[8]);
						if ($einfo[2] eq "transcript") {
							unless (exists $filter_index2{$einfo[8]}) {
                                                               	print OUT "$elem\n";
                                                       	}
						}
						else {
							my $strip1 = substr $elast[0], 15;
							my $strip2 = substr($strip1, 0, -1);
							unless (exists $filter_index2{$strip2}) {
								print OUT "$elem\n";
							}
						}
					}
					print OUT "###\n";
				}
			}
			else {
				print OUT "$gene\n";
				foreach my $elem (@gene_model) {
					print OUT "$elem\n";
				}
				print OUT "###\n";
			}
		}
		else {
			print OUT "###\n";
		}
		undef $gene;
		undef @gene_model;
		$t_count = 0;
	}
	else {
		my @cols = split(/\t/, $line);
		if ($cols[2] eq "gene") {
			$gene = $line;
		}
		elsif ($cols[2] eq "transcript") {
			$t_count++;
			push @gene_model, $line;
		}
		else {
			push @gene_model, $line;
		}
	}
}

close IN3;
close OUT;

my $gcount3 = $gcount1 - $gcount2;

print "$gcount1 genes affected, $gcount3 removed entirely\n";

exit;
