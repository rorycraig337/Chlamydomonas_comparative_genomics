Run Canu using unfiltered reads and genome size estimate from Miniasm

```
canu -p c_debaryana -d v1_out genomeSize=148.9m -pacbio-raw ../pacbio_reads/c_debaryana.subreads.fa correctedErrorRate=0.065 corMhapSensitivity=normal maxThreads=24 gnuplotTested=true
```

Run Blobtools on Canu assembly - no contaminants

```
minimap2 -ax map-pb -t24 v1_out/c_debaryana.contigs.fasta ../pacbio_reads/c_debaryana.subreads.fa > c_debaryana.canu_v1.reads.sam
samtools view -Sb c_debaryana.canu_v1.reads.sam | samtools sort - > c_debaryana.canu_v1.reads.bam
samtools index c_debaryana.canu_v1.reads.bam

export BLASTDB=/scratch/ncbi/blastdbs
blastn -task megablast -query v1_out/c_debaryana.contigs.fasta -db nt -outfmt '6 qseqid staxids bitscore std' -max_target_seqs 1 -max_hsps 1 -num_threads 24 -evalue 1e-25 -out c_debaryana.canu_v1.vs.nt.mts1.hsp1.1e25.megablast.out

blobtools create -i v1_out/c_debaryana.contigs.fasta -s c_debaryana.canu_v1.reads.sam -t c_debaryana.canu_v1.vs.nt.mts1.hsp1.1e25.megablast.out -o blobtools_canu_v1
blobtools view -i blobtools_canu_v1.blobDB.json
blobtools plot -i blobtools_canu_v1.blobDB.json
```
