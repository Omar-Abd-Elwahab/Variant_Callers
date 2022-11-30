#!/bin/bash

bash /Sentieon/DNAscopeHiFiBeta0.4.pipeline/dnascope_HiFi.sh \
	-r ref.fa \
	-i file.bam \
	-m /Sentieon/DNAscopeHiFiBeta0.4.pipeline/DNAscopeHiFiBeta0.4.model \
	-t 16 \
	out.vcf.gz

