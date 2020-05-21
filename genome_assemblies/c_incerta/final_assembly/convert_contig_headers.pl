#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);

#script converts fasta headers to C(contig number)
#usage: perl convert_contig_headers.pl --in in.fa --out out.fa

my $in;
my $out;

GetOptions(
        'in=s' => \$in,
        'out=s' => \$out,
) or die "missing input\n";   

open (IN, "$in") or die;
open (OUT, ">$out") or die;

my $count = 0;

while (my $line = <IN>) {
        chomp $line;
        if ($line =~ /^>tig/) {
                $count++;
                my $contig_number = sprintf("%04d", $count);
                print OUT ">C$contig_number\n"
        }
	else {
              	print OUT "$line\n";
        }
}

close IN;
close OUT;

exit;
