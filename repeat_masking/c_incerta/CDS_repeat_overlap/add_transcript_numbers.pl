#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);

#adds transcript numbers (from fasta file) to gene IDs in list
#usage: perl add_transcript_numbers.pl --list genes.txt --fasta in.fa --out genes_with_transcripts.txt

my $list;
my $fasta;
my $out;

GetOptions(
        'list=s' => \$list,
        'fasta=s' => \$fasta,
        'out=s' => \$out,
) or die "missing input\n";

open (IN1, "$list") or die;

my %index;

while (my $line = <IN1>) {
	chomp $line;
	$index{$line} = 1;
}

close IN1;

open (IN2, "$fasta") or die;
open (OUT, ">$out") or die;

while (my $fline = <IN2>) {
	chomp $fline;
	if ($fline =~ /^>/) {
		my $ID = substr($fline, 1);
		my @fcols = split(/\./, $ID);
		if (exists $index{$fcols[0]}) {
			print OUT "$ID\n";
		}
	}
}

close IN2;
close OUT;

exit;
