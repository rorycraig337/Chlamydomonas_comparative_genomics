#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);

#grep -v -f in a script

my $seqs;

my $search;
my $searched;
my $out;

GetOptions(
	'search=s' => \$search,
	'searched=s' => \$searched,
	'out=s' => \$out,
) or die "missing input\n";

my %match;

open (IN1, "$search") or die;

while (my $line1 = <IN1>) {
	chomp $line1;
	$match{$line1} = 1;
}

close IN1;

open (IN2, "$searched") or die;
open (OUT, ">$out") or die;

while (my $line2 = <IN2>) {
	chomp $line2;
	unless (exists $match{$line2}) {
		print OUT "$line2\n";
	}
}

close IN2;
close OUT;

exit;
