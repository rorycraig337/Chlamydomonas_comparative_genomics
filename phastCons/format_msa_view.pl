#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);

#script to format .mfa file output by msa_view, replaces "*" gaps with "-", and removes space in FASTA header
#usage: perl format_msa_view.pl --mfa in.mfa --out out.mfa

my $mfa;
my $out;

GetOptions(
	'mfa=s' => \$mfa,
	'out=s' => \$out,
) or die "Missing Input\n";

open (IN, "$mfa") or die;
open (OUT, ">$out") or die;

while (my $line = <IN>) {
	chomp $line;
	if ($line =~ /^>/) {
		my @columns = split(" ", $line);
		print OUT "$columns[0]$columns[1]\n";
	}
	else {
		$line =~ tr/\*/\-/; #replace "*" with "-"
		print OUT "$line\n";
	}
}

close IN;
close OUT;

exit;
