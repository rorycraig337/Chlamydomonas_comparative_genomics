Trim reads with BBDUK

```
bbduk.sh in1=Cincerta_wt.BGI.180bp.1.fwd.fastq.gz in2=Cincerta_wt.BGI.180bp.1.rev.fastq.gz out1=c_incerta.PE1.1.fastq.gz out2=c_incerta.PE1.2.fastq.gz ref=~/software/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tbo
bbduk.sh in1=Cincerta_wt.BGI.180bp.2.fwd.fastq.gz in2=Cincerta_wt.BGI.180bp.2.rev.fastq.gz out1=c_incerta.PE2.1.fastq.gz out2=c_incerta.PE2.2.fastq.gz ref=~/software/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tbo
```

Map trimmed reads and remove PCR duplicates

```
bwa mem -t 8 ../arrow/c_incerta.canu_v2.arrow_v3.fa c_incerta.PE1.1.fastq.gz c_incerta.PE1.2.fastq.gz | samtools view -Sb - > temp.c_incerta.PE1.bam
samtools sort temp.c_incerta.PE1.bam > c_incerta.PE1.bam
samtools flagstat c_incerta.PE1.bam > c_incerta.PE1.flagstat.txt
samtools index c_incerta.PE1.bam

bwa mem -t 8 ../arrow/c_incerta.canu_v2.arrow_v3.fa c_incerta.PE2.1.fastq.gz c_incerta.PE2.2.fastq.gz | samtools view -Sb - > temp.c_incerta.PE2.bam
samtools sort temp.c_incerta.PE2.bam > c_incerta.PE2.bam
samtools flagstat c_incerta.PE2.bam > c_incerta.PE2.flagstat.txt
samtools index c_incerta.PE2.bam

picard MarkDuplicates I=c_incerta.PE1.bam O=c_incerta.PE1.no-dupes.bam M=c_incerta.PE1.dupes.txt REMOVE_DUPLICATES=true
picard MarkDuplicates I=c_incerta.PE2.bam O=c_incerta.PE2.no-dupes.bam M=c_incerta.PE2.dupes.txt REMOVE_DUPLICATES=true

rm temp*

samtools sort -n c_incerta.PE1.no-dupes.bam > c_incerta.PE1.no-dupes.n.bam
samtools sort -n c_incerta.PE2.no-dupes.bam > c_incerta.PE2.no-dupes.n.bam
samtools fastq -1 c_incerta.PE1.1.no-dupes.fastq.gz -2 c_incerta.PE1.2.no-dupes.fastq.gz -s c_incerta.PE1.singles.no-dupes.fastq.gz c_incerta.PE1.no-dupes.n.bam
samtools fastq -1 c_incerta.PE2.1.no-dupes.fastq.gz -2 c_incerta.PE2.2.no-dupes.fastq.gz -s c_incerta.PE2.singles.no-dupes.fastq.gz c_incerta.PE2.no-dupes.n.bam

rm *n.bam
```

Merge paired-end reads (100 bp reads, 180 bp insert size)

```
bbmerge-auto.sh in1=c_incerta.PE1.1.no-dupes.fastq.gz in2=c_incerta.PE1.2.no-dupes.fastq.gz out=c_incerta.PE1.merged.fq.gz outu=c_incerta.PE1.unmerged.fq.gz ihist=lib1_hist.txt
bbmerge-auto.sh in1=c_incerta.PE2.1.no-dupes.fastq.gz in2=c_incerta.PE2.2.no-dupes.fastq.gz out=c_incerta.PE2.merged.fq.gz outu=c_incerta.PE2.unmerged.fq.gz ihist=lib2_hist.txt
```

Map filtered merged and unmerged reads

```
bwa mem -t 32 ../arrow/c_incerta.canu_v2.arrow_v3.fa c_incerta.PE1.merged.fq.gz | samtools view -Sb - > temp.c_incerta.PE1.merged.bam
samtools sort temp.c_incerta.PE1.merged.bam > c_incerta.PE1.merged.bam
samtools flagstat c_incerta.PE1.merged.bam > c_incerta.PE1.merged.flagstat.txt
samtools index c_incerta.PE1.merged.bam

bwa mem -t 32 ../arrow/c_incerta.canu_v2.arrow_v3.fa c_incerta.PE2.merged.fq.gz | samtools view -Sb - | samtools sort - > temp.c_incerta.PE2.merged.bam
samtools sort temp.c_incerta.PE2.merged.bam > c_incerta.PE2.merged.bam
samtools flagstat c_incerta.PE2.merged.bam > c_incerta.PE2.merged.flagstat.txt
samtools index c_incerta.PE2.merged.bam

bwa mem -t 32 ../arrow/c_incerta.canu_v2.arrow_v3.fa -p c_incerta.PE1.unmerged.fq.gz | samtools view -Sb - > temp.c_incerta.PE1.unmerged.bam
samtools sort temp.c_incerta.PE1.unmerged.bam > c_incerta.PE1.unmerged.bam
samtools flagstat c_incerta.PE1.unmerged.bam > c_incerta.PE1.unmerged.flagstat.txt
samtools index c_incerta.PE1.unmerged.bam

bwa mem -t 32 ../arrow/c_incerta.canu_v2.arrow_v3.fa -p c_incerta.PE2.unmerged.fq.gz | samtools view -Sb - > temp.c_incerta.PE2.unmerged.bam
samtools sort temp.c_incerta.PE2.unmerged.bam > c_incerta.PE2.unmerged.bam
samtools flagstat c_incerta.PE2.unmerged.bam > c_incerta.PE2.unmerged.flagstat.txt
samtools index c_incerta.PE2.unmerged.bam

rm temp*
```
