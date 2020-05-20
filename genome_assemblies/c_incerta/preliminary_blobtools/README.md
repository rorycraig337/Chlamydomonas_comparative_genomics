Make preliminary assembly with Miniasm to check for contaminants

```
minimap2 -x ava-pb -t16  ../pacbio_reads/c_incerta.subreads.fa ../pacbio_reads/c_incerta.subreads.fa | gzip -1 > c_incerta.subreads.paf.gz
miniasm -f ../pacbio_reads/c_incerta.subreads.fa c_incerta.subreads.paf.gz > c_incerta.miniasm_v1.gfa
awk '/^S/{print ">"$2"\n"$3}' c_incerta.miniasm_v1.gfa > c_incerta.miniasm_v1.fa
```
