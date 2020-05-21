for i in *fa ; do
	root=`basename $i .fa`
  BuildDatabase -name $root -engine ncbi $i
  RepeatModeler -pa 20 -database $root
done
