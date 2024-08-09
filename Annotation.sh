#!/bin/bash

set -e

shift $((OPTIND-1))

AssmemblyPath="$1"

cd ${AssmemblyPath}


for i in `ls * | sed -s s/.fasta//`

do


prokka --outdir ../ProkaAnnotation/${i} --addgenes  --genus Streptococcus --species pyogenes  --usegenus --force  --prefix ${i} ${i}.fasta

if [ ! -d  ../GFF_Files ] ; then mkdir -p ../GFF_Files ; fi

cp ../ProkaAnnotation/${i}/*.gff ../GFF_Files

echo "\n\n"   ${i}  annotated

#echo $i

done


#roary -e -n -p 8 -i 90 -f ../Roary_out2 ../GFF_Files/*.gff

#query_pan_genome -a union -o ../Roary_out/GAS_Pan_genome ../GFF_Files/*.gff

#query_pan_genome -a intersection -o ../Roary_out/GAS_Core_genome ../GFF_Files/*.gff


#query_pan_genome -a complement -o ../Roary_out/GAS_Accessory_genes ../GFF_Files/*.gff
