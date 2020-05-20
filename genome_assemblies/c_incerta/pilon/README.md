First iteration of Pilon - restore any indels >5 bp

```
pilon --genome ../arrow/c_incerta.canu_v2.arrow_v3.fa --unpaired ../illumina_preprocessing/c_incerta.PE1.merged.bam --unpaired ../illumina_preprocessing/c_incerta.PE2.merged.bam --frags ../illumina_preprocessing/c_incerta.PE1.unmerged.bam --frags ../illumina_preprocessing/c_incerta.PE2.unmerged.bam --frags ../illumina_preprocessing/c_incerta_MP1.PE_all.bam --frags ../illumina_preprocessing/c_incerta_MP2.PE_all.bam --jumps ../illumina_preprocessing/c_incerta_MP1.MP_all.bam --jumps ../illumina_preprocessing/c_incerta_MP2.MP_all.bam --frags ../illumina_preprocessing/c_incerta.RNAseq.bam --output c_incerta.canu_v2.arrow_v3.pilon_v1 --changes --fix bases -Xmx260G
perl restore_pilon_indels.pl --genome c_incerta.canu_v2.arrow_v3.pilon_v1.fasta --changes c_incerta.canu_v2.arrow_v3.pilon_v1.changes --min_indel 5 --out c_incerta.canu_v2.arrow_v3.pilon_v1.fa
bwa index c_incerta.canu_v2.arrow_v3.pilon_v1.fa
STAR --runThreadN 12 --runMode genomeGenerate --genomeDir ./ --genomeFastaFiles ./c_incerta.canu_v2.arrow_v3.pilon_v1.fa
```

Second iteration - first remap reads against pilon 1 genome

```
bwa mem -t 20 c_incerta.canu_v2.arrow_v3.pilon_v1.fa ../illumina_preprocessing/c_incerta.PE1.merged.fq.gz | samtools view -Sb - > temp.c_incerta.PE1.merged.pilon1.bam
samtools sort temp.c_incerta.PE1.merged.pilon1.bam > c_incerta.PE1.merged.pilon1.bam
samtools index c_incerta.PE1.merged.pilon1.bam

bwa mem -t 20 c_incerta.canu_v2.arrow_v3.pilon_v1.fa ../illumina_preprocessing/c_incerta.PE2.merged.fq.gz | samtools view -Sb - > temp.c_incerta.PE2.merged.pilon1.bam
samtools sort temp.c_incerta.PE2.merged.pilon1.bam > c_incerta.PE2.merged.pilon1.bam
samtools index c_incerta.PE2.merged.pilon1.bam

bwa mem -t 20 c_incerta.canu_v2.arrow_v3.pilon_v1.fa -p ../illumina_preprocessing/c_incerta.PE1.unmerged.fq.gz | samtools view -Sb - > temp.c_incerta.PE1.unmerged.pilon1.bam
samtools sort temp.c_incerta.PE1.unmerged.pilon1.bam > c_incerta.PE1.unmerged.pilon1.bam
samtools index c_incerta.PE1.unmerged.pilon1.bam

bwa mem -t 20 c_incerta.canu_v2.arrow_v3.pilon_v1.fa -p ../illumina_preprocessing/c_incerta.PE2.unmerged.fq.gz | samtools view -Sb - > temp.c_incerta.PE2.unmerged.pilon1.bam
samtools sort temp.c_incerta.PE2.unmerged.pilon1.bam > c_incerta.PE2.unmerged.pilon1.bam
samtools index c_incerta.PE2.unmerged.pilon1.bam

bwa mem -t 20 c_incerta.canu_v2.arrow_v3.pilon_v1.fa -p ../illumina_preprocessing/c_incerta_MP1.PE_all.fastq.gz | samtools view -Sb - > temp.c_incerta_MP1.PE_all.pilon1.bam
samtools sort temp.c_incerta_MP1.PE_all.pilon1.bam > c_incerta_MP1.PE_all.pilon1.bam
samtools index c_incerta_MP1.PE_all.pilon1.bam

bwa mem -t 20 c_incerta.canu_v2.arrow_v3.pilon_v1.fa -p ../illumina_preprocessing/c_incerta_MP2.PE_all.fastq.gz | samtools view -Sb - > temp.c_incerta_MP2.PE_all.pilon1.bam
samtools sort temp.c_incerta_MP2.PE_all.pilon1.bam > c_incerta_MP2.PE_all.pilon1.bam
samtools index c_incerta_MP2.PE_all.pilon1.bam

bwa mem -t 20 c_incerta.canu_v2.arrow_v3.pilon_v1.fa -p ../illumina_preprocessing/c_incerta_MP1.MP_all.fastq.gz | samtools view -Sb - > temp.c_incerta_MP1.MP_all.pilon1.bam
samtools sort temp.c_incerta_MP1.MP_all.pilon1.bam > c_incerta_MP1.MP_all.pilon1.bam
samtools index c_incerta_MP1.MP_all.pilon1.bam

bwa mem -t 20 c_incerta.canu_v2.arrow_v3.pilon_v1.fa -p ../illumina_preprocessing/c_incerta_MP2.MP_all.fastq.gz | samtools view -Sb - > temp.c_incerta_MP2.MP_all.pilon1.bam
samtools sort temp.c_incerta_MP2.MP_all.pilon1.bam > c_incerta_MP2.MP_all.pilon1.bam
samtools index c_incerta_MP2.MP_all.pilon1.bam

STAR --runThreadN 20 --genomeDir ./ --readFilesIn ../../illumina_preprocessing/c_incerta.RNAseq.1.P.fq.gz ../illumina_preprocessing/c_incerta.RNAseq.2.P.fq.gz --readFilesCommand zcat --twopassMode Basic --outSAMtype BAM Unsorted
samtools sort Aligned.out.bam > c_incerta.RNAseq.pilon1.bam
samtools index c_incerta.RNAseq.pilon1.bam
```

