Trim reads with BBDUK

```
bbduk.sh in1=Cincerta_wt.BGI.180bp.1.fwd.fastq.gz in2=Cincerta_wt.BGI.180bp.1.rev.fastq.gz out1=c_incerta.PE1.1.fastq.gz out2=c_incerta.PE1.2.fastq.gz ref=/opt/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tbo
bbduk.sh in1=Cincerta_wt.BGI.180bp.2.fwd.fastq.gz in2=Cincerta_wt.BGI.180bp.2.rev.fastq.gz out1=c_incerta.PE2.1.fastq.gz out2=c_incerta.PE2.2.fastq.gz ref=/opt/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tbo
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

Filter 5kb mate pair libraries with NxTrim 

```
nxtrim -1 FCH3KTWBBXX-WHCHLdmyDAAADLAAPEI-57_L4_1.fq.gz -2 FCH3KTWBBXX-WHCHLdmyDAAADLAAPEI-57_L4_2.fq.gz -O c_incerta_MP1 --rf
nxtrim -1 FCH53LTBBXX-WHCHLdmyDAAADLAAPEI-57_L6_1.fq.gz -2 FCH53LTBBXX-WHCHLdmyDAAADLAAPEI-57_L6_2.fq.gz -O c_incerta_MP2 --rf
```

Trim reads with BBDUK

```
bbduk.sh in=c_incerta_MP1.unknown.fastq.gz out=c_incerta_MP1.unknown.bbduk.fastq.gz ref=/opt/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tbo
bbduk.sh in=c_incerta_MP2.unknown.fastq.gz out=c_incerta_MP2.unknown.bbduk.fastq.gz ref=/opt/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tbo
bbduk.sh in=c_incerta_MP1.pe.fastq.gz out=c_incerta_MP1.pe.bbduk.fastq.gz ref=/opt/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tbo
bbduk.sh in=c_incerta_MP2.pe.fastq.gz out=c_incerta_MP2.pe.bbduk.fastq.gz ref=/opt/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tbo
bbduk.sh in=c_incerta_MP1.mp.fastq.gz out=c_incerta_MP1.mp.bbduk.fastq.gz ref=/opt/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tbo
bbduk.sh in=c_incerta_MP2.mp.fastq.gz out=c_incerta_MP2.mp.bbduk.fastq.gz ref=/opt/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tbo
```

Map trimmed reads

```
bwa mem -t 22 ../arrow/c_incerta.canu_v2.arrow_v3.fa -p c_incerta_MP1.unknown.bbduk.fastq.gz | samtools view -Sb - > temp.c_incerta_MP1.unknown.bam
samtools sort temp.c_incerta_MP1.unknown.bam > c_incerta_MP1.unknown.bam
samtools flagstat c_incerta_MP1.unknown.bam > c_incerta_MP1.unknown.flagstat.txt
samtools index c_incerta_MP1.unknown.bam

bwa mem -t 22 ../arrow/c_incerta.canu_v2.arrow_v3.fa -p c_incerta_MP2.unknown.bbduk.fastq.gz | samtools view -Sb - > temp.c_incerta_MP2.unknown.bam
samtools sort temp.c_incerta_MP2.unknown.bam > c_incerta_MP2.unknown.bam
samtools flagstat c_incerta_MP2.unknown.bam > c_incerta_MP2.unknown.flagstat.txt
samtools index c_incerta_MP2.unknown.bam

bwa mem -t 22 ../arrow/c_incerta.canu_v2.arrow_v3.fa -p c_incerta_MP1.pe.bbduk.fastq.gz | samtools view -Sb - > temp.c_incerta_MP1.pe.bam
samtools sort temp.c_incerta_MP1.pe.bam > c_incerta_MP1.pe.bam
samtools flagstat c_incerta_MP1.pe.bam > c_incerta_MP1.pe.flagstat.txt
samtools index c_incerta_MP1.pe.bam

bwa mem -t 22 ../arrow/c_incerta.canu_v2.arrow_v3.fa -p c_incerta_MP2.pe.bbduk.fastq.gz | samtools view -Sb - > temp.c_incerta_MP2.pe.bam
samtools sort temp.c_incerta_MP2.pe.bam > c_incerta_MP2.pe.bam
samtools flagstat c_incerta_MP2.pe.bam > c_incerta_MP2.pe.flagstat.txt
samtools index c_incerta_MP2.pe.bam

