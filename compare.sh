#!/bin/bash


mkdir -p /path/to/happy_results
singularity exec docker://jmcdani20/hap.py:v0.3.12 \
    /opt/hap.py/bin/hap.py \
		--threads 5 \
        	-r /path/to/reference/ref.fa \
        	-f /path/to/benchmark/benchmark.bed \
        	-o /apth/to/happy_results/happy_giab \
        	--engine=vcfeval \
        	--pass-only \
        	/path/to/benchmark/benchmark.vcf.gz \
        	/path/to/output/out.vcf

