Trim reads 



```
bbduk.sh in1=c_schloesseri.BGI_125bp.1.fwd.fastq.gz in2=c_schloesseri.BGI_125bp.1.rev.fastq.gz out1=c_schloesseri.PE1.1.fastq.gz  out2=c_schloesseri.PE1.2.fastq.gz ref=/opt/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tbo
bbduk.sh in1=c_schloesseri.BGI_125bp.2.fwd.fastq.gz in2=c_schloesseri.BGI_125bp.2.rev.fastq.gz out1=c_schloesseri.PE2.1.fastq.gz  out2=c_schloesseri.PE2.2.fastq.gz ref=/opt/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tbo
bbduk.sh in1=c_schloesseri.BGI_125bp.3.fwd.fastq.gz in2=c_schloesseri.BGI_125bp.3.rev.fastq.gz out1=c_schloesseri.PE3.1.fastq.gz  out2=c_schloesseri.PE3.2.fastq.gz ref=/opt/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tbo
bbduk.sh in1=c_schloesseri.BGI_125bp.4.fwd.fastq.gz in2=c_schloesseri.BGI_125bp.4.rev.fastq.gz out1=c_schloesseri.PE4.1.fastq.gz  out2=c_schloesseri.PE4.2.fastq.gz ref=/opt/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tbo
```

Remove PCR duplicates and first mapping foreach library

