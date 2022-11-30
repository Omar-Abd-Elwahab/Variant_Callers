#!/bin/bash


mkdir -p happy_results
singularity exec docker://jmcdani20/hap.py:v0.3.12 \
    /opt/hap.py/bin/hap.py \
		--threads 5 \
        	-r ref.fa \
        	-f benchmark.bed \
        	-o ~/happy_results/happy_giab \
        	--engine=vcfeval \
        	--pass-only \
        	benchmark.vcf.gz \
        	out.vcf

