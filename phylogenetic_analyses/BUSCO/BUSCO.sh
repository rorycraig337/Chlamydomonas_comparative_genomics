for i in *fa ; do
	root=`basename $i .fa`
	python /home/craigror/programs/busco/scripts/run_BUSCO.py -i $i -o $root.Cr -l /home/craigror/programs/busco/chlorophyta_odb10/ -m genome -c 16 -sp chlamydomonas
	python /home/craigror/programs/busco/scripts/run_BUSCO.py -i $i	-o $root.Vc -l /home/craigror/programs/busco/chlorophyta_odb10/ -m genome -c 16 -sp volvox
	python /home/craigror/programs/busco/scripts/run_BUSCO.py -i $i -o $root.Cr2 -l /home/craigror/programs/busco/chlorophyta_odb10/ -m genome -c 16 -sp chlamy2011
done
