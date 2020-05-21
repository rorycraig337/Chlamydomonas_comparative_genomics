Map RNA-seq to repeat masked assembly

```
STAR --runThreadN 32 --genomeDir ../../repeat_masking/c_debaryana/ --readFilesIn ../../genome_assemblies/c_debaryana/illumina_preprocessing/RNA_seq/c_debaryana.RNAseq.1.P.fq.gz ../../genome_assemblies/c_debaryana/illumina_preprocessing/RNA_seq/c_debaryana.RNAseq.2.P.fq.gz --readFilesCommand zcat --twopassMode Basic --outSAMtype BAM Unsorted
samtools sort Aligned.out.bam > c_debaryana.RNAseq.softmask_nl.bam
samtools flagstat c_debaryana.RNAseq.softmask_nl.bam > c_debaryana.RNAseq.softmask_nl.flagstat.txt
samtools index c_debaryana.RNAseq.softmask_nl.bam
```

Split mapped reads to plus and minus

```
bash ../c_incerta/split_bam_proper_pairs.sh c_debaryana.RNAseq.softmask_nl.bam
```

Run BRAKER2

```
braker.pl --species=c_debaryana --genome=../../repeat_masking/e_debaryana/Chlamydomonas_debaryana.V1.softmasked.nuclear.fa --softmasking --bam=plus.bam,minus.bam --stranded=+,- --UTR=on --cores 12
```
