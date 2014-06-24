#!/bin/bash
# A script to view the number of genes, signal peptides and effectors identified by path_pipe	
GENOMES=$1
PATH=$2
LIST=`tail -n +2 $GENOMES |cut -d, -f4`

echo "Assembling wilt genome from the wilt.csv file"
cd $PATH

for ASSEMBLY in $LIST; do
echo "Assembling "
echo $ASSEMBLY
cd $ASSEMBLY
cat ./F/*.fastq>R1.fastq
cat ./R/*.fastq>R2.fastq
echo "Working directory" 
echo $PATH
#SPAdes_assemble_part1.sh ./F/R1.fastq ./R/R2.fastq ./assembly/prog1/V.dahliae/$ASSEMBLY/

R1=$1
R2=$2
WORK_DIR=$3


done;
