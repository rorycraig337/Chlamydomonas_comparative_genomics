Remove unsupported contigs and format fasta

```
grep "reads=1 " ../canu/v1_out/c_debaryana.contigs.fasta | awk '{print $1 "|arrow|arrow|arrow|pilon|pilon|pilon"}' > single_read_contigs.txt
cat organelle_contigs.txt single_read_contigs.txt > filtered_contigs.txt
perl ../../c_incerta/final_assembly/fasta_filter.pl --in ../pilon/c_debaryana.canu_v1.arrow_v3.pilon_v3.fa --filter filtered_contigs.txt --out c_debaryana.V1_raw1.fa
sortbyname.sh in=c_debaryana.V1_raw1.fa out=c_debaryana.V1_raw2.fa length=t descending
perl ../../c_incerta//final_assembly/convert_contig_headers.pl --in c_debaryana.V1_raw2.fa --out c_debaryana.V1_raw3.fa
reformat.sh in=c_debaryana.V1_raw3.fa out=Chlamydomonas_debaryana.V1.fa tuc -Xmx1g
```
