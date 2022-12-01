#!/bin/bash

#Building DeepVariant
BIN_VERSION="1.4.0"
singularity build /path/to/deepvariant-1.4.0.sif docker://google/deepvariant:"${BIN_VERSION}"
 
#Illumina data variant calling
mkdir -p /path/to/deepvariant_output_illumina
singularity run -B /usr/lib/locale/:/usr/lib/locale/ \
    -B /path/to/working_directoy/ \
  /path/to/deepvariant-1.4.0.sif \
  /opt/deepvariant/bin/run_deepvariant \
  --model_type=WGS \
  --ref=/path/to/references/ref.fa \
  --reads=/path/to/bam_illumina/file_deduped.bam \
  --output_vcf=/path/to/deepvariant_output_illumina/out.vcf.gz \
  --num_shards=16

#PacBio HiFi data variant calling
mkdir -p deepvariant_output_hifi
singularity run -B /usr/lib/locale/:/usr/lib/locale/ \
    -B /path/to/working_directoy/ \
  /path/to/deepvariant-1.4.0.sif \
  /opt/deepvariant/bin/run_deepvariant \
  --model_type=PACBIO \
  --ref=/path/to/references/ref.fa \
  --reads=/path/to/bam/file.bam \
  --output_vcf=/path/to/deepvariant_output_hifi/out.vcf.gz \
  --num_shards=16

#Building pepper_margin_deepvariant
singularity build /path/to/pepper_deepvariant_r0.8.sif docker://kishwars/pepper_deepvariant:r0.8

#ONT data variant calling
mkdir -p /path/to/deepvariant_output_ont
time singularity run -B /usr/lib/locale/:/usr/lib/locale \
    -B /home/omabd4 \
  /path/to/pepper_deepvariant_r0.8.sif \
  run_pepper_margin_deepvariant call_variant \
  -f /path/to/reference/ref.fa \
  -b /path/to/bam/file.bam \
  -o /path/to/deepvariant_output_ont/out.vcf.gz \
  -t 16 \
  --ont_r9_guppy5_sup


