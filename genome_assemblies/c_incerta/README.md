Remove contigs supported by only one read

```
grep "reads=1 " ../canu/canu_v2/v2_out/c_incerta_canu_v2.contigs.fasta | awk '{print $1 "|arrow|arrow|arrow|pilon|pilon|pilon"}' > single_read_contigs.txt
cat organelle_contigs.txt single_read_contigs.txt > filtered_contigs.txt
perl fasta_filter.pl --in ../pilon/c_incerta.canu_v2.arrow_v3.pilon_v3.fa --filter filtered_contigs.txt --out c_incerta.V3_raw1.fa
```

Format assembly

```
sortbyname.sh in=c_incerta.V3_raw1.fa out=c_incerta.V3_raw2.fa length=t descending
perl convert_contig_headers.pl --in c_incerta.V3_raw2.fa --out c_incerta.V3_raw3.fa
reformat.sh in=c_incerta.V3_raw3.fa out=Chlamydomonas_incerta.V3.fa tuc -Xmx1g
```
