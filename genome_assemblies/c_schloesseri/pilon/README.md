Pilon 1

```
pilon --genome ../arrow/c_schloesseri.canu_v2.arrow_v3.fa --frags ../illumina_preprocessing/c_schloesseri.PE1.no-dupes.bam --frags ../illumina_preprocessing/c_schloesseri.PE2.no-dupes.bam --frags ../illumina_preprocessing/c_schloesseri.PE3.no-dupes.bam --frags ../illumina_preprocessing/c_schloesseri.PE4.no-dupes.bam --frags ../illumina_preprocessing/c_schloesseri.RNAseq.bam --output c_schloesseri.canu_v2.arrow_v3.pilon_v1 --changes --fix bases -Xmx260G
perl /../../c_incerta/pilon/restore_pilon_indels.pl --genome c_schloesseri.canu_v2.arrow_v3.pilon_v1.fasta --changes c_schloesseri.canu_v2.arrow_v3.pilon_v1.changes --min_indel 5 --out c_schloesseri.canu_v2.arrow_v3.pilon_v1.fa
bwa index c_schloesseri.canu_v2.arrow_v3.pilon_v1.fa
STAR --runThreadN 12 --runMode genomeGenerate --genomeDir ./ --genomeFastaFiles ./c_schloesseri.canu_v2.arrow_v3.pilon_v1.fa
```

Pilon 2

```
bwa mem -t 32 c_schloesseri.canu_v2.arrow_v3.pilon_v1.fa ../illumina_preprocessing/c_schloesseri.PE1.1.no-dupes.fastq.gz ../illumina_preprocessing/c_schloesseri.PE1.2.no-dupes.fastq.gz | samtools view -Sb - > temp.c_schloesseri.PE1.pilon2.bam
samtools sort temp.c_schloesseri.PE1.pilon2.bam > c_schloesseri.PE1.pilon2.bam
samtools index c_schloesseri.PE1.pilon2.bam

bwa mem -t 32 c_schloesseri.canu_v2.arrow_v3.pilon_v1.fa ../illumina_preprocessing/c_schloesseri.PE2.1.no-dupes.fastq.gz ../illumina_preprocessing/c_schloesseri.PE2.2.no-dupes.fastq.gz | samtools view -Sb - > temp.c_schloesseri.PE2.pilon2.bam
samtools sort temp.c_schloesseri.PE2.pilon2.bam > c_schloesseri.PE2.pilon2.bam
samtools index c_schloesseri.PE2.pilon2.bam

bwa mem -t 32 c_schloesseri.canu_v2.arrow_v3.pilon_v1.fa ../illumina_preprocessing/c_schloesseri.PE3.1.no-dupes.fastq.gz ../illumina_preprocessing/c_schloesseri.PE3.2.no-dupes.fastq.gz | samtools view -Sb - > temp.c_schloesseri.PE3.pilon2.bam
samtools sort temp.c_schloesseri.PE3.pilon2.bam > c_schloesseri.PE3.pilon2.bam
samtools index c_schloesseri.PE3.pilon2.bam

bwa mem -t 32 c_schloesseri.canu_v2.arrow_v3.pilon_v1.fa ../illumina_preprocessing/c_schloesseri.PE4.1.no-dupes.fastq.gz ../illumina_preprocessing/c_schloesseri.PE4.2.no-dupes.fastq.gz | samtools view -Sb - > temp.c_schloesseri.PE4.pilon2.bam
samtools sort temp.c_schloesseri.PE4.pilon2.bam > c_schloesseri.PE4.pilon2.bam
samtools index c_schloesseri.PE4.pilon2.bam

STAR --runThreadN 20 --genomeDir ./ --readFilesIn ../illumina_preprocessing/c_schloesseri.RNAseq.1.P.fq.gz ../illumina_preprocessing/c_schloesseri.RNAseq.2.P.fq.gz --readFilesCommand zcat --twopassMode Basic --outSAMtype BAM Unsorted
samtools sort Aligned.out.bam > c_schloesseri.RNAseq.pilon2.bam
samtools index c_schloesseri.RNAseq.pilon2.bam

rm temp*

pilon --genome c_schloesseri.canu_v2.arrow_v3.pilon_v1.fa --frags c_schloesseri.PE1.pilon2.bam --frags c_schloesseri.PE2.pilon2.bam --frags c_schloesseri.PE3.pilon2.bam --frags c_schloesseri.PE4.pilon2.bam --frags c_schloesseri.RNAseq.pilon2.bam --output c_schloesseri.canu_v2.arrow_v3.pilon_v2 --changes --fix bases -Xmx260G
perl /../../c_incerta/pilon/restore_pilon_indels.pl --genome c_schloesseri.canu_v2.arrow_v3.pilon_v2.fasta --changes c_schloesseri.canu_v2.arrow_v3.pilon_v2.changes --min_indel 5 --out c_schloesseri.canu_v2.arrow_v3.pilon_v2.fa
bwa index c_schloesseri.canu_v2.arrow_v3.pilon_v2.fa
STAR --runThreadN 12 --runMode genomeGenerate --genomeDir ./ --genomeFastaFiles ./c_schloesseri.canu_v2.arrow_v3.pilon_v2.fa
```

