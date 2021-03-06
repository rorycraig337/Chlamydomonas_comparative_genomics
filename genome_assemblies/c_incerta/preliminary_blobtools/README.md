Make preliminary assembly with Miniasm to check for contaminants

```
minimap2 -x ava-pb -t16  ../pacbio_reads/c_incerta.subreads.fa ../pacbio_reads/c_incerta.subreads.fa | gzip -1 > c_incerta.subreads.paf.gz
miniasm -f ../pacbio_reads/c_incerta.subreads.fa c_incerta.subreads.paf.gz > c_incerta.miniasm_v1.gfa
awk '/^S/{print ">"$2"\n"$3}' c_incerta.miniasm_v1.gfa > c_incerta.miniasm_v1.fa
```

Map reads against Miniasm assembly

```
minimap2 -ax map-pb -t16 c_incerta.miniasm_v1.fa ../pacbio_reads/c_incerta.subreads.fa > c_incerta.miniasm_v1.raw_reads.sam
samtools view -Sb c_incerta.miniasm_v1.raw_reads.sam | samtools sort - > c_incerta.miniasm_v1.raw_reads.bam
samtools index c_incerta.miniasm_v1.raw_reads.bam
```

Blast Miniasm assembly contigs against NCBI nt database

```
export BLASTDB=/scratch/ncbi/blastdbs
blastn -task megablast -query c_incerta.miniasm_v1.fa -db nt -outfmt '6 qseqid staxids bitscore std' -max_target_seqs 1 -max_hsps 1 -num_threads 32 -evalue 1e-25 -out c_incerta.miniasm_v1.vs.nt.mts1.hsp1.1e25.megablast.out
```

Run Blobtools

```
blobtools create -i c_incerta.miniasm_v1.fa -s c_incerta.miniasm_v1.raw_reads.sam -t c_incerta.miniasm_v1.vs.nt.mts1.hsp1.1e25.megablast.out -o blobtools_v1
blobtools view -i blobtools_v1.blobDB.json
blobtools plot -i blobtools_v1.blobDB.json
```

Extract contaminant reads and unmapped reads

```
perl extract_contigs.pl --table blobtools_v1.blobDB.table.txt --contam_list Proteobacteria --passed passed_contigs.txt --contaminants contaminant_contings.txt --no_hits no-hit_contigs.txt
cat no-hit_contigs.txt contaminant_contings.txt | sort > rerun_contigs.txt
samtools faidx ../miniasm_v1/c_incerta.miniasm_v1.fa
perl fai2bed.pl --fai ../miniasm_v1/c_incerta.miniasm_v1.fa.fai --out c_incerta.miniasm_v1.bed
grep -f rerun_contigs.txt c_incerta.miniasm_v1.bed > rerun_contigs.bed
samtools view -b -L rerun_contigs.bed c_incerta.miniasm_v1.raw_reads.bam > rerun_reads.bam
samtools fasta -0 rerun_reads.fa rerun_reads.bam
samtools view -b -f4 c_incerta.miniasm_v1.raw_reads.bam > unmapped_reads.bam
samtools fasta -0 unmapped_reads.fa unmapped_reads.bam
cat rerun_reads.fa unmapped_reads.fa > miniasm_contaminants_reads.fa
```

Extract non-contaminant mappable reads

```
sort passed_contigs.txt > s_passed_contigs.txt
grep -f s_passed_contigs.txt c_incerta.miniasm_v1.bed > passed_contigs.bed
samtools view -b -L passed_contigs.bed c_incerta.miniasm_v1.raw_reads.bam > passed_reads.bam
samtools fasta -0 passed_reads.fa passed_reads.bam
```

Assemble putative contaminant reads

```
minimap2 -x ava-pb -t16  miniasm_contaminants_reads.fa miniasm_contaminants_reads.fa | gzip -1 > miniasm_contaminants.paf.gz
miniasm -f miniasm_contaminants_reads.fa miniasm_contaminants.paf.gz > miniasm_contaminants.gfa
awk '/^S/{print ">"$2"\n"$3}' miniasm_contaminants.gfa > miniasm_contaminants.fa
```

Map putative contaminant reads against contaminant assembly

```
minimap2 -ax map-pb -t16 miniasm_contaminants.fa miniasm_contaminants_reads.fa > miniasm_contaminant.sam
samtools view -Sb miniasm_contaminant.sam | samtools sort - > miniasm_contaminant.bam
samtools index miniasm_contaminant.bam
```

Blast putative contaminant contigs against NCBI nt database

```
export BLASTDB=/scratch/ncbi/blastdbs
blastn -task megablast -query miniasm_contaminants.fa -db nt -outfmt '6 qseqid staxids bitscore std' -max_target_seqs 1 -max_hsps 1 -num_threads 32 -evalue 1e-25 -out miniasm_contaminant.vs.nt.mts1.hsp1.1e25.megablast.out
```

Run blobtools on contaminant assembly

```
blobtools create -i miniasm_contaminants.fa -s miniasm_contaminant.sam -t miniasm_contaminant.vs.nt.mts1.hsp1.1e25.megablast.out -o blobtools_contaminant
blobtools view -i blobtools_contaminant.blobDB.json
blobtools plot -i blobtools_contaminant.blobDB.json
```

Extract reads that map to either no-hit or Chlorophyta contigs, or are unmapped

```
perl extract_taxonomy.pl --table blobtools_contaminant.blobDB.table.txt --list no-hit,Chlorophyta --out usable_contigs.txt
samtools faidx ../miniasm_contaminant/miniasm_contaminants.fa
perl fai2bed.pl --fai miniasm_contaminants.fa.fai --out miniasm_contaminants.bed
grep -f usable_contigs.txt miniasm_contaminants.bed > usable_contigs.bed
samtools view -b -L usable_contigs.bed miniasm_contaminant.bam > usable_reads.bam
samtools fasta -0 usable_reads.fa usable_reads.bam
samtools view -b -f4 miniasm_contaminant.bam > unmapped_reads.contaminant.bam
samtools fasta -0 unmapped_reads.contaminant.fa unmapped_reads.contaminant.bam
cat usable_reads.fa unmapped_reads.contaminant.fa > contaminant_passed.fa
```

Extract reads mapping to Proteobacteria contigs

```
perl extract_taxonomy.pl --table blobtools_contaminant.blobDB.table.txt --list Proteobacteria --out contaminant_contigs.txt
grep -f contaminant_contigs.txt miniasm_contaminants.bed > contaminant_contigs.bed
samtools view -b -L contaminant_contigs.bed miniasm_contaminant.bam > contaminant_reads.bam
samtools fasta -0 contaminant_reads.fa contaminant_reads.bam
```

Make final Miniasm assembly to estimate genome size for Canu

```
cat passed_reads.fa contaminant_passed.fa > miniasm_v2.fa
minimap2 -x ava-pb -t48  miniasm_v2.fa miniasm_v2.fa | gzip -1 > c_incerta.passed_reads.paf.gz
miniasm -f miniasm_v2.fa c_incerta.passed_reads.paf.gz > c_incerta.miniasm_v2.gfa
awk '/^S/{print ">"$2"\n"$3}' c_incerta.miniasm_v2.gfa > c_incerta.miniasm_v2.fa
quast.py c_incerta.miniasm_v2.fa
```
