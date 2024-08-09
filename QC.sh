#!/bin/bash

## This script is for quality cotrol of the sequencing data using fastqc and summarised using multiqc reports. 
## copyright Saikou Y Bah. Florey Institure MMB University of Sheffield.  

set -e
### Defined user options to be use to run the analysis
usage() { echo "Usage: $0 [-c <QC_Folder_Name>]
			
			-c Name to be given to QC folder. This will be created as the script is running. If there is similar name it will not be overwritten. 
				
				" 1>&2; exit 1; }


while getopts ":c:" o; do  
    case "${o}" in
        c)
            c=${OPTARG}
            ;;    
        *)
            usage
            ;;
    esac
done

shift $((OPTIND-1)) 

ReadPath="$1"

cd "$ReadPath"


if [ ! -d "${c}" ] ; then mkdir -p "${c}" ; fi


fastqc *gz

mv *fastqc* ./"${c}"

multiqc  ./"${c}"

mv  multiqc_report*  ./"${c}"

