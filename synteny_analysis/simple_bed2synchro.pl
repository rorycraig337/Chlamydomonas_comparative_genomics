#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;

#script converts 1-based features bed file to xxxx.def input file for synchro
#simplified version that ignores centromeres
#usage: perl simple_bed2synchro.pl --features features.bed --def cinc.def --ch cinc.ch

my $features;
my $def;
my $ch;

GetOptions(
	'features=s' => \$features,
	'def=s' => \$def,
	'ch=s' => \$ch,
) or die "missing input\n";

open (IN, "$features") or die;
open (OUT1, ">$def") or die;

my @chrs;
my %chr_last;

#run through first line so we save the name of the first chromosome

my $line1 = <IN>;
chomp $line1;
my @cols1 = split(/\t/, $line1);
my $chr = $cols1[0];
my $chr_count = 1;
my $res1 = sprintf("%03d", $chr_count);
push @chrs, $chr;

my $IDc = 1;
my $IDa = 1;
my $IDf = 1;
my $res2 = sprintf("%05d", $IDc);
my $res3 = sprintf("%05d", $IDa);
my $res4 = sprintf("%05d", $IDf);

print OUT1 "type\tname\tchr\tstart\tend\tstrand\tsens\tIDg/chr\tIDg/all\tIDf/all\n";
print OUT1 "gene\t$cols1[3]\t$res1\t$cols1[1]\t$cols1[2]\t$cols1[5]\t0\t$res2\t$res3\t$res4\n";

#now loop through entire features set

while (my $line = <IN>) {
	chomp $line;
	my @cols = split(/\t/, $line);
	if ($cols[0] ne "$chr") { #new chromosome/scaffold
		$chr_last{$chr} = $res4; #store last feature of chromosome
		$chr = $cols[0]; #set new chromosome name
		$chr_count++; #increment chromosome count
		$res1 = sprintf("%03d", $chr_count);
		$IDc = 0; #reset gene count
		push @chrs, $chr; #store new chromosome
	}
	$IDc++;
	$IDa++;
	$IDf++;
	$res2 = sprintf("%05d", $IDc);
	$res3 = sprintf("%05d", $IDa);
	$res4 = sprintf("%05d", $IDf);
	print OUT1 "gene\t$cols[3]\t$res1\t$cols[1]\t$cols[2]\t$cols[5]\t0\t$res2\t$res3\t$res4\n";
}

$chr_last{$chr} = $res4; #store feature count of final chromosome/scaffold

close IN;
close OUT1;

open (OUT2, ">$ch") or die;

#first line: print chromosome/scaffold names

print OUT2 join("\t", @chrs);
print OUT2 "\n";

#second and third lines: print feature number for end of chromosome

my @end_feat;

foreach my $chr2 (@chrs) {
	push @end_feat, $chr_last{$chr2};
}

print OUT2 join("\t", @end_feat);
print OUT2 "\n";
print OUT2 join("\t", @end_feat);
#print OUT2 "\n";

close OUT2;

exit;
