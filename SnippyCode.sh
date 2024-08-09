#!/bin/sh

usage() { echo "Usage: $0  [-R <ReferenceGenome>]
                        
                        -R Reference genome For the organism
                         Example ./SnippyCode.sh  -R ReferenceGemome  Path/To/Fastq/Reads
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


shift $((OPTIND-1))
Path=${1}
cd  ${Path}


if  [ -z "${R}" ] ; then 
    usage
fi



for i in `ls * | sed -e 's/_L001_R[12].Paired.fastq.gz//' | sort | uniq`

do 

#snippy --outdir ../SnippyOutput/${i} --prefix ${i} --ref ${R} --R1 ${i}_L001_R1.Paired.fastq.gz  --R2 ${i}_L001_R2.Paired.fastq.gz

echo  Done
done



snippy-core --ref ${R} --prefix ./CoreGenome_2  ./SnippyOutput/*

snippy-clean_full_aln core.full.aln > clean.full.aln
run_gubbins.py -p gubbins clean.full.aln
snp-sites -c gubbins.filtered_polymorphic_sites.fasta > clean.core.aln

