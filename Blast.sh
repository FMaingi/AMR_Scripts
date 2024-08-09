#!/bin/bash


usage() { echo "Usage: $0  [-R <PathToQuerySeq> ] [-N <NameOfOutPut> ]
                        
                        -R PathToQuerySeq
                        
                        [-N <NameOfOutPut> ]
                         Example ./Blast.sh   -R PathToQuerySeq  [-N <NameOfOutPut> ] Path/To/Assemblies
                                 " 1>&2; exit 1; }


while getopts ":R:N:" o; do 
    case "${o}" in
        R)
            R=${OPTARG}
            ;;
        N)
            N=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

set -e

shift $((OPTIND-1))

AssmemblyPath="$1"

cd ${AssmemblyPath}

if  [ -z "${R}" ] || [ -z "${N}" ] ; then 
    usage
fi

if [ -d  BlastDb ] ; then rm -r BlastDb ; fi
mkdir BlastDb

cat *fasta > BlastDb/Blast.fa

makeblastdb -max_file_sz 2GB -in BlastDb/Blast.fa -parse_seqids -title "Blast DB" -dbtype nucl


blastn -db BlastDb/Blast.fa  -perc_identity 50 -outfmt 6  -query $R -out $N
