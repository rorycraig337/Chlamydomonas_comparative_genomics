Trim Illumina reads

```
bbduk.sh in1=c_debaryana.BGI_150bp.fwd.fastq.gz in2=c_debaryana.BGI_150bp.rev.fastq.gz out1=c_debaryana.PE.1.fastq.gz  out2=c_debaryana.PE.2.fastq.gz ref=/opt/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tbo
```

Remove PCR duplicates

```
bwa mem -t 32 ../arrow/c_debaryana.canu_v1.arrow_v3.fa c_debaryana.PE.1.fastq.gz c_debaryana.PE.2.fastq.gz | samtools view -Sb - > temp.c_debaryana.PE.bam
samtools sort temp.c_debaryana.PE.bam > c_debaryana.PE.bam
samtools flagstat c_debaryana.PE.bam > c_debaryana.PE.flagstat.txt
samtools index c_debaryana.PE.bam

picard MarkDuplicates I=c_debaryana.PE.bam O=c_debaryana.PE.no-dupes.bam M=c_debaryana.PE.dupes.txt REMOVE_DUPLICATES=true

rm temp*

samtools sort -n c_debaryana.PE.no-dupes.bam > c_debaryana.PE.no-dupes.n.bam
samtools fastq -1 c_debaryana.PE.1.no-dupes.fastq.gz -2 c_debaryana.PE.2.no-dupes.fastq.gz -s c_debaryana.PE.singles.no-dupes.fastq.gz c_debaryana.PE.no-dupes.n.bam

rm *n.bam
```

Map reads to Canu + Arrow 3 assembly

```
bwa mem -t 32 ../arrow/c_debaryana.canu_v1.arrow_v3.fa c_debaryana.PE.1.no-dupes.fastq.gz c_debaryana.PE.2.no-dupes.fastq.gz | samtools view -Sb - > temp.c_debaryana.PE.no-dupes.bam
#amtools sort temp.c_debaryana.PE.no-dupes.bam > c_debaryana.PE.no-dupes.bam
samtools flagstat c_debaryana.PE.no-dupes.bam > c_debaryana.PE.no-dupes.flagstat.txt
samtools index c_debaryana.PE.no-dupes.bam

#rm temp*
```

Trim + map RNA-seq

```
cp ~/programs/Trimmomatic-0.38/adapters/TruSeq3-PE.fa .
java -jar ~/programs/Trimmomatic-0.38/trimmomatic-0.38.jar PE FCHYYM7CCXY_L2_HKRDCHLpuqEAABRAAPEI-227_1.fq.gz FCHYYM7CCXY_L2_HKRDCHLpuqEAABRAAPEI-227_2.fq.gz c_debaryana.RNAseq.1.P.fq.gz c_debaryana.RNAseq.1.U.fq.gz c_debaryana.RNAseq.2.P.fq.gz c_debaryana.RNAseq.2.U.fq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:3 MINLEN:25

STAR --runThreadN 32 --genomeDir ../arrow/ --readFilesIn c_debaryana.RNAseq.1.P.fq.gz c_debaryana.RNAseq.2.P.fq.gz --readFilesCommand zcat --twopassMode Basic --outSAMtype BAM Unsorted
samtools sort Aligned.out.bam > c_debaryana.RNAseq.bam
samtools flagstat c_debaryana.RNAseq.bam > c_debaryana.RNAseq.flagstat.txt
samtools index c_debaryana.RNAseq.bam
```
