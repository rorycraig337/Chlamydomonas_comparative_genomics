Orthofinder species:  *C. reinhardtii, C. incerta, C. schloesseri, E. debaryana, G. pectorale, V. carteri, D. salina, C. eustigma, R. subcapita, C. zofingiensis*

Use primary transcript models for Phytozome species (downloaded 13/10/19)

Use NCBI versions for non-Phytzome species (downloaded 13/10/19)

Get longest protein coding sequences from BRAKER annotations

```
perl extract_longest_ids.pl --gtf ../../gene_annotation/final_gene_models/c_incerta.braker2.f1.gtf --out c_incerta_longest_transcripts.txt
faSomeRecords ../../gene_annotation/final_gene_models/c_incerta.braker2.protein.fa c_incerta_longest_transcripts.txt c_incerta_longest.proteins.fa

perl extract_longest_ids.pl --gtf ../../gene_annotation/final_gene_models/c_schloesseri.braker2.f1.gtf --out c_schloesseri_longest_transcripts.txt
faSomeRecords ../../gene_annotation/final_gene_models/c_schloesseri.braker2.protein.fa c_schloesseri_longest_transcripts.txt c_schloesseri.longest_proteins.fa

perl extract_longest_ids.pl --gtf ../../gene_annotation/final_gene_models/c_debaryana.braker2.f1.gtf --out c_debaryana_longest_transcripts.txt
faSomeRecords ../../gene_annotation/final_gene_models/c_debaryana.braker2.protein.fa c_debaryana_longest_transcripts.txt c_debaryana.longest_proteins.fa
```

