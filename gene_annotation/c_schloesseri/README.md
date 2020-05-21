Map RNA-seq to repeat masked assembly

```
STAR --runThreadN 32 --genomeDir ../../repeat_masking/c_schloesseri/ --readFilesIn ../../genome_assemblies/c_schloesseri/illumina_preprocessing/RNA_seq/c_schloesseri.RNAseq.1.P.fq.gz ../../genome_assemblies/c_schloesseri/illumina_preprocessing/RNA_seq/c_schloesseri.RNAseq.2.P.fq.gz --readFilesCommand zcat --twopassMode Basic --outSAMtype BAM Unsorted
samtools sort Aligned.out.bam > c_schloesseri.RNAseq.softmask_nl.bam
samtools flagstat c_schloesseri.RNAseq.softmask_nl.bam > c_schloesseri.RNAseq.softmask_nl.flagstat.txt
samtools index c_schloesseri.RNAseq.softmask_nl.bam
```

Split mapped reads to plus and minus

```
bash ../c_incerta/split_bam_proper_pairs.sh c_schloesseri.RNAseq.softmask_nl.bam
```

Run BRAKER2

```
braker.pl --species=c_schloesseri --genome=../../repeat_masking/c_schloesseri/Chlamydomonas_schloesseri.V1.softmasked_nolow.fa --softmasking --bam=plus.bam,minus.bam --stranded=+,- --UTR=on --cores 12
```
