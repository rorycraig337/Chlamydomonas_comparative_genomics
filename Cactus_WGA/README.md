Run Cactus

```
PATH=$HOME/opt/python-2.7.17/bin:$PATH
source /localdisk/home/s0920593/software/cactus_env/bin/activate

ttPrefix=/localdisk/home/s0920593/software/kyoto_061119
export kyotoTycoonIncl="-I${ttPrefix}/include -DHAVE_KYOTO_TYCOON=1"
export kyotoTycoonLib="-L${ttPrefix}/lib -Wl,-rpath,${ttPrefix}/lib -lkyototycoon -lkyotocabinet -lz -lbz2 -lpthread -lm -lstdc++"
export PATH=/localdisk/home/s0920593/software/kyoto_061119/bin:$PATH
export LD_LIBRARY_PATH=/localdisk/home/s0920593/software/kyoto_061119/lib:$LD_LIBRARY_PATH

export PATH=/localdisk/home/s0920593/software/cactus/bin:$PATH

cactus jobStore4 ./algal-8way_seqFile.txt  ./algal-8way.hal --binariesMode local --maxCores 30
```
