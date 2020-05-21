Remove genes with internal stop codons and format file names correctly

```
perl internal_stop_check.pl --cds ../c_incerta/c_incerta/augustus.hints_utr.codingseq --out c_incerta.internal_stops.txt
faSomeRecords -exclude ../c_incerta/braker/c_incerta/augustus.hints_utr.codingseq c_incerta.internal_stops.txt c_incerta.braker2.CDS.fa
faSomeRecords -exclude ../c_incerta/braker/c_incerta/augustus.hints_utr.aa c_incerta.internal_stops.txt c_incerta.braker2.protein.fa
perl ENSEMBL_format_gff3.pl --gff3 ../c_incerta/braker/c_incerta/augustus.hints_utr.gtf --out c_incerta.braker2.gtf
perl filterGTF.pl --gtf c_incerta.braker2.gtf --filter c_incerta.internal_stops.txt --out c_incerta.braker2.f1.gtf


perl internal_stop_check.pl --cds ../c_schloesseri/braker/c_schloesseri_nl/augustus.hints_utr.codingseq --out c_schloesseri.internal_stops.txt
faSomeRecords -exclude ../c_schloesseri/braker/c_schloesseri/augustus.hints_utr.codingseq c_schloesseri.internal_stops.txt c_schloesseri.braker2.CDS.fa
aSomeRecords -exclude ../c_schloesseri/braker/c_schloesseri/augustus.hints_utr.aa c_schloesseri.internal_stops.txt c_schloesseri.braker2.protein.fa
perl ENSEMBL_format_gff3.pl --gff3 ../c_schloesseri/braker/c_schloesseri/augustus.hints_utr.gtf --out c_schloesseri.braker2.gtf
perl filterGTF.pl --gtf c_schloesseri.braker2.gtf --filter c_schloesseri.internal_stops.txt --out c_schloesseri.braker2.f1.gtf

perl internal_stop_check.pl --cds ../c_debaryana/braker/c_debaryana/augustus.hints_utr.codingseq --out c_debaryana.internal_stops.txt
faSomeRecords -exclude ../c_debaryana/braker/c_debaryana/augustus.hints_utr.codingseq c_debaryana.internal_stops.txt c_debaryana.braker2.CDS.fa
faSomeRecords -exclude ../c_debaryana/braker/c_debaryana/augustus.hints_utr.aa c_debaryana.internal_stops.txt c_debaryana.braker2.protein.fa
perl ENSEMBL_format_gff3.pl --gff3 ../c_debaryana/braker/c_debaryana/augustus.hints_utr.gtf --out c_debaryana.braker2.gtf
perl filterGTF.pl --gtf c_debaryana.braker2.gtf --filter c_debaryana.internal_stops.txt --out c_debaryana.braker2.f1.gtf
```

Remove genes with peptides <30 aa

```
samtools faidx c_incerta.braker2.protein.fa
perl extract_short_seqs.pl --fai c_incerta.braker2.protein.fa.fai --length 30 --out c_incerta.short_peps.txt
faSomeRecords -exclude c_incerta.braker2.CDS.fa c_incerta.short_peps.txt c_incerta.braker2.CDS.f2.fa
faSomeRecords -exclude c_incerta.braker2.protein.fa c_incerta.short_peps.txt c_incerta.braker2.protein.f2.fa
perl filterGTF.pl --gtf c_incerta.braker2.f1.gtf --filter c_incerta.short_peps.txt --out c_incerta.braker2.f2.gtf

samtools faidx c_schloesseri.braker2.protein.fa
perl extract_short_seqs.pl --fai c_schloesseri.braker2.protein.fa.fai --length 30 --out c_schloesseri.short_peps.txt
faSomeRecords -exclude c_schloesseri.braker2.CDS.fa c_schloesseri.short_peps.txt c_schloesseri.braker2.CDS.f2.fa
faSomeRecords -exclude c_schloesseri.braker2.protein.fa c_schloesseri.short_peps.txt c_schloesseri.braker2.protein.f2.fa
perl filterGTF.pl --gtf c_schloesseri.braker2.f1.gtf --filter c_schloesseri.short_peps.txt --out c_schloesseri.braker2.f2.gtf

samtools faidx c_debaryana.braker2.protein.fa
perl extract_short_seqs.pl --fai c_debaryana.braker2.protein.fa.fai --length 30 --out c_debaryana.short_peps.txt
faSomeRecords -exclude c_debaryana.braker2.CDS.fa c_debaryana.short_peps.txt c_debaryana.braker2.CDS.f2.fa
faSomeRecords -exclude c_debaryana.braker2.protein.fa c_debaryana.short_peps.txt c_debaryana.braker2.protein.f2.fa
perl filterGTF.pl --gtf c_debaryana.braker2.f1.gtf --filter c_debaryana.short_peps.txt --out c_debaryana.braker2.f2.gtf
```

Remove repeat overlap genes

```
faSomeRecords -exclude c_incerta.braker2.CDS.f2.fa ../../repeat_masking/c_incerta/CDS_repeat_overlap/repeat_genes.with_transcripts.txt c_incerta.braker2.CDS.f3.fa
faSomeRecords -exclude c_incerta.braker2.protein.f2.fa ../../repeat_masking/c_incerta/CDS_repeat_overlap/repeat_genes.with_transcripts.txt c_incerta.braker2.protein.f3.fa
perl filterGTF.pl --gtf c_incerta.braker2.f2.gtf --filter ../../repeat_masking/c_incerta/CDS_repeat_overlap/repeat_genes.with_transcripts.txt --out c_incerta.braker2.f3.gtf

faSomeRecords -exclude c_schloesseri.braker2.CDS.f2.fa ../../repeat_masking/c_schloesseri/CDS_repeat_overlap/repeat_genes.with_transcripts.txt c_schloesseri.braker2.CDS.f3.fa
faSomeRecords -exclude c_schloesseri.braker2.protein.f2.fa ../../repeat_masking/c_schloesseri/CDS_repeat_overlap/repeat_genes.with_transcripts.txt c_schloesseri.braker2.protein.f3.fa
perl filterGTF.pl --gtf c_schloesseri.braker2.f2.gtf --filter ../../repeat_masking/c_schloesseri/CDS_repeat_overlap/repeat_genes.with_transcripts.txt --out c_schloesseri.braker2.f3.gtf

faSomeRecords -exclude c_debaryana.braker2.CDS.f2.fa ../../repeat_masking/c_debaryana/CDS_repeat_overlap/repeat_genes.with_transcripts.txt c_debaryana.braker2.CDS.f3.fa
faSomeRecords -exclude c_debaryana.braker2.protein.f2.fa ../../repeat_masking/c_debaryana/CDS_repeat_overlap/repeat_genes.with_transcripts.txt c_debaryana.braker2.protein.f3.fa
perl filterGTF.pl --gtf c_debaryana.braker2.f2.gtf --filter ../../repeat_masking/c_debaryana/CDS_repeat_overlap/repeat_genes.with_transcripts.txt --out c_debaryana.braker2.f3.gtf
```

Convert to GFF3

```
gtf2gff.pl < c_incerta.braker2.f3.gtf --out=c_incerta.braker2.gff3 --gff3
gtf2gff.pl < c_schloesseri.braker2.f3.gtf --out=c_schloesseri.braker2.gff3 --gff3
gtf2gff.pl < c_debaryana.braker2.f3.gtf --out=c_debaryana.braker2.gff3 --gff3
```
