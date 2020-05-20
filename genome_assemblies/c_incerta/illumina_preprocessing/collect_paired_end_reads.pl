#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);

#script to parse SAM file and output names of properly paired paired-end reads (i.e. innies)
#also outputs all properly paired reads (all_proper)
#usage: collect_paired_end_reads.pl --sam in.sam --PE_proper PE.txt --all_proper all.txt

my $sam;
my $PE_proper;
my $all_proper;

GetOptions(
        'sam=s' => \$sam,
        'PE_proper=s' => \$PE_proper,
	'all_proper=s' => \$all_proper,
) or die "missing input\n";

open (IN, "$sam") or die;
open (OUT1, ">$PE_proper") or die;
open (OUT2, ">$all_proper") or die;

while (my $line = <IN>) {
        chomp $line;
        unless ($line =~ /^@/) {
                my @cols = split(" ", $line);
                my $flag = $cols[1];
                my $insert = $cols[8];
                if ($flag == 83) {
                        if ($insert < 0) {
                                print OUT1 "$cols[0]\n";
                        }
                	print OUT2 "$cols[0]\n";
		}
                if ($flag == 163) {
                        if ($insert > 0) {
                                print OUT1 "$cols[0]\n";
                        }
			print OUT2 "$cols[0]\n";
                }
                if ($flag == 99) {
                        if ($insert > 0) {
                                print OUT1 "$cols[0]\n";
                        }
			print OUT2 "$cols[0]\n";
                }
                if ($flag == 147) {
                        if ($insert < 0) {
                                print OUT1 "$cols[0]\n";
                        }
			print OUT2 "$cols[0]\n";
                }
        }
}

close IN;
close OUT1;
close OUT2;

exit;
