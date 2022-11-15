#!/bin/bash

#SBATCH --time=1-23:00:00
#SBATCH -D /mnt/ibis/fbelzile/users/omabd4
#SBATCH -J HG003-workflow
#SBATCH -c 5
#SBATCH -p ibis_large
#SBATCH --mem=50G
#SBATCH --output=/mnt/ibis/fbelzile/users/omabd4/gatk_V2_workflow_HG003.out


module load java
module load python
module load bwa
#time /mnt/ibis/fbelzile/users/omabd4/gatk4/gatk-4.2.6.1/gatk --java-options "-Xmx200G" HaplotypeCaller --native-pair-hmm-threads 16 \
#        -R /mnt/ibis/fbelzile/users/omabd4/references/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna \
#        -I /mnt/ibis/fbelzile/users/omabd4/out_gatk_ilmna/GATK_recal_reads_HG003.bam \
#        -O /mnt/ibis/fbelzile/users/omabd4/out_gatk_ilmna/HG003_V2_gatk.vcf


#extract SNPS and INDELS
/mnt/ibis/fbelzile/users/omabd4/gatk4/gatk-4.2.6.1/gatk --java-options "-Xmx50G" SelectVariants \
        -R /mnt/ibis/fbelzile/users/omabd4/references/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna \
        -V /mnt/ibis/fbelzile/users/omabd4/out_gatk_ilmna/HG003_V2_gatk.vcf \
        -select-type SNP \
        -O /mnt/ibis/fbelzile/users/omabd4/out_gatk_ilmna/GATK_raw_snps_v2_HG003.vcf
/mnt/ibis/fbelzile/users/omabd4/gatk4/gatk-4.2.6.1/gatk --java-options "-Xmx50G" SelectVariants \
        -R /mnt/ibis/fbelzile/users/omabd4/references/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna \
        -V /mnt/ibis/fbelzile/users/omabd4/out_gatk_ilmna/HG003_V2_gatk.vcf \
        -select-type INDEL \
        -O /mnt/ibis/fbelzile/users/omabd4/out_gatk_ilmna/GATK_raw_indels_v2_HG003.vcf



#Filter SNPS
/mnt/ibis/fbelzile/users/omabd4/gatk4/gatk-4.2.6.1/gatk --java-options "-Xmx50G" VariantFiltration \
        -R /mnt/ibis/fbelzile/users/omabd4/references/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna \
        -V /mnt/ibis/fbelzile/users/omabd4/out_gatk_ilmna/GATK_raw_snps_v2_HG003.vcf \
        -O /mnt/ibis/fbelzile/users/omabd4/out_gatk_ilmna/GATK_filtered_snps_v2_HG003.vcf \
        -filter-name "QD_filter" -filter "QD < 2.0" \
        -filter-name "FS_filter" -filter "FS > 60.0" \
        -filter-name "MQ_filter" -filter "MQ < 40.0" \
        -filter-name "SOR_filter" -filter "SOR > 4.0" \
        -filter-name "MQRankSum_filter" -filter "MQRankSum < -12.5" \
        -filter-name "ReadPosRankSum_filter" -filter "ReadPosRankSum < -8.0"

#Filter INDELs
/mnt/ibis/fbelzile/users/omabd4/gatk4/gatk-4.2.6.1/gatk --java-options "-Xmx50G" VariantFiltration \
        -R /mnt/ibis/fbelzile/users/omabd4/references/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna \
        -V /mnt/ibis/fbelzile/users/omabd4/out_gatk_ilmna/GATK_raw_indels_v2_HG003.vcf \
        -O /mnt/ibis/fbelzile/users/omabd4/out_gatk_ilmna/GATK_filtered_indels_v2_HG003.vcf \
        -filter-name "QD_filter" -filter "QD < 2.0" \
        -filter-name "FS_filter" -filter "FS > 200.0" \
        -filter-name "SOR_filter" -filter "SOR > 10.0"


