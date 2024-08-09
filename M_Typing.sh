#!/bin/sh

set -e

shift $((OPTIND-1))

AssmemblyPath="$1"

cd ${AssmemblyPath}

for i in `ls *fasta | sed 's/.fasta//'`
do

if [ ! -d ./EmmType ] ; then mkdir ./EmmType ; fi

perl /home/ubuntu/Saikou/M_Typing/my_version_emm_Typer4.pl -z ${AssmemblyPath}/${i}.fasta -r /home/ubuntu/Saikou/M_Typing/GAS_Scripts_Reference-master/GAS_Reference_DB/ -o ${i} -n ${i}

cp ${AssmemblyPath}/${i}/${i}*Results.txt ./EmmType

echo ${i}
done

cd EmmType 

cat *txt  | sort -r | uniq > FinalEmmResuts.txt

mv ../EmmType ../..
