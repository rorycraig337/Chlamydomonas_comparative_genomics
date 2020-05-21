#!/usr/bin/env bash

for i in *.fa ; do
	root=`basename $i .fa`	
	cat $i | tr -d '*' > $root.no_stops.fa
	mafft --auto $root.no_stops.fa > $root.mafft.fa
	trimal -in $root.mafft.fa -out $root.mafft.trimAl_auto.fa -automated1
	perl clean_headers.pl --in $root.mafft.trimAl_auto.fa --out $root.mafft.trimAl_auto.c.fa
done

