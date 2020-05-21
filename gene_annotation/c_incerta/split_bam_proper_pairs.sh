set -ue

# Get the bam file from the command line
DATA=$1

#
# 1. alignments of the second in pair if they map to the forward strand
# 2. alignments of the first in pair if their mate maps to the forward strand
#
samtools view -b -f 128 -F 16 $DATA > plus1.bam
samtools index plus1.bam

samtools view -b -f 64 -F 32 $DATA > plus2.bam
samtools index plus2.bam

#
# Combine alignments that originate on the forward strand.
#
samtools merge -f plus.bam plus1.bam plus2.bam
samtools index plus.bam

# 1. alignments of the second in pair if it maps to the reverse strand
# 2. alignments of the first in pair if their mates map to the reverse strand
#
samtools view -b -f 144 $DATA > minus1.bam
samtools index minus1.bam

samtools view -b -f 96 $DATA > minus2.bam
samtools index minus2.bam

#
# Combine alignments that originate on the reverse strand.
#
samtools merge -f minus.bam minus1.bam minus2.bam
samtools index minus.bam
