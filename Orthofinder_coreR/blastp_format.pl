#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;

#takes list of blastp commands output by orthofinder and adds additional commands from Moreno-Hagelsieb and Latimer 2008
#usage: blastp_format.pl --commands blastp.txt --out blastp.sh

my $commands;
my $out;

GetOptions(
	'commands=s' => \$commands,
	'out=s' => \$out,
) or die "missing input\n";

open (IN, "$commands") or die;
open (OUT, ">$out") or die;

while (my $line = <IN>) {
	chomp $line;
	print OUT "$line -seg yes -soft_masking true -use_sw_tback\n";
}

close IN;
close OUT;

exit;
