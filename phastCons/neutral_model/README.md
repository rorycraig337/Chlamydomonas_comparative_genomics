Extract sites that are 4D in *C. reinhardtii* and are aligned with a 4D-containing codon in all 7 other species

```
perl maf_to_4D.pl --CDS ../site_classes/CDS.bed --maf_path ../../Cactus_WGA/MAF/ --list species.txt --out maf_4D.fa
```

Produce neutral model using phyloFit

```
phyloFit --tree "((Edaphochlamys_debaryana,(Chlamydomonas_schloesseri,(Chlamydomonas_incerta,Chlamydomonas_reinhardtii))),(((Eudorina_2016-703-Eu-15,Volvox_carteri),Yamagishiella_unicocca),Gonium_pectorale))" maf_4D.fa
mv phyloFit.mod volvocales_8way.4D.mod
```