Now run second iteration

```
pilon --genome c_incerta.canu_v2.arrow_v3.pilon_v1.fa --unpaired c_incerta.PE1.merged.pilon1.bam --unpaired c_incerta.PE2.merged.pilon1.bam --frags c_incerta.PE1.unmerged.pilon1.bam --frags c_incerta.PE2.unmerged.pilon1.bam --frags c_incerta_MP1.PE_all.pilon1.bam --frags c_incerta_MP2.PE_all.pilon1.bam --jumps c_incerta_MP1.MP_all.pilon1.bam --jumps c_incerta_MP2.MP_all.pilon1.bam --frags c_incerta.RNAseq.pilon1.bam --output c_incerta.canu_v2.arrow_v3.pilon_v2 --changes --fix bases -Xmx260G
perl restore_pilon_indels.pl --genome c_incerta.canu_v2.arrow_v3.pilon_v2.fasta --changes c_incerta.canu_v2.arrow_v3.pilon_v2.changes --min_indel 5 --out c_incerta.canu_v2.arrow_v3.pilon_v2.fa
#bwa index c_incerta.canu_v2.arrow_v3.pilon_v2.fa
#STAR --runThreadN 12 --runMode genomeGenerate --genomeDir ./ --genomeFastaFiles ./c_incerta.canu_v2.arrow_v3.pilon_v2.fa
```

Third iteration - re-map and re-run 

