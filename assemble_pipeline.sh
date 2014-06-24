#!/bin/bash
# A script to view the number of genes, signal peptides and effectors identified by path_pipe	
GENOMES=$1
LIST=`tail -n +2 $GENOMES |cut -d, -f4`
PATHDATA=$2


echo "Assembling wilt genome from the $GENOMES file"
cd $PATHDATA

for ASSEMBLY in $LIST; do
echo "Assembling $ASSEMBLY "

echo "Working directory" 
echo $PATHDATA
cd raw_dna/paired/V.dahliae/
echo "Subdirectory"
echo `pwd`
cd $ASSEMBLY
echo "Raw Data Subdirectory"
echo `pwd`
cat ./F/*.fastq>R1.fastq
cat ./R/*.fastq>R2.fastq

#SPAdes_assemble_part1.sh ./F/R1.fastq ./R/R2.fastq ./assembly/prog1/V.dahliae/$ASSEMBLY/


done;
