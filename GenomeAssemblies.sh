#!/bin/sh

## This code is for Spades assembly copyright Saikou Y Bah, Florey Institute University of Sheffield. 
## Run the analysis as follow: ./GenomeAssemblies.sh ./Path/to/FastqFiles. 
## After it has finish a folder called "SpadesAssemblies" will be found on the FastqFiles parent directory.

usage() { echo "Usage: $0 [-T <PathToTrimmomaticFolder>]
                        
                        -T Path to the trimomatic folder
                         Example ./GenomeAssemblies.sh -T PatqhToTrimmomaticFolder   Path/To/Fastq/Reads
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



if  [ -z "${T}" ] ; then 
    usage
fi

shift $((OPTIND-1))
Path=${1}
cd  ${Path}



## Doing  the trimming using trimmomatics

echo Trimming the Fastq Reads
echo "\n\n\n"
for samp in `ls *.gz | sed -e 's/[12]_001.fastq.gz//' | sort | uniq `
do 


java -jar ${T}/trimmomatic-0.39.jar PE ${samp}1_001.fastq.gz ${samp}2_001.fastq.gz ${samp}1.Paired.fastq.gz ${samp}1.Unpaired.fastq.gz ${samp}2.Paired.fastq.gz ${samp}2.Unpaired.fastq.gz ILLUMINACLIP:${T}/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3  TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

#echo ${samp}
if [ ! -d "PairedReads" ] ; then mkdir -p PairedReads ; fi
 
if [ ! -d "UnpairedReads" ] ; then mkdir -p UnpairedReads ; fi
 

mv *Paired.fastq.gz* ./PairedReads
mv *Unpaired.fastq.gz* ./UnpairedReads

done

echo Finishing Trimming
#echo "\n\n\n"

echo Started Assembly with Spades
echo "n\n\n"


cd  PairedReads/ 

### Assembly, QC and annotation of assemblies with Spades, quast.

for i in `ls * | sed -e 's/_L001_R[12].Paired.fastq.gz//' | sort | uniq`

do 

if [ ! -d  ../SpadesAssemblies ] ; then mkdir -p ../SpadesAssemblies ; fi

if [ ! -d  ../SpadesContigs ] ; then mkdir -p ../SpadesContigs ; fi

spades.py -k 21,33,55,77 -1 ${i}_L001_R1.Paired.fastq.gz  -2 ${i}_L001_R2.Paired.fastq.gz --careful -o ../SpadesAssemblies/${i}

cp ../SpadesAssemblies/${i}/contigs.fasta ../SpadesContigs/${i}.fasta

echo  ${i} Spades assembly Finish 
echo "\n\n\n"

done

echo "\n" Performing quality control

quast.py ../SpadesContigs/*fasta  -r  ${R} -o ../SpadesAssemblyQC

## Doing the MLST analysis. 

echo "/n" Doing MLST from the Assembly contigs

mlst ../SpadesContigs/*fasta > ../SpadesContigs/Spades_MTSL_Results.txt
