Canu run 1 using genome size from Miniasm

```
canu -p c_schloesseri -d v1_out genomeSize=137.0m -pacbio-raw ../pacbio_reads/c_schloesseri.subreads.fa correctedErrorRate=0.065 corMhapSensitivity=normal maxThreads=24 gnuplotTested=true
```

Run blobtools pipeline

```
minimap2 -ax map-pb -t24 ../v1_out/c_schloesseri.contigs.fasta ../../../pacbio_raw_reads/c_schloesseri.subreads.fa > c_schloesseri.canu_v1.reads.sam
samtools view -Sb c_schloesseri.canu_v1.reads.sam | samtools sort - > c_schloesseri.canu_v1.reads.bam
samtools index c_schloesseri.canu_v1.reads.bam

export BLASTDB=/scratch/ncbi/blastdbs
blastn -task megablast -query v1_out/c_schloesseri.contigs.fasta -db nt -outfmt '6 qseqid staxids bitscore std' -max_target_seqs 1 -max_hsps 1 -num_threads 24 -evalue 1e-25 -out c_schloesseri.canu_v1.vs.nt.mts1.hsp1.1e25.megablast.out

blobtools create -i ../v1_out/c_schloesseri.contigs.fasta -s c_schloesseri.canu_v1.reads.sam -t c_schloesseri.canu_v1.vs.nt.mts1.hsp1.1e25.megablast.out -o blobtools_canu_v1
blobtools view -i blobtools_canu_v1.blobDB.json
blobtools plot -i blobtools_canu_v1.blobDB.json

perl ../../preliminary_blobtools/extract_taxonomy.pl --table blobtools_canu_v1.blobDB.table.txt --list no-hit,Chlorophyta --out usable_contigs.txt
samtools faidx ../v1_out/c_schloesseri.contigs.fasta
perl ../../preliminary_blobtools/fai2bed.pl --fai v1_out/c_schloesseri.contigs.fasta.fai --out c_schloesseri.contigs.bed
grep -f usable_contigs.txt c_schloesseri.contigs.bed > usable_contigs.bed
samtools view -b -L usable_contigs.bed c_schloesseri.canu_v1.reads.bam > usable_reads.bam
samtools fasta -0 usable_reads.fa usable_reads.bam
samtools view -b -f4 c_schloesseri.canu_v1.reads.bam > unmapped_reads.bam
samtools fasta -0 unmapped_reads.fa unmapped_reads.bam
cat usable_reads.fa unmapped_reads.fa > canu_v2.reads.fa
grep ">" canu_v2.reads.fa | cut -c2- > canu_v2.reads.txt
```

Two contaminant contigs, re-run Canu with filtered reads

```
canu -p c_schloesseri -d v2_out genomeSize=130.5m -pacbio-raw canu_v2.reads.fa correctedErrorRate=0.065 corMhapSensitivity=normal maxThreads=24 gnuplotTested=true
```

Check assembly is clean with blobtools

```
minimap2 -ax map-pb -t24 v2_out/c_schloesseri.contigs.fasta ../pacbio_reads/c_schloesseri.subreads.fa > c_schloesseri.canu_v2.reads.sam
samtools view -Sb c_schloesseri.canu_v2.reads.sam | samtools sort - > c_schloesseri.canu_v2.reads.bam
samtools index c_schloesseri.canu_v2.reads.bam

export BLASTDB=/scratch/ncbi/blastdbs
blastn -task megablast -query v2_out/c_schloesseri.contigs.fasta -db nt -outfmt '6 qseqid staxids bitscore std' -max_target_seqs 1 -max_hsps 1 -num_threads 24 -evalue 1e-25 -out c_schloesseri.canu_v2.vs.nt.mts1.hsp1.1e25.megablast.out

blobtools create -i ../v2_out/c_schloesseri.contigs.fasta -s c_schloesseri.canu_v2.reads.sam -t c_schloesseri.canu_v2.vs.nt.mts1.hsp1.1e25.megablast.out -o blobtools_canu_v2
blobtools view -i blobtools_canu_v2.blobDB.json
blobtools plot -i blobtools_canu_v2.blobDB.json
```
