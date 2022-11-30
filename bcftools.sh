#!/bin/bash


#PacBio HiFi data varianrt calling
bcftools mpileup --threads=16 --config pacbio-ccs -D -Q5 --max-BQ 50 -F0.1 -o25 -e1 --delta-BQ 10 -M99999 \
 	-Ou -f /path/to/reference/ref.fa \
 	/path/to/bam/file.bam | bcftools call --threads=16 -mv -Oz -o /path/to/output/out.vcf
   

#Illumina data variant calling
bcftools mpileup --threads=16 \
  -Ou -f /path/to/reference/ref.fa \
 	/path/to/bam/file.bam | bcftools call --threads=16 -mv -Oz -o /path/to/output/out.vcf
  

#ONT data variant calling
bcftools mpileup --threads=16 --config ont -B -Q5 --max-BQ 30 -I \
  -Ou -f /path/to/reference/ref.fa \
 	/path/to/bam/file.bam | bcftools call --threads=16 -mv -Oz -o /path/to/output/out.vcf
  
#Filtering with Quality > 20
bcftools view -i '%QUAL>=20' /path/to/output/out.vcf > /path/to/output/out_filterd.vcf
