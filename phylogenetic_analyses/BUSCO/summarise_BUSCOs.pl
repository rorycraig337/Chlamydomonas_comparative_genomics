#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;

#part 1 of BUSCO phylogeny pipeline, produce summary presence of single-copy BUSCO presence/absence
#assumes all BUSCO output directories are in the same working folder (where script is run)
#usage: perl summarise_BUSCOs.pl --species_list species.txt --BUSCO_list BUSCOs.txt --out complete_BUSCOs.txt

my $species_list;
my $BUSCO_list;
my $out;

GetOptions(
        'species_list=s' => \$species_list,
        'BUSCO_list=s' => \$BUSCO_list,
        'out=s' => \$out,
) or die "missing input\n";

open (IN, "$species_list") or die;
open (OUT, ">$out") or die;

my $count = 0;
my %BUSCOs;

print OUT "BUSCO";

while (my $species = <IN>) {
	chomp $species;
	print OUT "\t$species";
	$count++;
	open (IN2, "run_$species/full_table_$species.tsv") or die;
	while (my $BUSCO = <IN2>) {
		chomp $BUSCO;
		unless ($BUSCO =~ /^#/) {
			my @cols = split(" ", $BUSCO);
			if ($cols[1] eq "Complete") {
				$BUSCOs{$species}{$cols[0]} = 1;
			}
		}
	}
	close IN2;
}

print OUT "\n";

close IN;

open (IN1, "$BUSCO_list") or die;

while (my $gene = <IN1>) {
	chomp $gene;
	print OUT "$gene";
	foreach my $id (sort keys %BUSCOs) {
		if (exists $BUSCOs{$id}{$gene}) {
			print OUT "\t1";
		}
		else {
			print OUT "\t0";
		}
	}
	print OUT "\n";
}


close IN1;
close OUT;

exit;
