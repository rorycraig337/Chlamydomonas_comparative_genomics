#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);

#script to remove "unknown" repeat sequences identified by RepeatModeller that have BLASTn hits to known transcripts
#will remove the relevant sequences from a fasta file of repeats
#usage: perl filter_repeat_modeler_hits.pl --blast blast.out --cutoff 0.001 --fasta repeats.fa --out repeats_filtered.fa

my $blast;
my $cutoff;
my $fasta;
my $out;

GetOptions(
        'blast=s' => \$blast,
        'cutoff=s' => \$cutoff,
        'fasta=s' => \$fasta,
        'out=s' => \$out,
) or die "missing input\n";

open (IN1, "$blast") or die;

my %filter;

while (my $hit = <IN1>) {
	chomp $hit;
	my @cols = split(" ", $hit);
	if ( ($cols[0] =~ /#Unknown/) and ($cols[8] < $cutoff) ) {
		$filter{">$cols[0]"} = 1;
	}
}

close IN1;

open (IN2, "$fasta") or die;
open (OUT, ">$out") or die;

my $print = 0;

while (my $line = <IN2>) {
	chomp $line;
	if ($line =~ /^>/) {
		if (exists $filter{$line}) {
			$print = 1;
		}
		else {
			$print = 0;
			print OUT "$line\n";
		}
	}
	elsif ($print == 0) {
		print OUT "$line\n";
	}
}

close IN2;
close OUT;

exit;
