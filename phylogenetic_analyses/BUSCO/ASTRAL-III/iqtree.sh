for i in ../*mafft.trimAl_auto.fa ; do
	 iqtree -s $i -m MFP -b 100 -nt 16
done
