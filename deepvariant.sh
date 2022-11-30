#!/bin/bash


BIN_VERSION="1.4.0"
singularity pull docker://google/deepvariant:"${BIN_VERSION}"
 


singularity run -B /usr/lib/locale/:/usr/lib/locale/ \
  docker://google/deepvariant:"${BIN_VERSION}" \
  /opt/deepvariant/bin/run_deepvariant \
  --model_type=PacBio \
  --ref=/path/to/reference/ref.fa \
  --reads=/path/to/bam/file.bam \
  --output_vcf=/path/to/output/out.vcf.gz \
  --num_shards=16

