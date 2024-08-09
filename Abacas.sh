#!/bin/bash


usage() { echo "Usage: $0  [-R <PathToReferenceFasta> ] [-F <PathToTheFastaAssemblyFolder> ]
                        
                        -R PathToReferenceFasta
                        
                        -F PathToTheFastaAssemblyFolder
                         Example ./Abacas.sh   -R PathToReferenceFasta  -F PathToTheFastaAssemblyFolder 
                                 " 1>&2; exit 1; }


while getopts ":R:F:" o; do 
    case "${o}" in
        R)
            R=${OPTARG}
            ;;
        F)
            F=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done


if  [ -z "${R}" ] || [ -z "${F}" ] ; then 
    usage
fi

for file in `ls ${F}/*fasta | sed -e 's/.fasta//'` 
do 
echo $file

abacas.pl -r ${R} -q ${file}.fasta -p nucmer -o  ${file}_Ordered
done
