Get overlap of each transcript by TEs and low complexity repeats

```
RepeatMasker -a -xsmall -gccalc -gff -pa 12 -lib ../c_sch_custom_lib.fa ../../../genome_assemblies/c_schloesseri/final_assembly/Chlamydomonas_schloesseri.V1.fa

grep "(" Chlamydomonas_schloesseri.V1.fa.out.gff > t1
grep "rich" Chlamydomonas_schloesseri.V1.fa.out.gff > t2
grep "poly" Chlamydomonas_schloesseri.V1.fa.out.gff > t3
cat t1 t2 t3 > other_repeats.gff
grep -v "(" Chlamydomonas_schloesseri.V1.fa.out.gff | grep -v "rich" | grep -v "poly" > TEs.gff
perl ../../c_incerta/CDS_repeat_overlap/gff2bed.pl --gff TEs.gff --out TEs.bed
perl ../../c_incerta/CDS_repeat_overlap/gff2bed.pl --gff other_repeats.gff --out other_repeats.bed
sort -k1,1 -k2n,2n TEs.bed > s_TEs.bed
bedtools merge -i s_TEs.bed > m_TEs.bed
sort -k1,1 -k2n,2n other_repeats.bed > s_other_repeats.bed
bedtools merge -i s_other_repeats.bed > m_other_repeats.bed
perl ../../c_incerta/CDS_repeat_overlap/gene_TE_overlap.pl --gff ../../../gene_annotation/final_gene_models/c_schloesseri.braker2.f2.gtf --TEs m_TEs.bed --repeats m_other_repeats.bed --out c_schloesseri.repeat_overlap.tsv
sort -nrk4,4 -nrk2,2 c_schloesseri.repeat_overlap.tsv > s_c_schloesseri.repeat_overlap.tsv
perl ../../c_incerta/CDS_repeat_overlap/filter_TE_genes.pl --overlap c_schloesseri.repeat_overlap.tsv --TE 30 --simple 70 --out repeat_genes.txt
perl ../../c_incerta/CDS_repeat_overlap/add_transcript_numbers.pl --list repeat_genes.txt --fasta ../../../gene_annotation/final_gene_models/c_schloesseri.braker2.CDS.f2.fa --out repeat_genes.with_transcripts.txt
```
