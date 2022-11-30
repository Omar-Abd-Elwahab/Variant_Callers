#!/bin/bash

#HiFi data variant calling
bash /Sentieon/DNAscopeHiFiBeta0.4.pipeline/dnascope_HiFi.sh \
	-r /path/to/reference/ref.fa \
	-i /path/to/bam/file.bam \
	-m /Sentieon/DNAscopeHiFiBeta0.4.pipeline/DNAscopeHiFiBeta0.4.model \
	-t 16 \
	/path/to/output/out.vcf.gz


#Illumina data varint calling
$sentieon driver -i /path/to/bam/file.bam \
    -r ref.fa \ \
    -t 16 --algo DNAscope \
    --model SentieonDNAscopeModel1.1.model \
    /path/to/output/sample_tmp.vcf.gz

$sentieon driver -t 16 \
     -r /path/to/reference/ref.fa \
     --algo DNAModelApply \
     --model SentieonDNAscopeModel1.1.model \
     -v /path/to/output/sample_tmp.vcf.gz \
     /path/to/output/out.vcf.gz

