Scafolded Assembly
====================

This details the commands used to perform genome assembly of V.d 51 using
sequence data generated at EMR, along with 5Kb mate-pair libraries, available on
ncbi.

# Data Organisation

Copy core data from isolate 51 into project folder.

```bash
  cd /home/groups/harrisonlab/project_files/verticillium_dahliae/wilt
  Species=V.dahliae
  Strain=51
  mkdir -p raw_dna/paired/$Species/$Strain/F
  mkdir -p raw_dna/paired/$Species/$Strain/R
  # cp /home/groups/harrisonlab/project_files/neonectria/NG-R0905_S4_L001_R1_001.fastq raw_dna/paired/$Species/$Strain/F/.
  # cp /home/groups/harrisonlab/project_files/neonectria/NG-R0905_S4_L001_R2_001.fastq raw_dna/paired/$Species/$Strain/R/.
```

Download 5Kb mate data into project folder.

```bash
  Species=V.dahliae
  Strain=JR2
  mkdir -p raw_dna/external_group/mate-paired/$Species/$Strain/F
  mkdir -p raw_dna/external_group/mate-paired/$Species/$Strain/R
  fastq-dump --gzip -O raw_dna/external_group/mate-paired/$Species/$Strain/. SRR575671
```

# Data QC

fastqc was used to viaualise data quality:

```bash
  ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/dna_qc;
  RawData=raw_dna/external_group/mate-paired/V.dahliae/JR2/SRR575671.fastq.gz
  qsub $ProgDir/run_fastqc.sh $RawData
```

Fastq-mcf was used to trim poor quality data

```bash
  screen -a
  qlogin
  ProjDir=/home/groups/harrisonlab/project_files/verticillium_dahliae/wilt
  Adapters=/home/armita/git_repos/emr_repos/tools/seq_tools/ncbi_adapters.fa
  Reads=$ProjDir/raw_dna/external_group/mate-paired/V.dahliae/JR2/SRR575671.fastq.gz
  WorkDir=/tmp/fastq-mcf_Vd
  mkdir -p $WorkDir
  cd $WorkDir
  cp $Reads tmp_reads.fq.gz
  cp $Adapters adapters.fa
  mkdir -p interlaced
  fastq-mcf adapters.fa tmp_reads.fq.gz -o interlaced/SRR575671_trimmed.fastq.gz -C 1000000 -u -k 20 -t 0.01 -q 30 -p 5
  OutDir=$ProjDir/qc_dna/external_group/mate-paired/V.dahliae/JR2
  mkdir -p $OutDir
  cp -r interlaced $OutDir/.
  rm -r $WorkDir
  logout
  ```
    Note - Remember to close the screen


```bash
  ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/dna_qc;
  RawData=qc_dna/external_group/mate-paired/V.dahliae/JR2/interlaced/SRR575671_trimmed.fastq.gz
  qsub $ProgDir/run_fastqc.sh $RawData dna
  mv external_group/mate-paired/V.dahliae/JR2/interlaced/SRR575671_trimmed_fastqc qc_dna/external_group/mate-paired/V.dahliae/JR2/interlaced/.
  rm -r external_group/
```

# Kmer coverage

kmer counting was performed using kmc.
This allowed estimation of sequencing depth and total genome size:

```bash
    echo $Strain
    Trim_F=$(ls qc_dna/paired/V.dahliae/51/F/51_qc_F.fastq)
    Trim_R=$(ls qc_dna/paired/V.dahliae/51/R/51_qc_R.fastq)
    Mp=$(ls qc_dna/external_group/mate-paired/V.dahliae/JR2/interlaced/SRR575671_trimmed.fastq.gz)
    ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/dna_qc
    echo "Reads are:"
    echo "$Trim_F"
    echo "$Trim_R"
    echo "$Mp"
    qsub $ProgDir/kmc_kmer_counting.sh $Trim_F $Trim_R $Mp
  done
```




# Assembly

```bash
ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/dna_qc
ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/assemblers/spades
F_Read=$(ls qc_dna/paired/V.dahliae/51/F/51_qc_F.fastq)
F_Read=$(ls qc_dna/paired/V.dahliae/51/R/51_qc_R.fastq)
Mp=$(ls qc_dna/external_group/mate-paired/V.dahliae/JR2/interlaced/SRR575671_trimmed.fastq.gz)
CovCutoff='10'
Species=$(echo $F_Read | rev | cut -f4 -d '/' | rev)
Strain=$(echo $F_Read | rev | cut -f3 -d '/' | rev)
OutDir=assembly/spades/$Species/$Strain
echo $Species
echo $Strain
echo "Reads are:"
echo "$Trim_F"
echo "$Trim_R"
echo "$Mp"
qsub $ProgDir/submit_Mp_Spades.sh $F_Read $R_Read $Mp $OutDir only-assembler $CovCutoff
    # qsub $ProgDir/submit_Mp_Spades.sh $F_Read $R_Read $Mp $OutDir correct $CovCutoff
```

```bash
  for Strain in 51; do
    ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/assemblers/assembly_qc/quast
    Assembly=$(ls assembly/spades/*/$Strain/filtered_contigs/contigs_min_500bp.fasta)
    OutDir=$(ls -d assembly/spades/*/$Strain/filtered_contigs)
    qsub $ProgDir/sub_quast.sh $Assembly $OutDir
  done
```
