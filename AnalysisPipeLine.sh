#!/bin/sh


# File: 
# Time-stamp <29-Aug-2019>
#
# Copyright (C) 2019 Molecular Biology and Biotechnology Department, University of Sheffield
#
# Author: Saikou Y Bah
#
# Description: This pipeline take fastq file folder and path to trimmomatics folder containing the jar file and adapter for de novo assembly and annotation
# Spades is used for the assemblies, prokka for the annotations  and  mlts to determine the MLST. A number is folders will be created as follow:
# Paired and Unpaired folders, SpadesAssemblies and ProkkaAnnotation folders for assemblies and annotation respectively. And an AllContigs Folder containing all the contigs
# The MLST_Resulst.txt in the AllContigs folder contain the MLST results

usage() { echo "Usage: $0 [-T <PathToTrimmomaticFolder>]
			
			-T Path to the trimomatic folder
                         Example ./AnalysisPipeLine.sh Path/To/Fastq/Reads
				" 1>&2; exit 1; }


while getopts ":T:" o; do 
    case "${o}" in
	T)
            T=${OPTARG}
            ;; 
        *)
            usage
            ;;
    esac
done


shift $((OPTIND-1))
Path=${1}
cd  ${Path}

if  [ -z "${T}" ] ; then 
    usage
fi


echo Trimming the Fastq Reads
echo "\n\n\n"
for samp in `ls *.gz | sed -e 's/[12]_001.fastq.gz//' | sort | uniq `
do 


#java -jar ${T}/trimmomatic-0.39.jar PE ${samp}1_001.fastq.gz ${samp}2_001.fastq.gz ${samp}1.Paired.fastq.gz ${samp}1.Unpaired.fastq.gz ${samp}2.Paired.fastq.gz ${samp}2.Unpaired.fastq.gz ILLUMINACLIP:${T}/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

#echo ${samp}
if [ ! -d "PairedReads" ] ; then mkdir -p PairedReads ; fi
 
if [ ! -d "UnpairedReads" ] ; then mkdir -p UnpairedReads ; fi
 

#mv *Paired.fastq.gz* ./PairedReads
#mv *Unpaired.fastq.gz* ./UnpairedReads

done

#echo Finishing Trimming
#echo "\n\n\n"

echo Started Assembly, Genome QC and Annotations
echo "n\n\n"

mkdir -p ../AllContigs

cd ./PairedReads 

for i in `ls * | sed -e 's/_L001_R[12].Paired.fastq.gz//' | sort | uniq`

do 

if [ ! -d  ../SpadesAssemblies ] ; then mkdir -p ../SpadesAssemblies ; fi

if [ ! -d  ../AllContigs ] ; then mkdir -p ../AllContigs ; fi

#spades.py -k 21,33,55,77 -1 ${i}_L001_R1.Paired.fastq.gz  -2 ${i}_L001_R2.Paired.fastq.gz --careful -o ../SpadesAssemblies/${i}

cp ../SpadesAssemblies/${i}/contigs.fasta ../AllContigs/${i}.fasta

echo  ${i} Spades assembly Finish 
echo "\n\n\n"
echo Prokka ${i}

#prokka --outdir ../ProkaAnnotation/${i} --prefix ${i} ../SpadesAssemblies/${i}/contigs.fasta

echo  Prokka ${i} Also finish

done

echo Finished Assembly annotation
echo All contigs.fasta files moved to AllContigs Directory

mlst ../AllContigs/*fasta > ../AllContigs/MTSL_Results.txt

