#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;

#script to extract gene names of longest splice forms from BRAKER gtf
#extracts longest proteins, which may not be longest transcript
#usage: perl extract_longest_ids.pl --gtf in.gtf --out ids.txt

my $gtf;
my $out;

GetOptions(
	'gtf=s' => \$gtf,
	'out=s' => \$out,
) or die "missing input\n";

open (IN, "$gtf") or die;
open (OUT, ">$out") or die;

my $pro = 0;
my $gene;
my $mrna = 0;
my $exon = 0;
my $count = 0;
my %exon_index;
my @tID;

while (my $line = <IN>) {
	chomp $line;
	my @cols = split(/\t/, $line);
	if ( ($line !~ /^#/) and ($cols[2] eq "gene") ) {
		$pro = 1;
		$count++;
		$gene = $cols[8];
	}
	if ( ($line !~ /^#/) and ($cols[2] eq "transcript") and ($pro == 1) ) {
		$mrna++;
		$exon = 0;
		my @info = split(/\./, $cols[8]);
		push @tID, $info[1];
	}
	if ( ($line !~ /^#/) and ($cols[2] eq "CDS") and ($pro == 1) ) {
		$exon++;
		my $start = $cols[3] - 1;
		$exon_index{$mrna}{$exon} = "$cols[0]\t$start\t$cols[4]";
	}
	if ( ($count > 0) and ($line =~ /^###/) and ($pro == 1) ) {
		if ($mrna == 1) {
			print OUT "$gene.$tID[0]\n";
		}
		else {
			my %cumu_length;
			for (my $i=1; $i <= $mrna; $i++) {
				foreach my $exon_key (sort {$a <=> $b} keys %{$exon_index{$i}}) {
					my @exon_cols = split(/\t/, $exon_index{$i}{$exon_key});
					$cumu_length{$i} += ($exon_cols[2] - $exon_cols[1]);
				}
			}
			my @longest = sort { $cumu_length{$a} <=> $cumu_length{$b} } keys %cumu_length;
#			print Dumper(\%cumu_length);
			my $lcf = $longest[-1];
			my $tlcf= $lcf - 1;
			print "$lcf\n";
			print "$gene\n";
			print OUT "$gene.$tID[$tlcf]\n";
			print "$tID[$tlcf]\n";
		}
		%exon_index = ();
		$pro = 0;
		$mrna = 0;
		$exon = 0;
		undef @tID;
	}
}

close IN;
close OUT;

exit;
