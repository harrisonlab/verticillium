#!/bin/bash
# A script to view the number of genes, signal peptides and effectors identified by path_pipe	
GENOMES=$1
LIST=`tail -n +2 $GENOMES |cut -d, -f4`
PATHDATA=$2


echo "Assembling wilt genome from the $GENOMES file"

for ASSEMBLY in $LIST; do
cd $PATHDATA
echo "Assembling $ASSEMBLY "

echo "Working directory" 
echo $PATHDATA
cd raw_dna/paired/V.dahliae/
echo "Subdirectory"
echo `pwd`
cd $ASSEMBLY
echo "Raw Data Subdirectory"
echo `pwd`
#cat ./F/*>R1.fastq
#cat ./R/*>R2.fastq
echo "Assembly path for output"
echo "$PATHDATA/assembly/prog1/$ASSEMBLY" 
SPAdes_assemble_part1.sh R1.fastq R2.fastq $PATHDATA/assembly/prog1/$ASSEMBLY/

done;
