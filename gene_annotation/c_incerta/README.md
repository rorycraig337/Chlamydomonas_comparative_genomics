Map RNA-seq to repeat masked assembly

```
STAR --runThreadN 32 --genomeDir ../../repeat_masking/c_incerta/ --readFilesIn ../../genome_assemblies/c_incerta/illumina_preprocessing/RNA_seq/c_incerta.RNAseq.1.P.fq.gz ../../genome_assemblies/c_incerta/illumina_preprocessing/RNA_seq/c_incerta.RNAseq.2.P.fq.gz --readFilesCommand zcat --twopassMode Basic --outSAMtype BAM Unsorted
samtools sort Aligned.out.bam > c_incerta.RNAseq.softmask_nl.bam
samtools flagstat c_incerta.RNAseq.softmask_nl.bam > c_incerta.RNAseq.softmask_nl.flagstat.txt
samtools index c_incerta.RNAseq.softmask_nl.bam
```

Split mapped reads to plus and minus

```
bash split_bam_proper_pairs.sh c_incerta.RNAseq.softmask_nl.bam
```

Run BRAKER2

```
braker.pl --species=c_incerta --genome=../../repeat_masking/c_incerta/Chlamydomonas_incerta.V3.softmasked_nolow.fa --softmasking --bam=plus.bam,minus.bam --stranded=+,- --UTR=on --cores 12
```
