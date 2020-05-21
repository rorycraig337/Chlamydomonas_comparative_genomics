Run IQ-TREE on all BUSCO alignments and run ASTRAL-III

```
bash iqtree.sh
for f in *.mafft.trimAl_auto.fa.treefile; do cat "${f}"; echo; done > BUSCO.tre
nw_ed  BUSCO.tre 'i & b<=10' o > BUSCO-BS10.tre
java -jar astral.5.6.3.jar -i BUSCO-BS10.tre -o BUSCO-BS10.ASTRAL.tre 2> BUSCO.log
```
