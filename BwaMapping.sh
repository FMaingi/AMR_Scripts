#!/bin/sh

usage() { echo "Usage: $0 [ -R <ReferenceGenome> ] 
                        
                          -R Reference genome For the organism
                         Example ./BwaMapping.sh  -R ReferenceGemome  Path/To/Fastq/Reads
                                " 1>&2; exit 1; }


while getopts ":R:" o; do 
    case "${o}" in
        R)
            R=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

if   [ -z "${R}" ] ; then 
    usage
fi



shift $((OPTIND-1))


PathToReads=$1

cd ${PathToReads}

bwa index ${R}

for i in `ls *.gz | sed -e 's/_L001_R[12]_001_paired.fastq.gz//' | sort | uniq`


do 


if [ ! -d "./RawBamFiles" ] ; then mkdir -p  "./RawBamFiles"  ; fi

if [ ! -d "./ProcessedBamFiles" ] ; then mkdir -p  "./ProcessedBamFiles"  ; fi

bwa mem -R "@RG\tID:$i\tSM:$i" $R  ${i}_L001_R1_001_paired.fastq.gz ${i}_L001_R2_001_paired.fastq.gz | samtools view -Sb  > ${i}.bam


samtools sort -n -O sam ${i}.bam | samtools fixmate -m -O bam -  ${i}.fixmate.bam

samtools sort -O bam -o ${i}.sorted.bam  ${i}.fixmate.bam

samtools markdup -r -S ${i}.sorted.bam  ${i}.sorted.dedup.bam

mv ${i}.sorted.dedup.bam  ./ProcessedBamFiles

mv ${i}.bam  ./RawBamFiles

rm *bam

echo ${i}
done

#cd ./RawBamFiles

#for i in `ls *bam`; do echo $i `echo  '\t'` `readlink -f  $i` >> RawBam.txt; done

#qualimap multi-bamqc -r -outformat PDF:HTML -d RawBam.txt -outdir  RawBamQC


cd ./ProcessedBamFiles

for i in `ls *bam`; do echo $i `echo  '\t'` `readlink -f  $i` >> ProcessedBam.txt; done

qualimap multi-bamqc -r -outformat PDF:HTML -d ProcessedBam.txt -outdir  ProcessedBamQC
