#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;

#takes an fai files and outputs a list of features shorter than a given length
#usage: extract_short_seqs.pl --fai in.fai --length 30 --out short.txt

my $fai;
my $length;
my $out;

GetOptions(
	'fai=s' => \$fai,
	'length=i' => \$length,
	'out=s' => \$out,
) or die "missing input\n";

open (IN, "$fai") or die;
open (OUT, ">$out") or die;

while (my $line = <IN>) {
	chomp $fai;
	my @cols = split(" ", $line);
	if ($cols[1] < $length) {
		print OUT "$cols[0]\n";
	}
}

close IN;
close OUT;

exit;
