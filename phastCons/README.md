Convert MAF to FASTA

```
bash msa_view.sh
```

Run phastCons with standard parameters

```
parallel -j 4 'phastCons --expected-length=45 --target-coverage=0.3 --rho=0.31 --most-conserved {= s:\.[^.]+$::;s:\.[^.]+$::; =}.most-cons.bed --msa-format FASTA {} neutral_model/volvocales_8way.4D.mod' ::: *.f.mfa
cat *most-cons.bed > CEs_run1.bed
sort -k1,1 -k2n,2n CEs_run1.bed > s.CEs_run1.bed
grep -v "MT_minus" s.CEs_run1.bed > f.CEs_run1.bed
```
