#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;

#script takes fasta file of CDS and checks for internal stop codons
#usage: perl internal_stop_check.pl --cds cds.fa --out internal_stops.txt

my $cds;
my $out;

GetOptions(
	'cds=s' => \$cds,
	'out=s' => \$out,
) or die "missing input\n";

open (IN, "$cds") or die;
open (OUT, ">$out") or die;

my $seq;
my $id;
my $count = 0;

while (my $line = <IN>) {
	chomp $line;
	if ($line =~ /^>/) {
		$count++;
		unless ($count == 1) {
			my $fullseq = substr $seq, 1;
			my $ucfs = uc $fullseq;
			my $l = length $ucfs;
			if (($l % 3) != 0) {
				die "$id not divisible by 3\n";
			}
			my @codons = $ucfs =~ /.../g;
			my $last = pop @codons;
#			if ( ($last ne "TAG") and ($last ne "TGA") and ($last ne "TAA") ) {
#				die "$id missing stop codon\n";
#			}
			foreach my $codon (@codons) {
				if ( ($codon eq "TAG") or ($codon eq "TGA") or ($codon eq "TAA") ) {
					print OUT "$id\n";
					last;
				}
			}
		}
		$id = substr $line, 1;
		$seq = "N";
	}
	else {
		$seq = $seq . $line;
	}
}

my $fullseq = substr $seq, 1;
my $ucfs = uc $fullseq;
my $l = length $ucfs;
if (($l % 3) != 0) {
	die "$id not divisible by 3\n";
}
my @codons = $ucfs =~ /.../g;
my $last = pop @codons;
#if ( ($last ne "TAG") and ($last ne "TGA") and ($last ne "TAA") ) {
#	die "$id missing stop codon\n";
#}
foreach my $codon (@codons) {
	if ( ($codon eq "TAG") or ($codon eq "TGA") or ($codon eq "TAA") ) {
		print OUT "$id\n";
		last;
	}
}

close IN;
close OUT;

exit;
