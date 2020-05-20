Run Canu with putative non-contaminant read-set and genome size estimate from Miniasm

```
canu -p c_incerta -d v1_out genomeSize=130.8m -pacbio-raw ../preliminary_blobtools/miniasm_v2.fa correctedErrorRate=0.065 corMhapSensitivity=normal maxThreads=48 gnuplotTested=true
```

Run Blobtools pipeline on Canu assembly

```
minimap2 -ax map-pb -t48 v1_out/c_incerta.contigs.fasta ../preliminary_blobtools/miniasm_v2.fa > c_incerta.canu_v1.reads.sam
samtools view -Sb c_incerta.canu_v1.reads.sam | samtools sort - > c_incerta.canu_v1.reads.bam
samtools index c_incerta.canu_v1.reads.bam

export BLASTDB=/scratch/ncbi/blastdbs
blastn -task megablast -query ../v1_out/c_incerta.contigs.fasta -db nt -outfmt '6 qseqid staxids bitscore std' -max_target_seqs 1 -max_hsps 1 -num_threads 32 -evalue 1e-25 -out c_incerta.canu_v1.vs.nt.mts1.hsp1.1e25.megablast.out 


blobtools create -i ../v1_out/c_incerta.contigs.fasta -s c_incerta.canu_v1.reads.sam -t c_incerta.canu_v1.vs.nt.mts1.hsp1.1e25.megablast.out -o blobtools_canu_v1
blobtools view -i blobtools_canu_v1.blobDB.json
blobtools plot -i blobtools_canu_v1.blobDB.json
```

Extract non-contaminant reads from Canu assembly

```
perl ../preliminary_blobtools/extract_taxonomy.pl --table blobtools_canu_v1.blobDB.table.txt --list no-hit,Chlorophyta --out usable_contigs.txt
samtools faidx v1_out/c_incerta.contigs.fasta
perl ../preliminary_blobtools/fai2bed.pl --fai v1_out/c_incerta.contigs.fasta.fai --out c_incerta.contigs.bed
grep -f usable_contigs.txt c_incerta.contigs.bed > usable_contigs.bed
samtools view -b -L usable_contigs.bed c_incerta.canu_v1.reads.bam > usable_reads.bam
samtools fasta -0 usable_reads.fa usable_reads.bam
samtools view -b -f4 c_incerta.canu_v1.reads.bam > unmapped_reads.bam
samtools fasta -0 unmapped_reads.fa unmapped_reads.bam
cat usable_reads.fa unmapped_reads.fa > canu_v2.reads.fa
grep ">" canu_v2.reads.fa | cut -c2- > canu_v2.reads.txt

perl ../preliminary_blobtools/extract_taxonomy.pl --table blobtools_canu_v1.blobDB.table.txt --list Proteobacteria --out contaminant_contigs.txt
grep -f contaminant_contigs.txt c_incerta.contigs.bed > contaminant_contigs.bed
samtools view -b -L contaminant_contigs.bed c_incerta.canu_v1.reads.bam > contaminant_reads.bam
samtools fasta -0 contamiant_reads.fa contaminant_reads.bam
```

Re-run Canu with contaminant-free reads

```
canu -p c_incerta_canu_v2 -d v2_out genomeSize=130.8m -pacbio-raw canu_v2.reads.fa correctedErrorRate=0.065 corMhapSensitivity=normal maxThreads=48 gnuplotTested=true
```

