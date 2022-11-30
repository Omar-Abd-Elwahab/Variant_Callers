#!/bin/bash

bcftools mpileup --threads=16 --config pacbio-ccs -D -Q5 --max-BQ 50 -F0.1 -o25 -e1 --delta-BQ 10 -M99999 \
 	-Ou -f /path/to/reference/ref.fa \
 	/path/to/bam/file.bam | bcftools call --threads=16 -mv -Oz -o /path/to/output/out.vcf

