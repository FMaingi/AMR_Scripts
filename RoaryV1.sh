#!/bin/sh

usage() { echo "Usage: $0  [-R <RoaryOutFilePath> ] [-N <RoaryOutFilePath> ]
                        
                        -R RoaryOutFilePath -N TreeName
                         Example ./Roary.sh   -R RoaryOutFilePath -N TreeName  Path/To/GTFAnnotation
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


shift $((OPTIND-1))
Path=${1}
cd  ${Path}


if  [ -z "${R}" ] || [ -z "${N}" ] ; then 
    usage
fi

roary -e -n -p 8 -i 90 -f ${R} *.gff

#cd ${R}
raxmlHPC -f a -x 12345 -s ./${R}/core_gene_alignment.aln  -n ${N} -m GTRCAT -# 100 -p 123

#roary_plots.py ${R}/RAxML_bestTree.Final.tree ${R}/gene_presence_absence.csv
