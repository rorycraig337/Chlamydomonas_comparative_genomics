#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);

#part 1 of BUSCO phylogeny pipeline, take summary table and produce per gene fasta files for each BUSCO
#usage: perl BUSCO_summary_to_fastas_filter.pl --summary summary.tsv --output output_directory --perc 0.75

my $summary;
my $output;
my $perc;

GetOptions(
        'summary=s' => \$summary,
        'output=s' => \$output,
        'perc=f' => \$perc,
) or die "missing input\n";

open (IN, "$summary") or die;

my $header = <IN>;
chomp $header;
my @head_cols = split(/\t/, $header);
my $pass = 0;

while (my $line = <IN>) {
	chomp $line;
	my @cols = split(/\t/, $line);
	my $col_count1 = 0;
	my $good = 0;
	foreach my $col (@cols) {
		if ( ($col_count1 > 0) and ($col == 1) ) {
			$good++;
		}
		$col_count1++;
	}
	my $col_count2 = 0;
	my $match = ($good / (scalar @cols - 1));
	print "$match\n";
	if ($match >= $perc) {
		open (OUT, ">$output/$cols[0].fa") or die;
		$pass++;
		foreach my $col (@cols) {
			if ( ($col_count2 > 0) and ($col == 1) ) {
				my $id = $head_cols[$col_count2];
				open (IN2, "run_$id/single_copy_busco_sequences/$cols[0].faa") or die;
				my $header = <IN2>;
				my $seq = <IN2>;
				chomp $seq;
				print OUT ">$id\n$seq\n";
				close IN2;
			}
			elsif ( ($col_count2 > 0) and ($col == 0) ) {
				my $id = $head_cols[$col_count2];
				print OUT ">$id\n";
			}
			$col_count2++;
		}
		close OUT;
	}
}

print "$pass good BUSCOs\n";

close IN;

exit;
