#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);

#script parses Phytozome GFF3 for chlamy and splits to site classes
#currently extracts CDS, 5' UTRs, 3' UTRs, introns & intergenic
#site classes may overlap, additional files with overlap removed based on site class hierarchy: CDS > 5' UTR > 3' UTR > intron > intergenic
#requires a bed file with chromosome coordinates ("genome.bed")
#also filters on list of genes
#usage: extract_phytozome_site_class.pl --gff3 chlamy.gff3 --list list.txt

my $gff3;
my $list;

GetOptions(
	'gff3=s' => \$gff3,
	'list=s' => \$list,
) or die "missing input\n";

open (IN0, "$list") or die;

my %filter;

while (my $fline = <IN0>) {
	chomp $fline;
	$filter{$fline} = 1;
}

close IN0;


#extract initial site classes from GFF3

open (IN, "$gff3") or die;
open (OUT1, ">genes.bed") or die;
open (OUT2, ">CDS.bed") or die;
open (OUT3, ">five_prime_UTR.bed") or die;
open (OUT4, ">three_prime_UTR.bed") or die;

my $p = 0;
my $gene;
my $f = 0;

while (my $line = <IN>) {
	unless ($line =~ /^#/) {
		chomp $line;
		my @cols = split(/\t/, $line);
		my $start = $cols[3] - 1;
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
				print OUT1 "$cols[0]\t$start\t$cols[4]\n";
			}
		}
		elsif ( ($cols[2] eq "CDS") and ($p == 1) ) {
			print OUT2 "$cols[0]\t$start\t$cols[4]\n";
		}
		elsif ( ($cols[2] eq "five_prime_UTR") and ($p == 1) ) {
			print OUT3 "$cols[0]\t$start\t$cols[4]\n";
		}
		elsif ( ($cols[2] eq "three_prime_UTR") and ($p == 1) ) {
			print OUT4 "$cols[0]\t$start\t$cols[4]\n";
		}
	}
}

print "$f filtered genes\n";

close IN;
close OUT1;
close OUT2;
close OUT3;
close OUT4;

#sort and merge bed files

system("sort -k1,1 -k2n,2n genes.bed | bedtools merge -i stdin > m_genes.bed");
system("sort -k1,1 -k2n,2n CDS.bed | bedtools merge -i stdin > m_CDS.bed");
system("sort -k1,1 -k2n,2n five_prime_UTR.bed | bedtools merge -i stdin > m_five_prime_UTR.bed");
system("sort -k1,1 -k2n,2n three_prime_UTR.bed | bedtools merge -i stdin > m_three_prime_UTR.bed");

#create initial intron and intergenic bed files

system("bedtools subtract -a m_genes.bed -b m_CDS.bed > m_intronic.bed");
system("bedtools subtract -a genome.bed -b m_genes.bed > m_intergenic.bed");

#create unique site class files

system("bedtools subtract -a m_five_prime_UTR.bed -b m_CDS.bed > u_five_prime_UTR.bed");
system("cat m_CDS.bed m_five_prime_UTR.bed | sort -k1,1 -k2n,2n | bedtools merge -i stdin > h1.bed");
system("bedtools subtract -a m_three_prime_UTR.bed -b h1.bed > u_three_prime_UTR.bed");
system("cat m_CDS.bed m_five_prime_UTR.bed m_three_prime_UTR.bed | sort -k1,1 -k2n,2n | bedtools merge -i stdin > h2.bed");
system("bedtools subtract -a m_intronic.bed -b h2.bed > u_intronic.bed");
system("cat m_CDS.bed m_five_prime_UTR.bed m_three_prime_UTR.bed m_intronic.bed | sort -k1,1 -k2n,2n | bedtools merge -i stdin > h3.bed");
system("bedtools subtract -a m_intergenic.bed -b h3.bed > u_intergenic.bed");

exit;
