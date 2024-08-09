#!/bin/sh

usage() { echo "Usage: $0  [-O <PathToOldDabase> ] [-N <NameOfNewDatabase> ]
                        
                        -O PathToOldDabase -N NameOfNewDatabase
                         Example ./CDC_DB_Update.sh -O PathToOldDabase -N NameOfNewDatabase
                                 " 1>&2; exit 1; }


while getopts ":O:N:" o; do 
    case "${o}" in
        O)
            O=${OPTARG}
            ;;
        N)
            N=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done



if  [ -z "${O}" ] || [ -z "${N}" ] ; then 
    usage
fi



cat ${O} | sed -e 's/ /XX/g2' | sed -e 's/XX.*//g' | sed -e 's/ /__/g' | sed -e 's/>/>__/g' > ${N}
