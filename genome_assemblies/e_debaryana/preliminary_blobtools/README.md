Initial Miniasm assembly

```
minimap2 -x ava-pb -t16  ../pacbio_reads/c_debaryana.subreads.fa ../pacbio_reads/c_debaryana.subreads.fa | gzip -1 > c_debaryana.subreads.paf.gz
miniasm -f ../pacbio_reads/c_debaryana.subreads.fa c_debaryana.subreads.paf.gz > c_debaryana.miniasm_v1.gfa
awk '/^S/{print ">"$2"\n"$3}' c_debaryana.miniasm_v1.gfa > c_debaryana.miniasm_v1.fa
```

Run Blobtools - no contaminants

```
minimap2 -ax map-pb -t16 ../miniasm_v1/c_debaryana.miniasm_v1.fa ../pacbio_reads/c_debaryana.subreads.fa > c_debaryana.miniasm_v1.raw_reads.sam
samtools view -Sb c_debaryana.miniasm_v1.raw_reads.sam | samtools sort - > c_debaryana.miniasm_v1.raw_reads.bam
samtools index c_debaryana.miniasm_v1.raw_reads.bam

export BLASTDB=/scratch/ncbi/blastdbs
blastn -task megablast -query c_debaryana.miniasm_v1.fa -db nt -outfmt '6 qseqid staxids bitscore std' -max_target_seqs 1 -max_hsps 1 -num_threads 32 -evalue 1e-25 -out c_debaryana.miniasm_v1.vs.nt.mts1.hsp1.1e25.megablast.out

blobtools create -i ../miniasm_v1/c_debaryana.miniasm_v1.fa -s c_debaryana.miniasm_v1.raw_reads.sam -t c_debaryana.miniasm_v1.vs.nt.mts1.hsp1.1e25.megablast.out -o blobtools_v1
blobtools view -i blobtools_v1.blobDB.json
blobtools plot -i blobtools_v1.blobDB.json
```
