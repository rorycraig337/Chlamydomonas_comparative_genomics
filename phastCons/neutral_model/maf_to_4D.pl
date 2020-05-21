#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Data::Dumper;
use Bio::AlignIO;
use Bio::SimpleAlign;

#script extracts 4D sites from MAF alignment, where all species are present and all 4D
#based on CDS of reference species, other species assumed to be CDS if aligned
#assumes that maf files do not contain paralogs and are split by chromosome/scaffold with name format "chromsome_X.maf"
#requires BED6 format for CDS, with gene_ID.CDS_number in column 4
#assumes CDS file is sorted by order of exons (i.e. not by start coordinate for reverse strand genes!)
#requires PHAST and EMBOSS tools to be installed and in the path
#list flag takes list of species as they appear in maf file
#usage: maf_to_4D.pl --CDS CDS.bed --maf_path ../maf/split/ --list species.txt --out 4D.fa

my $CDS;
my $maf_path;
my $list;
my $out;

GetOptions(
	'CDS=s' => \$CDS,
	'maf_path=s' => \$maf_path,
	'list=s' => \$list,
	'out=s' => \$out,
) or die "missing input\n";

#translation table hash

my %fD_codons = (
  TCT => "S", TCC => "S", TCA => "S", TCG => "S",
  CTT => "L", CTC => "L", CTA => "L", CTG => "L",
  CCT => "P", CCC => "P", CCA => "P", CCG => "P",
  CGT => "R", CGC => "R", CGA => "R", CGG => "R",
  ACT => "T", ACC => "T", ACA => "T", ACG => "T",
  GTT => "V", GTC => "V", GTA => "V", GTG => "V",
  GCT => "A", GCC => "A", GCA => "A", GCG => "A",
  GGT => "G", GGC => "G", GGA => "G", GGG => "G",
);

#build hash containing all CDS blocks by gene ID

my %CDS_index;

open (IN1, "$CDS") or die;

while (my $CDS_line = <IN1>) {
	chomp $CDS_line;
	my @CDS_cols = split(/\t/, $CDS_line);
	my @ID_cols = split(/\./, $CDS_cols[3]);
	my $ID = "$ID_cols[0]" . "." . "$ID_cols[1]";
	my $index_info = "$CDS_cols[0]\t$CDS_cols[1]\t$CDS_cols[2]\t$CDS_cols[5]";
	push @{ $CDS_index{$ID} }, $index_info;
}

close IN1;

#read in species from list

open (IN2, "$list") or die;

my %spp_order;
my $spp_number = 0;
my %fDseq; #hash to contain 4D sites

while (my $list_line = <IN2>) {
	chomp $list_line;
	$spp_order{$spp_number} = $list_line;
	$fDseq{$spp_order{$spp_number}} = "-"; #initialize each key-value pair with a gap character
	$spp_number++;
}

close IN2;

#foreach gene, extract each CDS from MAF
#reverse complement if - strand
#convert to MFA and combine

foreach my $gene (sort keys %CDS_index) {
	my $elem_count = 0;
	my @mfa_array;
	foreach my $CDS_elem ( @{$CDS_index{$gene}} ) {
		$elem_count++;
		my @elem_cols = split(/\t/, $CDS_elem);
		my $maf = "$maf_path" . "$elem_cols[0]" . ".maf";
		my $start = $elem_cols[1] + 1; #maf_parse is 1-based
		system("maf_parse --start $start --end $elem_cols[2] $maf > $elem_count.maf"); #extract MAF for CDS block
		system("msa_view $elem_count.maf --out-format FASTA > $elem_count.mfa"); #convert MAF to MFA
		if ($elem_cols[3] eq "-") { #need to reverse complement MAF blocks
			system("seqret -sreverse $elem_count.mfa $elem_count.r.mfa"); #reverse complement
			system("rm $elem_count.mfa"); #remove original file so it isn't concatenated in the next step
			push @mfa_array, "$elem_count.r.mfa";
		}
		else {
			push @mfa_array, "$elem_count.mfa";
		}
	}
	my $cat = join(" ", @mfa_array);
	system("perl catfasta2phyml.pl -c --fasta $cat > cat.mfa"); #concatenate alignments
	#new extract 4D sites
	my $str = Bio::AlignIO->new(-file => "cat.mfa",
		-format => "fasta" );
	my $aln = $str->next_aln();
	my $depth = $aln->num_sequences;
	if ($depth != $spp_number) { #not all species present, clean up files and skip
		system("rm *mfa");
		system("rm *maf");
		next;
	}
	else {
		my $aln_ordered=$aln->sort_by_list($list);
		my $len = $aln_ordered->length();
		my $depth = $aln_ordered->num_sequences;
		my $pos = 1;
		unless ( ($len % 3) == 0) {
			print "concatenated CDS not a multiple of 3, gene: $gene\n";
			system("rm *mfa");
			system("rm *maf");
			next;
		}
		until ($pos == ($len + 1)) {
			my @fDsites;
			my $ns = 0;
			my $s_count = 0;
			foreach my $seq ($aln_ordered->each_seq) {
				$s_count++;
				my $end = $pos + 2;
				my $codon = $seq->subseq($pos, $end); #extract codon
				my $site3 = $seq->subseq($end, $end); #extract 3rd position
				if ( ($s_count == 1) and ($pos == 1) ) {
					unless ($codon eq "ATG") {
						print "reference species concatenated CDS does not have a valid start codon, gene: $gene\n";
						system("rm *mfa");
						system("rm *maf");
						next;
					}
				}
				unless (exists $fD_codons{$codon}) { #does codon contain 4D site?
					$ns = 1;
				}
				push @fDsites, $site3;
			}
			if ($ns == 0) { #all codons contain 4D site
				my $loop = 0;
				foreach my $fDsite (@fDsites) {
					$fDseq{$spp_order{$loop}} = $fDseq{$spp_order{$loop}} . $fDsite;
					$loop++;
				}
			}
			$pos = $pos + 3;
		}
	}
	system("rm *mfa");
	system("rm *maf");
}

#print 4D sites from all genes to file

open (OUT, ">$out") or die;

foreach my $species (sort {$a <=> $b} keys %spp_order) {
	my $header = ">" . $spp_order{$species};
	print OUT "$header\n";
	print OUT "$fDseq{$spp_order{$species}}\n";
}

close OUT;

exit;
