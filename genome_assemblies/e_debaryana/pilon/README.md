Pilon 1

```
pilon --genome ../arrow/c_debaryana.canu_v1.arrow_v3.fa --frags ../illumina_preprocessing/c_debaryana.PE.no-dupes.bam --frags ../illumina_preprocessing/c_debaryana.RNAseq.bam --output c_debaryana.canu_v1.arrow_v3.pilon_v1 --changes --fix bases -Xmx260G
perl ../../c_incerta/pilon/restore_pilon_indels.pl --genome c_debaryana.canu_v1.arrow_v3.pilon_v1.fasta --changes c_debaryana.canu_v1.arrow_v3.pilon_v1.changes --min_indel 5 --out c_debaryana.canu_v1.arrow_v3.pilon_v1.fa
bwa index c_debaryana.canu_v1.arrow_v3.pilon_v1.fa
STAR --runThreadN 12 --runMode genomeGenerate --genomeDir ./ --genomeFastaFiles ./c_debaryana.canu_v1.arrow_v3.pilon_v1.fa
```

Pilon 2

```
bwa mem -t 32 c_debaryana.canu_v1.arrow_v3.pilon_v1.fa ../illumina_preprocessing/c_debaryana.PE.1.no-dupes.fastq.gz ../illumina_preprocessing/c_debaryana.PE.2.no-dupes.fastq.gz | samtools view -Sb - > temp.c_debaryana.pilon2.bam
samtools sort temp.c_debaryana.pilon2.bam > c_debaryana.pilon2.bam
samtools index c_debaryana.pilon2.bam

STAR --runThreadN 20 --genomeDir ./ --readFilesIn ../illumina_preprocessing/c_debaryana.RNAseq.1.P.fq.gz ../illumina_preprocessing/c_debaryana.RNAseq.2.P.fq.gz --readFilesCommand zcat --twopassMode Basic --outSAMtype BAM Unsorted
samtools sort Aligned.out.bam > c_debaryana.RNAseq.pilon2.bam
samtools index c_debaryana.RNAseq.pilon2.bam

pilon --genome c_debaryana.canu_v1.arrow_v3.pilon_v1.fa --frags c_debaryana.pilon2.bam --frags c_debaryana.RNAseq.pilon2.bam --output c_debaryana.canu_v1.arrow_v3.pilon_v2 --changes --fix bases -Xmx260G
perl ../../c_incerta/pilon/restore_pilon_indels.pl --genome c_debaryana.canu_v1.arrow_v3.pilon_v2.fasta --changes c_debaryana.canu_v1.arrow_v3.pilon_v2.changes --min_indel 5 --out c_debaryana.canu_v1.arrow_v3.pilon_v2.fa
bwa index c_debaryana.canu_v1.arrow_v3.pilon_v2.fa
STAR --runThreadN 12 --runMode genomeGenerate --genomeDir ./ --genomeFastaFiles ./c_debaryana.canu_v1.arrow_v3.pilon_v2.fa

rm temp*
```

Pilon 3

```
bwa mem -t 32 c_debaryana.canu_v1.arrow_v3.pilon_v2.fa ../illumina_preprocessing/c_debaryana.PE.1.no-dupes.fastq.gz ../illumina_preprocessing/c_debaryana.PE.2.no-dupes.fastq.gz | samtools view -Sb - > temp.c_debaryana.pilon3.bam
samtools sort temp.c_debaryana.pilon3.bam > c_debaryana.pilon3.bam
samtools index c_debaryana.pilon3.bam

STAR --runThreadN 20 --genomeDir ./ --readFilesIn ../illumina_preprocessing/c_debaryana.RNAseq.1.P.fq.gz ../illumina_preprocessing/c_debaryana.RNAseq.2.P.fq.gz --readFilesCommand zcat --twopassMode Basic --outSAMtype BAM Unsorted
samtools sort Aligned.out.bam > c_debaryana.RNAseq.pilon3.bam
samtools index c_debaryana.RNAseq.pilon3.bam

pilon --genome c_debaryana.canu_v1.arrow_v3.pilon_v2.fa --frags c_debaryana.pilon3.bam --frags c_debaryana.RNAseq.pilon3.bam --output c_debaryana.canu_v1.arrow_v3.pilon_v3 --changes --fix bases -Xmx260G
perl ../../c_incerta/pilon/restore_pilon_indels.pl --genome c_debaryana.canu_v1.arrow_v3.pilon_v3.fasta --changes c_debaryana.canu_v1.arrow_v3.pilon_v3.changes --min_indel 5 --out c_debaryana.canu_v1.arrow_v3.pilon_v3.fa
bwa index c_debaryana.canu_v1.arrow_v3.pilon_v3.fa

rm temp*
```
