for i in *fa ; do
	root=`basename $i .fa`
  BuildDatabase -name $root -engine ncbi $i
  RepeatModeler -pa 20 -database $root
  perl ../../repeat_masking/c_incerta/renameRMDLconsensi.pl $root-families.fa $root $root_repmod.fa
done
