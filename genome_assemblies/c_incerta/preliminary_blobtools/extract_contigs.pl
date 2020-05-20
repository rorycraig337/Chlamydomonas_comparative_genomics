#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;

#script to parse blobplot table, outputting no-hit contigs with coverage no higher than that of the max coverage contaminant contig
#script to parse blobplot table
#splits contigs into three files, contaminants, no-hit with coverage less than max contaminant, & non-contaminant + no-hit with higher coverage
#usage: perl extract_contigs.pl --table in.tsv --contam_list list1,list2,list3 --passed passed.txt --contamanants contaminant_contings.txt --no-hits no-hit_contigs.txt

my $table;
my $contam_list;
my $passed;
my $contaminants;
my $no_hits;

GetOptions(
        'table=s' => \$table,
	'contam_list=s' => \$contam_list,
        'passed=s' => \$passed,
	'contaminants=s' => \$contaminants,
        'no_hits=s' => \$no_hits,
) or die "missing input\n";

my @contam_match = split(",", $contam_list);
my %contam_contigs;
my %no_hit_contigs;

open (IN, "$table") or die;
open (OUT1, ">$passed") or die;

while (my $line = <IN>) {
	unless ($line =~ /^#/) {
		my $cflag = 0;
		chomp $line;
		my @cols = split(/\t/, $line);
		if ($cols[5] eq "no-hit") {
			$no_hit_contigs{$cols[0]} = $cols[4];
			$cflag = 1;
		}
		else {
			foreach my $contam_name (@contam_match) {
				if ($cols[5] eq "$contam_name") {
					$contam_contigs{$cols[0]} = $cols[4];
					$cflag = 1;
				}
			}	
		}
		if ($cflag == 0) {
			print OUT1 "$cols[0]\n";
		}
	}
}

close IN;

open (OUT2, ">$no_hits") or die;
open (OUT3, ">$contaminants") or die;

my @cov_range = sort { $contam_contigs{$a} <=> $contam_contigs{$b} } keys %contam_contigs;
my $max = $contam_contigs{$cov_range[-1]};

foreach my $no_hit_contig (keys %no_hit_contigs) {
	my $cov = $no_hit_contigs{$no_hit_contig};
	unless ($cov > $max) {
		print OUT2 "$no_hit_contig\n";
	}
	else {
		print OUT1 "$no_hit_contig\n";
	}
}

foreach	my $contam_contig (keys %contam_contigs) {
        print OUT3 "$contam_contig\n";
}

close OUT1;
close OUT2;
close OUT3;

exit;
