#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;
use Bio::SeqIO;

#script to take genome (fasta) and *changes file, both output by Pilon, and restore all indels of length > 'min_indel' in output genome
#usage: restore_pilon_indels.pl --genome genome.fa --changes pilon.changes --min_indel 5 --out restored_genome.fa

my $genome;
my $changes;
my $min_indel;
my $out;

GetOptions(
	'genome=s' => \$genome,
	'changes=s' => \$changes,
	'min_indel=i' => \$min_indel,
	'out=s' => \$out,
) or die "missing input\n";

open (IN1, "$changes") or die;

my %big_indels;

while (my $change = <IN1>) {
	chomp $change;
	my @change_cols = split(" ", $change);
	my @orig_cols = split(/:/, $change_cols[0]);
	my @new_cols = split(/:/, $change_cols[1]);
	my $contig = $new_cols[0];
	if ( ($change_cols[3] eq ".") and (length $change_cols[2] > $min_indel) ) { #change is a large deletion
		my @coor_cols = split(/-/, $orig_cols[1]);
		$big_indels{$contig}{$coor_cols[0]}{del}{$coor_cols[1]}{$new_cols[1]} = "$change_cols[2]"; #store contig, old start, old end, new single coordinate as keys, deletion as value
	}
	elsif ( ($change_cols[2] eq ".") and (length $change_cols[3] > $min_indel) ) { #change is a large insertion
		my @coor_cols = split(/-/, $new_cols[1]);
		my $coor = "$coor_cols[0]\t$coor_cols[1]\t$orig_cols[1]";
		$big_indels{$contig}{$orig_cols[1]}{in}{$coor_cols[0]}{$coor_cols[1]} = "$change_cols[3]"; #store contig, old single coordiante, new start, new end as keys, insertion as value
	}
	elsif ( (length $change_cols[3] > $min_indel) and (length $change_cols[2] > $min_indel) ) {
		print "WARNING: $change\n";
	}
}

close IN1;

open (OUT, ">$out") or die;

my $in  = Bio::SeqIO->new(-file => "$genome" , '-format' => 'Fasta');

while ( my $seq = $in->next_seq() ) { #loop through each contig
	my $id = $seq->id;
	my $sequence = $seq->seq();
	my $offset = 0;
	my $seq_length = $seq->length;
	if (exists $big_indels{$id}) { #contig contains large indel
		foreach my $start (sort {$a <=> $b} keys %{$big_indels{$id}}) {
			foreach my $form (keys %{$big_indels{$id}{$start}}) {
				if ($form eq "del") {
					foreach my $stop (keys %{$big_indels{$id}{$start}{$form}}) {
						foreach my $new (keys %{$big_indels{$id}{$start}{$form}{$stop}}) {
							my $new_seq_length = $seq_length + $offset; #get new length of contig by appending offset to original length
							my $break = $new + $offset - 1;
							my $before = substr $sequence, 0, $break; #get sequence before deletion
							my $remainder = $new_seq_length - $new - $offset + 1;
							my $after = substr $sequence, - $remainder; #get sequence after deletion
							$sequence = $before . $big_indels{$id}{$start}{$form}{$stop}{$new} . $after; #insert deletion between flanks
							$offset += length $big_indels{$id}{$start}{$form}{$stop}{$new}; #store length of deletion as offset
						}
					}
				}
				if ($form eq "in") {
					foreach my $new_start (keys %{$big_indels{$id}{$start}{$form}}) {
						foreach my $new_stop (keys %{$big_indels{$id}{$start}{$form}{$new_start}}) {
							my $new_seq_length = $seq_length + $offset; #get new length of contig by appending offset to original length
							my $break = $new_start + $offset - 1;				
							my $before = substr $sequence, 0, $break; #get sequence before insertion
							my $remainder = $new_seq_length - $new_stop - $offset;
							my $after = substr $sequence, - $remainder; #get sequence after insertion
							$sequence = $before . $after; #cat flanks to remove insertion
							$offset -= length $big_indels{$id}{$start}{$form}{$new_start}{$new_stop}; #store length of insetion as negative offset
						}
					}
				}
			}
		}
	}
    print OUT ">$id\n"; 
    $sequence=~s/(.{80})/$1\n/g;
    chomp $sequence;
    print OUT "$sequence\n"; #print out original/restored sequence in fasta
}

close OUT;

exit;



