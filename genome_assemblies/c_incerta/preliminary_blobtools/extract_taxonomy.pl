#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;

#script to parse blobplot table, outputting user designated taxonomy
#usage: perl extract_no-hit_contaminant_coverage.pl --table in.tsv --list list1,list2,list3 --out out.txt

my $table;
my $list;
my $out;

GetOptions(
        'table=s' => \$table,
	'list=s' => \$list,
        'out=s' => \$out,
) or die "missing input\n";

my @tax_match = split(",", $list);

open (IN, "$table") or die;
open (OUT, ">$out") or die;

while (my $line = <IN>) {
	unless ($line =~ /^#/) {
		chomp $line;
		my @cols = split(/\t/, $line);
		foreach my $contig (@tax_match) {
			if ($cols[5] eq "$contig") {
				print OUT "$cols[0]\n";
			}
		}	
	}
}

close IN;
close OUT;

exit;