bwa mem -t 22 ../arrow/c_incerta.canu_v2.arrow_v3.fa -p c_incerta_MP1.mp.bbduk.fastq.gz | samtools view -Sb - > temp.c_incerta_MP1.mp.bam
samtools sort temp.c_incerta_MP1.mp.bam > c_incerta_MP1.mp.bam
samtools flagstat c_incerta_MP1.mp.bam > c_incerta_MP1.mp.flagstat.txt
samtools index c_incerta_MP1.mp.bam

bwa mem -t 22 ../arrow/c_incerta.canu_v2.arrow_v3.fa -p c_incerta_MP2.mp.bbduk.fastq.gz | samtools view -Sb - > temp.c_incerta_MP2.mp.bam
samtools sort temp.c_incerta_MP2.mp.bam > c_incerta_MP2.mp.bam
samtools flagstat c_incerta_MP2.mp.bam > c_incerta_MP2.mp.flagstat.txt
samtools index c_incerta_MP2.mp.bam

rm *temp
```
Remove PCR duplicates

```
picard MarkDuplicates I=c_incerta_MP1.unknown.bam O=c_incerta_MP1.unknown.no-dupes.bam M=c_incerta_MP1.unknown.dupes.txt REMOVE_DUPLICATES=true
picard MarkDuplicates I=c_incerta_MP2.unknown.bam O=c_incerta_MP2.unknown.no-dupes.bam M=c_incerta_MP2.unknown.dupes.txt REMOVE_DUPLICATES=true
picard MarkDuplicates I=c_incerta_MP1.pe.bam O=c_incerta_MP1.pe.no-dupes.bam M=c_incerta_MP1.pe.dupes.txt REMOVE_DUPLICATES=true
picard MarkDuplicates I=c_incerta_MP2.pe.bam O=c_incerta_MP2.pe.no-dupes.bam M=c_incerta_MP2.pe.dupes.txt REMOVE_DUPLICATES=true
picard MarkDuplicates I=c_incerta_MP1.mp.bam O=c_incerta_MP1.mp.no-dupes.bam M=c_incerta_MP1.mp.dupes.txt REMOVE_DUPLICATES=true
picard MarkDuplicates I=c_incerta_MP2.mp.bam O=c_incerta_MP2.mp.no-dupes.bam M=c_incerta_MP2.mp.dupes.txt REMOVE_DUPLICATES=true

#samtools view -h c_incerta_MP1.unknown.no-dupes.bam > c_incerta_MP1.unknown.no-dupes.sam
#samtools view -h c_incerta_MP2.unknown.no-dupes.bam > c_incerta_MP2.unknown.no-dupes.sam
```

Get insert mapping metrics

```
picard CollectJumpingLibraryMetrics I=c_incerta_MP1.pe.bam O=c_incerta_MP1.pe.jumping_metrics.txt
picard CollectJumpingLibraryMetrics I=c_incerta_MP2.pe.bam O=c_incerta_MP2.pe.jumping_metrics.txt
picard CollectJumpingLibraryMetrics I=c_incerta_MP1.mp.bam O=c_incerta_MP1.mp.jumping_metrics.txt
picard CollectJumpingLibraryMetrics I=c_incerta_MP2.mp.bam O=c_incerta_MP2.mp.jumping_metrics.txt

