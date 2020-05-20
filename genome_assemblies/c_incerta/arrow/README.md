First iteration - extract BAM file of contaminant-free reads and map using pbalign

```
picard FilterSamReads I=../pacbio_reads/m54041_180618_163823.subreads.bam O=c_incerta.clean_pacbio.bam READ_LIST_FILE=../canu/canu_v2.reads.txt FILTER=includeReadList VALIDATION_STRINGENCY=LENIENT
source ~/my_env/bin/activate
pbalign --nproc 48 c_incerta.clean_pacbio.bam ../canu/v2_out/c_incerta_canu_v2.contigs.fasta c_incerta_canu_v2_pbalign_v1.sam
samtools view -Sb c_incerta_canu_v2_pbalign_v1.sam | samtools sort - > c_incerta_canu_v2_pbalign_v1.bam
samtools index c_incerta_canu_v2_pbalign_v1.bam
pbindex c_incerta_canu_v2_pbalign_v1.bam
```

Run arrow 

```
arrow -j16 c_incerta_canu_v2_pbalign_v1.bam -r ../canu/v2_out/c_incerta_canu_v2.contigs.fasta -o c_incerta.canu_v2.arrow_v1.fa -o c_incerta.canu_v2.arrow_v1.fq -o c_incerta.canu_v2.arrow_v1.variants.gff
samtools faidx c_incerta.canu_v2.arrow_v1.fa
```

Iteration 2

```
source ~/my_env/bin/activate
pbalign --nproc 48 c_incerta.clean_pacbio.bam c_incerta.canu_v2.arrow_v1.fa unsorted.bam &
samtools sort unsorted.bam > c_incerta_canu_v2.pbalign_v2.bam
rm unsorted.bam
samtools index c_incerta_canu_v2.pbalign_v2.bam
pbindex c_incerta_canu_v2.pbalign_v2.bam

arrow -j16 c_incerta_canu_v2.pbalign_v2.bam -r c_incerta.canu_v2.arrow_v1.fa -o c_incerta.canu_v2.arrow_v2.fa -o c_incerta.canu_v2.arrow_v2.fq -o c_incerta.canu_v2.arrow_v2.variants.gff &
samtools faidx c_incerta.canu_v2.arrow_v2.fa
```

Iteration 3

```
source ~/my_env/bin/activate
pbalign --nproc 32 c_incerta.clean_pacbio.bam c_incerta.canu_v2.arrow_v2.fa c_incerta_canu_v2.pbalign_v3.bam
samtools index c_incerta_canu_v2.pbalign_v3.bam
pbindex c_incerta_canu_v2.pbalign_v3.bam

arrow -j16 c_incerta_canu_v2.pbalign_v3.bam -r c_incerta.canu_v2.arrow_v2.fa -o c_incerta.canu_v2.arrow_v3.fa -o c_incerta.canu_v2.arrow_v3.fq -o c_incerta.canu_v2.arrow_v3.variants.gff &
samtools faidx c_incerta.canu_v2.arrow_v3.fa
```

Index polished genome for Illumina mapping

```
bwa index c_incerta.canu_v2.arrow_v3.fa
STAR --runThreadN 12 --runMode genomeGenerate --genomeDir ./ --genomeFastaFiles ./c_incerta.canu_v2.arrow_v3.fa
```
