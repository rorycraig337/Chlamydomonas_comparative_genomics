#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;
use File::Basename;

#script takes a set of protein fastas and a set of 1-1 orthogroup files and produces per-orthogroup fasta files
#usage: orthogroups2fastas.pl --SCO SCO --proteins proteins --out fastas

my $SCO;
my $proteins;
my $out;

GetOptions(
	'SCO=s' => \$SCO,
	'proteins=s' => \$proteins,
	'out=s' => \$out,
) or die "missing input\n"; 

my @prot = glob("$proteins/*fa");

my %pindex;

foreach my $pfile (@prot) {
	my @pcols = split(/\./, basename($pfile));
	open (IN1, "$pfile") or die;
	my $seq;
	my $count = 0;
	while (my $pline = <IN1>) {
		chomp $pline;
		if ($pline =~ /^>/) {
			$seq = substr $pline, 1; 
			$count = 0;
		}
		else {
			$pindex{$pcols[0]}{$seq} = $pline;
			$count++;
			if ($count > 1) {
				die "not a single line sequence, $seq\n";
			}
		}
	}
	close IN1;
}

my @OGfiles = glob("$SCO/Orthogroups.OG*.txt");

foreach my $OG (@OGfiles) {
	my @ogcols = split(/\./, basename($OG));
	open (IN2, "$OG") or die;
	open (OUT, ">$out/$ogcols[1].fa") or die;
	while (my $ogline = <IN2>) {
		chomp $ogline;
		my @cols = split(/\./, $ogline);
		print OUT ">$ogline\n";
		if (exists $pindex{$cols[0]}{$ogline}) {
			print OUT "$pindex{$cols[0]}{$ogline}\n";
		}
		else {
			die "$ogline\n";
		}
	}

	close IN2;
	close OUT;
}

exit;