picard CollectInsertSizeMetrics I=c_incerta_MP1.pe.bam O=c_incerta_MP1.pe.insert.txt H=c_incerta_MP1.pe.insert_histogram.pdf M=0.5
picard CollectInsertSizeMetrics I=c_incerta_MP2.pe.bam O=c_incerta_MP2.pe.insert.txt H=c_incerta_MP2.pe.insert_histogram.pdf M=0.5
picard CollectInsertSizeMetrics I=c_incerta_MP1.mp.bam O=c_incerta_MP1.mp.insert.txt H=c_incerta_MP1.mp.insert_histogram.pdf M=0.5
picard CollectInsertSizeMetrics I=c_incerta_MP2.mp.bam O=c_incerta_MP2.mp.insert.txt H=c_incerta_MP2.mp.insert_histogram.pdf M=0.5
```

Extract unknown reads mapped as proper paired-end and mate pairs

```
perl collect_paired_end_reads.pl --sam c_incerta_MP1.unknown.no-dupes.sam --PE_proper c_incerta_MP1.PE_proper.txt --all_proper c_incerta_MP1.all_proper.txt
perl collect_paired_end_reads.pl --sam c_incerta_MP2.unknown.no-dupes.sam --PE_proper c_incerta_MP2.PE_proper.txt --all_proper c_incerta_MP2.all_proper.txt
sort -u c_incerta_MP1.PE_proper.txt > u_c_incerta_MP1.PE_proper.txt
sort -u c_incerta_MP1.all_proper.txt > u_c_incerta_MP1.all_proper.txt
sort -u c_incerta_MP2.PE_proper.txt > u_c_incerta_MP2.PE_proper.txt
sort -u c_incerta_MP2.all_proper.txt > u_c_incerta_MP2.all_proper.txt
perl grep_vf.pl --search u_c_incerta_MP1.PE_proper.txt --searched u_c_incerta_MP1.all_proper.txt --out u_c_incerta_MP1.MP_proper.txt
perl grep_vf.pl --search u_c_incerta_MP2.PE_proper.txt --searched u_c_incerta_MP2.all_proper.txt --out u_c_incerta_MP2.MP_proper.txt
filterbyname.sh in=c_incerta_MP1.unknown.bbduk.fastq.gz out=c_incerta_MP1.unknown.pe.fastq.gz names=u_c_incerta_MP1.PE_proper.txt include=t
filterbyname.sh in=c_incerta_MP1.unknown.bbduk.fastq.gz out=c_incerta_MP1.unknown.mp.fastq.gz names=u_c_incerta_MP1.MP_proper.txt include=t
filterbyname.sh in=c_incerta_MP2.unknown.bbduk.fastq.gz out=c_incerta_MP2.unknown.pe.fastq.gz names=u_c_incerta_MP2.PE_proper.txt include=t
filterbyname.sh in=c_incerta_MP2.unknown.bbduk.fastq.gz out=c_incerta_MP2.unknown.mp.fastq.gz names=u_c_incerta_MP2.MP_proper.txt include=t
```

Combine NxTrim annotations with unknowns annotated based on mapping

```
cat c_incerta_MP1.pe.bbduk.fastq.gz c_incerta_MP1.unknown.pe.fastq.gz > c_incerta_MP1.PE_all.fastq.gz
cat c_incerta_MP2.pe.bbduk.fastq.gz c_incerta_MP2.unknown.pe.fastq.gz > c_incerta_MP2.PE_all.fastq.gz
cat c_incerta_MP1.mp.bbduk.fastq.gz c_incerta_MP1.unknown.mp.fastq.gz > c_incerta_MP1.MP_all.fastq.gz
cat c_incerta_MP2.mp.bbduk.fastq.gz c_incerta_MP2.unknown.mp.fastq.gz > c_incerta_MP2.MP_all.fastq.gz
```

For each library, map PE and MP reads

```
bwa mem -t 22 ../arrow/c_incerta.canu_v2.arrow_v3.fa -p c_incerta_MP1.PE_all.fastq.gz | samtools view -Sb - > temp.c_incerta_MP1.PE_all.bam
samtools sort temp.c_incerta_MP1.PE_all.bam > c_incerta_MP1.PE_all.bam
samtools flagstat c_incerta_MP1.PE_all.bam > c_incerta_MP1.PE_all.flagstat.txt
samtools index c_incerta_MP1.PE_all.bam

bwa mem -t 22 ../arrow/c_incerta.canu_v2.arrow_v3.fa -p c_incerta_MP2.PE_all.fastq.gz | samtools view -Sb - > temp.c_incerta_MP2.PE_all.bam
samtools sort temp.c_incerta_MP2.PE_all.bam > c_incerta_MP2.PE_all.bam
samtools flagstat c_incerta_MP2.PE_all.bam > c_incerta_MP2.PE_all.flagstat.txt
samtools index c_incerta_MP2.PE_all.bam

bwa mem -t 22 ../arrow/c_incerta.canu_v2.arrow_v3.fa -p c_incerta_MP1.MP_all.fastq.gz | samtools view -Sb - > temp.c_incerta_MP1.MP_all.bam
samtools sort temp.c_incerta_MP1.MP_all.bam > c_incerta_MP1.MP_all.bam
samtools flagstat c_incerta_MP1.MP_all.bam > c_incerta_MP1.MP_all.flagstat.txt
samtools index c_incerta_MP1.MP_all.bam

bwa mem -t 22 ../arrow/c_incerta.canu_v2.arrow_v3.fa -p c_incerta_MP2.MP_all.fastq.gz | samtools view -Sb - > temp.c_incerta_MP2.MP_all.bam
samtools sort temp.c_incerta_MP2.MP_all.bam > c_incerta_MP2.MP_all.bam
samtools flagstat c_incerta_MP2.MP_all.bam > c_incerta_MP2.MP_all.flagstat.txt
samtools index c_incerta_MP2.MP_all.bam

rm temp*
```
