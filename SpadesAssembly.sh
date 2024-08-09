#!/bin/sh

## This code is for Spades assembly copyright Saikou Y Bah, Florey Institute University of Sheffield. 
## Run the analysis as follow: ./SpadesAssembly.sh ./Path/to/FastqFiles. 
## After it has finish a folder called "SpadesAssemblies" will be found on the FastqFiles parent directory.

set -e

shift $((OPTIND-1))

ReadPath="$1"
cd $ReadPath

for samp in `ls *gz | sed -e 's/_R[12].Paired.fastq.gz//' | sort | uniq`
do 
echo $samp

spades.py -k 21,33,55,77 --pe1-1 ${samp}_R1.Paired.fastq.gz  --pe1-2 ${samp}_R2.Paired.fastq.gz --careful -o $samp

if [ ! -d ../"SpadesAssemblies" ] ; then mkdir ../SpadesAssemblies ; fi

mv  $samp ../SpadesAssemblies
done