```
bwa mem -t 32 ../arrow/c_schloesseri.canu_v2.arrow_v3.fa c_schloesseri.PE1.1.fastq.gz c_schloesseri.PE1.2.fastq.gz | samtools view -Sb - > temp.c_schloesseri.PE1.bam
samtools sort temp.c_schloesseri.PE1.bam > c_schloesseri.PE1.bam
samtools flagstat c_schloesseri.PE1.bam > c_schloesseri.PE1.flagstat.txt
samtools index c_schloesseri.PE1.bam
rm temp*

picard MarkDuplicates I=c_schloesseri.PE1.bam O=c_schloesseri.PE1.no-dupes.bam M=c_schloesseri.PE1.dupes.txt REMOVE_DUPLICATES=true
samtools sort -n c_schloesseri.PE1.no-dupes.bam > c_schloesseri.PE1.no-dupes.n.bam
samtools fastq -1 c_schloesseri.PE1.1.no-dupes.fastq.gz -2 c_schloesseri.PE1.2.no-dupes.fastq.gz -s c_schloesseri.PE1.singles.no-dupes.fastq.gz c_schloesseri.PE1.no-dupes.n.bam
rm *n.bam

bwa mem -t 32 ../arrow/c_schloesseri.canu_v2.arrow_v3.fa c_schloesseri.PE1.1.no-dupes.fastq.gz c_schloesseri.PE1.2.no-dupes.fastq.gz | samtools view -Sb - > temp.c_schloesseri.PE1.no-dupes.bam
samtools sort temp.c_schloesseri.PE1.no-dupes.bam > c_schloesseri.PE1.no-dupes.bam
samtools flagstat c_schloesseri.PE1.no-dupes.bam > c_schloesseri.PE1.no-dupes.flagstat.txt
samtools index c_schloesseri.PE1.no-dupes.bam
rm temp*

bwa mem -t 32 ../arrow/c_schloesseri.canu_v2.arrow_v3.fa c_schloesseri.PE2.1.fastq.gz c_schloesseri.PE2.2.fastq.gz | samtools view -Sb - > temp.c_schloesseri.PE2.bam
samtools sort temp.c_schloesseri.PE2.bam > c_schloesseri.PE2.bam
samtools flagstat c_schloesseri.PE2.bam > c_schloesseri.PE2.flagstat.txt
samtools index c_schloesseri.PE2.bam
rm temp*

picard MarkDuplicates I=c_schloesseri.PE2.bam O=c_schloesseri.PE2.no-dupes.bam M=c_schloesseri.PE2.dupes.txt REMOVE_DUPLICATES=true
samtools sort -n c_schloesseri.PE2.no-dupes.bam > c_schloesseri.PE2.no-dupes.n.bam
samtools fastq -1 c_schloesseri.PE2.1.no-dupes.fastq.gz -2 c_schloesseri.PE2.2.no-dupes.fastq.gz -s c_schloesseri.PE2.singles.no-dupes.fastq.gz c_schloesseri.PE2.no-dupes.n.bam
rm *n.bam

bwa mem -t 32 ../arrow/c_schloesseri.canu_v2.arrow_v3.fa c_schloesseri.PE2.1.no-dupes.fastq.gz c_schloesseri.PE2.2.no-dupes.fastq.gz | samtools view -Sb - > temp.c_schloesseri.PE2.no-dupes.bam
samtools sort temp.c_schloesseri.PE2.no-dupes.bam > c_schloesseri.PE2.no-dupes.bam
samtools flagstat c_schloesseri.PE2.no-dupes.bam > c_schloesseri.PE2.no-dupes.flagstat.txt
samtools index c_schloesseri.PE2.no-dupes.bam
rm temp*

bwa mem -t 32 ../arrow/c_schloesseri.canu_v2.arrow_v3.fa c_schloesseri.PE3.1.fastq.gz c_schloesseri.PE3.2.fastq.gz | samtools view -Sb - > temp.c_schloesseri.PE3.bam
samtools sort temp.c_schloesseri.PE3.bam > c_schloesseri.PE3.bam
samtools flagstat c_schloesseri.PE3.bam > c_schloesseri.PE3.flagstat.txt
samtools index c_schloesseri.PE3.bam
rm temp*

picard MarkDuplicates I=c_schloesseri.PE3.bam O=c_schloesseri.PE3.no-dupes.bam M=c_schloesseri.PE3.dupes.txt REMOVE_DUPLICATES=true
samtools sort -n c_schloesseri.PE3.no-dupes.bam > c_schloesseri.PE3.no-dupes.n.bam
samtools fastq -1 c_schloesseri.PE3.1.no-dupes.fastq.gz -2 c_schloesseri.PE3.2.no-dupes.fastq.gz -s c_schloesseri.PE3.singles.no-dupes.fastq.gz c_schloesseri.PE3.no-dupes.n.bam
rm *n.bam

bwa mem -t 32 ../arrow/c_schloesseri.canu_v2.arrow_v3.fa c_schloesseri.PE3.1.no-dupes.fastq.gz c_schloesseri.PE3.2.no-dupes.fastq.gz | samtools view -Sb - > temp.c_schloesseri.PE3.no-dupes.bam
samtools sort temp.c_schloesseri.PE3.no-dupes.bam > c_schloesseri.PE3.no-dupes.bam
samtools flagstat c_schloesseri.PE3.no-dupes.bam > c_schloesseri.PE3.no-dupes.flagstat.txt
samtools index c_schloesseri.PE3.no-dupes.bam
rm temp*

bwa mem -t 32 ../arrow/c_schloesseri.canu_v2.arrow_v3.fa c_schloesseri.PE4.1.fastq.gz c_schloesseri.PE4.2.fastq.gz | samtools view -Sb - > temp.c_schloesseri.PE4.bam
samtools sort temp.c_schloesseri.PE4.bam > c_schloesseri.PE4.bam
samtools flagstat c_schloesseri.PE4.bam > c_schloesseri.PE4.flagstat.txt
samtools index c_schloesseri.PE4.bam
rm temp*

picard MarkDuplicates I=c_schloesseri.PE4.bam O=c_schloesseri.PE4.no-dupes.bam M=c_schloesseri.PE4.dupes.txt REMOVE_DUPLICATES=true
samtools sort -n c_schloesseri.PE4.no-dupes.bam > c_schloesseri.PE4.no-dupes.n.bam
samtools fastq -1 c_schloesseri.PE4.1.no-dupes.fastq.gz -2 c_schloesseri.PE4.2.no-dupes.fastq.gz -s c_schloesseri.PE4.singles.no-dupes.fastq.gz c_schloesseri.PE4.no-dupes.n.bam
rm *n.bam

bwa mem -t 32 ../arrow/c_schloesseri.canu_v2.arrow_v3.fa c_schloesseri.PE4.1.no-dupes.fastq.gz c_schloesseri.PE4.2.no-dupes.fastq.gz | samtools view -Sb - > temp.c_schloesseri.PE4.no-dupes.bam
samtools sort temp.c_schloesseri.PE4.no-dupes.bam > c_schloesseri.PE4.no-dupes.bam
samtools flagstat c_schloesseri.PE4.no-dupes.bam > c_schloesseri.PE4.no-dupes.flagstat.txt
samtools index c_schloesseri.PE4.no-dupes.bam
rm temp*
```

Trim and map RNA-seq library

```
java -jar ~/programs/Trimmomatic-0.38/trimmomatic-0.38.jar PE FCHYYM7CCXY_L2_HKRDCHLpuqEAAARAAPEI-225_1.fq.gz FCHYYM7CCXY_L2_HKRDCHLpuqEAAARAAPEI-225_2.fq.gz c_schloesseri.RNAseq.1.P.fq.gz c_schloesseri.RNAseq.1.U.fq.gz c_schloesseri.RNAseq.2.P.fq.gz c_schloesseri.RNAseq.2.U.fq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:3 MINLEN:25

STAR --runThreadN 32 --genomeDir ../arrow/ --readFilesIn c_schloesseri.RNAseq.1.P.fq.gz c_schloesseri.RNAseq.2.P.fq.gz --readFilesCommand zcat --twopassMode Basic --outSAMtype BAM Unsorted
samtools sort Aligned.out.bam > c_schloesseri.RNAseq.bam
samtools flagstat c_schloesseri.RNAseq.bam > c_schloesseri.RNAseq.flagstat.txt
samtools index c_schloesseri.RNAseq.bam
```
