#!/bin/sh

# Copyright Saikou Y Bah MBB university of Sheffield.  This small script is mend to do the trimming of reads assuming that the reads end with [12]_001.fastq.gz
# First give the file path to were the reads are stored  then path to were the trimmomatics folder is
# Example ./Trimming.sh /Path/to/read /Path/to/Trimmomatics folder 

shift $((OPTIND-1)) 

ReadPath="$1"
Trm="$2"
#ls $Trm
cd $ReadPath


for samp in `ls *.gz | sed -e 's/_L001_R[12]_001.fastq.gz//' | sort | uniq `
do 
echo $samp

java -jar ${Trm}/trimmomatic-0.39.jar PE ${samp}_L001_R1_001.fastq.gz ${samp}_L001_R1_001.fastq.gz ${samp}_R1.Paired.fastq.gz ${samp}_R1.Unpaired.fastq.gz ${samp}_R2.Paired.fastq.gz ${samp}_R2.Unpaired.fastq.gz ILLUMINACLIP:${Trm}/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

if [ ! -d "PairedReads" ] ; then mkdir -p PairedReads ; fi
 
if [ ! -d "UnpairedReads" ] ; then mkdir -p UnpairedReads ; fi
 
mv *Paired* ./PairedReads
mv *Unpaired* ./UnpairedReads

done



