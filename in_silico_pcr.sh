#!/bin/sh

usage() { echo "Usage: $0  [-A <PathToPcrPrimers> ]
                        
                        -A PathToPcrPrimers
                         Example ./in_silico_pcr.sh   -A PathToPcrPrimers  Path/To/FastAssemblierFolder
                                 " 1>&2; exit 1; }


while getopts ":A:" o; do 
    case "${o}" in
        A)
            A=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done


if  [ -z "${A}" ] ; then 
    usage
fi


shift $((OPTIND-1))
Path=${1}
cd  ${Path}


for i in `ls *fasta | sed -e s/.fasta//`;
do
    perl /home/ubuntu/Saikou/SYScripts/in_silico_pcr.py -p $A -m 5 -e  -o $i.V1 -i $i.fasta;
done
