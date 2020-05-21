for i in *.fa ; do
	root=`basename $i .fa`
	mafft $i > $root.mafft.fa
	trimal -in $root.mafft.fa -out $root.mafft.trimAl_auto.fa -automated1
done
