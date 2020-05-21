Add R domain on MT loci where available
#Gonium pectorale mt+ R is LC062719.1
#C. reinhardtii mt- is GU814015.1, contains T domain, split from end of TOC32
#Yamagishiella uniccoa mt- is LC314413
#Eudorina mt male is LC314415
#V. carteri mt male is GU784916, contains C domain, split at start of PKY1

```
cat Chlamydomonas_reinhardtii.v5.fa Chlamydomonas_reinhardtii.MT_minus.fa > Chlamydomonas_reinhardtii.w_MT.fa
cat Gonium_pectorale.fa Gonium_pectorale.MT_plus.fa > Gonium_pectorale.w_MT.fa
cat Yamagishiella_unicocca.fa Yamagishiella_unicocca.MT_minus.fa > Yamagishiella_unicocca.w_MT.fa
cat Eudorina_2016-703-Eu-15.fa Eudorina_sp_2006-703-Eu-15.MT_male.fa > Eudorina_2016-703-Eu-15.w_MT.fa
cat Volvox_carteri.fa Volvox_carteri.MT_male.fa > Volvox_carteri.w_MT.fa
```

Run RepeatModeler on each species

```
bash RepeatModeler.sh
```

Combine RepeatModeler library for each species with curated repeats and run RepeatMasker

```
cat volvocales_repeatmasker_lib_v2.fa Chlamydomonas_reinhardtii_repmod.fa > Chlamydomonas_reinhardtii_custom_lib.fa
RepeatMasker -pa 32 -a -xsmall -gccalc -lib Chlamydomonas_reinhardtii_custom_lib.fa Chlamydomonas_reinhardtii.w_MT.fa
rm Chlamydomonas_reinhardtii.w_MT.fa
mv Chlamydomonas_reinhardtii.w_MT.fa.masked Chlamydomonas_reinhardtii.rm.fa

cat volvocales_repeatmasker_lib_v2.fa Chlamydomonas_incerta_repmod.fa > Chlamydomonas_incerta_custom_lib.fa
RepeatMasker -pa 32 -a -xsmall -gccalc -lib Chlamydomonas_incerta_custom_lib.fa Chlamydomonas_incerta.nuclear.fa
rm Chlamydomonas_incerta.nuclear.fa
mv Chlamydomonas_incerta.nuclear.fa.masked Chlamydomonas_incerta.rm.fa

cat volvocales_repeatmasker_lib_v2.fa Chlamydomonas_schloesseri_repmod.fa > Chlamydomonas_schloesseri_custom_lib.fa
RepeatMasker -pa 32 -a -xsmall -gccalc -lib Chlamydomonas_schloesseri_custom_lib.fa Chlamydomonas_schloesseri.nuclear.fa
rm Chlamydomonas_schloesseri.nuclear.fa
mv Chlamydomonas_schloesseri.nuclear.fa.masked Chlamydomonas_schloesseri.rm.fa

cat volvocales_repeatmasker_lib_v2.fa Chlamydomonas_debaryana_repmod.fa > Chlamydomonas_debaryana_custom_lib.fa
RepeatMasker -pa 32 -a -xsmall -gccalc -lib Chlamydomonas_debaryana_custom_lib.fa Chlamydomonas_debaryana.nuclear.fa
rm Chlamydomonas_debaryana.nuclear.fa
mv Chlamydomonas_debaryana.nuclear.fa.masked Edaphochlamys_debaryana.rm.fa

cat volvocales_repeatmasker_lib_v2.fa Gonium_pectorale_repmod.fa > Gonium_pectorale_custom_lib.fa
RepeatMasker -pa 32 -a -xsmall -gccalc -lib Gonium_pectorale_custom_lib.fa Gonium_pectorale.w_MT.fa
rm Gonium_pectorale.w_MT.fa
mv Gonium_pectorale.w_MT.fa.masked Gonium_pectorale.rm.fa

cat volvocales_repeatmasker_lib_v2.fa Yamagishiella_unicocca_repmod.fa > Yamagishiella_unicocca_custom_lib.fa
RepeatMasker -pa 32 -a -xsmall -gccalc -lib Yamagishiella_unicocca_custom_lib.fa Yamagishiella_unicocca.w_MT.fa
rm Yamagishiella_unicocca.w_MT.fa
mv Yamagishiella_unicocca.w_MT.fa.masked Yamagishiella_unicocca.rm.fa

cat volvocales_repeatmasker_lib_v2.fa Eudorina_2016-703-Eu-15_repmod.fa > Eudorina_2016-703-Eu-15_custom_lib.fa
RepeatMasker -pa 32 -a -xsmall -gccalc -lib Eudorina_2016-703-Eu-15_custom_lib.fa Eudorina_2016-703-Eu-15.w_MT.fa
rm Eudorina_2016-703-Eu-15.w_MT.fa
mv Eudorina_2016-703-Eu-15.w_MT.fa.masked Eudorina_2016-703-Eu-15.rm.fa

cat volvocales_repeatmasker_lib_v2.fa Volvox_carteri_repmod.fa > Volvox_carteri_custom_lib.fa
RepeatMasker -pa 32 -a -xsmall -gccalc -lib Volvox_carteri_custom_lib.fa Volvox_carteri.w_MT.fa
rm Volvox_carteri.w_MT.fa
mv Volvox_carteri.w_MT.fa.masked Volvox_carteri.rm.fa
```
