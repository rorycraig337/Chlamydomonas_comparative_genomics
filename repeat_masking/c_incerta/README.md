Run RepeatModeler

```
BuildDatabase -name Chlamydomonas_incerta.V3 -engine ncbi ../../genome_assemblies/c_incerta/final_assembly/Chlamydomonas_incerta.V3.fa
RepeatModeler -pa 32 -database Chlamydomonas_incerta.V3
perl renameRMDLconsensi.pl Chlamydomonas_incerta.V3-families.fa Chlamydomonas_incerta Chlamydomonas_incerta_repmod.fa
```

BLAST results against all C. reinhardtii and V. carteri, filtering unknown hits with e < 0.001

```
cat C_reinhardtii_v5.3.1_transcripts.fa V_carteri_v2.1_transcripts.fa > Cr_Vc_transcripts.fa
makeblastdb -in Cr_Vc_transcripts.fa -parse_seqids -dbtype nucl
blastn -query Chlamydomonas_incerta_repmod.fa -db Cr_Vc_transcripts.fa -outfmt "6 qseqid sseqid pident slen qlen length mismatch gapopen evalue" -out repmod-v-transcripts.out
perl filter_repeat_modeler_hits.pl --blast repmod-v-transcripts.out --cutoff 0.001 --fasta Chlamydomonas_incerta_repmod.fa --out Chlamydomonas_incerta_repmod_filtered.fa
```

Make custom lib by combining Volvocales curated repeats with RepeatModeler output

```
cat volvocales_repeat_lib_w_nonTE.fa Chlamydomonas_incerta_repmod_filtered.fa > c_inc_custom_lib.fa
```

Run RepeatMasker without masking low complexity repeats

```
RepeatMasker -nolow -a -xsmall -gccalc -lib c_inc_custom_lib.fa ../../genome_assemblies/c_incerta/final_assembly/Chlamydomonas_incerta.V3.fa
```
