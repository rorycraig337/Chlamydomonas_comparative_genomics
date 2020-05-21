for i in ../*mafft.trimAl_auto.c.fa ; do
	 iqtree -s $i -m MFP -b 100 -nt AUTO -ntmax 12
done
