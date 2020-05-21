for i in *mafft.fa ; do
	root=`basename $i .mafft.fa`
	perl backtranslate_protein.pl --prot $i --nuc $root.fna --list ../../volvocales_gold.txt --out $root.codons.fa
	perl extract_4D.pl --in $root.codons.fa --list ../../volvocales_gold.txt --out $root.4D.fa
done
