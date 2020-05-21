#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;

#creates ****.prt input file for synchro from fasta file of proteins and ****.def file
#assumes phytozome gene IDs
#perl fasta2prt.pl --fasta proteins.fa --def crei.def --prt crei.prt

my $fasta;
my $def;
my $prt;

GetOptions(
	'fasta=s' => \$fasta,
	'def=s' => \$def,
	'prt=s' => \$prt,
) or die "missing input\n";

#build hash of proteins

my %seqs;
my $seq_count = 0;
my $seq_ID;
my $seq;

open (IN1, "$fasta") or die;

while (my $fline = <IN1>) {
	if ($fline =~ /^>/) {
		chomp $fline;
		$seq_count++;
		if ($seq_count > 1) {
			my $strip_seq = substr $seq, 1;
			$seqs{$seq_ID} = $strip_seq;
		}
		my @ID_cols = split(/\./, $fline);
		my $pre_ID = $ID_cols[0] . "." . $ID_cols[1];
		$seq_ID = substr $pre_ID, 1;
		$seq = "X";
	}
	else {
		$seq = $seq . $fline;
	}
}

#add final sequence
my $strip_seq = substr $seq, 1;
$seqs{$seq_ID} = $strip_seq;

close IN1;

open (IN2, "$def") or die;
open (OUT, ">$prt") or die;

while (my $line = <IN2>) {
	chomp $line;
	my @cols = split(/\t/, $line);
	if ($cols[0] eq "gene") {
		if (exists $seqs{$cols[1]}) {
			print OUT ">";
			print OUT "$cols[1]\t$cols[2]\t$cols[3]\t$cols[4]\t$cols[5]\t$cols[6]\t$cols[7]\t$cols[8]\t$cols[9]\n";
			print OUT "$seqs{$cols[1]}";
		}
		else {
			die "$cols[1] missing from protein fasta\n";
		}
	}
}

close OUT;

exit;
