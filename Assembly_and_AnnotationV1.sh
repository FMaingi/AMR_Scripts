#!/bin/bash

set -e

shift $((OPTIND-1))

ReadPath="$1"
Spades="$2"
#Proka="$3"
cd $ReadPath


for i in `ls *fastq.gz | sed -e 's/_R[12].Paired.fastq.gz//' | sort | uniq`

do

if [ ! "${ReadPath}/${Spades}" ]; then mkdir -p "${ReadPath}/${Spades}"; fi

spades.py  -k 21,33,55,77  -t 8 -1 ${i}_R1.Paired.fastq.gz -2 ${i}_R2.Paired.fastq.gz --careful -o "${ReadPath}/${Spades}"/${i}

prokka --outdir "${ReadPath}"/Proka/${i} --prefix ${i} "${ReadPath}/${Spades}/${i}"/contigs.fasta

echo ${i}

done

