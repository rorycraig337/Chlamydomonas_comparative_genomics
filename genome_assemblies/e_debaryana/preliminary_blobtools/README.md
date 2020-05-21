Initial Miniasm assembly

```
minimap2 -x ava-pb -t16  ../pacbio_reads/c_debaryana.subreads.fa ../pacbio_reads/c_debaryana.subreads.fa | gzip -1 > c_debaryana.subreads.paf.gz
miniasm -f ../pacbio_reads/c_debaryana.subreads.fa c_debaryana.subreads.paf.gz > c_debaryana.miniasm_v1.gfa
awk '/^S/{print ">"$2"\n"$3}' c_debaryana.miniasm_v1.gfa > c_debaryana.miniasm_v1.fa
```

Run Blobtools

```
minimap2 -ax map-pb -t16 ../miniasm_v1/c_debaryana.miniasm_v1.fa ../pacbio_reads/c_debaryana.subreads.fa > c_debaryana.miniasm_v1.raw_reads.sam
samtools view -Sb c_debaryana.miniasm_v1.raw_reads.sam | samtools sort - > c_debaryana.miniasm_v1.raw_reads.bam
samtools index c_debaryana.miniasm_v1.raw_reads.bam

export BLASTDB=/scratch/ncbi/blastdbs
blastn -task megablast -query c_debaryana.miniasm_v1.fa -db nt -outfmt '6 qseqid staxids bitscore std' -max_target_seqs 1 -max_hsps 1 -num_threads 32 -evalue 1e-25 -out c_debaryana.miniasm_v1.vs.nt.mts1.hsp1.1e25.megablast.out

blobtools create -i ../miniasm_v1/c_debaryana.miniasm_v1.fa -s c_debaryana.miniasm_v1.raw_reads.sam -t c_debaryana.miniasm_v1.vs.nt.mts1.hsp1.1e25.megablast.out -o blobtools_v1
blobtools view -i blobtools_v1.blobDB.json
blobtools plot -i blobtools_v1.blobDB.json

perl ../../c_incerta/preliminary_blobtools/extract_contigs.pl --table blobtools_v1.blobDB.table.txt --contam_list Proteobacteria --passed passed_contigs.txt --contaminants contaminant_contings.txt --no_hits no-hit_contigs.txt
cat no-hit_contigs.txt contaminant_contings.txt | sort > rerun_contigs.txt
samtools faidx c_incerta.miniasm_v1.fa
perl ../../c_incerta/preliminary_blobtools/fai2bed.pl --fai c_incerta.miniasm_v1.fa.fai --out c_incerta.miniasm_v1.bed
grep -f rerun_contigs.txt c_incerta.miniasm_v1.bed > rerun_contigs.bed
samtools view -b -L rerun_contigs.bed c_incerta.miniasm_v1.raw_reads.bam > rerun_reads.bam
samtools fasta -0 rerun_reads.fa rerun_reads.bam
samtools view -b -f4 c_incerta.miniasm_v1.raw_reads.bam > unmapped_reads.bam
samtools fasta -0 unmapped_reads.fa unmapped_reads.bam
cat rerun_reads.fa unmapped_reads.fa > miniasm_contaminants_reads.fa
sort passed_contigs.txt > s_passed_contigs.txt
grep -f s_passed_contigs.txt c_incerta.miniasm_v1.bed > passed_contigs.bed
samtools view -b -L passed_contigs.bed c_incerta.miniasm_v1.raw_reads.bam > passed_reads.bam
samtools fasta -0 passed_reads.fa passed_reads.bam
```

No contaminants
