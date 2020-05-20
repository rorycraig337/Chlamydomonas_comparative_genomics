pbalign + arrow iteration 1

```
picard FilterSamReads I=../pacbio_reads/m54041_180619_131047.subreads.bam O=c_schloesseri.clean_pacbio.bam READ_LIST_FILE=../canu_v2.reads.txt FILTER=includeReadList VALIDATION_STRINGENCY=LENIENT

source ~/my_env/bin/activate
pbalign --nproc 24 c_schloesseri.clean_pacbio.bam ../canu/v2_out/c_schloesseri.contigs.fasta c_schloesseri_canu_v2.pbalign_v1.bam
samtools index c_schloesseri_canu_v2.pbalign_v1.bam
pbindex c_schloesseri_canu_v2.pbalign_v1.bam

arrow -j16 c_schloesseri_canu_v2.pbalign_v1.bam -r ../canu/v2_out/c_schloesseri.contigs.fasta -o c_schloesseri.canu_v2.arrow_v1.fa -o c_schloesseri.canu_v2.arrow_v1.fq -o c_schloesseri.canu_v2.arrow_v1.variants.gff
samtools faidx c_schloesseri.canu_v2.arrow_v1.fa
bwa index c_schloesseri.canu_v2.arrow_v1.fa
```
pbalign + arrow iteration 2

```
source ~/my_env/bin/activate
pbalign --nproc 24 c_schloesseri.clean_pacbio.bam c_schloesseri.canu_v2.arrow_v1.fa c_schloesseri_canu_v2.pbalign_v2.bam
samtools index c_schloesseri_canu_v2.pbalign_v2.bam
pbindex c_schloesseri_canu_v2.pbalign_v2.bam

arrow -j16 c_schloesseri_canu_v2.pbalign_v2.bam -r c_schloesseri.canu_v2.arrow_v1.fa -o c_schloesseri.canu_v2.arrow_v2.fa -o c_schloesseri.canu_v2.arrow_v2.fq -o c_schloesseri.canu_v2.arrow_v2.variants.gff
samtools faidx c_schloesseri.canu_v2.arrow_v2.fa
bwa index c_schloesseri.canu_v2.arrow_v2.fa
```

pbalign + arrow iteration 2

```
source ~/my_env/bin/activate
pbalign --nproc 48 c_schloesseri.clean_pacbio.bam c_schloesseri.canu_v2.arrow_v2.fa c_schloesseri_canu_v2.pbalign_v3.bam
samtools index c_schloesseri_canu_v2.pbalign_v3.bam
pbindex c_schloesseri_canu_v2.pbalign_v3.bam

arrow -j16 c_schloesseri_canu_v2.pbalign_v3.bam -r c_schloesseri.canu_v2.arrow_v2.fa -o c_schloesseri.canu_v2.arrow_v3.fa -o c_schloesseri.canu_v2.arrow_v3.fq -o c_schloesseri.canu_v2.arrow_v3.variants.gff
samtools faidx c_schloesseri.canu_v2.arrow_v3.fa
bwa index c_schloesseri.canu_v2.arrow_v3.fa
STAR --runThreadN 12 --runMode genomeGenerate --genomeDir ./ --genomeFastaFiles ./c_schloesseri.canu_v2.arrow_v3.fa
```
