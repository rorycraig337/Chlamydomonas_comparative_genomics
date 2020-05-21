Convert to MAF format and filter paralogs

```
hal2maf ../algal-8way.hal volvocales.maf --refGenome Chlamydomonas_reinhardtii --onlyOrthologs --noAncestors

mafDuplicateFilter --maf volvocales.maf > volvocales.paralog_filtered.maf

perl maf_fai_splitter.pl --maf volvocales.paralog_filtered.maf --fai ../preprocess_genomes/Chlamydomonas_reinhardtii.rm.fa.fai --ref Chlamydomonas_reinhardtii
```
