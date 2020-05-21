pbalign + arrow 1

```
source ~/my_env/bin/activate
pbalign --nproc 24 ../pacbio_reads/m54041_180619_025334.subreads.bam ../canu/v1_out/c_debaryana.contigs.fasta c_debaryana_canu_v1.pbalign_v1.bam
samtools index c_debaryana_canu_v1.pbalign_v1.bam
pbindex c_debaryana_canu_v1.pbalign_v1.bam

arrow -j16 c_debaryana_canu_v1.pbalign_v1.bam -r ../canu/v1_out/c_debaryana.contigs.fasta -o c_debaryana.canu_v1.arrow_v1.fa -o c_debaryana.canu_v1.arrow_v1.fq -o c_debaryana.canu_v1.arrow_v1.variants.gff
samtools faidx c_debaryana.canu_v1.arrow_v1.fa
bwa index c_debaryana.canu_v1.arrow_v1.fa
```

pbalign + arrow 2

```
source ~/my_env/bin/activate
pbalign --nproc 32 ../pacbio_reads/m54041_180619_025334.subreads.bam c_debaryana.canu_v1.arrow_v1.fa c_debaryana_canu_v1.pbalign_v2.bam
samtools index c_debaryana_canu_v1.pbalign_v2.bam
pbindex c_debaryana_canu_v1.pbalign_v2.bam

arrow -j16 c_debaryana_canu_v1.pbalign_v2.bam -r c_debaryana.canu_v1.arrow_v1.fa -o c_debaryana.canu_v1.arrow_v2.fa -o c_debaryana.canu_v1.arrow_v2.fq -o c_debaryana.canu_v1.arrow_v2.variants.gff
samtools faidx c_debaryana.canu_v1.arrow_v2.fa
bwa index c_debaryana.canu_v1.arrow_v2.fa
```

pbalign + arrow 3

```
source ~/my_env/bin/activate
pbalign --nproc 16 ../pacbio_reads/m54041_180619_025334.subreads.bam c_debaryana.canu_v1.arrow_v2.fa c_debaryana_canu_v1.pbalign_v3.bam
samtools index c_debaryana_canu_v1.pbalign_v3.bam
pbindex c_debaryana_canu_v1.pbalign_v3.bam

arrow -j16 c_debaryana_canu_v1.pbalign_v3.bam -r c_debaryana.canu_v1.arrow_v2.fa -o c_debaryana.canu_v1.arrow_v3.fa -o c_debaryana.canu_v1.arrow_v3.fq -o c_debaryana.canu_v1.arrow_v3.variants.gff
samtools faidx c_debaryana.canu_v1.arrow_v3.fa
bwa index c_debaryana.canu_v1.arrow_v3.fa
STAR --runThreadN 12 --runMode genomeGenerate --genomeDir ./ --genomeFastaFiles ./c_debaryana.canu_v1.arrow_v3.fa
```
