Run BUSCO on each species genome

```bash BUSCO.sh```

Extract proteins for BUSCO genes shared by >=80% of species

```
perl summarise_BUSCOs.pl --species_list volvocales_trim.txt --BUSCO_list BUSCOs.txt --out full_summary.volvocales_trim.tsv
perl BUSCO_summary_to_fastas_filter.pl --summary full_summary.volvocales_trim.tsv --output ./ --perc 0.8
```

Align BUSCOs and concatenate

```
bash mafft_trimal.sh
perl catfasta2phyml.pl -f -c *mafft.trimAl_auto.fa > volvocales_trim_80.concat.fa
```