```
bwa mem -t 20 c_incerta.canu_v2.arrow_v3.pilon_v2.fa ../illumina_preprocessing/c_incerta.PE1.merged.fq.gz | samtools view -Sb - > temp.c_incerta.PE1.merged.pilon2.bam
samtools sort temp.c_incerta.PE1.merged.pilon2.bam > c_incerta.PE1.merged.pilon2.bam
samtools index c_incerta.PE1.merged.pilon2.bam

bwa mem -t 20 c_incerta.canu_v2.arrow_v3.pilon_v2.fa ../illumina_preprocessing/c_incerta.PE2.merged.fq.gz | samtools view -Sb - > temp.c_incerta.PE2.merged.pilon2.bam
samtools sort temp.c_incerta.PE2.merged.pilon2.bam > c_incerta.PE2.merged.pilon2.bam
samtools index c_incerta.PE2.merged.pilon2.bam

bwa mem -t 20 c_incerta.canu_v2.arrow_v3.pilon_v2.fa -p ../illumina_preprocessing/c_incerta.PE1.unmerged.fq.gz | samtools view -Sb - > temp.c_incerta.PE1.unmerged.pilon2.bam
samtools sort temp.c_incerta.PE1.unmerged.pilon2.bam > c_incerta.PE1.unmerged.pilon2.bam
samtools index c_incerta.PE1.unmerged.pilon2.bam

bwa mem -t 20 c_incerta.canu_v2.arrow_v3.pilon_v2.fa -p ../illumina_preprocessing/c_incerta.PE2.unmerged.fq.gz | samtools view -Sb - > temp.c_incerta.PE2.unmerged.pilon2.bam
samtools sort temp.c_incerta.PE2.unmerged.pilon2.bam > c_incerta.PE2.unmerged.pilon2.bam
samtools index c_incerta.PE2.unmerged.pilon2.bam

bwa mem -t 20 c_incerta.canu_v2.arrow_v3.pilon_v2.fa -p ../illumina_preprocessing/c_incerta_MP1.PE_all.fastq.gz | samtools view -Sb - > temp.c_incerta_MP1.PE_all.pilon2.bam
samtools sort temp.c_incerta_MP1.PE_all.pilon2.bam > c_incerta_MP1.PE_all.pilon2.bam
samtools index c_incerta_MP1.PE_all.pilon2.bam

bwa mem -t 20 c_incerta.canu_v2.arrow_v3.pilon_v2.fa -p ../illumina_preprocessing/c_incerta_MP2.PE_all.fastq.gz | samtools view -Sb - > temp.c_incerta_MP2.PE_all.pilon2.bam
samtools sort temp.c_incerta_MP2.PE_all.pilon2.bam > c_incerta_MP2.PE_all.pilon2.bam
samtools index c_incerta_MP2.PE_all.pilon2.bam

bwa mem -t 20 c_incerta.canu_v2.arrow_v3.pilon_v2.fa -p ../illumina_preprocessing/c_incerta_MP1.MP_all.fastq.gz | samtools view -Sb - > temp.c_incerta_MP1.MP_all.pilon2.bam
samtools sort temp.c_incerta_MP1.MP_all.pilon2.bam > c_incerta_MP1.MP_all.pilon2.bam
samtools index c_incerta_MP1.MP_all.pilon2.bam

bwa mem -t 20 c_incerta.canu_v2.arrow_v3.pilon_v2.fa -p ../illumina_preprocessing/c_incerta_MP2.MP_all.fastq.gz | samtools view -Sb - > temp.c_incerta_MP2.MP_all.pilon2.bam
samtools sort temp.c_incerta_MP2.MP_all.pilon2.bam > c_incerta_MP2.MP_all.pilon2.bam
samtools index c_incerta_MP2.MP_all.pilon2.bam

STAR --runThreadN 20 --genomeDir ./ --readFilesIn ../illumina_preprocessing/c_incerta.RNAseq.1.P.fq.gz ../illumina_preprocessing/c_incerta.RNAseq.2.P.fq.gz --readFilesCommand zcat --twopassMode Basic --outSAMtype BAM Unsorted
samtools sort Aligned.out.bam > c_incerta.RNAseq.pilon2.bam
samtools index c_incerta.RNAseq.pilon2.bam

pilon --genome c_incerta.canu_v2.arrow_v3.pilon_v2.fa --unpaired c_incerta.PE1.merged.pilon2.bam --unpaired c_incerta.PE2.merged.pilon2.bam --frags c_incerta.PE1.unmerged.pilon2.bam --frags c_incerta.PE2.unmerged.pilon2.bam --frags c_incerta_MP1.PE_all.pilon2.bam --frags c_incerta_MP2.PE_all.pilon2.bam --jumps c_incerta_MP1.MP_all.pilon2.bam --jumps c_incerta_MP2.MP_all.pilon2.bam --frags c_incerta.RNAseq.pilon2.bam --output c_incerta.canu_v2.arrow_v3.pilon_v3 --changes --fix bases -Xmx260G
perl restore_pilon_indels.pl --genome c_incerta.canu_v2.arrow_v3.pilon_v3.fasta --changes c_incerta.canu_v2.arrow_v3.pilon_v3.changes --min_indel 5 --out c_incerta.canu_v2.arrow_v3.pilon_v3.fa
bwa index c_incerta.canu_v2.arrow_v3.pilon_v3.fa
STAR --runThreadN 12 --runMode genomeGenerate --genomeDir ./ --genomeFastaFiles ./c_incerta.canu_v2.arrow_v3.pilon_v3.fa
bwa index c_incerta.canu_v2.arrow_v3.pilon_v3.fa
```
