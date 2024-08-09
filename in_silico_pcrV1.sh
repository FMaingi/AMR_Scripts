#!/bin/sh

#!/bin/sh

usage() { echo "Usage: $0  [-A <PathToPcrPrimers> -N <NameOfOutput> ]
                        
                        -A PathToPcrPrimers
			-N NameOfOutput
                         Example ./in_silico_pcr.sh   -A PathToPcrPrimers -N  NameOfOutput  Path/To/FastAssemblierFolder
                                 " 1>&2; exit 1; }


while getopts ":A:N:" o; do 
    case "${o}" in
        A)
            A=${OPTARG}
            ;;
        N)
            N=${OPTARG}
            ;;
	*)
            usage
            ;;
    esac
done


if  [ -z "${A}""${N}" ] ; then 
    usage
fi


shift $((OPTIND-1))
Path=${1}
cd  ${Path}



perl /home/ubuntu/Saikou/SYScripts/in_silico_pcr.py -p $A -m 3 -e  -o $N *fasta;

