Run IQ-TREE on each individual protein alignment and run ASTRAL-III 

```
bash iqtree.sh
for f in *treefile; do cat "${f}"; echo; done > OF.tre
nw_ed  OF.tre 'i & b<=10' o > OF-BS10.tre
java -jar astral.5.6.3.jar -i OF-BS10.tre -o OF-BS10.ASTRAL.tre 2> OF.log
```
