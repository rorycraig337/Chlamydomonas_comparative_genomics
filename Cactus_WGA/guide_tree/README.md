Extract both protein and nucleotide BUSCOs shared by 8 species 

```
perl ../../phylogenetic_analyses/BUSCO/summarise_BUSCOs.pl --species_list volvocales_gold.txt --BUSCO_list BUSCOs.txt --out full_summary.volvocales_gold.tsv
perl ../../phylogenetic_analyses/BUSCO/BUSCO_summary_to_fastas_filter.pl --summary full_summary.volvocales_gold.tsv --output ./ --perc 1.0
perl BUSCO_summary_to_fastas_filter.nuc.pl --summary full_summary.volvocales_gold.tsv --output ./ --perc 1.0
```

Align proteins 

```
bash ../../phylogenetic_analyses/BUSCO/mafft_trimal.sh
```

Extract 4D sites based on protein alignments and concatenate

```
bash 4D_extract.sh
perl catfasta2phyml.pl -f -c *4D.fa > volvocales_gold_100.4D_concat.fa
```
Get neutral branch lengths using topology from phylogenetic analyses

```
phyloFit --tree "((Edaphochlamys_debaryana,(Chlamydomonas_schloesseri,(Chlamydomonas_incerta,Chlamydomonas_reinhardtii))),(((Eudorina_2016-703-Eu-15,Volvox_carteri),Yamagishiella_unicocca),Gonium_pectorale))" volvocales_gold_100.4D_concat.fa
```
