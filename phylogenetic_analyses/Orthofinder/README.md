Orthofinder species:  *C. reinhardtii, C. incerta, C. schloesseri, E. debaryana, G. pectorale, V. carteri, P. parva, D. salina, C. eustigma, R. subcapita, C. zofingiensis*

Use primary transcript models for Phytozome species (downloaded 13/10/19)

Use NCBI versions for non-Phytzome species (downloaded 13/10/19)

Get longest protein coding sequences from BRAKER annotations

```
perl extract_longest_ids.pl --gtf ../../gene_annotation/final_gene_models/c_incerta.braker2.f1.gtf --out c_incerta_longest_transcripts.txt
faSomeRecords ../../gene_annotation/final_gene_models/c_incerta.braker2.protein.fa c_incerta_longest_transcripts.txt c_incerta_longest.proteins.fa

perl extract_longest_ids.pl --gtf ../../gene_annotation/final_gene_models/c_schloesseri.braker2.f1.gtf --out c_schloesseri_longest_transcripts.txt
faSomeRecords ../../gene_annotation/final_gene_models/c_schloesseri.braker2.protein.fa c_schloesseri_longest_transcripts.txt c_schloesseri.longest_proteins.fa

perl extract_longest_ids.pl --gtf ../../gene_annotation/final_gene_models/c_debaryana.braker2.f1.gtf --out c_debaryana_longest_transcripts.txt
faSomeRecords ../../gene_annotation/final_gene_models/c_debaryana.braker2.protein.fa c_debaryana_longest_transcripts.txt c_debaryana.longest_proteins.fa
```

Pre-process fastas by adding species-specific prefixes with Kinfin

```
mkdir preprocessed_fastas
filter_fastas_before_clustering.py -f c_incerta.longest_proteins.fa > preprocessed_fastas/c_incerta.protein.fa
filter_fastas_before_clustering.py -f c_schloesseri.longest_proteins.fa > preprocessed_fastas/c_schloesseri.protein.fa
filter_fastas_before_clustering.py -f c_debaryana.longest_proteins.fa > preprocessed_fastas/c_debaryana.protein.fa
filter_fastas_before_clustering.py -f c_reinhardtii.v5.6.protein_primaryTranscriptOnly.fa > preprocessed_fastas/c_reinhardtii.protein.fa
filter_fastas_before_clustering.py -f v_carteri.v2.1.protein_primaryTranscriptOnly.fa > preprocessed_fastas/v_carteri.protein.fa
filter_fastas_before_clustering.py -f p_parva.protein_primaryTranscriptOnly.fa > preprocessed_fastas/p_parva.protein.fa
filter_fastas_before_clustering.py -f d_salina.v1.0.protein_primaryTranscriptOnly.fa > preprocessed_fastas/d_salina.protein.fa
filter_fastas_before_clustering.py -f c_zofingiensis.v5.2.3.2.protein_primaryTranscriptOnly.fa > preprocessed_fastas/c_zofingiensis.protein.fa
filter_fastas_before_clustering.py -f g_pectorale.NCBI_protein.fa > preprocessed_fastas/g_pectorale.protein.fa
filter_fastas_before_clustering.py -f c_eustigma.NCBI_protein.fa > preprocessed_fastas/c_eustigma.protein.fa
filter_fastas_before_clustering.py -f r_subcapitata.NCBI_protein.fa > preprocessed_fastas/r_subcapitata.protein.fa
```

Run Orthofinder with altered BLASTp commands

```
orthofinder -f preprocessed_fastas -op > op_blastp.txt
tail -n121 op_blastp.txt > blastp.txt
perl blastp_format.pl --commands blastp.txt --out blastp_commands.txt
parallel --jobs 24 < blastp_commands.txt
orthofinder -b /localdisk/home/s0920593/projects/chlamy_genomics/Orthofinder_v3/preprocessed_fastas/Results_Jan28/WorkingDirectory/ -t 32 -og
```

Extract single-copy orthologs and align protein sequences foreach

```
echo '#IDX,TAXON' > config.txt
sed 's/: /,/g' preprocessed_fastas/Results_Jan28/WorkingDirectory/SpeciesIDs.txt | cut -f 1 -d"." >> config.txt
kinfin --cluster_file preprocessed_fastas/Results_Jan28/WorkingDirectory/Orthogroups.txt --config_file config.txt --sequence_ids_file preprocessed_fastas/Results_Jan28/WorkingDirectory/SequenceIDs.txt --species_ids_file preprocessed_fastas/Results_Jan28/WorkingDirectory/SpeciesIDs.txt --fasta_dir preprocessed_fastas/
grep "true" kinfin_results/all/all.all.cluster_1to1s.txt | awk '{ print $1 }' > SCO.txt
get_protein_ids_from_cluster.py -g ../preprocessed_fastas/Results_Jan28/WorkingDirectory/Orthogroups.txt --cluster_ids SCO.txt
perl orthogroups2fastas.pl --SCO SCO --proteins preprocessed_fastas --out ./
bash mafft_trimAl.sh
perl catfasta2phyml.pl -c -f *mafft.trimAl_auto.c.fa > SCO.concat.auto.fa
```