Pilon 3

```
bwa mem -t 32 c_schloesseri.canu_v2.arrow_v3.pilon_v2.fa ../illumina_preprocessing/c_schloesseri.PE1.1.no-dupes.fastq.gz ../illumina_preprocessing/c_schloesseri.PE1.2.no-dupes.fastq.gz | samtools view -Sb - > temp.c_schloesseri.PE1.pilon3.bam
samtools sort temp.c_schloesseri.PE1.pilon3.bam > c_schloesseri.PE1.pilon3.bam
samtools index c_schloesseri.PE1.pilon3.bam

bwa mem -t 32 c_schloesseri.canu_v2.arrow_v3.pilon_v2.fa ../illumina_preprocessing/c_schloesseri.PE2.1.no-dupes.fastq.gz ../illumina_preprocessing/c_schloesseri.PE2.2.no-dupes.fastq.gz | samtools view -Sb - > temp.c_schloesseri.PE2.pilon3.bam
samtools sort temp.c_schloesseri.PE2.pilon3.bam > c_schloesseri.PE2.pilon3.bam
samtools index c_schloesseri.PE2.pilon3.bam

bwa mem -t 32 c_schloesseri.canu_v2.arrow_v3.pilon_v2.fa ../illumina_preprocessing/c_schloesseri.PE3.1.no-dupes.fastq.gz ../illumina_preprocessing/c_schloesseri.PE3.2.no-dupes.fastq.gz | samtools view -Sb - > temp.c_schloesseri.PE3.pilon3.bam
samtools sort temp.c_schloesseri.PE3.pilon3.bam > c_schloesseri.PE3.pilon3.bam
samtools index c_schloesseri.PE3.pilon3.bam

bwa mem -t 32 c_schloesseri.canu_v2.arrow_v3.pilon_v2.fa ../illumina_preprocessing/c_schloesseri.PE4.1.no-dupes.fastq.gz ../illumina_preprocessing/c_schloesseri.PE4.2.no-dupes.fastq.gz | samtools view -Sb - > temp.c_schloesseri.PE4.pilon3.bam
samtools sort temp.c_schloesseri.PE4.pilon3.bam > c_schloesseri.PE4.pilon3.bam
samtools index c_schloesseri.PE4.pilon3.bam

STAR --runThreadN 20 --genomeDir ./ --readFilesIn ../illumina_preprocessing/c_schloesseri.RNAseq.1.P.fq.gz ../illumina_preprocessing/c_schloesseri.RNAseq.2.P.fq.gz --readFilesCommand zcat --twopassMode Basic --outSAMtype BAM Unsorted
samtools sort Aligned.out.bam > c_schloesseri.RNAseq.pilon3.bam
samtools index c_schloesseri.RNAseq.pilon3.bam

rm temp*

pilon --genome ../pilon_2/c_schloesseri.canu_v2.arrow_v3.pilon_v2.fa --frags c_schloesseri.PE1.pilon3.bam --frags c_schloesseri.PE2.pilon3.bam --frags c_schloesseri.PE3.pilon3.bam --frags c_schloesseri.PE4.pilon3.bam --frags c_schloesseri.RNAseq.pilon3.bam --output c_schloesseri.canu_v2.arrow_v3.pilon_v3 --changes --fix bases -Xmx260G
perl /../../c_incerta/pilon/restore_pilon_indels.pl --genome c_schloesseri.canu_v2.arrow_v3.pilon_v3.fasta --changes c_schloesseri.canu_v2.arrow_v3.pilon_v3.changes --min_indel 5 --out c_schloesseri.canu_v2.arrow_v3.pilon_v3.fa
bwa index c_schloesseri.canu_v2.arrow_v3.pilon_v3.fa
samtools faidx c_schloesseri.canu_v2.arrow_v3.pilon_v3.fa
```
