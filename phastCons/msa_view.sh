#!/usr/bin/env bash

for i in ../Cactus_WGA/MAF/*maf ; do
	root=`basename $i .maf`
	msa_view $i --in-format MAF --out-format FASTA > $root.mfa
	perl format_msa_view.pl	--mfa $root.mfa --out $root.f.mfa
	rm $root.mfa
done
