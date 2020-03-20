**Orthofinder core-*Reinhardtinia***



#species: C. reinhardtii, C. incerta, C. schloesseri, E. debaryana, G. pectorale, V. carteri


#C. reinhardtii and V. carteri protein sequences for primary transcripts downloaded from Phytozome

#G. pectorale proteins downloaded from NCBI, no alternative transcripts so proceed without changes

#extract protein sequences for longest transcripts for C. incerta, C. schloesseri, E. debaryana

perl extract_longest_ids.pl --gtf ../BRAKER/final_gene_models/c_incerta.braker2.f3.gtf --out c_incerta_longest_transcripts.txt

faSomeRecords ../BRAKER/final_gene_models/c_incerta.braker2.protein.f3.fa c_incerta_longest_transcripts.txt c_incerta.longest_proteins.fa


perl extract_longest_ids.pl --gtf ../BRAKER/final_gene_models/c_schloesseri.braker2.f3.gtf --out c_schloesseri_longest_transcripts.txt

faSomeRecords ../BRAKER/final_gene_models/c_schloesseri.braker2.protein.f3.fa c_schloesseri_longest_transcripts.txt c_schloesseri.longest_proteins.fa


perl extract_longest_ids.pl --gtf ../BRAKER/final_gene_models/c_debaryana.braker2.f3.gtf --out c_debaryana_longest_transcripts.txt

faSomeRecords ../BRAKER/final_gene_models/c_debaryana.braker2.protein.f3.fa c_debaryana_longest_transcripts.txt c_debaryana.longest_proteins.fa


#pre-process all files using Kinfin (add species names prefixes, remove proteins with internal stop-codons, and proteins <30 aa)

mkdir preprocessed_fastas

filter_fastas_before_clustering.py -f c_reinhardtii.longest_proteins.fa > preprocessed_fastas/c_reinhardtii.protein.fa

filter_fastas_before_clustering.py -f c_incerta.longest_proteins.fa > preprocessed_fastas/c_incerta.protein.fa

filter_fastas_before_clustering.py -f c_schloesseri.longest_proteins.fa > preprocessed_fastas/c_schloesseri.protein.fa

filter_fastas_before_clustering.py -f c_debaryana.longest_proteins.fa > preprocessed_fastas/c_debaryana.protein.fa

filter_fastas_before_clustering.py -f g_pectorale.longest_proteins.fa > preprocessed_fastas/g_pectorale.protein.fa

filter_fastas_before_clustering.py -f v_carteri.longest_proteins.fa > preprocessed_fastas/v_carteri.protein.fa


#run Orthofinder

orthofinder -f preprocessed_fastas -op > op_blastp.txt #produce file with BLAST commands

tail -n36 op_blastp.txt > blastp.txt #extract only BLAST commands from file

perl blastp_format.pl --commands blastp.txt --out blastp_commands.txt #add recommended additional parameters “-seq yes, -soft_masking true, -use_sw_tback”

parallel --jobs 24 < blastp_commands.txt #run BLASTp in parallel

orthofinder -b /localdisk/home/s0920593/projects/chlamy_genomics/Orthofinder_coreR/preprocessed_fastas/Results_Feb18/WorkingDirectory/ -t 32 -og #run Orthofinder using custom BLASTp output
