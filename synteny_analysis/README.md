Create input files for SynChro

First create bed file of genes after removing repeat genes

```
perl gene_gff2bed.pl --gff ../Cactus_WGA/site_classes/c_reinhardtii.v5_6.gff3 --list ../Cactus_WGA/site_classes/repeat_genes.txt --out gene.bed
```

Add centromeres

```
cat gene.bed centromeres_trimmed.bed | sort -k1,1 -k2n,2n > features.bed
```

Produce DEF and CH files

```
perl bed2synchro.pl --features features.bed --def CREI.def --ch CREI.ch
```

Produce PRT file

```
perl fasta2prt.pl --fasta Creinhardtii_281_v5.6.protein_primaryTranscriptOnly.fa --def CREI.def --prt CREI.prt
```

#now repeat for each other species
grep ">" ../Orthofinder_coreR/c_incerta.longest_proteins.fa | sed 's/^.//' > c_incerta.gene_list.txt
perl gene_gtf2bed.pl --gtf ../gene_annotation/final_gene_models/c_incerta.braker2.f3.gtf --list c_incerta.gene_list.txt --out c_incerta.features.bed
sort -k1,1 -k2n,2n c_incerta.features.bed > s.c_incerta.features.bed
perl simple_bed2synchro.pl --features s.c_incerta.features.bed --def CINC.def --ch CINC.ch
perl fasta2prt.pl --fasta ../Orthofinder_coreR/c_incerta.longest_proteins.fa --def CINC.def --prt CINC.prt

grep ">" ../Orthofinder_coreR/c_schloesseri.longest_proteins.fa | sed 's/^.//' > c_schloesseri.gene_list.txt
perl gene_gtf2bed.pl --gtf ../gene_annotation/final_gene_models/c_schloesseri.braker2.f3.gtf --list c_schloesseri.gene_list.txt --out c_schloesseri.features.bed
sort -k1,1 -k2n,2n c_schloesseri.features.bed > s.c_schloesseri.features.bed
perl simple_bed2synchro.pl --features s.c_schloesseri.features.bed --def CSCH.def --ch CSCH.ch
perl fasta2prt.pl --fasta ../Orthofinder_coreR/c_schloesseri.longest_proteins.fa --def CSCH.def --prt CSCH.prt

grep ">" ../Orthofinder_coreR/c_debaryana.longest_proteins.fa | sed 's/^.//' > c_debaryana.gene_list.txt
perl gene_gtf2bed.pl --gtf ../gene_annotation/final_gene_models/c_debaryana.braker2.f3.gtf --list c_debaryana.gene_list.txt --out c_debaryana.features.bed
sort -k1,1 -k2n,2n c_debaryana.features.bed > s.c_debaryana.features.bed
perl simple_bed2synchro.pl --features s.c_debaryana.features.bed --def CDEB.def --ch CDEB.ch
perl fasta2prt.pl --fasta ../Orthofinder_coreR/c_debaryana.longest_proteins.fa --def CDEB.def --prt CDEB.prt
```

Add CHROicle and SynChro directory structure from http://www.lcqb.upmc.fr/CHROnicle/SynChro.html

```
cd SynChro
mkdir Ci Cs Ed
cd Ci && mkdir 01Genomes && cd ..
cd Cs && mkdir 01Genomes && cd ..
cd Ed && mkdir 01Genomes && cd ..
cp ../CREI.* ../CINC.* Ci/01Genomes/
cp ../CREI.* ../CSCH.* Cs/01Genomes/
cp ../CREI.* ../CDEB.* Ed/01Genomes/
cd Programs/1SynChro
```

Run SynChro 

```
PATH=/localdisk/home/s0920593/software/blast-2.2.26/bin/:$PATH
export PATH
./SynChro.py Ci 0 2
./SynChro.py Cs 0 2
./SynChro.py Ed 0 2
```
