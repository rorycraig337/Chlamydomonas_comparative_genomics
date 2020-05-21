#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);

#script removes sequences from fasta
#expects list to include ">" character 
#usage: perl fasta_filter.pl --in in.fa --filter seqs.txt --out out.fa

my $in;
my $filter;
my $out;

GetOptions(
        'in=s' => \$in,
        'filter=s' => \$filter,
        'out=s' => \$out,
) or die "missing input\n";  

my %filter_index;

open (IN1, "$filter") or die;

while (my $seq = <IN1>) {
	chomp $seq;
	$filter_index{$seq} = 1;
}

close IN1;

my $flag;

open (IN2, "$in") or die;
open (OUT, ">$out") or die;

while (my $line = <IN2>) {
	chomp $line;
	if ($line =~ /^>/) {
		if (exists $filter_index{$line}) {
			$flag = 1;
		}
		else {
			$flag = 0;
			print OUT "$line\n";
		}
	}
	elsif ($flag == 0) {
		print OUT "$line\n";
	}
}

close IN2;
close OUT;

exit;
